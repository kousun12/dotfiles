ggm() {
    local diff_output
    local command_output

    diff_output=$(git diff HEAD)
    command_output=$(echo "$diff_output

For the above 'git diff HEAD' give me the command to commit these changes, describing what the changes are. Always use 'git commit -am' to add all the files. Conform to Conventional Commits specification." | llm -m claude-3-5-haiku-latest -s "Return only the command to be executed as a raw string, no string delimiters wrapping it, no yapping, no markdown, no fenced code blocks, what you return will be passed to subprocess.check_output() directly.

For example your output should look like this:

git commit -am \"feat: Add a new feature to the app\"
")

    echo -e "\033[2mSuggested:\033[0m"
    echo -e "\033[1;36m$command_output\033[0m"

    echo -en "\033[1;33mPress [Enter] to execute, or 'n/N' to cancel: \033[0m"
    read user_input

    if [[ -z "$user_input" ]]; then
        eval "$command_output"
        echo -e "\033[1;32mCommand executed.\033[0m"
    elif [[ "$user_input" =~ ^[nN]$ ]]; then
        echo -e "\033[1;31mCommand cancelled.\033[0m"
    else
        echo -e "\033[1;31mInvalid input. Command cancelled.\033[0m"
    fi
}

summarize() {
    local text=""
    local system_prompt=$(cat <<EOF
Summarize the following content.
Respond with just the text of the summary. Do not acknowledge my request or address me in any way. The output format is markdown. Begin always with a heading, e.g
## Summary
EOF
)
    if [ ! -t 0 ]; then
        text=$(cat)
    else
        # Otherwise use command line arguments
        if [ $# -eq 0 ]; then
            echo "Usage: summarize \"text to summarize\"" >&2
            return 1
        fi
        text="$*"
    fi

    echo "<content>$text</content>

Summarize the above content. Your summary should be detailed and complete but written in a succinct form." | llm -m claude-3-5-haiku-latest --no-stream -s "$system_prompt"
}

parse_claims() {
    local text=""
    local system_prompt=$(cat <<EOF
Given the content, extract out a bullet list of main claims.
Respond with just the list. Do not acknowledge my request or address me in any way. The output format is markdown. Begin always with a heading, e.g
## Claims

  - claim1
  - claim2
EOF
)
    if [ ! -t 0 ]; then
        text=$(cat)
    else
        # Otherwise use command line arguments
        if [ $# -eq 0 ]; then
            echo "Usage: parse_claims \"text\"" >&2
            return 1
        fi
        text="$*"
    fi

    echo "<content>$text</content>

Parse the above for distinct claims. Each one should be succinct, at most one sentence" | llm -m claude-3-5-haiku-latest --no-stream -s "$system_prompt"
}

transcribe() {
    local url=""
    local title=""
    local temp_dir="/tmp/transcribe_$$"
    local audio_file=""

    # Parse arguments
    while [[ $# -gt 0 ]]; do
        case $1 in
            --title=*)
                title="${1#*=}"
                shift
                ;;
            http*://*)
                url="$1"
                shift
                ;;
            *)
                echo "Usage: transcribe <url> [--title=<optional>]"
                return 1
                ;;
        esac
    done

    if [ -z "$url" ]; then
        echo "Error: URL is required"
        return 1
    fi

    # Extract video ID and use as default title if none provided
    local video_id=$(echo "$url" | grep -o '[^/=]*$')
    if [ -z "$title" ]; then
        title="$video_id"
    fi

    # Create output directory structure
    local output_dir="$HOME/Transcripts/$title"
    mkdir -p "$output_dir"

    # Check if transcript already exists
    if [ -f "$output_dir/transcript.json" ]; then
        echo "Transcript already exists at: $output_dir/transcript.json"
        return 0
    fi

    # Construct R2 path
    local r2_key="audio/$video_id.m4a"
    local audio_url="https://media.substrate.run/$r2_key"

    # First check for local audio
    if [ -f "$output_dir/audio.m4a" ]; then
        echo "Found local audio: $output_dir/audio.m4a"
        audio_file="$output_dir/audio.m4a"
    else
        echo "Local audio not found, downloading from YouTube..."
        mkdir -p "$temp_dir"
        trap 'rm -rf "$temp_dir"' EXIT

        if ! yt-dlp "$url" -f 140 -o "$temp_dir/%(id)s.%(ext)s" --quiet; then
            echo "Error: Failed to download audio"
            return 1
        fi

        audio_file=$(ls "$temp_dir"/*.m4a 2>/dev/null | head -n 1)
        if [ -z "$audio_file" ]; then
            echo "Error: No audio file found after download"
            return 1
        fi

        cp "$audio_file" "$output_dir/audio.m4a"
        audio_file="$output_dir/audio.m4a"
        echo "Audio saved to: $output_dir/audio.m4a"
    fi

    # Check if we need to upload to R2
    if aws s3api head-object --bucket substrate-public --key "$r2_key" --profile substrate_cf 2>/dev/null; then
        echo "Audio already exists in R2: $audio_url"
    else
        echo "Uploading to Cloudflare R2..."
        if ! aws s3 cp "$audio_file" "s3://substrate-public/$r2_key" --profile substrate_cf --quiet; then
            echo "Error: Failed to upload to Cloudflare R2"
            return 1
        fi
        echo "Audio uploaded to: $audio_url"
    fi

    # Submit transcription request
    echo "Submitting transcription request..."
    local response=$(curl --silent --request POST \
        --url https://queue.fal.run/fal-ai/whisper \
        --header "Authorization: Key $FAL_KEY" \
        --header "Content-Type: application/json" \
        --data "{
            \"audio_url\": \"$audio_url\",
            \"task\": \"transcribe\",
            \"chunk_level\": \"segment\",
            \"version\": \"3\",
            \"batch_size\": 64,
            \"language\": \"en\"
        }")

    local request_id=$(echo "$response" | grep -o '"request_id": *"[^"]*"' | sed 's/"request_id": *//; s/"//g')
    if [ -z "$request_id" ]; then
        echo "Error: Failed to get request ID from response"
        return 1
    fi

    echo "Waiting for transcription to complete..."
    local transcription_status=""
    local max_attempts=60
    local attempt=0

    while [ $attempt -lt $max_attempts ]; do
        transcription_status=$(curl --silent --request GET \
            --url "https://queue.fal.run/fal-ai/whisper/requests/$request_id/status" \
            --header "Authorization: Key $FAL_KEY" | grep -o '"status": *"[^"]*"' | sed 's/"status": *//; s/"//g')

        if [ "$transcription_status" = "COMPLETED" ]; then
            break
        elif [ "$transcription_status" = "FAILED" ]; then
            echo "Error: Transcription failed"
            return 1
        fi

        echo -n "."
        sleep 5
        ((attempt++))
    done
    echo

    if [ $attempt -eq $max_attempts ]; then
        echo "Error: Transcription timed out"
        return 1
    fi

    # Get the transcription result
    echo "Retrieving transcription..."
    local result=$(curl --silent --request GET \
        --url "https://queue.fal.run/fal-ai/whisper/requests/$request_id" \
        --header "Authorization: Key $FAL_KEY")

    echo "$result" > "$output_dir/transcript.json"
    echo "Transcription saved to: $output_dir/transcript.json"

    echo "Postprocessing summary..."

    # Run summarize and parse_claims in parallel and save to temporary files
    {
        echo "$result" | jq ".text" | summarize > "$output_dir/_summary.md" &
        echo "$result" | jq ".text" | parse_claims > "$output_dir/_claims.md" &
        wait
    }

    # Combine the results into a single markdown file with proper headers
    {
        echo "# Transcript Analysis"
        echo
        echo "## Video URL"
        echo "$url"
        echo
        echo "## Hosted Audio"
        echo "$audio_url"
        echo
        echo "## Summary"
        cat "$output_dir/_summary.md"
        echo
        echo "## Key Claims"
        cat "$output_dir/_claims.md"
    } > "$output_dir/summary.md"

    echo "Summary saved to: $output_dir/summary.md"
    return 0
}

alias glog='git log --oneline --pretty=format:"%C(green bold dim)%h%Creset %C(auto)%d %C(cyan bold)%an%Creset %s %C(blue bold)(%cr)%Creset" --decorate --abbrev-commit --date=relative'
alias grhh='git reset --hard @'
alias gg='git grep -i'
alias alog='adb logcat | grep -i'
alias devices='adb devices'
alias xcodeclean="rm -frd ~/Library/Developer/Xcode/DerivedData/* && rm -frd ~/Library/Caches/com.apple.dt.Xcode/*"
alias gdc='git diff --cached'
alias glast='git for-each-ref --count=40 --sort=-committerdate refs/heads/ --format="%(refname:short)" | fzf'
alias gcl='gco $(glast)'
alias up='git-up'
alias c='git commit -m'
alias ca='git commit -am'
alias dk="docker-compose"
alias cgrep="grep --color=always"
alias esr="~/code/substack/apps/substack/esr"
alias srs="/Users/robcheung/code/substack/packages/srs/srs"
alias watts="/usr/sbin/system_profiler SPPowerDataType | grep Wattage"
alias gcof="fzf-git-checkout"
alias cup="chiplet up"
alias cupr="chiplet up --overlay rob"
alias pc="pycharm"
alias rr="cargo run --"

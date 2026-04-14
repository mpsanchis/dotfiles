#!/bin/bash

# Read JSON input from stdin (required by Claude Code's statusline API)
input=$(cat)

# Get ccusage output (pass stdin input)
ccusage_output=$(echo "$input" | bun x ccusage statusline 2>/dev/null)

# Get OAuth credentials from macOS Keychain
CREDS=$(security find-generic-password -s "Claude Code-credentials" -w 2>/dev/null)
ACCESS_TOKEN=$(echo "$CREDS" | jq -r '.claudeAiOauth.accessToken' 2>/dev/null)

quota_info=""
CACHE_FILE="/tmp/claude-statusline-quota-cache.json"
CACHE_MAX_AGE=600  # seconds

# Check if cached result is fresh enough
cache_age=999999
if [ -f "$CACHE_FILE" ]; then
    cache_mtime=$(stat -f %m "$CACHE_FILE" 2>/dev/null)
    now=$(date +%s)
    cache_age=$(( now - cache_mtime ))
fi

# Fetch or read cached raw API response
usage_data=""
if [ $cache_age -le $CACHE_MAX_AGE ] && [ -f "$CACHE_FILE" ]; then
    usage_data=$(cat "$CACHE_FILE")
elif [ -n "$ACCESS_TOKEN" ] && [ "$ACCESS_TOKEN" != "null" ]; then
    usage_data=$(curl -s "https://api.anthropic.com/api/oauth/usage" \
        -H "Authorization: Bearer $ACCESS_TOKEN" \
        -H "anthropic-beta: oauth-2025-04-20" 2>/dev/null)
    # Cache raw JSON (even if empty, to avoid hammering on errors)
    echo "$usage_data" > "$CACHE_FILE"
fi

# Format quota info from raw data (computed fresh every invocation so countdown stays accurate)
if [ -n "$usage_data" ]; then
    session_pct=$(echo "$usage_data" | jq -r '.five_hour.utilization // empty' 2>/dev/null)
    weekly_pct=$(echo "$usage_data" | jq -r '.seven_day.utilization // empty' 2>/dev/null)
    resets_at=$(echo "$usage_data" | jq -r '.five_hour.resets_at // empty' 2>/dev/null)

    if [ -n "$session_pct" ] && [ "$session_pct" != "null" ]; then
        session_display=$(printf "%.0f" "$session_pct")

        # Calculate time left until 5h reset
        time_left=""
        if [ -n "$resets_at" ] && [ "$resets_at" != "null" ]; then
            # Strip fractional seconds and colon in tz offset for macOS date parsing
            clean_ts=$(echo "$resets_at" | sed 's/\.[0-9]*//; s/:\([0-9][0-9]\)$/\1/')
            reset_epoch=$(date -jf "%Y-%m-%dT%H:%M:%S%z" "$clean_ts" +%s 2>/dev/null)
            if [ -n "$reset_epoch" ]; then
                now=$(date +%s)
                diff=$(( reset_epoch - now ))
                if [ $diff -gt 0 ]; then
                    hours=$(( diff / 3600 ))
                    mins=$(( (diff % 3600) / 60 ))
                    if [ $hours -gt 0 ]; then
                        time_left="${hours}h${mins}m"
                    else
                        time_left="${mins}m"
                    fi
                fi
            fi
        fi

        quota_info="5h: ${session_display}%"

        if [ -n "$weekly_pct" ] && [ "$weekly_pct" != "null" ]; then
            weekly_display=$(printf "%.0f" "$weekly_pct")
            quota_info="$quota_info | 7d: ${weekly_display}%"
        fi

        [ -n "$time_left" ] && quota_info="$quota_info | next reset in ${time_left}"

        # Show how stale the cached data is
        if [ -f "$CACHE_FILE" ]; then
            fetch_mtime=$(stat -f %m "$CACHE_FILE" 2>/dev/null)
            now=$(date +%s)
            fetch_age=$(( now - fetch_mtime ))
            if [ $fetch_age -lt 60 ]; then
                quota_info="$quota_info · fetched just now"
            else
                fetch_mins=$(( fetch_age / 60 ))
                quota_info="$quota_info · fetched ${fetch_mins}m ago"
            fi
        fi
    fi
fi

# Combine outputs
output="$ccusage_output"
[ -n "$quota_info" ] && output="$output | $quota_info"

echo "$output"


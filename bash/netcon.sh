#!/usr/bin/env bash
# Shebang line: tells the OS to run this script using bash found in the user's PATH

# =============================================================================
# Script: netcon.sh
# Purpose: Test HTTPS connectivity to a list of endpoints from a file.
#          Each line in the file should be "host" or "host:port". Default port is 443.
# =============================================================================

# Require a file path as the first argument, or exit with a usage message.
# ${1:?message} - If $1 (first argument) is unset or empty, print "message" and exit.
# $0 expands to the script name (e.g., "./netcon.sh").
endpoints_file="${1:?Usage: $0 <endpoints_file>}"

# Read the file line by line.
# IFS=        - Don't split on whitespace (preserves leading/trailing spaces).
# read -r     - Don't interpret backslashes as escape characters.
# || [ -n "$line" ] - Process the last line even if it doesn't end with a newline.
while IFS= read -r line || [ -n "$line" ]; do

	# Remove comments: delete everything from the first '#' to end of line.
	# ${line%%#*} - Remove the longest match of "#*" (# and everything after) from the end.
	line="${line%%#*}"

	# Trim leading and trailing whitespace using xargs.
	# printf '%s' "$line" - Print the line without a trailing newline.
	# | xargs            - Removes leading/trailing whitespace; also collapses internal spaces.
	line="$(printf '%s' "$line" | xargs)"

	# Skip empty lines.
	# [ -z "$line" ] - Test if the string length is zero.
	# && continue    - If true, skip to the next iteration of the loop.
	[ -z "$line" ] && continue

	# Extract the hostname (everything before the first colon).
	# ${line%%:*} - Remove the longest match of ":*" (: and everything after) from the end.
	# For "example.com:8080", this yields "example.com".
	# For "example.com" (no colon), this yields "example.com".
	host="${line%%:*}"

	# Check if the line contains a colon (i.e., a port was specified).
	# [[ "$line" == *:* ]] - Pattern match: true if line contains a colon anywhere.
	if [[ "$line" == *:* ]]; then
		# Extract the port (everything after the first colon).
		# ${line#*:} - Remove the shortest match of "*:" (everything up to and including :) from the start.
		# For "example.com:8080", this yields "8080".
		port="${line#*:}"
	else
		# No colon found, so no port was specified.
		port=""
	fi

	# Validate the port: if empty or not a number, default to 443.
	# -z "$port"              - True if port is an empty string.
	# ! "$port" =~ ^[0-9]+$   - True if port does NOT match the regex (one or more digits only).
	# ||                      - Logical OR: if either condition is true, set port to 443.
	if [[ -z "$port" || ! "$port" =~ ^[0-9]+$ ]]; then
		port=443
	fi

	# Edge case: if host equals port, the line had no colon and both got the same value.
	# This shouldn't normally happen after the above logic, but this is a safeguard.
	if [ "$host" = "$port" ]; then
		port=""
	fi

	# Re-validate port after the edge case check (same logic as above).
	if [[ -z "$port" || ! "$port" =~ ^[0-9]+$ ]]; then
		port=443
	fi

	# Print a status message showing which host:port is being tested.
	echo "Testing $host on port $port..."

	# Attempt an HTTPS connection using curl.
	# -k                  - Allow insecure connections (ignore SSL certificate errors).
	# --connect-timeout 10 - Fail if connection takes longer than 10 seconds.
	# 2>&1                - Redirect stderr to stdout so we capture all output.
	# $( ... )            - Command substitution: run the command and store its output in $output.
	output=$(curl -k --connect-timeout 10 "https://${host}:${port}" 2>&1)

	# Capture the exit status of the previous command (curl).
	# $? - Special variable holding the exit code of the last command (0 = success, non-zero = failure).
	rc=$?

	# Check if curl failed (non-zero exit code).
	# -ne - "not equal" numeric comparison.
	if [ "$rc" -ne 0 ]; then
		# Connection failed: print failure message and the curl output (which contains the error).
		echo "FAILED: $host:$port"
		echo "$output"
	else
		# Connection succeeded: print success message.
		echo "SUCCESS: $host:$port"
	fi

# End of the while loop.
# < "$endpoints_file" - Redirect the contents of the file as input to the while loop.
done < "$endpoints_file"
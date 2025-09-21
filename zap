#!/bin/bash
FUZZ_WORD="FUZZ"
CHANGE_LAST=false
CHANGE_FIRST=false
APPEND_MODE=false
EXTRACT_PARAMS=false

show_help() {
  cat << EOF
Usage: zap [FUZZ_WORD] [OPTIONS]

Options:
  -f        Replace only the last parameter value
  -s        Replace only the first parameter value
  -a        Append FUZZ_WORD to parameter values instead of replacing
  -e        Extract all parameter names from URLs
  -h        Show this help menu

Example Usage:
  cat urls.txt | ./zap               # Replace all parameter values with "FUZZ"
  cat urls.txt | ./zap TEST          # Replace all parameter values with "TEST"
  cat urls.txt | ./zap -a            # Append "FUZZ" to all parameter values
  cat urls.txt | ./zap -s -a         # Append "FUZZ" only to the first parameter value
  cat urls.txt | ./zap -e            # Extract all parameter names
EOF
}

# Parse arguments
while [[ $# -gt 0 ]]; do
  case "$1" in
    -f) CHANGE_LAST=true ;;
    -s) CHANGE_FIRST=true ;;
    -a) APPEND_MODE=true ;;
    -e) EXTRACT_PARAMS=true ;;
    -h) show_help; exit 0 ;;
    *) FUZZ_WORD="$1" ;;
  esac
  shift
done

# Escape special characters for sed
ESCAPED_FUZZ=$(printf '%s\n' "$FUZZ_WORD" | sed -e 's/[\/&]/\\&/g')

# Read URLs from stdin
while IFS= read -r line; do
  if $EXTRACT_PARAMS; then
    if [[ "$line" == *"="* ]]; then
      QUERY="${line#*\?}"
      for param in ${QUERY//&/ }; do
        echo "${param%%=*}"
      done
    fi
  else
    if [[ "$line" == *"="* ]]; then
      if $CHANGE_LAST || $CHANGE_FIRST; then
        IFS='&' read -ra PARAMS <<< "${line#*\?}"
        BASE="${line%%\?*}"
        
        if $CHANGE_LAST; then
          INDEX=$((${#PARAMS[@]}-1))
        elif $CHANGE_FIRST; then
          INDEX=0
        fi

        KEY=${PARAMS[$INDEX]%%=*}        
        VALUE=${PARAMS[$INDEX]#*=}       

        if $APPEND_MODE; then
          PARAMS[$INDEX]="$KEY=${VALUE}${ESCAPED_FUZZ}"  
        else
          PARAMS[$INDEX]="$KEY=${ESCAPED_FUZZ}"            
        fi

        echo "$BASE?$(IFS='&'; echo "${PARAMS[*]}")"
      else
        if $APPEND_MODE; then
          echo "$line" | sed -E "s|=([^&]*)|=\1${ESCAPED_FUZZ}|g"
        else
          echo "$line" | sed -E "s|=[^&]*|=${ESCAPED_FUZZ}|g"
        fi
      fi
    fi
  fi
done | sort -u

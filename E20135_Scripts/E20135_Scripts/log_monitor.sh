#!/bin/bash

sanitize_log_file() {
    local file; file="$1"
    if [[ -z "$file" || ! -f "$file" ]]; then
        printf "Σφάλμα: Το αρχείο δεν υπάρχει: %s\n" "$file" >&2
        return 1
    fi
    return 0
}

search_keywords() {
    local logfile="$1"
    shift
    local keywords=("$@")
    local date; date=$(date +"%Y%m%d")
    local log_base; log_base=$(basename "$logfile")
    local outfile; outfile="$HOME/important_${log_base}_${date}.log"

    local pattern; pattern=$(IFS='|'; printf "%s" "${keywords[*]}")
    local matches; matches=$(grep -iE "$pattern" "$logfile")

    if [[ -n "$matches" ]]; then
        printf "%s\n" "$matches" > "$outfile"
        printf "Οι σχετικές καταγραφές αποθηκεύτηκαν στο: %s\n" "$outfile"
    else
        printf "Δεν βρέθηκαν σχετικές καταχωρήσεις.\n"
    fi
}

main() {
    local logfile
    printf "Δώσε διαδρομή αρχείου log (π.χ. /var/log/syslog): "
    read -r logfile

    if ! sanitize_log_file "$logfile"; then
        return 1
    fi

    printf "Δώσε λέξεις-κλειδιά διαχωρισμένες με κενό (π.χ. error fail warning): "
    read -r -a keywords

    if [[ "${#keywords[@]}" -eq 0 ]]; then
        printf "Καμία λέξη-κλειδί δεν δόθηκε.\n" >&2
        return 1
    fi

    search_keywords "$logfile" "${keywords[@]}"
}

main


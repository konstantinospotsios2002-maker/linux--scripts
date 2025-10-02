#!/bin/bash

BACKUP_DIR="$HOME/backups"

sanitize_input() {
    local input; input="$1"
    if [[ -z "$input" || ! -d "$input" ]]; then
        printf "Σφάλμα: Μη έγκυρος κατάλογος: %s\n" "$input" >&2
        return 1
    fi
    return 0
}

create_backup() {
    local source_dir; source_dir="$1"
    local base_name; base_name=$(basename "$source_dir")
    local timestamp; timestamp=$(date +"%Y%m%d_%H%M%S")
    local backup_name; backup_name="backup_${base_name}_${timestamp}.tar.gz"
    mkdir -p "$BACKUP_DIR"

    if ! tar -czf "$BACKUP_DIR/$backup_name" -C "$(dirname "$source_dir")" "$base_name"; then
        printf "Αποτυχία δημιουργίας αντιγράφου ασφαλείας.\n" >&2
        return 1
    fi

    printf "Επιτυχής δημιουργία αντιγράφου: %s\n" "$BACKUP_DIR/$backup_name"
}

cleanup_old_backups() {
    find "$BACKUP_DIR" -type f -name "backup_*" -mtime +7 -print -delete
}

main() {
    local user_input
    printf "Δώσε πλήρη διαδρομή καταλόγου για backup: "
    read -r user_input

    if ! sanitize_input "$user_input"; then
        return 1
    fi

    if ! create_backup "$user_input"; then
        return 1
    fi

    cleanup_old_backups
}

main



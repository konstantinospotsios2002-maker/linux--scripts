#!/bin/bash

sanitize_directory() {
    local dir; dir="$1"
    if [[ -z "$dir" || ! -d "$dir" ]]; then
        printf "Σφάλμα: Ο κατάλογος δεν υπάρχει: %s\n" "$dir" >&2
        return 1
    fi
    return 0
}

organize_files() {
    local target_dir; target_dir="$1"
    local file ext dir_name

    shopt -s nullglob
    for file in "$target_dir"/*; do
        [[ -f "$file" ]] || continue
        ext="${file##*.}"
        if [[ "$file" == "$target_dir/$ext" ]]; then
            dir_name="no_extension"
        else
            dir_name="${ext,,}"
        fi
        mkdir -p "$target_dir/$dir_name"
        mv "$file" "$target_dir/$dir_name/" || printf "Σφάλμα μετακίνησης %s\n" "$file" >&2
    done
    printf "Η οργάνωση των αρχείων ολοκληρώθηκε στον κατάλογο: %s\n" "$target_dir"
}

main() {
    local input_dir; input_dir="$1"

    if ! sanitize_directory "$input_dir"; then
        return 1
    fi

    organize_files "$input_dir"
}

main "$1"

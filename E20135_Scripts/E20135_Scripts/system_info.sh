#!/bin/bash

print_datetime() {
    printf "\n📅 Ημερομηνία και ώρα: %s\n" "$(date)"
}

print_hostname() {
    printf "\n💻 Όνομα υπολογιστή: %s\n" "$(hostname)"
}

print_user_count() {
    local count; count=$(who | wc -l)
    printf "\n👥 Συνδεδεμένοι χρήστες: %d\n" "$count"
}

print_cpu_ram_status() {
    local cpu; cpu=$(top -bn1 | grep "Cpu(s)" | awk '{print $2 + $4}')
    local mem; mem=$(free -m | awk '/Mem:/ {printf "%.2f%% used, %.2fMB free", $3/$2*100, $4}')
    printf "\n⚙️  Χρήση CPU: %.2f%%\n" "$cpu"
    printf "🧠 RAM: %s\n" "$mem"
}

print_disk_usage() {
    printf "\n💾 Χώρος στους δίσκους:\n"
    df -h --output=source,fstype,size,used,avail,pcent,target | tail -n +2
}

print_top_processes() {
    printf "\n🔥 Top 5 διεργασίες κατά χρήση CPU:\n"
    ps -eo pid,comm,%cpu --sort=-%cpu | head -n 6

    printf "\n🧮 Top 5 διεργασίες κατά χρήση RAM:\n"
    ps -eo pid,comm,%mem --sort=-%mem | head -n 6
}

main() {
    print_datetime
    print_hostname
    print_user_count
    print_cpu_ram_status
    print_disk_usage
    print_top_processes
}

main

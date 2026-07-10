wherespace() {
    sudo du -hd "${2:-1}" "${1:-.}" | sort -h
}

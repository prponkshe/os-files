
# Repo map: name => full path
declare -A repo_map
repo_map[multi-holo]=/home/northee/git/multi-holo

z() {
    local dest="${repo_map[$1]}"
    if [[ -d "$dest" ]]; then
        cd "$dest"
    else
        echo "Unknown repo: $1"
        return 1
    fi
}


_z_complete() {
    COMPREPLY=( $(compgen -W "${!repo_map[*]}" -- "${COMP_WORDS[1]}") )
}

complete -F _z_complete z


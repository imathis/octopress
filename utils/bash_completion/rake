_rake() 
{
    local cur prev opts
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    opts="deploy generate preview watch new_post"

    COMPREPLY=( $(compgen -W "${opts}" -- ${cur}) )
}
complete -F _rake rake

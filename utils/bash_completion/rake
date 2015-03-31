_rake() 
{
    local current_keyin_str targets
    COMPREPLY=()
    current_keyin_str="${COMP_WORDS[COMP_CWORD]}"
    targets="deploy generate preview watch new_post new_page isolate \
          integrate clean update_style update_source gen_deploy   \
          copydot rsync set_root_dir setup_github_pages list -T   \
          install"

    COMPREPLY=( $(compgen -W "${targets}" -- ${current_keyin_str}) )
}
complete -F _rake rake

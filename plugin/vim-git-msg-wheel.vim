if exists("g:loaded_git_msg_wheel")
    finish
endif
let g:loaded_git_msg_wheel = 1
let g:git_msg_wheel_key = get(g:, 'git_msg_wheel_key', '<C-l>')
let g:git_msg_wheel_length = get(g:, 'git_msg_wheel_length', 50)
let g:git_msg_wheel_list_show = get(g:, 'git_msg_wheel_list_show', 1)
let g:git_msg_wheel_alternate_key = get(g:, 'git_msg_wheel_alternate_key', "\<C-x>\<C-l>")

augroup vim_autocomplete_recent_git_commit_message
    autocmd FileType gitcommit call git_msg_wheel#printRecentGitLog()
    execute "autocmd FileType gitcommit inoremap <silent><nowait><buffer> " . g:git_msg_wheel_key . " <C-r>=git_msg_wheel#lastCommitMsg()<CR>"
augroup END


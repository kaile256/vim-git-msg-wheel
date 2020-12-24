if exists("g:loaded_git_msg_wheel")
    finish
endif
let g:loaded_git_msg_wheel = 1
let g:git_msg_wheel_key = get(g:, 'git_msg_wheel_key', '<C-l>')
let g:git_msg_wheel_length = get(g:, 'git_msg_wheel_length', 50)
let g:git_msg_wheel_list_show = get(g:, 'git_msg_wheel_list_show', 1)
let g:git_msg_wheel_alternate_key = get(g:, 'git_msg_wheel_alternate_key', "\<C-x>\<C-l>")

augroup vim_autocomplete_recent_git_commit_message
    autocmd FileType gitcommit call s:printRecentGitLog()
    execute "autocmd FileType gitcommit inoremap <silent><nowait><buffer> " . g:git_msg_wheel_key . " <C-r>=LastCommitMsg()<CR>"
augroup END

function! s:printRecentGitLog()
    if exists('w:git_msg_wheel__executed')
        return
    endif
    normal! Go
    let w:git_msg_wheel__startLine = line('$')
    silent execute 'r! git log --pretty=oneline | head -' . g:git_msg_wheel_length . ' | sed "s/^/\#\# /"'
    normal! gg
    let b:git_msg_wheel__commitMessages = getline(w:git_msg_wheel__startLine, '$')

    let l:i = 0
    for l:msg in b:git_msg_wheel__commitMessages
        let b:git_msg_wheel__commitMessages[l:i] = substitute(l:msg, '^## \S*\s', '', '')
        let l:i += 1
    endfor

    if g:git_msg_wheel_list_show != 1
        normal! Gdip
    endif

    let w:git_msg_wheel__executed = 1
endfunction

function! LastCommitMsg()
    if line('.') > 1
      return g:git_msg_wheel_alternate_key
    endif

    let line = getline('.')
    let candidates = filter(deepcopy(b:git_msg_wheel__commitMessages), 'v:val =~# "^". line')
    let matches = map(deepcopy(candidates), 'substitute(v:val, line, "", "")')
    call complete(col('.'), matches)
    return ''
endfunc


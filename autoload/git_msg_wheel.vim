function! git_msg_wheel#printRecentGitLog()
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

function! git_msg_wheel#lastCommitMsg()
    if line('.') > 1
      return g:git_msg_wheel_alternate_key
    endif

    let line = getline('.')
    let candidates = filter(deepcopy(b:git_msg_wheel__commitMessages), 'v:val =~# "^". line')
    let matches = map(deepcopy(candidates), 'substitute(v:val, line, "", "")')
    call complete(col('.'), matches)
    return ''
endfunc


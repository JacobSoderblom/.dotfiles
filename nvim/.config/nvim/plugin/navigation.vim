
nnoremap <C-k> :cnext<CR>zz
nnoremap <C-j> :cprev<CR>zz
nnoremap <leader>k :lnext<CR>zz
nnoremap <leader>j :lprev<CR>zz
nnoremap <C-q> :call ToggleQFList(1)<CR>
nnoremap <leader>q :call ToggleQFList(0)<CR>

let g:monokai_qf_l = 0
let g:monokai_qf_g = 0

fun! ToggleQFList(global)
    if a:global
        if g:monokai_qf_g == 1
            let g:monokai_qf_g = 0
            cclose
        else
            let g:monokai_qf_g = 1
            copen
        end
    else
        if g:monokai_qf_l == 1
            let g:monokai_qf_l = 0
            lclose
        else
            let g:monokai_qf_l = 1
            lopen
        end
    endif
endfun

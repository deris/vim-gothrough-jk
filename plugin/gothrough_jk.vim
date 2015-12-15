" gothrough-jk - summary
" Version: 0.1.0
" Copyright (C) 2015 deris0126
" License: MIT license  {{{
"     Permission is hereby granted, free of charge, to any person obtaining
"     a copy of this software and associated documentation files (the
"     "Software"), to deal in the Software without restriction, including
"     without limitation the rights to use, copy, modify, merge, publish,
"     distribute, sublicense, and/or sell copies of the Software, and to
"     permit persons to whom the Software is furnished to do so, subject to
"     the following conditions:
"
"     The above copyright notice and this permission notice shall be included
"     in all copies or substantial portions of the Software.
"
"     THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
"     OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
"     MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
"     IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
"     CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
"     TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
"     SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
" }}}

if exists('g:loaded_gothrough_jk')
  finish
endif
let g:loaded_gothrough_jk = 1

let s:save_cpo = &cpo
set cpo&vim


let g:gothrough_jk_go_step         = get(g:, 'gothrough_jk_go_step', 5)
let g:gothrough_jk_move_count      = get(g:, 'gothrough_jk_move_count', 3)
let g:gothrough_jk_move_interval   = get(g:, 'gothrough_jk_move_interval', 150)
let g:gothrough_jk_reset_interval  = get(g:, 'gothrough_jk_reset_interval', 4000)
let g:gothrough_jk_same_direction  = get(g:, 'gothrough_jk_same_direction', 1)
let g:gothrough_jk_relativenumber  = get(g:, 'gothrough_jk_relativenumber', 0)
let g:gothrough_jk_repeat_count_jk = get(g:, 'gothrough_jk_repeat_count_jk', 0)

noremap <silent><expr> <Plug>(gothrough-jk-j)  gothrough_jk#j()
noremap <silent><expr> <Plug>(gothrough-jk-k)  gothrough_jk#k()
noremap <silent><expr> <Plug>(gothrough-jk-gj) gothrough_jk#gj()
noremap <silent><expr> <Plug>(gothrough-jk-gk) gothrough_jk#gk()

if !get(g:, 'gothrough_jk_no_default_key_mappings', 0) &&
  \!hasmapto('<Plug>(gothrough-jk-j)') &&
  \!hasmapto('<Plug>(gothrough-jk-k)') &&
  \!hasmapto('<Plug>(gothrough-jk-gj)') &&
  \!hasmapto('<Plug>(gothrough-jk-gk)')
  nmap j  <Plug>(gothrough-jk-j)
  nmap k  <Plug>(gothrough-jk-k)
  xmap j  <Plug>(gothrough-jk-j)
  xmap k  <Plug>(gothrough-jk-k)
  nmap gj <Plug>(gothrough-jk-gj)
  nmap gk <Plug>(gothrough-jk-gk)
  xmap gj <Plug>(gothrough-jk-gj)
  xmap gk <Plug>(gothrough-jk-gk)
end

augroup gothrough-jk
  autocmd!
  autocmd CursorHold,CursorHoldI,BufLeave * call gothrough_jk#reset_gothrough_mode()
  autocmd CursorMoved,CursorMovedI        * call gothrough_jk#reset_moved()
augroup END


let &cpo = s:save_cpo
unlet s:save_cpo

" __END__
" vim: foldmethod=marker

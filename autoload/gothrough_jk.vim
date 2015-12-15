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

let s:save_cpo = &cpo
set cpo&vim

" Public API {{{1
function! gothrough_jk#j() "{{{
  return s:gothrough_jk('j')
endfunction
"}}}

function! gothrough_jk#k() "{{{
  return s:gothrough_jk('k')
endfunction
"}}}

function! gothrough_jk#gj() "{{{
  return s:gothrough_jk('gj')
endfunction
"}}}

function! gothrough_jk#gk() "{{{
  return s:gothrough_jk('gk')
endfunction
"}}}

function! gothrough_jk#reset_gothrough_mode() "{{{
  if s:gothrough_mode == 0 && s:move_count == 0
    return
  endif

  let diff_time = reltime(s:prev_time, reltime())

  let msec = (diff_time[0] * 1000) + (diff_time[1] / 1000)
  if s:gothrough_mode && msec > g:gothrough_jk_reset_interval
    call s:reset_gothrough_mode()
  endif
endfunction
"}}}

function! gothrough_jk#reset_moved() "{{{
  if s:moved_jk
    let s:moved_jk = 0
  else
    call s:reset_gothrough_mode()
  endif
endfunction
"}}}

"}}}

" Private {{{1

let s:moved_jk       = 0
let s:gothrough_mode = 0
let s:move_count     = 0
let s:prev_time      = reltime()
let s:last_jk        = ''
let s:prev_count     = 0

function! s:reset_gothrough_mode() "{{{
  let s:gothrough_mode = 0
  let s:move_count     = 0
  let s:prev_count     = 0
  call s:reset_relativenumber()
endfunction
"}}}

function! s:gothrough_jk(jk) "{{{
  let s:moved_jk = 1

  if v:count > 0
    let s:prev_count = v:count
    let s:gothrough_mode = 0
    let s:move_count     = 0
    call s:reset_relativenumber()
    if g:gothrough_jk_repeat_count_jk
      let s:gothrough_mode = 1
      let s:last_jk = a:jk
      let s:prev_time = reltime()
    endif
    return a:jk
  endif

  let now_time    = reltime()
  let diff_time   = reltime(s:prev_time, now_time)
  let s:prev_time = now_time

  let msec = (diff_time[0] * 1000) + (diff_time[1] / 1000)

  if s:gothrough_mode
    if g:gothrough_jk_same_direction && a:jk !=# s:last_jk
      call s:reset_gothrough_mode()
    endif
    if msec > g:gothrough_jk_reset_interval
      call s:reset_gothrough_mode()
    endif
  else
    if msec <= g:gothrough_jk_move_interval
      let s:gothrough_mode = s:move_count >= g:gothrough_jk_move_count
    else
      let s:move_count = 0
    endif
  endif

  let s:last_jk = a:jk

  if g:gothrough_jk_repeat_count_jk && s:prev_count > 0
    return s:prev_count . a:jk
  endif

  if g:gothrough_jk_relativenumber
    call s:set_relativenumber()
  endif

  let s:move_count += (s:move_count < g:gothrough_jk_move_count ? 1 : 0)
  return (s:gothrough_mode ? g:gothrough_jk_go_step : '') . a:jk
endfunction
"}}}

function! s:set_relativenumber() "{{{
  if !exists('w:gothrough_jk_relativenumber')
    let w:gothrough_jk_relativenumber = &relativenumber
    set relativenumber
  endif
endfunction
"}}}

function! s:reset_relativenumber() "{{{
  if exists('w:gothrough_jk_relativenumber')
    let &relativenumber = w:gothrough_jk_relativenumber
    unlet w:gothrough_jk_relativenumber
  endif
endfunction
"}}}

"}}}

let &cpo = s:save_cpo
unlet s:save_cpo

" __END__ "{{{1
" vim: foldmethod=marker

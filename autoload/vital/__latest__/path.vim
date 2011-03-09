" vital.path

" You should check the following related builtin functions.
" fnamemodify()
" resolve()
" simplify()

let s:save_cpo = &cpo
set cpo&vim

let s:path_sep_pattern = exists('+shellslash') ? '[\\/]' : '/'

" Get the path separator.
function! s:separator()
  return !exists('+shellslash') || &shellslash ? '/' : '\'
endfunction

" Convert all path separators to "/".
function! s:unify_separator(path)
  return substitute(a:path, s:path_sep_pattern, '/', 'g')
endfunction

" Split the path with path separator.
" Note that this includes the drive letter of MS Windows.
function! s:split(path)
  return split(a:path, s:path_sep_pattern)
endfunction

" Join the paths.
" join('foo', 'bar')            => 'foo/bar'
" join('foo/', 'bar')           => 'foo/bar'
" join('/foo/', ['bar', 'buz/']) => '/foo/bar/buz/'
function! s:join(...)
  let sep = s:separator()
  let path = ''
  for part in a:000
    if type(part) is type([])
      let path .= sep . call('s:join', part)
    else
      let path = substitute(path, s:path_sep_pattern . '$', '', '') . sep .
      \          substitute(part, '^' . s:path_sep_pattern, '', '')
    endif
    unlet part
  endfor
  return path[1 :]  " Remove an extra pass separator of the head.
endfunction


let &cpo = s:save_cpo
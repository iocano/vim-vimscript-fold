" Set folding via syntax for vim script
setlocal foldmethod=syntax

" Command window 'q:' and ':option window' set filetype=vim, so disable folding on those windows
" Malformed syntax (if, function, etc) would fold everything from the malformed command until last command
if bufname('') =~# '^\%(' . (v:version < 702 ? 'command-line' : '\[Command Line\]') . '\|option-window\)$'
  " With this, folding can still be enabled easily via any zm, zc, zi, ... command.
  setlocal nofoldenable
endif

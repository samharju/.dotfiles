if exists("b:current_syntax")
  finish
endif

let s:cpo_save = &cpo
set cpo&vim

syn case ignore

syn match sesTitle      display '\%1l.\+'
syn match sesPaneDef    display '#pane\|#\/pane' 
syn match sesPaneOpt    display '#layout' 
syn match sesPaneOpt    display '#main-pane-width' 
syn match sesPaneOpt    display '#main-pane-height' 

syn region sesPaneCmds    display start='#pane' end='#/pane' contains=sesPaneDef

"syn match sesPane display '^#[0-9a-z]\{8}-[0-9a-z]\{4}-[0-9a-z]\{4}-[0-9a-z]\{4}-[0-9a-z]\{12}'

hi def link sesTitle		Title
hi def link sesPaneDef		Keyword
hi def link sesPaneCmds		Function
hi def link sesPaneOpt		Character


let b:current_syntax = "ses"

let &cpo = s:cpo_save
unlet s:cpo_save

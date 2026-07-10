if exists("b:current_syntax")
  finish
endif

let s:cpo_save = &cpo
set cpo&vim

syn case ignore

syn keyword logerr fatal error err
syn keyword loginf info inf
syn keyword logwrn warning warn wrn
syn keyword logdbg debug dbg
syn keyword logbool true false

syn region logstr display start=/"/ end=/"/ end=/$/ skip=/\\./
syn region logstr display start=/`/ end=/`/ end=/$/ skip=/\\./
syn region logstr display start=/'/ end=/'/ end=/$/ skip=/\\./

syn match loguuid display '[0-9a-z]\{8}-[0-9a-z]\{4}-[0-9a-z]\{4}-[0-9a-z]\{4}-[0-9a-z]\{12}'
syn match logsep display '[\[\]\(\):=]'

syn match logurl display '\<https\?:\/\/\S\+'

syn match logdate display '\d\{4}-\d\{2}-\d\{2}T\?'
syn match logdate display '\d\{2}:\d\{2}:\d\+\(\.\d\+\)\?Z\?'
syn match logdate display '+\d\{4}'

syn match logkey display '[-a-zA-Z0-9_]\+=\@=' contains=logsep
syn match logval display '=\@<=[-a-zA-Z0-9_\.:]\+' contains=logsep

hi def link logdate		Comment
hi def link logerr		DiagnosticError
hi def link loginf		DiagnosticOk 
hi def link logwrn		DiagnosticWarn 
hi def link logdbg		DiagnosticHint 
hi def link logbool		DiagnosticInfo
hi def link loguuid		@variable.parameter
hi def link logsep		Special 
hi def link logstr		String 
hi def link logurl		Function
hi def link logkey		Function
hi def link logval		Comment


let b:current_syntax = "log"

let &cpo = s:cpo_save
unlet s:cpo_save

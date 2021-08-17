" z(\)         : Mark sub-expression as external (can be accessed from another pattern match, only usable syntax region start pattern)
"                 Access subexpresion with \z1, \z2, ..., \z9
" \%(\)         : Like \(\) but no counting it as subexpresion (faster)
" \ze           : Match any position and set the end of the match there, the previous char is the last char of the whole match
"                 In end\ze\(if\|for\) match 'end' in 'endif' and 'endfor'
" \s            : Match <space> and <tab>
" *             : Match 0 or more the preceding atom, a*: match "", "a", "aa", "aaa", etc.
" \n            : Match an end of line
" \@!           : Match if the preceding atom does not match at the current position
" .             : Match any single character, but not an end of line
" \z1, ..., \z9 : Matches the same string that was matched by the corresponding sub-expression in a previous start pattern match.
" {-}           : Matches 0 or more of the preceding atom, as few as possible

" syntax region : Defines one region, e.g. syn region region_name
" start         : The search pattern that defines the start of the region
" end           : The search pattern that defines the end of the region
" fold          : This argument makes the fold level increase by one for this itemo
" skip          : The search pattern that defines text inside the region where not to look for the end
" transparent   : This item will not be highlighted itself, but will take the highlighting of the item it is contained in.
" keepend       : Makes vimCommand always end at the end of the line, when "keepend" is not used, a match with an end pattern is retried
" extend    	: Override a "keepend" for an item this region is contained in
" contains      : List of syntax group names. These groups will be allowed to begin inside the item (they may extend past the containing group's end). This allows for recursive nesting of matches and regions.

syn cluster vimNoFold contains=vimComment,vimLineComment,vimCommentString,vimString,vimSynKeyRegion,vimSynRegPat,vimPatRegion,vimMapLhs,vimOperParen,@EmbeddedScript
syn cluster vimEmbeddedScript  contains=vimMzSchemeRegion,vimTclRegion,vimPythonRegion,vimRubyRegion,vimPerlRegion

syn region vimFoldSyntax
            \ start="^\s*\<syn\%[tax]\> "
            \ end="^\%(\s*\\\s*\)\@!"
            \ transparent fold
            \ containedin=ALLBUT,@vimNoFold

 syn region vimFoldMarker
            \ start="^\".* {{{"
            \ end="^\"\s*}}}"
            \ transparent
            \ extend keepend
            \ skip="={\+"

syn region vimFoldComment
            \ start="^\%(^\s*\"\+.*\n\)\@<!\s*\"\+"
            \ end="^\(\s*\"\)\@!"
            \ containedin=ALLBUT,@vimNoFold
            \ transparent fold
            \ skip=+"\%(\\"\|[^"]\)\{-}\%("\|$\)\|'[^']\{-}'+

syn region vimFoldList
            \ start="\[\n\s*\\\s*"
            \ end="^\(\s*\\\)\@!"
            \ containedin=ALLBUT,@vimNoFold
            \ transparent fold
            \ extend keepend

syn region vimFoldWhile
            \ start="\<wh\%[ile]\>" end="\<endw\%[hile]\>"
            \ transparent fold keepend extend
            \ containedin=ALLBUT,@vimNoFold
            \ skip=+"\%(\\"\|[^"]\)\{-}\%("\|$\)\|'[^']\{-}'+

syn region vimFoldFor
            \ start="\v<for>%(\s*\n\s*\\)?\s*.+%(\s*\n\s*\\\s*)?\s*<in>" end="\<endfo\%[r]\>"
            \ transparent fold
            \ keepend extend
            \ containedin=ALLBUT,@vimNoFold
            \ skip=+"\%(\\"\|[^"]\)\{-}\%("\|$\)\|'[^']\{-}'+

" endif has a shorthand which can also match many other end patterns if we did'nt include the word boundary \> pattern,
" and also it may match syntax end=/pattern/ elements, so we must explicitly exclude these

syn region vimFoldIfContainer
            \ start="\<if\>"
            \ end="\<en\%[dif]\>=\@!"
            \ transparent
            \ keepend extend
            \ containedin=ALLBUT,@vimNoFold
            \ contains=NONE
            \ skip=+"\%(\\"\|[^"]\)\{-}\%("\|$\)\|'[^']\{-}'+

syn region vimFoldIf
            \ start="\<if\>"
            \ end="^\s*\\\?\s*else\%[if]\>"ms=s-1,me=s-1
            \ fold transparent
            \ keepend
            \ contained containedin=vimFoldIfContainer
            \ nextgroup=vimFoldElseIf,vimFoldElse
            \ contains=TOP
            \ skip=+"\%(\\"\|[^"]\)\{-}\%("\|$\)\|'[^']\{-}'+

syn region vimFoldElseIf
            \ start="\<else\%[if]\>"
            \ end="^\s*\\\?\s*else\%[if]\>"ms=s-1,me=s-1
            \ fold transparent
            \ keepend
            \ contained containedin=vimFoldIfContainer
            \ nextgroup=vimFoldElseIf,vimFoldElse
            \ contains=TOP
            \ skip=+"\%(\\"\|[^"]\)\{-}\%("\|$\)\|'[^']\{-}'+

syn region vimFoldElse
            \ start="\<el\%[se]\>"
            \ end="\<en\%[dif]\>=\@!"
            \ fold transparent
            \ keepend
            \ contained containedin=vimFoldIfContainer
            \ contains=TOP
            \ skip=+"\%(\\"\|[^"]\)\{-}\%("\|$\)\|'[^']\{-}'+

syn region vimFoldTryContainer
            \ start="\<try\>"
            \ end="\<endt\%[ry]\>"
            \ transparent
            \ keepend extend
            \ containedin=ALLBUT,@vimNoFold
            \ contains=NONE
            \ skip=+"\%(\\"\|[^"]\)\{-}\%("\|$\)\|'[^']\{-}'+

syn region vimFoldTry
            \ start="\<try\>"
            \ end="^\s*\\\?\s*\(fina\%[lly]\|cat\%[ch]\)\>"ms=s-1,me=s-1
                \ fold transparent
                \ keepend
                \ contained containedin=vimFoldTryContainer
                \ nextgroup=vimFoldCatch,vimFoldFinally
                \ contains=TOP
                \ skip=+"\%(\\"\|[^"]\)\{-}\%("\|$\)\|'[^']\{-}'+

syn region vimFoldCatch
            \ start="\<cat\%[ch]\>"
            \ end="^\s*\\\?\s*\(cat\%[ch]\|fina\%[lly]\)\>"ms=s-1,me=s-1
                \ fold transparent
                \ keepend
                \ contained containedin=vimFoldTryContainer
                \ nextgroup=vimFoldCatch,vimFoldFinally
                \ contains=TOP
                \ skip=+"\%(\\"\|[^"]\)\{-}\%("\|$\)\|'[^']\{-}'+

syn region vimFoldFinally
            \ start="\<fina\%[lly]\>"
            \ end="\<endt\%[ry]\>"
            \ fold transparent
            \ keepend
            \ contained containedin=vimFoldTryContainer
            \ contains=TOP
            \ skip=+"\%(\\"\|[^"]\)\{-}\%("\|$\)\|'[^']\{-}'+

syn region vimFoldFunction
            \ start="\<fu\%[nction]!\=\s\+\%(<[sS][iI][dD]>\|[sSgGbBwWtTlL]:\)\?\%(\i\|[#.]\|{.\{-1,}}\)*\ze\s*("
            \ end="\<endfu\%[nction]\>"
            \ transparent fold
            \ keepend extend
            \ containedin=ALLBUT,@vimNoFold
            \ skip=+"\%(\\"\|[^"]\)\{-}\%("\|$\)\|'[^']\{-}'+ "comment to fix highlight on wiki'

syn region vimFoldAugroup
            \ start="\<aug\%[roup]\ze\s\+\(END\>\)\@!"
            \ end="\<aug\%[roup]\s\+END\>"
            \ transparent fold
            \ keepend extend
            \ containedin=ALLBUT,@vimNoFold
            \ skip=+"\%(\\"\|[^"]\)\{-}\%("\|$\)\|'[^']\{-}'+

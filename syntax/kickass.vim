
if exists("b:current_syntax")
  finish
endif

setlocal commentstring=//\ %s

syntax match kickassConstDecl /^\s*\.const\s\+\zs\w\+/
syntax match kickassConstValue /\$\x\+\b/

" Diese Direktiven farblich hervorheben – robust gegenüber Einrückung
syntax match kickassDirective /^\s*\.\%(const\|var\|label\|word\|byte\|text\|dword\)\>/

syntax keyword kickassKeyword adc and asl bit clc cld cli clv cmp cpx cpy dec dex dey eor inc inx iny lda ldx ldy lsr nop ora pha php pla plp rol ror sbc sec sed sei sta stx sty tax txa tay tya tsx txs
syntax keyword kickassIllegal aac aax alr anc ane arr aso asr atx axa axs dcm dcp dop hlt ins isb isc jam kil lae lar las lax lse lxa oal rla rra sax sbx skb sha shs say shx shy slo skw sre sxa sya tas top xaa xas
syntax keyword kickassControl bcc bcs beq bmi bne bpl brk bvc bvs jmp jsr rti rts

syntax match kickassComment "//.*$"
syntax region kickassComment start="/\*" end="\*/"

syntax keyword kickassDirectiveSpecial CmdArgument

syntax keyword kickassFuncLang getNamespace
syntax keyword kickassFuncString toIntString toBinaryString toOctalString toHexString
syntax keyword kickassFuncMath abs acos asin atan atan2 cbrt ceil cos cosh exp expm1 floor hypot IEEEremainder log log10 log1p max min pow mod random round signum sin sinh sqrt tan tanh toDegrees toRadians
syntax keyword kickassFuncFile LoadBinary LoadPicture LoadSid createFile
syntax keyword kickassFunc3D Matrix RotationMatrix ScaleMatrix MoveMatrix PerspectiveMatrix Vector

syntax keyword kickassStructEnum .struct .enum
syntax keyword kickassEval .eval .fill .print .printnow .import .align .assert .asserterror .error
syntax keyword kickassKeywords .pc .importonce .pseudopc .return .eval
syntax match kickassStartAddress /\*\s*=/

syntax keyword kickassEncoding .encoding

syntax match kickassPreprocessor /#\(define\|elif\|if\|undef\)\s\+\w\+/
syntax match kickassPreprocessor /#\(else\|endif\|importonce\)/
syntax match kickassPreprocessor /#import\s\+\".*\"/
syntax match kickassPreprocessor /#importif\s\+!?[a-zA-Z_]\w*\s\+\".*\"/

syntax keyword kickassConst true false
syntax keyword kickassColor BLACK WHITE RED CYAN PURPLE GREEN BLUE YELLOW ORANGE BROWN LIGHT_RED DARK_GRAY GRAY DARK_GREY GREY LIGHT_GREEN LIGHT_BLUE LIGHT_GRAY LIGHT_GREY

syntax keyword kickassOpcode LDA_IMM LDA_ZP LDA_ZPX LDX_ZPY LDA_IZPX LDA_IZPY LDA_ABS LDA_ABSX LDA_ABSY JMP_IND BNE_REL RTS
syntax keyword kickassFile BF_C64FILE BF_BITMAP_SINGLECOLOR BF_KOALA BF_FLI
syntax keyword kickassPseudo AT_ABSOLUTE AT_ABSOLUTEX AT_ABSOLUTEY AT_IMMEDIATE AT_INDIRECT AT_IZEROPAGEX AT_IZEROPAGEY AT_NONE

syntax keyword kickassMath PI E
syntax keyword kickassHash Hashtable
syntax match kickassList /\b\(list\|List\)(\s*\$?\d*\s*)/
syntax match kickassFor /\.for\s*(var)/
syntax match kickassIfElse /\.if\b\|else\b/
syntax match kickassWhile /\.while\s*(.*)/

syntax region kickassString start=/"/ end=/"/ contains=kickassEscape
syntax match kickassEscape /\\./

syntax match kickassFilenamespace /\.filenamespace\s*\w\+/
syntax match kickassNamespace /\.namespace\s*\w\+/
" syntax match kickassLabel /^\s*!?\w\+:/
syntax match kickassLabel /^\s*\([!@.]\?\w\+\)\ze:/
syntax match kickassPseudocommand /\.pseudocommand\s*\w\+/
syntax match kickassFunction /\.function\s*\w\+/
syntax match kickassMacro /\.macro\s*\w\+/

syntax match kickassHex /#\?\$[0-9A-Fa-f]\+/
syntax match kickassDec /\b\d\+/
syntax match kickassBin /#\?%[01]\+/

let b:current_syntax = "kickass"

highlight default link kickassKeyword         Keyword
highlight default link kickassIllegal         Error
highlight default link kickassControl         Conditional
highlight default link kickassComment         Comment
highlight default link kickassDirective       PreProc
highlight default link kickassDirectiveSpecial Type
highlight default link kickassFuncLang        Function
highlight default link kickassFuncString      String
highlight default link kickassFuncMath        Function
highlight default link kickassFuncFile        Function
highlight default link kickassFunc3D          Function
highlight default link kickassStructEnum      Type
highlight default link kickassEval            Statement
highlight default link kickassKeywords        Statement
highlight default link kickassEncoding        Type
highlight default link kickassPreprocessor    PreProc
highlight default link kickassConst           Constant
highlight default link kickassColor           Constant
highlight default link kickassOpcode          Keyword
highlight default link kickassFile            Identifier
highlight default link kickassPseudo          Keyword
highlight default link kickassMath            Constant
highlight default link kickassHash            Type
highlight default link kickassList            Identifier
highlight default link kickassFor             Repeat
highlight default link kickassIfElse          Conditional
highlight default link kickassWhile           Repeat
highlight default link kickassString          String
highlight default link kickassEscape          SpecialChar
highlight default link kickassFilenamespace   Identifier
highlight default link kickassNamespace       Identifier
highlight default link kickassLabel           Label
highlight default link kickassPseudocommand   Keyword
highlight default link kickassFunction        Function
highlight default link kickassMacro           Macro
highlight default link kickassHex             Number
highlight default link kickassDec             Number
highlight default link kickassBin             Number
highlight default link kickassConstDecl       Identifier
highlight default link kickassConstValue      Number

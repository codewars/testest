! Copyright 2019-2024 nomennescio

USING: accessors arrays assocs classes classes.error compiler.errors continuations debugger formatting fry inspector
io io.streams.string io.styles kernel locals math namespaces parser prettyprint prettyprint.backend
prettyprint.config prettyprint.custom prettyprint.sections quotations sequences splitting
stack-checker.errors summary system tools.errors ;
IN: tools.testest

: describe#{ ( description -- starttime ) nl "<DESCRIBE::>%s" printf nl flush nano-count ;
: it#{ ( description -- starttime ) nl "<IT::>%s" printf nl flush nano-count ;
: }# ( starttime -- ) nano-count swap - 1000000 / nl "<COMPLETEDIN::>%f ms" printf nl ;

! user redefinable test result message quotations

SYMBOL: test-passed.
SYMBOL: test-failed.

[ "Test Passed" write ] test-passed. set-global
[ "Test Failed : " write error. ] test-failed. set-global

: with-passed ( passed quot -- ) '[ _ test-passed. set @ ] with-scope ; inline
: with-failed ( failed quot -- ) '[ _ test-failed. set @ ] with-scope ; inline
: with-passed-failed ( passed failed quot -- ) '[ _ test-passed. set _ test-failed. set @ ] with-scope ; inline

<PRIVATE

: with-message ( quot -- ) with-string-writer unclip-last [ "\n" "<:LF:>" replace ] dip suffix write ; inline

: passed. ( -- ) [ test-passed. get call( -- ) ] with-message ; inline
: failed. ( error -- ) [ test-failed. get call( error -- ) ] with-message ; inline
: (error.) ( error -- ) [ print-error ] with-message ; inline

: passed# ( -- ) nl "<PASSED::>" write ;
: failed# ( -- ) nl "<FAILED::>" write ;
: error# ( -- ) nl "<ERROR::>" write ;

ERROR: thrown error ;

: catch-all ( stack quot -- stack' ) '[ _ _ with-datastack ] [ \ thrown boa 1array ] recover ; inline

: unexpected-error? ( got expected -- ? ) [ ?first thrown? ] bi@ not and ;

SYMBOL: once
: only-once ( ..a quot: ( ..a -- ... ) -- ... ) once get [ 2drop ] [ call once on ] if ; inline

SYMBOL: no-compiler-errors
: without-compiler-errors ( ..a b quot: ( ..a b -- ... ) -- ... )
  no-compiler-errors compiler-errors get values [ on call ] [ [ off ] dip [ errors. ] only-once 3drop ] if-empty ; inline

: (unit-test) ( test-quot: ( -- ... ) expected-quot: ( -- ... ) -- )
  [ swap [ { } swap catch-all ] bi@ swap 2dup unexpected-error? [ drop first error# (error.) ]
    [ '[ _ _ assert-sequence= passed# passed. ] [ failed# failed. ] recover ] if nl
  ] without-compiler-errors ;

PRIVATE>

DEFER: -> delimiter
DEFER: }> delimiter
SYNTAX: <{ \ -> parse-until >quotation suffix! \ }> parse-until >quotation suffix! \ (unit-test) suffix! ;

! customized printing

! deprecated
: lf ( -- ) "<:LF:>" write ;

<PRIVATE

: pprint-unlimited ( obj -- ) [ pprint ] without-limits ;

! signature changed from ( obj -- str ) in 0.98 to ( obj -- ) in 0.99, use 0.98's definition
: error-in-pprint ( obj -- str )
    class-of name>> "~pprint error: " "~" surround ;

: seq. ( seq -- )
  [
    [ nl pprint-unlimited ]
    [ drop [ error-in-pprint ] keep write-object ]
    recover
  ] each
;

SYMBOL: ERROR:{
: pprint-error ( error-tuple -- ) [ ERROR:{ ] dip [ class-of ] [ tuple>assoc ] bi \ } (pprint-tuple) ;

! print errors differently from tuples

M: tuple pprint* dup class-of error-class? [ pprint-error ] [ pprint-tuple ] if ;
M: tuple error. dup class-of error-class? no-compiler-errors get and [ pprint-short ] [ describe ] if ;

SYMBOL: THROWN:
M: thrown pprint* THROWN: pprint-word error>> pprint* ;
M: thrown error. "Thrown: " write error>> error. ;

M: assert-sequence error.
  [ "Expected :" write expected>> seq. ]
  [ nl "But got :" write got>> seq. ] bi
;

PRIVATE>
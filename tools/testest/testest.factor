! Copyright 2019-2022 nomennescio

USING: accessors arrays classes classes.error continuations debugger formatting fry inspector
io io.streams.string io.styles kernel locals math namespaces parser prettyprint prettyprint.backend
prettyprint.config prettyprint.custom quotations sequences splitting system ;
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

: unexpected-error? ( got expected -- ? ) ?first thrown? not swap ?first thrown? and ;

: (unit-test) ( test-quot expected-quot -- )
  [ { } swap catch-all ] bi@ 2dup unexpected-error? [ drop first error# (error.) ]
  [ '[ _ _ assert-sequence= passed# passed. ] [ failed# failed. ] recover ] if nl
;

PRIVATE>

DEFER: -> delimiter
DEFER: }> delimiter
SYNTAX: <{ \ -> parse-until >quotation suffix! \ }> parse-until >quotation suffix! \ (unit-test) suffix! ;

! customized printing

! deprecated
: lf ( -- ) "<:LF:>" write ;

<PRIVATE

: pprint-unlimited ( obj -- ) [ pprint ] without-limits ;

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
M: tuple error. dup class-of error-class? [ pprint-short ] [ describe ] if ;

SYMBOL: THROWN:
M: thrown pprint* THROWN: pprint-word error>> pprint* ;
M: thrown error. "Thrown: " write error>> error. ;

M: assert-sequence error.
  [ "Expected :" write expected>> seq. ]
  [ nl "But got :" write got>> seq. ] bi
;

PRIVATE>
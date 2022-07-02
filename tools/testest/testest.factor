! Copyright 2019-2022 nomennescio

USING: accessors continuations debugger formatting fry io io.styles kernel locals math
namespaces parser prettyprint prettyprint.config quotations sequences system ;
IN: tools.testest

: describe#{ ( description -- starttime ) nl "<DESCRIBE::>%s" printf nl flush nano-count ;
: it#{ ( description -- starttime ) nl "<IT::>%s" printf nl flush nano-count ;
: }# ( starttime -- ) nano-count swap - 1000000 / nl "<COMPLETEDIN::>%f ms" printf nl ;

! line internal unformatted linefeed, to be used in single-line test result messages

: lf ( -- ) "<:LF:>" write ;

: pprint-unlimited ( obj -- ) [ pprint ] without-limits ;

: seq. ( seq -- )
  [
    [ lf pprint-unlimited ]
    [ drop [ error-in-pprint ] keep write-object ]
    recover
  ] each
;

! user redefinable test result message quotations

SYMBOL: test-passed.
SYMBOL: test-failed.

[ "Test Passed" write ] test-passed. set-global
[ "Test Failed : " write error. ] test-failed. set-global

: with-passed ( passed quot -- ) '[ _ test-passed. set @ ] with-scope ; inline
: with-failed ( failed quot -- ) '[ _ test-failed. set @ ] with-scope ; inline
: with-passed-failed ( passed failed quot -- ) '[ _ test-passed. set _ test-failed. set @ ] with-scope ; inline

<PRIVATE

: passed. ( -- ) test-passed. get call( -- ) ; inline
: failed. ( error -- ) test-failed. get call( error -- ) ; inline

: passed# ( -- ) nl "<PASSED::>" write ;
: failed# ( -- ) nl "<FAILED::>" write ;

:: (unit-test) ( test expected -- )
  [ { } test with-datastack { } expected with-datastack assert-sequence= passed# passed. nl ]
  [ failed# failed. nl ] recover
;

PRIVATE>

! customized printing

SYMBOL: ERROR:{
: pprint-error ( error-tuple -- ) [ ERROR:{ ] dip [ class-of ] [ tuple>assoc ] bi \ } (pprint-tuple) ;

! print errors differently from tuples
M: tuple pprint* dup class-of error-class? [ pprint-error ] [ pprint-tuple ] if ;
M: tuple error. dup class-of error-class? [ pprint-short ] [ describe ] if ;

M: assert-sequence error.
  [ "Expected :" write expected>> seq. ]
  [ lf "but got :" write got>> seq. ] bi
;

DEFER: -> delimiter
DEFER: }> delimiter
SYNTAX: <{ \ -> parse-until >quotation suffix! \ }> parse-until >quotation suffix! \ (unit-test) suffix! ;

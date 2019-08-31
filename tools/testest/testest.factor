! Copyright 2019 nomennescio

USING: accessors continuations debugger formatting io io.styles kernel locals math namespaces
parser prettyprint quotations sequences system ;
IN: tools.testest

: describe#{ ( description -- starttime ) nl "<DESCRIBE::>%s" printf nl nano-count ;
: it#{ ( description -- starttime ) nl "<IT::>%s" printf nl nano-count ;
: }# ( starttime -- ) nano-count swap - 1000000 / nl "<COMPLETEDIN::>%f ms" printf nl ;

! line internal unformatted linefeed, to be used in single-line test result messages

: lf ( -- ) "<:LF:>" write ;

: seq. ( seq -- )
  [
    [ lf pprint-short ]
    [ drop [ error-in-pprint ] keep write-object ]
    recover
  ] each
;

! user redefinable test result messages

SYMBOL: test-passed.
SYMBOL: test-failed.

[ "Test Passed" write ] test-passed. set-global
[ "Test Failed : " write error. ] test-failed. set-global

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

M: assert-sequence error.
  [ "Expected :" write expected>> seq. ]
  [ lf "but got :" write got>> seq. ] bi
;

DEFER: -> delimiter
DEFER: }> delimiter
SYNTAX: <{ \ -> parse-until >quotation suffix! \ }> parse-until >quotation suffix! \ (unit-test) suffix! ;

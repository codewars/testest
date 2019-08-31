! Copyright 2019 nomennescio

USING: accessors debugger io kernel namespaces sequences tools.testest ;
IN: tests

M: assert-sequence error.
  [ "Actually expected :" write expected>> seq. ]
  [ lf "but instead got :" write got>> seq. ] bi
;

: run-test ( -- )
  "short strings" it#{
    <{ "Hello World!" -> "Hello World!" }>
    <{ "Hello Worlds!" -> "Hello Worlds!" }>
  }#
  
  "failing compares" it#{
    <{ "Hello World!" -> "Hello Worlds!" }>
    <{ "Hello Worlds!" -> "Hello Worlds! " }>
  }#
;

: custom1 ( -- )

  [ [ "Just passed" write ] test-passed. set
    [ "Just failed" write drop ] test-failed. set
    run-test
  ] with-scope
;

: custom2 ( -- )
  [
    [ "Test passed" write ] test-passed. set
    [ error. ] test-failed. set
    run-test
  ] with-scope
;

: custom3 ( -- )
  run-test
;

: run-tests ( -- )
  "custom message" describe#{
    custom1
    custom2
    custom3
  }#
;

MAIN: run-tests

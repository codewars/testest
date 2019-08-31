! Copyright 2019 nomennescio

USING: io tools.testest ;
IN: tests

: run-tests ( -- )
  <{ 0 -> 0 }>
  <{ 1/2 -> 1/2 }>
  <{ 1.0 -> 1.0 }>
  <{ C{ 0 1 } -> C{ 0 1 } }>
  <{ { 1 2 } -> { 1 2 } }>
  <{ B{ 1 2 } -> B{ 1 2 } }>
  <{ V{ 3 4 } -> V{ 3 4 } }>
  <{ "Hello" -> "Hello" }>
  <{ \ run-tests -> \ run-tests }>
  <{ [ "Hello" print ] -> [ "Hello" print ] }>
;

MAIN: run-tests

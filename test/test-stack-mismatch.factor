! Copyright 2019 nomennescio

USING: tools.testest ;
IN: tests

: run-tests ( -- )

"group of tests" describe#{
  "single test" it#{
    <{ 0 0 -> 0 }>
  }#
  "double test" it#{
    <{ 0 0 -> 0 }>
    <{ 0 -> 0 }>
  }#
  "double fail test" it#{
    <{ 0 0 -> 0 }>
    <{ 0 -> 0 0 0 }>
  }#
}#

;

MAIN: run-tests


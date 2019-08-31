! Copyright 2019 nomennescio

USING: tools.testest ;
IN: tests

: run-tests ( -- )

"Expected results and actual results tests" describe#{
  "Match" it#{
     <{ 0 1 2 3 -> 0 1 2 3 }>
  }#
  "Mismatch" it#{
     <{ 0 1 2 3 -> 4 5 6 7 }>
  }#
}#
;

MAIN: run-tests


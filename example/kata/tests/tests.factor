USING: kata.preloaded prettyprint tools.testest ;
FROM: kata => solution ;
IN: kata.tests

: run-tests ( -- )
  "Sample tests" describe#{
    "Succeeding tests" it#{
      <{ 0 1 solution ->  0 }>
      <{ 1 0 solution ->  0 }>
      <{ 1 1 solution ->  1 }>
      <{ 3 5 solution -> 15 }>
    }#
    "Failing tests" it#{
      <{ 0 0 solution ->  1 }>
    }#
  }#
;

MAIN: run-tests

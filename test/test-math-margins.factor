! Copyright 2022 nomennescio

USING: accessors debugger io kernel math.margins namespaces sequences tools.testest ;
IN: tests

: run-tests ( -- )
  "math.margins" describe#{
    "constructors" it#{
      <{ 1 2 3 <margin> not -> f }>
      <{ 2 1 [a-e,a+e] not -> f }>
      <{ 2 50 [a-%,a+%] not -> f }>
    }#
  }#
;

MAIN: run-tests
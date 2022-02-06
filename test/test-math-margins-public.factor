! Copyright 2022 nomennescio

USING: accessors debugger io kernel math.constants math.margins namespaces present sequences tools.testest ;
IN: tests

: run-tests ( -- )
  "math.margins" describe#{
    "constructors" it#{
      <{ 1 2 3 <margin> not -> f }>
      <{ 2 1 [a-e,a+e] not -> f }>
      <{ 2 50 [a-%,a+%] not -> f }>
    }#
    "constructors aliases" it#{
      <{ 2 1 ± not -> f }>
      <{ 2 50 ±% not -> f }>
    }#
    "conversion" it#{
      <{ "no" >margin -> f }>
      <{ 2 >± -> 2 0 ± }>
      <{ 2 0 ± >± -> 2 0 ± }>
    }#
    "equals" it#{
      <{ 2 >margin 2 2 2 <margin> = -> t }>
      <{ 2 >margin 2 1 [a-e,a+e] = -> t }>
      <{ 3 >margin pi 5 [a-%,a+%] = -> t }>
    }#
  }#
;

MAIN: run-tests

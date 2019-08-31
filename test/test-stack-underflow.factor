! Copyright 2019 nomennescio

USING: kernel tools.testest ;
IN: tests

: run-tests ( -- )

"stack underflow" describe#{
  "single test" it#{
    <{ drop -> 0 }>
  }#
  "double test" it#{
    <{ drop -> 0 }>
    <{ drop drop -> 0 }>
  }#
  "double test" it#{
    <{ drop -> 0 0 }>
    <{ drop drop -> 0 0 }>
  }#
  "double test" it#{
    <{ drop -> 0 0 }>
    <{ drop drop -> 0 }>
  }#
}#

;

MAIN: run-tests


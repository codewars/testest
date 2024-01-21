! Copyright 2024 nomennescio

USING: tools.testest kernel math ;
IN: tests

: wont-compile ;

: run-tests ( -- )

"Compilation error" describe#{
  "Compilation error in user code" it#{
     <{ wont-compile -> }>
  }#
}#
;

MAIN: run-tests
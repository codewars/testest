! Copyright 2024 nomennescio

USING: tools.testest kernel math ;
IN: tests

: wont-infer ( -- ) 0 ;

: run-tests ( -- )

"Compilation error" describe#{
  "Compilation error in user code" it#{
     <{ wont-infer -> }>
  }#
}#
;

MAIN: run-tests
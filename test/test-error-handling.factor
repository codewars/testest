! Copyright 2022 nomennescio

USING: tools.testest kernel math ;
IN: tests

ERROR: custom-error error-message integer-argument ;
C: <custom-error> custom-error

: run-tests ( -- )

"System and custom errors tests" describe#{
  "Unexpected system error in user code" it#{
     <{ 1 0 / -> 1 }>
  }#
  "Unexpected custom error in user code" it#{
     <{ "thrown custom error" 1 custom-error -> 1 }>
  }#
  "Expected custom error" it#{
     <{ "thrown custom error" 1 custom-error -> "thrown custom error" 1 custom-error }>
  }#
  "Missing expected custom error" it#{
     <{ 1 -> "thrown custom error" 1 custom-error }>
  }#
  "Missing expected thrown error" it#{
     <{ "thrown error" -> "thrown error" throw }>
  }#
  "Missing expected thrown custom error" it#{
     <{ "thrown custom error" 1 <custom-error> -> "thrown custom error" 1 custom-error }>
  }#
}#
;

MAIN: run-tests
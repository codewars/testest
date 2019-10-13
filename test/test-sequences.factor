! Copyright 2019 nomennescio

USING: tools.testest ;
IN: tests

: run-tests ( -- )

<{ { 0 } -> { 1 } }>
<{ { { 0 } { 0 } } -> { { 0 } { 1 } } }>

;

MAIN: run-tests


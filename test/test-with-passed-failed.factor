! Copyright 2022 nomennescio

USING: accessors debugger io kernel namespaces sequences tools.testest ;
IN: tests

: pass1 ( -- ) <{ "Hello World!" -> "Hello World!" }> ;
: pass2 ( -- ) <{ "Hello Worlds!" -> "Hello Worlds!" }> ;
: fail1 ( -- ) <{ "Hello World!" -> "Hello Worlds!" }> ;
: fail2 ( -- ) <{ "Hello Worlds!" -> "Hello Worlds! " }> ;

: run-test ( -- )
  "short strings" it#{ pass1 pass2 }#
  "failing compares" it#{ fail1 fail2 }#
;

: custom1 ( -- ) [ "Just passed" write ] [ "Just failed" write drop ] [ run-test ] with-passed-failed ;
: custom2 ( -- ) [ "Test passed" write ] [ error. ] [ run-test ] with-passed-failed ;
: custom3 ( -- ) run-test ;

: run-tests ( -- )

  "custom message" describe#{
    custom1
    custom2
    custom3
  }#
  
  "nested custom messages" describe#{

    [ "Test passed A" write ] [ "Test failed A " write error. ] [
      "short strings" it#{
        [ "Passed 1" write ] [ pass1 ] with-passed
        [ "Passed 2" write ] [ pass2 ] with-passed
      }#
      
      "failing compares" it#{
        [ "Passed 3" write ] [ fail1 ] with-passed
        [ "Passed 4" write ] [ fail2 ] with-passed
      }#
    ] with-passed-failed
    
    [ "Test passed B" write ] [ "Test failed B " write error. ] [
      "short strings" it#{
        [ "Failed 1" write drop ] [ pass1 ] with-failed
        [ "Failed 2" write drop ] [ pass2 ] with-failed
      }#
      
      "failing compares" it#{
        [ "Failed 3" write drop ] [ fail1 ] with-failed
        [ "Failed 4" write drop ] [ fail2 ] with-failed
      }#
    ] with-passed-failed

  }#
;

MAIN: run-tests
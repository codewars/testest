## tools.testest
*"If thou testest me, thou wilt find no wickedness in me"
Psalms 17:3*

### Vocabulary to test Factor code on Codewars

`tools.testest` is a Factor vocabulary for writing test cases on Codewars, tuned to the Codewars framework by appropriately formatted messages. 

### General setup

In your test code `USE: tools.testest`then structure your tests. Tests are run by executing the `MAIN:` entrypoint, which points to a word with no stack effects. A typical generic test setup looks like:
```
USING: tools.testest ... your vocabs ... ;
IN: your-kata.tests

: run-tests ( -- )
  ... your test code ...
;

MAIN: run-tests
```
and your solution would look like:
```
IN: your-kata
... your solution ...
```

### Test cases
Test cases are partitioned into one or more `describe#{` sections, where each section has one or more test cases grouped under `it#{`. A single test case is run by `<{ ... actual results ... -> ... expected results ... }>` where both sides can contain words that are called to process inputs. A test cases checks if the actual results compare equal (using the `=` word) to the expected results. It passes upon success, and fails upon failure. This is reported in the Codewars runner. Both `describe#{` sections as well as `it#{'` sections report their execution times at the end of a section.

Typical Factor testcode to test a solution `solve ( a b c -- d )` looks like:
```
: your-solve ( a b c -- d )
  ... your reference solution ...
;

:: run-tests ( -- )
  "Specific test cases" describe#{
    "Test case 1" it#{
      <{ 1 2 3 solve -> 6 }> 
    }#
    "Test case 2" it#{
      <{ 4 5 6 solve -> 15 }>
    }#
  }#
  "Random test cases" describe#{
    "Single Test Group" it#{
	  100 [
	    1000 random :> r 
        <{ r r 3 * r 5 - solve -> r r 3 * r 5 - your-solve }> 
      ] times
    }#
	100 [
      "Testing for " 1000 random :> r r number>string append
      it#{ 
        <{ r 2 4 solve -> r 2 4 reference-solve }>
      }#
    ] times
  }#
;
```

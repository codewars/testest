## tools.testest
*"If thou testest me, thou wilt find no wickedness in me"*
Psalms 17:3

### Vocabulary to test Factor code on Codewars

`tools.testest` is a Factor vocabulary for writing test cases on Codewars, tuned to the Codewars framework by appropriately formatted messages written by nomennescio (https://github.com/nomennescio).

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
      it#{ <{ r 2 4 solve -> r 2 4 reference-solve }> }#
    ] times
  }#
;
```

### Custom pass and fail messages

Default messages are shown when a test passes or fails. These message can customised using `with-passed`, `with-failed`, and `with-passed-failed` combinators, with the following signatures:
```
: with-passed ( passed quot -- )
: with-failed ( failed quot -- )
: with-passed-failed ( passed failed quot -- )
```
Both `passed` and `failed` are quotations, one of which is called after each test inside `quot` is executed when it passes or fails. The signature of `passed` and `failed` are:
```
: passed ( -- )
: failed ( error -- )
```

The argument to `failed` is an `assert-sequence` error with slots `got` for a sequence of actual results and `expected` for a sequence of expected results. Both the `passed` and `failed` quotations can write messages to output stream. To print newlines use the `lf` word.

Custom messages can be nested, and are restored outside the scope of the quotation passed to the `with-passed`, `with-failed`, and `with-passed-failed`, combinators.

### Custom pass and fail messages example

```
: run-tests ( -- )
  ...
  [ "Just passed" ] [
    [ [ "Expected: " write expected>> seq. ] [ lf "Actual: " write got>> seq. ] bi ] [
      <{ 1 4 add -> 5 }>
      <{ 2 3 add -> 5 }>
    ] with-failed
  ] with-passed
  ...
;
```

### Inexact value comparisons with margins

In some situations solutions compute an inexact solution. The `math.margins` vocabulary can to convert `real` result into a `margin`, which can then be compared against a predefined expected value with acceptable margins defined using the implicitly used `=` by each test case. Three types of margins are supported: `margin`, `abs-margin`, and `rel-margin`, representing general margins, margins with absolute error bound, and margins with a relative error bound, each with a different visual representations, but the same from a comparison point of view. These can be constructed with
```
: <margin> ( from central to -- margin )
: [a-e,a+e] ( a epsilon -- margin )
: [a-%,a+%] ( a percent -- margin )
```
The latter two have aliases `±` for `[a-e,a+e]` and `±%` for `[a-%,a+%]`.

Reals can be converted in margins for comparison with `>margin` or its alias `>±`. Comparing using `=` with a constructed margin will compare against the margin's boundaries, if the real falls within the boundaries true is returned, else false.

### Inexact value comparison with margins example

```
: run-tests ( -- )
  "Example test" describe#{
    "Absolute margin" it#{ <{ 20 sin >± -> 0 1 ± }> }#
    "Relative margin" it#{ <{ calculate-pi >± -> pi 1 ±% }> }#
  }#
;
```

The first example calculates a sine, converts to a margin, then compares against `0±1`, i.e. all values within the range `[-1,1]` will pass the test.
The second examples calculates pi to a certain precision, converts it to margin, then compares against builtin `pi±1%`, i.e. all values within the range `[pi-pi*1/100, pi+pi*1/100]` will pass the test.

### Utility words

Some users requested features to be added to the library, which although useful, might not be common enough to warrant their inclusion yet.

I list these usecases here, with utility words which implement the feature

##### Codewars newlines

Strings to be printed on the Codewars code runner, need to use `lf` to print newlines. The `cw>` word converts embedded newlines into newlines used by the runner
```
: >cw ( string -- codewars-string )  "\n" "<:LF:>" replace ;
```

##### Minimum margin for relative margins

When using relative margins, the closer the value gets to zero, the smaller the effective margin gets, until it is zero at value zero. The `%e` word calculates a relative margin such that it will never get smaller than `epsilon`
```
: %e ( value percent epsilon -- value max(rel,abs) ) [ over * 100 / ] dip max ;
```

Example usage
```
pi 1 1e-10 %e ±
```
creates a margin of `pi` within `1%`, or absolute margin `1e-10`, whatever is larger

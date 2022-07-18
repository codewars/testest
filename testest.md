## tools.testest
*"If thou testest me, thou wilt find no wickedness in me"*
Psalms 17:3

### Vocabulary to test Factor code on Codewars

`tools.testest` is a Factor vocabulary for writing test cases on Codewars, tuned to the Codewars framework by appropriately formatted messages written by nomennescio (https://github.com/nomennescio).

### General setup

For code testing a solution `solve`:
```
IN: your-kata
: solve ( ... )
... your solution ...
```

in your test code `USE: tools.testest` and structure your tests. Tests are run by executing the `MAIN:` entrypoint, which points to a word with no stack effects. A typical generic test setup looks like:
```
USING: tools.testest your-kata.preloaded ... vocabs used by tests ... ;
FROM: your-kata => solve ;
IN: your-kata.tests

: run-tests ( -- )
  ... your test code ...
;

MAIN: run-tests
```
where `run-tests` calls `solve` with different test vectors for each test case.

### Test cases
Test cases are partitioned into one or more `describe#{` sections, where each section has one or more test cases grouped under `it#{`. A single test case is run by `<{ ... actual results ... -> ... expected results ... }>` where both sides can contain words that are called to process inputs and/or outputs. The test case checks if the implicit sequence of actual results on the left of `->` compares equal (using the `=` word) to the sequence of expected results on the right. It passes upon success, and fails upon failure. This is reported in the Codewars runner. Note that any `<{ .. }>` does not affect the stack when it has completed. Both `describe#{` sections as well as `it#{` sections report their execution times at the end of a section.

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

Default messages are shown when a test passes or fails. These messages can be customised using `with-passed`, `with-failed`, and `with-passed-failed` combinators, with the following stack effects:
```
: with-passed ( passed quot -- )
: with-failed ( failed quot -- )
: with-passed-failed ( passed failed quot -- )
```
Both `passed` and `failed` are quotations, one of which is called after each test inside `quot` is executed when it passes or fails. The signatures of `passed` and `failed` are:
```
: passed ( -- )
: failed ( error -- )
```

The argument to `failed` is an `assert-sequence` error with slots `got` for a sequence of actual results and `expected` for a sequence of expected results. Both the `passed` and `failed` quotations can write messages to the output stream. Newlines are converted to platform specific line separators.

Custom messages can be nested, and are restored outside the scope of the quotation passed to the `with-passed`, `with-failed`, and `with-passed-failed` combinators.

### Custom pass and fail messages example

```
: run-tests ( -- )
  ...
  [ "Just passed" ] [
    [ [ "Expected: " write expected>> . ] [ nl "Actual: " write got>> . ] bi ] [
      <{ 1 4 add -> 5 }>
      <{ 2 3 add -> 5 }>
    ] with-failed
  ] with-passed
  ...
;
```

### Handling of errors

Factor can throw errors, and testcode may need to test that. As errors are first-class objects, the testest library supports such testing in an intuitive way. If test code on the right side of the arrow `->` throws an error, the left side is expected to throw that same error, if it does, the test passes, if it doesn't the test fails. On the other hand, if the code on the right does not throw an error, any error thrown by the left side is considered as a real error and reported as such. To help analysing thrown errors, all `ERROR:`s are printed in a special format by the default failure handler. *All* errors inside `<{ .. }>` are captured and *not* rethrown.

### Handling of errors example

```
ERROR: custom-error error-message integer-argument ;

: run-tests ( -- )

"System and custom errors tests" describe#{
  "Unexpected divide by 0 error in user code" it#{
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
}#
```

### Inexact value comparisons with margins

In some situations solutions compute an inexact result. The `math.margins` vocabulary can be used to convert a `real` result into a `margin`, which can then be compared against a predefined expected value with acceptable margins defined using the implicitly used `=` by each test case. Three types of margins are supported: `margin`, `abs-margin`, and `rel-margin`, representing general margins, margins with absolute error bound, and margins with a relative error bound respectively, each with a different visual representation, but giving the same outcome from a comparison point of view. These can be constructed with
```
: <margin> ( from central to -- margin )
: [a-e,a+e] ( a epsilon -- margin )
: [a-%,a+%] ( a percent -- margin )
```
The latter two have aliases `±` for `[a-e,a+e]` and `±%` for `[a-%,a+%]`.

Reals can be converted in margins for comparison with `>margin` or its alias `>±`. Comparing using `=` with a constructed margin will compare against the margin's boundaries, if the real falls within the boundaries true is returned, else false.

Margin comparisons are not true equivalence relations, but are tolerance relations, as they are reflexive and symmetric, but not necessarily transitive.

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

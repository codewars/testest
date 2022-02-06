! Copyright 2022 nomennescio
! See LICENSE.md for license

! margins are like intervals with a central value and left and right acceptable margins
! margins compare equal if one contains the other, to support inexact comparisons using equal ("=")

USING: accessors combinators.short-circuit kernel locals make math math.intervals math.parser present prettyprint.custom prettyprint.sections sequences ;
IN: math.margins

<PRIVATE

: -.+ ( a b -- a-b a a+b ) [ - ] [ drop ] [ + ] 2tri ;

! class

TUPLE: margin { range interval read-only } { central real read-only } ; ! preferably margin would be a subclass of interval, but we can't reuse its constructor
TUPLE: abs-margin < margin ; ! margin class with absolute margin
TUPLE: rel-margin < margin ; ! margin class with margin as percentage of central value

! constructors

ERROR: unordered-margin ; ! guards invariant from<=central<=to

:: boa-margin ( from central to class -- margin ) from central <= central to <= and [ from to [a,b] central ] [ unordered-margin ] if class boa ; inline
: <margin> ( from central to -- margin ) margin boa-margin ;

PRIVATE>

: [a-e,a+e] ( a epsilon -- margin ) abs -.+ abs-margin boa-margin ;
: [a-%,a+%] ( a percent -- margin ) over * 100 / abs -.+ rel-margin boa-margin ;

ALIAS: ±  [a-e,a+e]
ALIAS: ±% [a-%,a+%]

! methods

! convert object to margin. prerequisite for comparisons

GENERIC: >margin ( obj -- margin )

M: object >margin drop f ;
M: margin >margin ;
M: real >margin dup dup <margin> ;

ALIAS: >± >margin

<PRIVATE

! margins compare equal if one contains the other (not a true equality because it's reflexive and symmetric, but not transitive)

M: margin hashcode* 2drop 0xbef001ed ; ! semi-unique singular value
M: margin equal? over margin? [ [ range>> ] bi@ { [ interval-subset? ] [ swap interval-subset? ] } 2|| ] [ 2drop f ] if ;

! extract values from margin

: margin> ( margin -- from central to ) [ range>> [ from>> ] [ to>> ] bi [ first ] bi@ ] [ central>> ] bi swap ;

! >string conversions

! specific

:     margin>string (     margin -- string ) margin> spin [ # "«" % # "»" % # ] "" make ;
: abs-margin>string ( abs-margin -- string ) margin> spin drop [ - ] keep [ # "±" % # ] "" make ;
: rel-margin>string ( rel-margin -- string ) margin> spin drop [ [ - ] keep abs / 100 * ] keep [ # "±" % # "%" % ] "" make ;

! generic

M:     margin present     margin>string ;
M: abs-margin present abs-margin>string ;
M: rel-margin present rel-margin>string ;

! custom prettyprinting

M: margin pprint* present text ;

PRIVATE>

! Copyright 2022 nomennescio
! See LICENSE.md for license

! margins are like intervals with a central value and left and right acceptable error margins
! margins compare equal if one contains the other, to support inexact comparisons using equal ("=")

USING: accessors combinators.short-circuit kernel math math.intervals prettyprint.custom prettyprint.sections sequences ;
IN: math.margins

! class

TUPLE: margin { range interval read-only } { central real read-only } ;
TUPLE: abs-error-margin < margin ;
TUPLE: rel-error-margin < margin ;

! constructors

: new-margin ( from to central class -- margin ) [ [ [a,b] ] dip ] dip boa ; inline ! does not check from <= central <= to, <interval> handles from > to
: <margin> ( from to central -- margin ) margin new-margin ;
: -+a ( a b -- a-b a+b a ) [ - ] [ + ] [ drop ] 2tri ;
: [a-e,a+e] ( a epsilon -- margin ) -+a abs-error-margin new-margin ;
: [a-%,a+%] ( a percent -- margin ) over * 100 / -+a rel-error-margin new-margin ;

ALIAS: ±  [a-e,a+e]
ALIAS: ±% [a-%,a+%]

! methods

: margin> ( margin -- from to central ) [ range>> [ from>> ] [ to>> ] bi [ first ] bi@ ] [ central>> ] bi ;

! convert object to margin. prerequisite for comparisons

GENERIC: >margin ( obj -- margin )

M: object >margin drop f ;
M: margin >margin ;
M: real >margin dup dup <margin> ;

ALIAS: >± >margin

! margins compare equal if one contains the other

M: margin equal? over margin? [ [ range>> ] bi@ { [ interval-subset? ] [ swap interval-subset? ] } 2|| ] [ 2drop f ] if ;

! custom prettyprinting

M: margin pprint* [ range>> [ to>> ] [ from>> ] bi [ first ] bi@ ] [ central>> ] bi swap "<" text pprint* "…" text pprint* "…" text pprint* ">" text ;
M: abs-error-margin pprint* [ range>> to>> first ] [ central>> ]  bi [ - ] keep pprint* "±" text pprint* ;
M: rel-error-margin pprint* [ range>> to>> first ] [ central>> ]  bi [ [ - ] keep 100 / / ] keep pprint* "±" text pprint* "%" text ;

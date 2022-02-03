! Copyright 2022 nomennescio
! See LICENSE.md for license

! margins are like intervals with a central value and left and right acceptable error margins
! margins compare equal if one contains the other, to support inexact comparisons using equal ("=")

USING: accessors combinators.short-circuit kernel locals math math.intervals prettyprint.custom prettyprint.sections sequences ;
IN: math.margins

! class

TUPLE: margin { range interval read-only } { central real read-only } ;
TUPLE: abs-error-margin < margin ;
TUPLE: rel-error-margin < margin ;

! constructors

ERROR: unordered-margin ;

:: new-margin ( from central to class -- margin )  from central < central to < and [ from to [a,b] central ] [ unordered-margin ] if class boa ; inline
: <margin> ( from central to -- margin ) margin new-margin ;
: -.+ ( a b -- a-b a a+b ) [ - ] [ drop ] [ + ] 2tri ;
: [a-e,a+e] ( a epsilon -- margin ) -.+ abs-error-margin new-margin ;
: [a-%,a+%] ( a percent -- margin ) over * 100 / -.+ rel-error-margin new-margin ;

ALIAS: ±  [a-e,a+e]
ALIAS: ±% [a-%,a+%]

! methods

! extract values from margin

: margin> ( margin -- from central to ) [ range>> [ from>> ] [ to>> ] bi [ first ] bi@ ] [ central>> ] bi swap ;

! convert object to margin. prerequisite for comparisons

GENERIC: >margin ( obj -- margin )

M: object >margin drop f ;
M: margin >margin ;
M: real >margin dup dup <margin> ;

ALIAS: >± >margin

! margins compare equal if one contains the other

M: margin equal? over margin? [ [ range>> ] bi@ { [ interval-subset? ] [ swap interval-subset? ] } 2|| ] [ 2drop f ] if ;

! custom prettyprinting

M: margin pprint* margin> spin "<" text pprint* "…" text pprint* "…" text pprint* ">" text ;
M: abs-error-margin pprint* margin> swap [ - ] keep pprint* "±" text pprint* drop ;
M: rel-error-margin pprint* margin> swap [ [ - ] keep 100 / / ] keep pprint* "±" text pprint* "%" text drop ;

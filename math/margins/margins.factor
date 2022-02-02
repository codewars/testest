! Copyright 2022 nomennescio
! See LICENSE.md for license

! margins are like intervals with a central value and left and right acceptable error margins
! margins compare equal if one contains the other, to support inexact comparisons using equal ("=")

USING: accessors combinators.short-circuit kernel math math.intervals prettyprint.custom prettyprint.sections sequences ;
IN: math.margins

! class

TUPLE: margin { range interval read-only } { central read-only } ;

! constructors

: <margin> ( from central to -- margin ) swapd [a,b] swap margin boa ; ! does not check from <= central <= to, <interval> handles from > to
: [a-e,a+e] ( a epsilon -- margin ) [ - ] [ drop ] [ + ] 2tri <margin> ;
: [a-%,a+%] ( a percent -- margin ) over * 100 / [a-e,a+e] ;

! methods

! convert object to margin. prerequisite for comparisons

GENERIC: >margin ( obj -- margin )

M: object >margin drop f ;
M: margin >margin ;
M: real >margin dup dup <margin> ;

M: margin equal? over margin? [ [ range>> ] bi@ { [ interval-subset? ] [ swap interval-subset? ] } 2|| ] [ 2drop f ] if ;

! custom prettyprinting

M: margin pprint* [ range>> to>> first ] [ central>> ]  bi [ - ] keep pprint* "±" text pprint* ;

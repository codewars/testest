! Copyright 2022 nomennescio

! margins are like intervals with a central value and left and right acceptable error margins
! margins compare equal if one contains the other

USING: accessors combinators.short-circuit kernel math math.intervals ;
IN: math.margins

! class

TUPLE: margin { range interval read-only } { central read-only } ;

! constructors

: <margin> ( from central to -- margin ) swapd [a,b] swap margin boa ; ! does not check from <= central <= to, <interval> handles from > to
: [a-e,a+e] ( a epsilon -- margin ) [ - ] [ drop ] [ + ] 2tri <margin> ;
: [a-%,a+%] ( a percent -- margin ) over * 100 / [a-e,a+e] ;

! methods

GENERIC: >margin ( obj -- margin )

M: object >margin drop f ;
M: margin >margin ;
M: real >margin dup dup <margin> ; ! M: real >margin 0 [a-e,a+e] ;

M: margin equal? over margin? [ [ range>> ] bi@ { [ interval-subset? ] [ swap interval-subset? ] } 2|| ] [ 2drop f ] if ;

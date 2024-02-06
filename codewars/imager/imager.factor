! Copyright (C) 2022-2024 nomennescio
! see LICENSE.md for license

USING: kernel memory namespaces sequences sequences.rotated system vectors vocabs vocabs.hierarchy vocabs.loader ;
IN: codewars.imager

CONSTANT: preload-extra-vocabs {
  "arrays" "assocs" "combinators" "coroutines" "decimals" "generators"
  "grouping" "infix" "lists" "lru-cache" "math" "multisets" "pair-rocket"
  "pairs" "path-finding" "qw" "sequences" "sets" "sorting" "splitting"
  "trees" "variants"
}

: load-and-save-image ( -- )
  "resource:pre" add-vocab-root vocab-roots [ -1 <rotated> >vector ] change-global
  "resource:extra" vocab-roots get remove [ load-root ] each
  "resource:extra" preload-extra-vocabs [ load-from-root ] with each
  image-path save-image-and-exit
;

MAIN: load-and-save-image

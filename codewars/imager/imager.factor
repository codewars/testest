! Copyright (C) 2022 nomennescio
! see LICENSE.md for license

USING: memory namespaces sequences sequences.rotated system vectors vocabs vocabs.hierarchy vocabs.loader ;
IN: codewars.imager

: load-and-save-image ( -- )
  "resource:pre" add-vocab-root vocab-roots [ -1 <rotated> ] change-global
  { "resource:core" "resource:basis" "resource:pre" "resource:work" } [ load-root ] each
  image-path save-image-and-exit
;

MAIN: load-and-save-image

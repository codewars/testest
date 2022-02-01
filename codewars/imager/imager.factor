! Copyright (C) 2022 nomennescio
! see LICENSE.md for license

USING: memory system vocabs vocabs.hierarchy ;
IN: codewars.imager

: load-and-save-image ( -- )
  "resource:core" load-root "resource:basis" load-root "tools.testest" require
  image-path save-image-and-exit
;

MAIN: load-and-save-image

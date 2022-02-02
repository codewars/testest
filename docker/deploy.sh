# Copyright 2022 nomennescio, see LICENSE.md for license
# deploy testest library into Docker image

# copy from TESTEST_URL/$1 to FACTOR_DIR/$2
function copy {
  mkdir -p $(dirname $FACTOR_DIR/$2)
  wget -q -O - $TESTEST_URL/$1 > $FACTOR_DIR/$2
}

copy codewars/imager/imager.factor work/codewars/imager/imager.factor
copy math/margins/margins.factor   work/math/margins/margins.factor
copy tools/testest/testest.factor  work/tools/testest/testest.factor

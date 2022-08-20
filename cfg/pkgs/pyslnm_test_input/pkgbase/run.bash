#!/bin/bash

if [ "X$BASH_SOURCE" != "X" ]; then
   export SITEBASE=$(cd "`dirname \"$BASH_SOURCE\"`";        pwd -P) || return
   export SITESPEC=$SITEBASE/github/site-spec
   export    TPSUP=$SITEBASE/github/tpsup
else
   if ! [[ "$0" =~ bash ]]; then
      echo "Run bash first ... Env is not set !!!" >&2
      return
   else
      echo "You used wrong bash (check version). please exit and find a newer version instead !!!" >&2
      echo " Or you can export BASH_SOURCE=/home/$USERNAME/sitebase/github/tpsup/profile or something similar" >&2
      return
   fi
fi

. $SITESPEC/profile
p3env
svenv
pyslnm_test_input auto s=henry
dvenv

#!/bin/bash  # this line is purely to let the editor to activate BASH check

if [ "X$BASH_SOURCE" != "X" ]; then
   # example:
   #    BASH_SOURCE is /home/tian/sitebase/github/site-spec/profile 
   #    SITEBASE    is /home/tian/sitebase
   #    TPSUP       is /home/tian/sitebase/github/tpsup
   SITEBASE=$(cd "`dirname \"$BASH_SOURCE\"`/../..";        pwd -P) || return
      TPSUP=$(cd "`dirname \"$BASH_SOURCE\"`/../tpsup";     pwd -P) || return
   SITESPEC=$(cd "`dirname \"$BASH_SOURCE\"`/../site-spec"; pwd -P) || return
   export SITEBASE
   export TPSUP
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

export PATH=$PATH:$SITEBASE/github/site-spec/scripts

# feel free to rename variables and functions as we won't sync this file back to github once cloned.
#export LOCAL_CURL_PROXY="--proxy proxy.abc.net:8080"

sitebase () {
   cd "$SITEBASE"
}

siteenv () {
   . "$SITEBASE"/github/site-spec/profile
}

. "$TPSUP"/profile

kdbnotes () {
   cd "$TPSUP/../kdb/notes"
}

myandroid () {
   export ANDROID_HOME=${HOME}/Android/Sdk
   export PATH="${ANDROID_HOME}/tools:${PATH}"
   export PATH="${ANDROID_HOME}/emulator:${PATH}"
   export PATH="${ANDROID_HOME}/platform-tools:${PATH}"
}

mycpp () {
   cd "$TPSUP/../cpp/cookbook/src"
}

mycmd () {
   cd "$TPSUP/cmd_exe"
}

myjava () {
   if [[ $UNAME =~ Msys ]]; then
      cd /c/users/$USER/eclipse-workspace
   elif [[ $UNAME =~ Cygwin ]]; then
      cd /cygdrive/c/users/$USER/eclipse-workspace
   elif [[ $UNAME =~ Linux ]]; then
      cd ~/eclipse-workspace
   else 
      echo "UNAME='$UNAME' is not supported"
   fi
}

myjoomla () {
   cd "$TPSUP/../joomla/php"
}

mykivy () {
   cd "$TPSUP/../kivy"
}

mynotes () {
   cd "$TPSUP/../notes"
}

myperllib () {
   # for compatibility with corp settings
   cd "$TPSUP/lib/perl/TPSUP"
}

myperltest () {
   cd "$TPSUP/lib/perltest"
}

myps1 () {
   cd "$TPSUP/ps1"
}

mysite () {
   # for compatibility with corp settings
   cd "$SITESPEC/scripts"
}

mytp () {
   # for compatibility with corp settings
   cd "$TPSUP/scripts"
}

perltestenv () {
   export PERL5LIB=$TPSUP/lib/perltest:$PERL5LIB
   reduce PERL5LIB
}

lca () {
   cd /media/sdcard/LCA/`date +%Y%m%d` && ls -l
}

vncserver () {
   /usr/bin/vncserver -geometry 1366x768 "$@"
}

tpproxy () {
   local usage
   usage="
usage:
   tpproxy is a bash function.
   tpproxy check
   tpproxy set
"

   if [ "X$1" = "Xcheck" ]; then
      echo "http_proxy=$http_proxy"
      echo "https_proxy=$https_proxy"
   elif [ "X$1" = "Xset" ]; then
      #export http_proxy=$http_proxy
      #export https_proxy=$https_proxy
      echo "tpproxy is not implemented on yet" >&2
   else
      echo "http_proxy=$http_proxy" >&2
      echo "https_proxy=$https_proxy" >&2
      echo "$usage" >&2
   fi

   # to make wget/curl work behind firewall

   # export http_proxy=http://user:password@host:port
   # export https_proxy=http://user:password@host:port

   # for authencationless proxy
   # export http_proxy=http://host:port
   # export https_proxy=http://host:port
}

pythonenv () {
   local OPTIND OPTARG o quiet usage expected_version actual_version

   usage="usage: pythonenv [-q] 2|3"

   quiet=N

   while getopts q o;
   do
      case "$o" in
         q) quiet=Y;;
         *) echo "unknow switch. $usage">&2; return 1;;
      esac
   done

   shift $((OPTIND-1))

   if [ $# -ne 1 ]; then
      echo "wrong number of args: expected 1, actual $#"
      echo $usage
      return
   fi

   expected_version=$1

   if [[ $UNAME =~ Linux ]]; then
      # for linux, /usr/bin/python is versio 2, /usr/bin/python3 is version 3
      # we make a symbolic of $TPSUP/python3/linux/bin/python from /usr/bin/python3
      # so that our shell script can have a consistent "#!/usr/bin/env python"
      if [ $expected_version = 3 ]; then
         export PATH="$TPSUP/python${expected_version}/linux/bin:$PATH"
      elif [ $expected_version = 2 ]; then
         export PATH="/usr/bin:$PATH"
      fi
   elif [[ $UNAME =~ Cygwin ]]; then
      if [ $expected_version = 3 ]; then
         export PATH="/cygdrive/c/Program Files/Python37:$PATH"
      elif [ $expected_version = 2 ]; then
         export PATH="/cygdrive/c/Program Files/Python27:$PATH"
      fi
   elif [[ $UNAME =~ Msys ]]; then
      if [ $expected_version = 3 ]; then
         export PATH="/c/Program Files/Python37:$PATH"
      elif [ $expected_version = 2 ]; then
         export PATH="/c/Program Files/Python27:$PATH"
      fi
   fi

   python=`which python`
   if [ $? != 0 ]; then
      return;
   fi

   actual_version=`"$python" --version 2>&1`
   [ $quiet = Y ] || echo "'$python' is $actual_version"

   if ! [[ $actual_version =~ "Python $expected_version" ]]; then
      echo "cannot find python version $expected_version in $PATH"
      return
   fi

   if [[ $UNAME =~ Cygwin ]]; then
      # cygwin converts PYTHONPATH's /cygdrive/c/users/$USERNAME/sitebase/github/... 
      # into sys.path C:/cygdrive/c/users/$USERNAME/sitebase/github/... 
      # therefore, we drop the front two parts: /cygdrive/c
      # Also Note: use semi-colon ; as separator

      export PYTHONPATH="/Users/$USER/github/tpsup/python$expected_version/lib;$PYTHONPATH"
   else
      export PYTHONPATH="$TPSUP/python$expected_version/lib:$PYTHONPATH"
   fi

   reduce  # this takes about 2 seconds

   [ $quiet = Y ] || echo PYTHONPATH=$PYTHONPATH

   export PATH="$TPSUP/python3/scripts:$TPSUP/python3/examples:$PATH"

   if [[ $UNAME =~ Cygwin && $quiet = N ]]; then
      echo "On Cygwin, use relative path or windows path. eg," 
      echo "                                                         :w
      ./tpcsv.py"
      echo "   python                                                ./tpcsv.py"
      echo "   C:/Users/$USERNAME/sitebase/github/tpsup/python3/scripts/tpcsv.py"
      echo "Absolute path doesn't work, eg"
      echo "                                                                      tpcsv.py"
      echo "   python                                                             tpcsv.py"
      echo "   /cygdrive/c/Users/$USERNAME/sitebase/github/tpsup/python3/lib/tpsup/tpcsv.py"
   fi    

   # export the function
   set -a
}

p2env () {
   pythonenv $@ 2 
}

p3env () {
   pythonenv $@ 3 
}

p3env -q  # this command takes about 2 seconds as it calls reduce()


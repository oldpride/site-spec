# you can add this one liner to user's .profile or .bash_profile
#   siteenv () { . ~/sitebase/github/site-spec/profile }

# this is for Cygwin
if [ "X$USERNAME" = "X" ]; then
   if [ "X$LOGNAME" != "X" ]; then
      # $USERNAME is set after we start cygwin terminal from taskbar
      # $LOGNAME is set after we logged into cygwin sshd
      export USERNAME=$LOGNAME
   else 
      USERNAME=`id |cut -d\( -f2|cut -d\) -f1`
   fi
fi

get_bash_source () {
   TP_BASH_SOURCE_FOUND=N
   unset TP_BASH_SOURCE_DIR
   unset TP_BASH_SOURCE_FILE

   if [ "X$BASH_SOURCE" != "X" ]; then
      TP_BASH_SOURCE_DIR=`  dirname "$BASH_SOURCE"`
      TP_BASH_SOURCE_FILE=`basename "$BASH_SOURCE"`

      TP_BASH_SOURCE_DIR=$(cd "$TP_BASH_SOURCE_DIR"; pwd -P)
      TP_BASH_SOURCE_FOUND=Y
      return 0
   else
      if ! [[ "$0" =~ bash ]]; then
         echo "Run bash first ... Env is not set !!!" >&2
      else
         echo "You used wrong bash (check version). please exit and find a newer version instead !!!" >&2
         echo " Or you can export BASH_SOURCE=this_file" >&2
      fi
      return 1
   fi
}

get_bash_source || return $?
# [ $TP_BASH_SOURCE_FOUND = Y ] || return $?
# example:
#    BASH_SOURCE is /home/tian/sitebase/github/site-spec/profile 
#    SITEBASE    is /home/tian/sitebase
#    SITESPEC    is /home/tian/sitebase/github/site-spec
#    TPSUP       is /home/tian/sitebase/github/tpsup
export SITEBASE=$(cd "$TP_BASH_SOURCE_DIR/../.."; pwd -P) || return
export SITESPEC=$SITEBASE/github/site-spec
export    TPSUP=$SITEBASE/github/tpsup

export PATH=$PATH:$SITEBASE/github/site-spec/scripts:/opt/mssql-tools/bin

# feel free to rename variables and functions as we won't sync this file back to github once cloned.
#export LOCAL_CURL_PROXY="--proxy proxy.abc.net:8080"

sitebase () {
   cd "$SITEBASE"
}

siteenv () { . "$SITEBASE"/github/site-spec/profile; }

#siteenv2 () {
#   #. "$SITEBASE"/github/site-spec/profile
#   SITEPROFILE="$SITEBASE/github/site-spec/profile"
#   if [ -f "$SITEPROFILE" ]; then
#      . "$SITEPROFILE"
#   elif [[ $(type -t convertpath) == function ]]; then
#      # We cannot find the profile maybe because bash's hosting terminal is changed, 
#      # For example, 
#      #    if we started with cygwin, cygwin is our bash's hosting terminal, cygwin
#      #       uses .bash_profile, having siteenv point to /cygdrive/c/user/ ...
#      #    next we launch vscode from cygwin, and then from vscode launch bash,
#      #       the bash inside vscode will be hosted by a gitbash terminal.
#      #       gitbash terminal expects file path to be /c/user/...,
#      #       however, the path in siteenv function is /cygdrive/c/user/..., inherited 
#      #       from env or .bash_profile. therefore, we need to convert it.
#      convertpath -e -i SITEPROFILE
#      . "$SITEPROFILE"
#   else
#      # try anyway
#      . "$SITEPROFILE"
#   fi
#}

export UNAME=`uname -a`

if [[ $UNAME =~ ^(Linux|Darwin) ]]; then
   # echo "${BASH_SOURCE}:${LINENO}" # line number
   TP_OS=${BASH_REMATCH[1]}
   TP_OS_VERSION=`echo $UNAME|cut -d' ' -f3|cut -d. -f1-2` # major.minors
   sitevim () {
      # if the site has no full-featured vim, install it and then turn on this function
      if [[ $TERM =~ xterm|^vt ]]; then
         echo -ne "\033]0;vim $@\007"
      fi

      LD_LIBRARY_PATH=$SITEBASE/$TP_OS/$Linux/usr/lib64 TERMINFO=/usr/share/terminfo $SITEBASE/Linux/$Linux/usr/bin/vim "$@"
   }

   # for linux, /usr/bin/python is versio 2, /usr/bin/python3 is version 3
   # we make a symbolic of $SITEBASE/python3/Linux/bin/python from /usr/bin/python3
   # so that our shell script can have a consistent "#!/usr/bin/env python"
   # $ ln -s /usr/bin/python3 $SITEBASE/python3/Linux/bin/python3
   export TP_P3_PATH="$SITEBASE/python3/$TP_OS/bin"
   export TP_P2_PATH="/usr/bin"
   
   if [[ $UNAME =~ microsoft-standard-WSL2 ]]; then
      # WSL Linux
      export SITEVENV="$SITEBASE/python3/venv/Linux/Linux5.15-python3.8"
   else
      # echo "${BASH_SOURCE}:${LINENO}"
      export SITEVENV="$SITEBASE/python3/venv/$TP_OS/${TP_OS}${TP_OS_VERSION}-python3.10"
   fi
   export ANDROID_HOME=${HOME}/Android/Sdk             # this is required by android sdk
   export ANDROID_STUDIO=${HOME}/Android/android-studio/bin/studio.sh # this is tpsup-specific
   export MYTEAM="${HOME}/team"
elif [[ $UNAME =~ Cygwin ]]; then
   # for Cygwin and for Windows in general, there is no binary exe "python3". to make it working, make a link
   # do the following from Cygwin
   #    $ ln -s /cygdrive/c/Program\ Files/Python3.10/python $SITEBASE/python3/Cygwin/bin/python3
   export TP_P3_PATH="/cygdrive/c/Program Files/Python3.10:$SITEBASE/python3/Cygwin/bin:/cygdrive/c/Program Files/Python3.10/scripts:/cygdrive/c/Users/$USERNAME/AppData/Roaming/Python/Python310/Scripts"
   export TP_P2_PATH="/cygdrive/c/Program Files/Python27:/cygdrive/c/Program Files/Python27/scripts"

   export SITEVENV="$SITEBASE/python3/venv/Windows/win10-python3.10"
   export ANDROID_HOME="/cygdrive/c/Users/william/AppData/Local/Android/Sdk"
   export ANDROID_STUDIO="/cygdrive/c/Program Files/Android/Android Studio/bin/studio64.exe"
   export MYTEAM="/cygdrive/c/users/$USERNAME/team"
elif [ "X$TERM_PROGRAM" = "Xvscode" ]; then
   export TP_P3_PATH="/c/Program Files/Python3.10:/c/Program Files/Python3.10/scripts:/c/Users/$USERNAME/AppData/Roaming/Python/Python310/Scripts"
   export TP_P2_PATH="/c/Program Files/Python27:/c/Program Files/Python27/scripts"

   export SITEVENV="$SITEBASE/python3/venv/Windows/win10-python3.10"
   export ANDROID_HOME="/c/Users/william/AppData/Local/Android/Sdk"
   export ANDROID_STUDIO="/c/Program Files/Android/Android Studio/bin/studio64.exe"
   export MYTEAM="/c/users/$USERNAME/team"
elif [[ $UNAME =~ MINGW ]]; then
   # this is gitbash
   # for gitbash and for Windows in general, there is no binary exe "python3". to make it working, make a link
   # do the following from gitbash
   #    ln -s "/c/Program Files/Python3.10/python" $SITEBASE/python3/MINGW/bin/python3
   export TP_P3_PATH="/c/Program Files/Python3.10:$SITEBASE/python3/MINGW/bin:/c/Program Files/Python3.10/scripts:/c/Users/$USERNAME/AppData/Roaming/Python/Python310/Scripts"
   export TP_P2_PATH="/c/Program Files/Python27:/c/Program Files/Python27/scripts"

   # GitBash buffers stdout by default. Disable the bufferring
   # https://stackoverflow.com/questions/107705/disable-output-buffering
   export PYTHONUNBUFFERED=Y

   export SITEVENV="$SITEBASE/python3/venv/Windows/win10-python3.10"
   export ANDROID_HOME="/c/Users/william/AppData/Local/Android/Sdk"
   export ANDROID_STUDIO="/c/Program Files/Android/Android Studio/bin/studio64.exe"
   export MYTEAM="/c/users/$USERNAME/team"
#elif [[ $UNAME =~ WSL2 ]]; then
   # Linux tianpc2 5.15.79.1-microsoft-standard-WSL2 #1 SMP Wed Nov 23 01:01:46 UTC 2022 x86_64 x86_64 x86_64 GNU/Linux
fi

. "$TPSUP"/profile

java11 () {
   if [[ $UNAME =~ Linux ]]; then
      export JAVA_HOME="/usr/lib/jvm/java-1.11.0-openjdk-amd64"
   elif [[ $UNAME =~ Cygwin ]]; then
      export JAVA_HOME="/cygdrive/c/Program Files/Java/jdk-11.0.16.1"
   elif [[ $UNAME =~ MINGW ]]; then
      export JAVA_HOME="/c/Program Files/Java/jdk-11.0.16.1"
   fi

   echo "JAVA_HOME=$JAVA_HOME"
}

testreduce () { echo "test reduce"; reduce all;}

kdbnotes () { cd "$TPSUP/../kdb/notes"; }
kungfusql () { cd "$TPSUP/../com_kungfulsql"; }

myandroid  () { cd "$SITEBASE/github/android"; }

mycad () { cd "$TPSUP/../freecad"; }
myvbs () { cd "$TPSUP/vbs"; }
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
myjoomla () { cd "$TPSUP/../joomla/php"; }
mynotes () { cd "$TPSUP/../notes"; }
mynotes2 () { cd "$TPSUP/../notes2"; }
myperltest () { cd "$TPSUP/lib/perltest"; }
mypkg () { cd "$SITESPEC/cfg/pkgs"; }
mysamba () {
   if [[ $UNAME =~ Linux ]]; then
      cd ~/sambashare
   elif [[ $UNAME =~ Cygwin ]]; then
      cd /cygdrive/z
   elif [ "X$TERM_PROGRAM" = "Xvscode" ]; then
      cd /z
   elif [[ $UNAME =~ Msys ]]; then
      cd /z
   fi
}

mysol () { cd "$TPSUP/../solidity/courses"; }

# automatically cd or mkdir to a latest sub-folder
myrel () {
   cdlatest "$@" ~/releases
}

mkrel () { 
   if [ $# -ne 1 ]; then
      echo "wrong number of args."
      echo "usage:    mkrel string"
      echo "example:  mkrel app1"
      return
   fi
   
   local RELDIR; 
   RELDIR=~/releases/"`date +%Y%m%d`_$1"; 

   [ -d $RELDIR ] || mkdir -p $RELDIR
   cd $RELDIR
}

perltestenv () {
   export PERL5LIB=$TPSUP/lib/perltest:$PERL5LIB
   reduce PERL5LIB
}

lca () { cd /media/sdcard/LCA/ && ls; }

vncserver () { /usr/bin/vncserver -geometry 1366x768 "$@"; }

tpproxy () {
   local usage my_proxy my_pac
   usage="
usage:
   tpproxy is a bash function.
   tpproxy check
   tpproxy set
   tpproxy unset
"
   my_proxy="http://proxy.abc.net:8080"
   my_pac="http://pac.abc.net/"

   # tp_pac is only used by tpsup scripts, eg, tpchrome, tpchromium

   if [ "X$1" = "Xcheck" ]; then
           env |/bin/grep -i "^(http|tp_pac)"
   elif [ "X$1" = "Xset" ]; then
      #export http_proxy=$my_proxy
      #export https_proxy=$my_proxy
      #tp_pac=$my_pac
      echo "tpproxy is not implemented on this site yet" >&2
   elif [ "X$1" = "Xunset" ]; then
      unset http_proxy
      unset https_proxy
      unset tp_pac
   else
      echo "http_proxy=$http_proxy"   >&2
      echo "https_proxy=$https_proxy" >&2
      echo "tp_pac=$my_pac"           >&2
      echo "$usage" >&2
   fi

   # to make wget/curl work behind firewall

   # export http_proxy=http://user:password@host:port
   # export https_proxy=http://user:password@host:port

   # for authencationless proxy
   # export http_proxy=http://host:port
   # export https_proxy=http://host:port
}

TP_REDUCE_DISABLE=Y


p3env -q  # this command takes about 2 seconds as it calls reduce()

nodeenv set

# https://www.gnu.org/software/bash/manual/html_node/The-Set-Builtin.html
# -a  Each variable or function that is created or modified is given the export attribute
#     and marked for export to the environment of subsequent commands "
set -a
set +a
# -b  Cause the status of terminated background jobs to be reported immediately, rather than
#     before printing the next primary prompt.
set -b

# todo: should I export (set -a; set -b) first or reduce first?
unset TP_REDUCE_DISABLE
reduce all

#!/bin/bash  # this line is purely to let the editor to activate BASH check

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

if [ "X$BASH_SOURCE" != "X" ]; then
   # example:
   #    BASH_SOURCE is /home/tian/sitebase/github/site-spec/profile 
   #    SITEBASE    is /home/tian/sitebase
   #    SITESPEC    is /home/tian/sitebase/github/site-spec
   #    TPSUP       is /home/tian/sitebase/github/tpsup
   export SITEBASE=$(cd "`dirname \"$BASH_SOURCE\"`/../..";        pwd -P) || return
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

export PATH=$PATH:$SITEBASE/github/site-spec/scripts:/opt/mssql-tools/bin

# feel free to rename variables and functions as we won't sync this file back to github once cloned.
#export LOCAL_CURL_PROXY="--proxy proxy.abc.net:8080"

sitebase () {
   cd "$SITEBASE"
}

siteenv () {
   . "$SITEBASE"/github/site-spec/profile
}

. "$TPSUP"/profile

kdbnotes () { cd "$TPSUP/../kdb/notes"; }

myandroid () {
   export ANDROID_HOME=${HOME}/Android/Sdk
   export PATH="${ANDROID_HOME}/tools:${PATH}"
   export PATH="${ANDROID_HOME}/emulator:${PATH}"
   export PATH="${ANDROID_HOME}/platform-tools:${PATH}"
}

mycpp () { cd "$TPSUP/../cpp/cookbook/src"; }

mycmd () { cd "$TPSUP/cmd_exe"; }

myfront () { cd "$TPSUP/../frontend"; }

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

kungfusql () { cd "$TPSUP/../com_kungfulsql"; }

mykivy () { cd "$TPSUP/../kivy"; }

mynotes () { cd "$TPSUP/../notes"; }

mycad () { cd "$TPSUP/../freecad"; }

myduino () { cd "$TPSUP/../arduino"; }

testreduce () { echo "test reduce"; reduce;}

myperllib () {
   # for compatibility with corp settings
   cd "$TPSUP/lib/perl/TPSUP"
}

myperltest () { cd "$TPSUP/lib/perltest"; }

myps1 () { cd "$TPSUP/ps1"; }

myrpm () {
   cd "$TPSUP/../rpm"
}

mysite () {
   # for compatibility with corp settings
   cd "$SITESPEC/scripts"
}

mysol () { cd "$TPSUP/../solidity/courses"; }

mytp () {
   # for compatibility with corp settings
   cd "$TPSUP/scripts"
}

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

lca () { cd /media/sdcard/LCA/`date +%Y%m%d` && ls -l; }

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

pythonenv () {
   local OPTIND OPTARG o quiet usage expected_version actual_version

   usage="usage: pythonenv [-q] 2|3"

   quiet=N

   while getopts q o;
   do
      case "$o" in
         q) quiet=Y; flag="-q";;
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
      delpath $flag "Program Files/Python$expected_version"
      if [ $expected_version = 3 ]; then
         #export PATH="/cygdrive/c/Program Files/Python37:$PATH"
         export PATH="/cygdrive/c/Program Files/Python3.10:/cygdrive/c/Program Files/Python3.10/scripts:/cygdrive/c/Users/$USERNAME/AppData/Roaming/Python/Python39/Scripts:$PATH"
      elif [ $expected_version = 2 ]; then
         export PATH="/cygdrive/c/Program Files/Python27:/cygdrive/c/Program Files/Python27/scripts:/c/Users/$USERNAME/AppData/Roaming/Python/Python39/Scripts:$PATH"
      fi
   elif [ "X$TERM_PROGRAM" = "Xvscode" ]; then
      delpath $flag "Program Files/Python$expected_version"
      # Visual Studio Code's terminal. we need 3.8 and above to run Solidity
      if [ $expected_version = 3 ]; then
         export PATH="/c/Program Files/Python3.10:/c/Program Files/Python3.10/scripts:$PATH"
      elif [ $expected_version = 2 ]; then
         export PATH="/c/Program Files/Python27:/c/Program Files/Python27/scripts:$PATH"
      fi
   elif [[ $UNAME =~ Msys ]]; then
      delpath $flag "Program Files/Python$expected_version"
      if [ $expected_version = 3 ]; then
         #export PATH="/c/Program Files/Python37:$PATH"
         export PATH="/c/Program Files/Python3.10:/c/Program Files/Python3.10/scripts:$PATH"
      elif [ $expected_version = 2 ]; then
         export PATH="/c/Program Files/Python27:/c/Program Files/Python27/scripts:$PATH"
      fi

      # GitBash buffers stdout by default. Disable the bufferring
      # https://stackoverflow.com/questions/107705/disable-output-buffering
      export PYTHONUNBUFFERED=Y
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

      export PYTHONPATH="/Users/$USER/sitebase/github/tpsup/python$expected_version/lib;$SITEBASE/Windows/win10-python3.7/lib/site-packages:$PYTHONPATH"
   else
      export PYTHONPATH="$TPSUP/python$expected_version/lib:$SITEBASE/Linux/linux3.10-python3.7/lib/site-packages:$PYTHONPATH:"
   fi

   reduce  # this takes about 2 seconds

   [ $quiet = Y ] || echo PYTHONPATH=$PYTHONPATH

   export PATH="$TPSUP/python3/scripts:$TPSUP/python3/examples:$PATH"

   if [[ $UNAME =~ Cygwin && $quiet = N ]]; then
   cat <<END
On Cygwin, use relative path or windows path. eg,
                                                         ./tpcsv.py
   python                                                ./tpcsv.py
   C:/Users/$USERNAME/sitebase/github/tpsup/python3/scripts/tpcsv.py

Absolute path doesn't work, eg
                                                                      tpcsv.py
   python                                                             tpcsv.py
   /cygdrive/c/Users/$USERNAME/sitebase/github/tpsup/python3/lib/tpsup/tpcsv.py
END
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

nodeenv () {
   # npm installation folder when running 
   #    $ npm install --global yarn
   # files go to
   #       %USERPROFILE%\AppData\Roaming\npm\node_modules\yarn\bin\yarn.exe
   #    C:\Users\william\AppData\Roaming\npm\node_modules\yarn\bin\yarn.exe
   # tpsup/profile set WINHOME %USERPROFILE%
   #
   #  yarn installation path - %LOCALAPPDATA%\yarn\bin
   #     yarn info ganache-cli
   #  files goes to
   #     C:\Users\william\AppData\Local\Yarn\bin
   
   if [[ $UNAME =~ Cygwin ]]; then
      export PATH="/cygdrive/c/Program Files/nodjs:$WINHOME/AppData/Roaming/npm/node_modules/yarn/bin:$WINHOME/AppData/Local/Yarn/bin:$PATH"
   elif [[ $UNAME =~ Msys ]]; then
      export PATH="/c/Program Files/nodejs:$WINHOME/AppData/Roaming/npm/node_modules/yarn/bin:$WINHOME/AppData/Local/Yarn/bin:$PATH"
   fi
}

selenium () {
   # set PATH for webdriver and browser

   # linux: /usr/bin/chromedriver, /usr/bin/chromium-browser

   if [[ $UNAME =~ Cygwin ]]; then
      export PATH=$PATH:'/cygdrive/C/Program Files (x86)/Google/Chrome/Application':/cygdrive/C/users/$USER
      reduce
   elif [[ $UNAME =~ Msys ]]; then
     export PATH=$PATH:'/C/Program Files (x86)/Google/Chrome/Application':~
      reduce
   fi
}

if [[ $UNAME =~ Linux ]]; then
   sitevim () {
      # if the site has no full-featured vim, install it and then turn on this function
      if [[ $TERM =~ xterm|^vt ]]; then
         echo -ne "\033]0;vim $@\007"
      fi

      LD_LIBRARY_PATH=$SITEBASE/Linux/$Linux/usr/lib64 TERMINFO=/usr/share/terminfo $SITEBASE/Linux/$Linux/usr/bin/vim "$@"
   }
fi

p3env -q  # this command takes about 2 seconds as it calls reduce()

nodeenv

# https://www.gnu.org/software/bash/manual/html_node/The-Set-Builtin.html
# -a  Each variable or function that is created or modified is given the export attribute
#     and marked for export to the environment of subsequent commands "
set -a
set +a
# -b  Cause the status of terminated background jobs to be reported immediately, rather than
#     before printing the next primary prompt.
set -b

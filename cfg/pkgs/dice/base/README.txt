install this tree as .../dicepkg,  eg, $HOME/dicepkg

create a self-contained venv under $HOME/dicevenv
   python -m venv $HOME/dicevenv
   source $HOME/dicevenv/bin/activate

   pip install --upgrade pip
   pip install bs4 lxml requests selenium urllib3

   deactivate

download chromedriver and save it to $HOME/dicevenv/bin

create a cfg folder $HOME/dicecfg, store the following files
   users.csv
   .env

set up env
   from windows cmd.exe
      setenv.bat

   from windows gitbash/cygwin
      . setenv.bash

   this takes you into venv. run 'dvenv' to exit venv

apply jobs
   apply $HOME/dicecfg/users.csv $HOME/dicecfg/.env 

output is saved 
   $HOME/dicebase

kill leftover chrome and chromedriver after each failed run, from windows cmd or linux bash.
   pkill chrome

to add a new user, modify two files
   $HOME/dicecfg/users.csv
   $HOME/dicecfg/.env

to run on every weekday
   crontab -e
   # GMT
   13 17 * * 1,2,3,4,5 bash -c ". $HOME/dicepkg/setenv.bash; pkill chrome; apply -headless $HOME/dicecfg/users.csv $HOME/dicecfg/.env" >/tmp/apply_`date +\%w`_1.log 2>&1
   13 19 * * 1,2,3,4,5 bash -c ". $HOME/dicepkg/setenv.bash; pkill chrome; apply -headless $HOME/dicecfg/users.csv $HOME/dicecfg/.env" >/tmp/apply_`date +\%w`_2.log 2>&1
   13 21 * * 1,2,3,4,5 bash -c ". $HOME/dicepkg/setenv.bash; pkill chrome; apply -headless $HOME/dicecfg/users.csv $HOME/dicecfg/.env" >/tmp/apply_`date +\%w`_3.log 2>&1

find application results
   less $HOME/dicebase/$email/applied_summary.txt

directory structure
   $HOME/dicebase     application results
   $HOME/dicecfg      application configuration
   $HOME/dicepkg      python code
   $HOME/dicevenv     python venv

   $HOME/dicecfg/users.csv    user file
   $HOME/dicecfg/.env         pass file
   /tmp/apply*.log            log  files

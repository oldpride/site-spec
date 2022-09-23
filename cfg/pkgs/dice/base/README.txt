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

kill leftover chromedriver after each failed run, from windows cmd or linux bash.
   pkill chromedriver

to add a new user, modify two files
   $HOME/users.csv
   $HOME/.env

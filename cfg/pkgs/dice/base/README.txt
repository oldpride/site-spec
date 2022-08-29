dice proj

set up env
   from windows cmd.exe
      setenv.bat

   from windows gitbash/cygwin
      . setenv.bash

   this takes you into venv. run 'dvenv' to exit venv

apply jobs
   apply path1/users.json path2/env.csv 
   example: apply users.json .env

kill leftover chromedriver after each failed run
   from cmd.exe
      pkill chromedriver

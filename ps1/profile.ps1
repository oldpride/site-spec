# C:\Users\william\sitebase\github\site-spec\ps1\profile.ps1

$global:SITEPS1=(Split-Path -Parent $PSCommandPath)
# C:\Users\william\sitebase\github\site-spec\ps1

$global:SITESPEC=(Split-Path -Parent $SITEPS1)
# C:\Users\william\sitebase\github\site-spec

$global:SITEBASE=(Get-Item "$SITESPEC\..\..").FullName
# C:\Users\william\sitebase

# . C:\Users\william\sitebase\github\tpsup\ps1\profile.ps1
# we need to source the profile for now as the Remove-Item cannot remove the alias within a function
#   https://stackoverflow.com/questions/568271/how-to-check-if-there-exists-a-process-with-a-given-pid-in-python/63497262#63497262
. $SITEBASE\github\tpsup\ps1\profile.ps1

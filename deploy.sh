#!/bin/tcsh
if ($#argv != 1) then
   echo " "
   echo "Usage: Deploy.sh <warname.war>"
   echo " "
   exit
endif

if !(-f $1) then
   echo " "
   echo "Error: $1 is not a regular file"
   echo " "
   exit
endif

setenv WAR      `basename $1`
setenv WARSRC   /home/systems/$WAR
setenv WARDST   /home/oracle

cat $1 >! $WARSRC

cd /opt/deploy

foreach server (server01 server02)
#foreach server 
   set ans="X"
   while ( "$ans" != "y" && "$ans" != "Y" && "$ans" != "n" && "$ans" != "N" && "$ans" != "q" && "$ans" != "Q" )
      tput clear
      echo -n "Upload to $server.  OK? (y/n/q): "
      set ans=$<
   end
   if ( "$ans" == "q" || "$ans" == "Q" ) exit
   if ( "$ans" == "y" || "$ans" == "Y" ) then
      scp $WARSRC systems@${server}:$WARSRC
      ssh -T systems@${server} "sudo mv $WARSRC $WARDST/$WAR ; sudo chown oracle:oinstall $WARDST/$WAR ; sudo chmod 664 $WARDST/$WAR"
      scp installer.sh systems@${server}:.
      scp request.xml systems@${server}:.
      ssh -T systems@${server} "sudo mv installer.sh $WARDST/. ; sudo chown oracle:oinstall $WARDST/installer.sh ; sudo chmod 774 $WARDST/installer.sh"
      ssh -T systems@${server} "sudo mv request.xml $WARDST/. ; sudo chown oracle:oinstall $WARDST/request.xml ; sudo chmod 774 $WARDST/request.xml"
      ssh systems@${server} "sudo su - --command='cd /home/oracle; /bin/tcsh ./installer.sh $WAR'"
      mutt -s "$WAR deployed on $server" ozdemircili@gmail.com < /dev/null
   endif
end


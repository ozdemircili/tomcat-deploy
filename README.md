tomcat-deploy
=============

A script to ease deploying tomcat apps to various (probably 100`s) automatically. 

The script uploads the .war file to the tomcat server with usename oracle (the user that you are running tomcat with) as the user systems(which is the user of the systems dept) then chowns the .war file with oracle:oinstall and calls the package to start the server and the app.



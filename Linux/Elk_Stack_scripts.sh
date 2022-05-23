#!/bin/bash

#Generate 100000 failed SSH login attempts on a single web server. Must be run outside of the authorized VM/Container to generate failed attempts.

for g in {1..100000}; do ssh Web_1@10.1.0.5; done

#Generate an infinite number of SSH login attempts on a single web server on all webserver. Must be run outside of the unauthorized VM/Container to generate failed attempts.

#While true; do it for g in {5..6}; do ssh Web_1@10.1.0.$g; done

#start and attach to the ansible container in one command from the Jump Box.

#sudo docker start wiggins_dunk && sudo docker attach wiggins_dunk

#use wget to generate high amount of web request to perform a dDos attack

while true: do wget 10.1.0.5; done

#same as the previous command without generating the 'index html' file after each request

while true; do wget 10.1.0.5 -O /dev/null; done

same as the previous command, this time the 'wget' DoS is performed on webbservers at the same time

while true; do for g in {5..6}; do wget /dev/null/ 10.1.0.$g; done

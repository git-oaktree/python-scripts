#!/usr/bin/python

''' Script should be used to check if it is possible to enumerate smtp servers using the vrfy command. To use the script it is necessary to provide a text file containing the names you want to pass to the server. At this point and time, the IP address of the smtp server is hard coded into the script and you will have to modify the script. '''

import time
import socket
import sys

x=0

if len(sys.argv) !=2:
        print 'Usage: vrfy.py <filename>'
        sys.exit(0)

file=open(sys.argv[1],'r')
file.readline()

#create a socket
s=socket.socket(socket.AF_INET, socket.SOCK_STREAM)
#connect to socket

s.connect(('192.168.15.229', 25))
banner=s.recv(1024)
print banner

def connect():
        s=socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        s.connect(('192.168.15.229', 25))
        banner=s.recv(1024)
        return s
for line in file:
        s.send('VRFY ' + line + '\r')
        result=s.recv(1024)
        print result
        time.sleep(1)
        x+=1
        if x == 10:
                s.close()
                s=connect()
                x=0

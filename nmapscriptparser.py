#!/usr/bin/python

import argparse
import re 

parser = argparse.ArgumentParser(description='Videos to images')
parser.add_argument('--file', type=str, help='.nmap output file to parse')
args = parser.parse_args()
print(args.file)
nmapFile=args.file

pattern = re.compile(r'(\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3})')


file = open(nmapFile,"r")

for line in file:
  if "Nmap" in line:
    currentIP=[]
    match = re.search(pattern,line)
    if match: 
      currentIP.append(match.group())
      
  if "Host script results" in line: 
    print currentIP[0]
    print line
  if line.startswith('|'):
    print line
  if line.startswith('|_'):
    print line 
    #printNextLine=0

    
print currentIP

      

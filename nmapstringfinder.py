#!/usr/bin/python

import argparse
import re 

parser = argparse.ArgumentParser(description='Videos to images')
parser.add_argument('--file', type=str, help='.nmap output file to parse')
parser.add_argument('--string', type=str, help='string to search for')
args = parser.parse_args()
print(args.file)
nmapFile=args.file
searchString=args.string

pattern = re.compile(r'(\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3})')


file = open(nmapFile,"r")

for line in file:
  if "Nmap" in line:
    currentIP=[]
    match = re.search(pattern,line)
    if match: 
      currentIP.append(match.group())
      
  if searchString in line: 
    print currentIP[0]
    print line
    #printNextLine=0

    

      

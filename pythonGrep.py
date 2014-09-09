#!/bin/python


""" Python Grep will mimic grep in bash. Purpose of this script is to fulfill one of the challenges of the OSCP exam"""
import optparse
import re


def grep(wtg,filename):
    try:
        file = open(filename,'r')
        file.close()
    except IOError as error:   #Need to look more at IOError as there are other types that exist (Eg, valueError)
        print error
        
def fileparse():
    parser=optparse.OptionParser()
    parser.add_option("-g", dest="wtg", type="string", help="What filter we are trying to match") #wtg stands for what to grep
    parser.add_option("-f", dest="filename", help="Full path of file to parse through")
    options,args=parser.parse_args()
    return options.wtg,options.filename
    
    

def main():
    wtg,filename=fileparse()
    grep(wtg,filename)

if __name__ == '__main__':
  main()
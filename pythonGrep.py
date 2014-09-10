#!/bin/python


""" Python Grep will mimic grep in bash. Purpose of this script is to fulfill one of the challenges of the OSCP exam. Script is case sensitive. This feature could be added easily by adding (.lower) to both the search string and the line variable within the grep function. """
import optparse
import re

def grep(file,wtg):
    searchString=wtg
    for line in file:
        matchobj=line.find(searchString) #Went with file instead of regex as I simply wanted to know if the search string is there. If present show the line
        if matchobj != -1:  #This is necessary be cause matchobj is created regardless of whether the searchString is found or not. If present the return value is the place number of where the word can be found. If not present a negative one is returned. 
            print line


def openFile(wtg,filename):
    try:
        file = open(filename,'r')
        grep(file,wtg)
        file.close()
    except IOError as error:   #Need to look more at IOError as there are other types that exist (Eg, valueError)
        print error
        
def fileparse():
    parser=optparse.OptionParser()
    parser.add_option("-g", dest="wtg", type="string", help="What filter we are trying to match") #wtg stands for what to grep
    parser.add_option("-f", dest="filename", help="Full path of file to parse through")
    options,args=parser.parse_args()
    if not options.wtg or not options.filename: #This is how you require 
        parser.error('Missing options')
    return options.wtg,options.filename 
    
    

def main():
    wtg,filename=fileparse()
    openFile(wtg,filename)

if __name__ == '__main__':
  main()
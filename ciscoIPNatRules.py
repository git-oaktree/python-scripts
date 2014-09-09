#!/bin/python

import optparse

""" The CiscoIPNatRules.py Script created to automate the creation of ip nat rules. The only item that must be provided is the -p flag (the pod number), and then the script will automatically create all the rules necessary for that POD""" 


def parse():
    parser=optparse.OptionParser()
    parser.add_option("-p", dest="podNumber", type=int, help="Pod number to create rules for")
    options, args=parser.parse_args()
    return options.podNumber

def createRules(x):
    pod=x
    for classroom in range(1,4):
        for studentnum in range(1,5):
            for systemnum in range(0,10):
                internalIP="192.168.%s%s.1%s%s" %(classroom,pod,studentnum,systemnum)
                externalIP="200.200.%s%s.%s%s%s" %(classroom,pod,2,studentnum,systemnum)
                print "ip nat inside source static %s %s"  %(internalIP,externalIP)
  
  

def main():
    podNumber=parse() 
    createRules(podNumber)
  

if __name__ == '__main__':
  main()

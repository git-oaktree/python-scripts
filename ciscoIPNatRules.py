#!/bin/python

import optparse

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
#               #internalIP='192.168.'+str(classroom)+str(pod)+'.'+str(1)+str(studentnum)+str(systemnum)
                externalIP='200.200.'+str(classroom)+str(pod)+'.'+str(2)+str(studentnum)+str(systemnum)
                print "ip nat inside source static %s %s"  %(internalIP,externalIP)
  
  

def main():
    podNumber=parse() 
    createRules(podNumber)
  

if __name__ == '__main__':
  main()

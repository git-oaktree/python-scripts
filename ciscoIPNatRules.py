#!/bin/python

for pod in range(1,9):
    for classroom in range(1,3):
        for studentnum in range(1,5):
            for systemnum in range(0,10):
                internalIP="192.168.%s%s.1%s%s" %(classroom,pod,studentnum,systemnum)
                #internalIP='192.168.'+str(classroom)+str(pod)+'.'+str(1)+str(studentnum)+str(systemnum)
                externalIP='xxx.xxx.'+str(classroom)+str(pod)+'.'+str(2)+str(studentnum)+str(systemnum)
                print "ip nat inside source static %s %s"  %(internalIP,externalIP)
  
  


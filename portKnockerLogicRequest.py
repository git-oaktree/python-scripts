#!/bin/python
from random import randint

"""This is script is an excerpt of a port knocker script being written by a coworker. That we want to restrict the amount of time someone can trigger the port knock without using time. loopnum < 11 could be translated as while packetCount < 1000, which would translate to a user having 1000 packets to correctly trigger the port knocker at which point they would have to restart. The code as is, works as follows. A while loop called shouldRestart is set to 1, and script will execute the loop. A list called success is there for debugging to ensure that the script is working in correct order. Next thing is to iterate through a list. If the random number is equal to the number in the for list, the item is added to success, and the for loop is stopped by setting loopNum to 12 which is higher then 11. At this point the next item is inspected. If loopNum gets to ten and there is yet to be a match, shouldRestart is left at one, so once the for loop finshes it will be restarted because of the while loop."""

num1=3
num2=4
num3=5


def matchme():
    loopNum=0
    numList=[num1,num2,num3]
    shouldRestart = 1
    while shouldRestart == 1:
        success=[]
        for numToMatch in numList:   
            loopNum=0
            while loopNum < 11:
                randomNumber=randint(0,10)
                if randomNumber == numToMatch:
                    success.append(numToMatch)
                    loopNum=12
                    if len(success) == 3:
                        shouldRestart=0
                        print success
                elif loopNum == 10 and randomNumber != numToMatch:
                    shouldRestart = 1
                    print 'entire loop will restart'
                else:
                    loopNum += 1
                    
                    
            



def main():
    matchme()
        
    
if __name__ == '__main__':
    main()
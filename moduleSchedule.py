#!/bin/python

from datetime import date, timedelta

moduleStart=date(2014,12,29)
currentDay=moduleStart
moduleDays=1
holidayList=[date(2014,10,13),date(2014,11,11),date(2014,11,27),date(2014,12,25),date(2015,1,1),date(2015,1,19),date(2015,2,16),date(2015,5,25),date(2015,7,3),date(2015,9,7)]
##########################################################
#Below holidays are here simply for organization
#columbusDay=date(2014,10,13)
#veteransDay=date(2014,11,11)
#ThanksgivingDay=date(2014,11,27)
#christmasDay=date(2014,12,25)
#newYearsDay=date(2015,1,1)
#MLK=date(2015,1,19)
#presidentsDay=date(2015,2,16)
#memorialDay=date(2015,5,25)
#julyFourth=date(2015,7,3)
#laborDay=date(2015,9,7)
##########################################################




print "First day of lesson1 is %s" % currentDay 
while moduleDays <= 40:
    #Make a list of holidays
    if currentDay in holidayList:
        print '%s is a holiday; no class' % currentDay
        tomorrow=currentDay+timedelta(days=1)
        currentDay=tomorrow   
        
    if currentDay.weekday() != 5 and currentDay.weekday() != 6:

        #daysSinceStart+=1  Most likely not needed
        if moduleDays % 40 == 0:
            print "last day of lesson4 is %s \n" % currentDay
            break
        elif moduleDays % 30 == 0:
            print "last day of lesson3 is %s \n" % currentDay
        elif moduleDays % 20 == 0:
            print "last day of lesson2 is %s \n" % currentDay
            print "First day of lesson3 is %s" % currentDay        
        elif moduleDays % 10 == 0:
            print "last day of lesson1 is %s \n" % currentDay
            print "First day of lesson2 is %s " % currentDay
        tomorrow=currentDay+timedelta(days=1)
        currentDay=tomorrow
        moduleDays+= 1            
    else:
        tomorrow=currentDay+timedelta(days=1)
        currentDay=tomorrow


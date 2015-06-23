#!/bin/python

import sys
import csv

def doesfileexist(filetoread):
    try:
        open(filetoread, 'r')
    except:
        print "error: File does not appear to exist"
        sys.exit(0)

''' Placeholder- Consider using
fieldName. without using fieldname we have to make sure the variable  that we
call match whatever the first row of the csv file are equal too.  Look at
PMOTW '''
'''useful link http://www.youlikeprogramming.com/2013/11/python-csv-reader-dictreader-quick-reference/ #Quote char'''
def parsecsv(fileName):     
    prev_id='0'
    prev_port=''
    prev_protocol=''     
    current_id='' 
    hostList=[]
    #csvfile=open(fileName, 'rt')     
    with open(fileName, 'rb') as csvfile:
        myfile=csv.DictReader(csvfile,quotechar='"') 
        for row in myfile:
            current_id=row['Plugin ID']
            current_protocol=row['Protocol']
            current_port=row['Port']
            if prev_id == '0':
                hostList.append(row['Host'])
                #lineentry='"%s","%s","%s,"%s","%s"' % (row['Plugin ID'],row['Name'],row['Synopsis'],row['Protocol'],row['Port'])
            elif prev_id != current_id: 
                '''Review for If the condition above is met, print out lineentry
                variable as well as all the IP's currently populated in the host array. Empty
                the host array, and then add the IP address for the current row to the host
                array. '''                 
                '''In the below print statment, the lineentry variable doesn't need quotes since those were added when line
                entry variable was created was created.'''
                print '%s,"%s"' % (lineentry, '; '.join(hostList))                 
                hostList=[]
                hostList.append(row['Host'])                
            elif prev_id==current_id: 
                '''If condition above is met, the only thing that has to be done is to add the host's IP
                address to the  host list. '''
                if (prev_port != current_port) or (prev_protocol != current_protocol):
                    print '%s,"%s"' % (lineentry, '; '.join(hostList))                 
                    hostList=[]
                    hostList.append(row['Host'])                
            lineentry='"%s","%s","%s,"%s","%s"' % (row['Plugin ID'],row['Name'],row['Synopsis'],row['Protocol'],row['Port'])
            prev_id=current_id
            prev_port=current_port
            prev_protocol=current_protocol
        '''At the completion of the for loop finish out the logic only if the current_id and prev_id are equal.  
        since that statement in the above for loop does not have a print statement we need this print statement'''
        if prev_id==current_id:
            print '"%s","%s","%s,"%s","%s","%s"' % (row['Plugin ID'],row['Name'],row['Synopsis'],row['Protocol'],row['Port'],'; '.join(hostList))
        csvfile.close()

def main():
    if len(sys.argv) == 2:
        fileName=sys.argv[1]
        doesfileexist(fileName)
    else:
        print 'Missing fileName. Must provide filename with the script.'
        sys.exit(1)
    parsecsv(fileName)

if __name__ == '__main__':
    main()

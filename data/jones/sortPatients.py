import os
import subprocess
import re
from datetime import datetime

f_hostLine = open('hostLineOnly', 'r')
hostLines = f_hostLine.readlines()
f_hostLine.close()

f_dateLine = open('dateLineOnly', 'r')
dateLines = f_dateLine.readlines()
f_dateLine.close()

f_sourceLine = open('sourceLineOnly', 'r')
sourceLines = f_sourceLine.readlines()
f_sourceLine.close()

# Read in line numbers to a list
lineNums = []
for i in range(0, len(hostLines)):
    row = hostLines[i].split("\n")
    lineNums.append(int (row[0]))

lineNumsDate = []
for i in range(0, len(dateLines)):
    row = dateLines[i].split("\n")
    lineNumsDate.append(int (row[0]))

lineNumsSource = []
for i in range(0, len(sourceLines)):
    row = sourceLines[i].split("\n")
    lineNumsSource.append(int (row[0]))

# File with all of the accession numbers
f = open ('accessionNum', 'r')
accession = f.readlines()
f.close()

datesPt1 = []
datesPt2 = []
accessionPt1 = []
accessionPt2 = []
sourcePt1 = []
sourcePt2 = []
outdate = 0

for i in range(0, len(accession)):
    accession[i] = accession[i].split("\n")[0]

    # Finds the last line with the accession number
    command = "grep " + accession[i] + "  jones.gb -n |tail -1"
    direct_output = subprocess.run(command, shell = True, text=True, capture_output=True).stdout
    lineForSeq = int(direct_output.split(":")[0])

    # Finds the first line with host data after the last appearance of the
    # accession number
    j = 0
    while (lineNums[j] < lineForSeq):
        j = j + 1

    # Finds the
    command = "grep "+ str(lineNums[j]) + " hostLine"
    direct_output = subprocess.run(command, shell = True, text=True, capture_output=True).stdout
    pt = (direct_output.split(";")[1]).split('"')[0]

    k = 0
    while (lineNumsDate[k] < lineForSeq):
        k = k + 1
        # Finds the
    command = "grep "+ str(lineNumsDate[k]) + " dateLine"
    direct_output = subprocess.run(command, shell = True, text=True, capture_output=True).stdout
    out_date = (direct_output.split('"')[1])

    l = 0
    while(lineNumsSource[l] < lineForSeq):
        l = l + 1
    command = "grep "+ str(lineNumsSource[l]) + " sourceLine"
    direct_output = subprocess.run(command, shell = True, text=True, capture_output=True).stdout
    out_source = (direct_output.split('"')[1])
    #print(out_source)

    if(pt == " p1"):
        accessionPt1.append(accession[i])
        datesPt1.append(datetime.strptime(out_date, "%d-%b-%Y"))
        sourcePt1.append(out_source)

        os.system("echo " + accession[i] + " >> p1_accession")

    elif (pt == " p2"):
        accessionPt2.append(accession[i])
        datesPt2.append(datetime.strptime(out_date, "%d-%b-%Y"))
        sourcePt2.append(out_source)

        os.system("echo " + accession[i] + " >> p2_accession")

    else:
        print("Problem sorting into patients.")


firstDatePt1 = datesPt1[0];
firstDatePt2 = datesPt2[0];

for i in range(1, len(datesPt1)):
    if(firstDatePt1 > datesPt1[i]):
        firstDatePt1 = datesPt1[i];

for i in range(1, len(datesPt2)):
    if(firstDatePt2 > datesPt2[i]):
        firstDatePt2 = datesPt2[i];

os.system("~/pullseq/src/./pullseq -i jones.fasta -n p1_accession > p1_toAlign.fa")
os.system("mafft p1_toAlign.fa > p1_alignment.fa")
os.system("~/pullseq/src/./pullseq -i jones.fasta -n p2_accession > p2_alignment.fa")
os.system("cp p1_alignment.fa p1_alignment_date.fa")
os.system("cp p2_alignment.fa p2_alignment_date.fa")
#echo "PATIENT","SEQID","FULLSEQID","COLDATE","TYPE","CENSORED","KEPT","DUPLICATE","NOTE"
quotes = "\\"
censorDate = datetime(2006, 7, 1)
for i in range(0, len(datesPt1)):
    day = datesPt1[i]-firstDatePt1
    if (datesPt1[i] > censorDate):
        # is censored
        censored = '1'
    else:
        # Is not censored
        censored = '0'
    command = 'echo '+ quotes+'"pt1' + quotes +'",' + quotes +'"' + accessionPt1[i] + '' + quotes +'",' + quotes +'"' + accessionPt1[i] + '' + quotes +'",'+ str(day.days + 1) + ',' + quotes +'"' + sourcePt1[i] + '' + quotes +'",'+ censored+',1,NA,NA>>p1_dates.csv'
    os.system(command)
    command = "sed -i 's/" + accessionPt1[i]+"/" + accessionPt1[i] + "_" + str(day.days + 1) + "/g' p1_alignment_date.fa"
    os.system(command)
    command = "sed -i 's/" + accessionPt1[i]+"/" + accessionPt1[i] + "_" + str(day.days + 1) + "/g' p1_dates.csv"
    os.system(command)

censorDate =datetime(2006, 9, 1)
for i in range(0, len(datesPt2)):
    day = datesPt2[i]-firstDatePt2
    if (datesPt2[i] > censorDate):
        # is censored
        censored = '1'
    else:
        # Is not censored
        censored = '0'
    command = 'echo '+ quotes+'"pt2' + quotes +'",' + quotes +'"' + accessionPt2[i] + '' + quotes +'",' + quotes +'"' + accessionPt2[i] + '' + quotes +'",'+ str(day.days + 1) + ',' + quotes +'"' + sourcePt2[i] + '' + quotes +'",'+ censored+',1,NA,NA>>p2_dates.csv'
    os.system(command)
    command = "sed -i 's/" + accessionPt2[i]+"/" + accessionPt2[i] + "_" + str(day.days + 1) + "/g' p2_alignment_date.fa"
    os.system(command)
    command = "sed -i 's/" + accessionPt2[i]+"/" + accessionPt2[i] + "_" + str(day.days + 1) + "/g' p2_dates.csv"
    os.system(command)

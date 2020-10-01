#!/usr/bin/python3
fin = open( "tree.ged", "r")
list = fin.readlines()
fin.close()

person = {}
ID = ""
name = ""
sex = []


for line in list:
    if(line.find('INDI', 0, len(line)-1)!=-1):
        word = line.split(' ')
        ID = word[1]
    elif ((line.find('GIVN',0,len(line)-1)!=-1)):
        word = line.split(' ')
        name = word[2].rstrip()
    elif ((line.find('SURN', 0, len(line)-1)!=-1)):
        word = line.split(' ')
        name = name + ' ' + word[2].rstrip()
        person[ID]= name
    elif ((line.find('SEX', 0, len(line)-1)!=-1)): # возможно добавление факта пол бесполезно, но пусть пока будет
        word = line.split(' ')
        sex.append([name, word[2].rstrip()])


parents = []
husb = ""
wife = ""

for line in list:
    if(line.find('HUSB', 0, len(line)-1)!=-1):
        word = line.split(' ')
        husb = person[word[2].rstrip()]
    elif(line.find('WIFE', 0, len(line)-1)!=-1):
        word = line.split(' ')
        wife = person[word[2].rstrip()]
    elif(line.find('CHIL', 0, len(line)-1)!=-1):
        word = line.split(' ')
        parents.append([husb, wife, person[word[2].rstrip()]])


fout = open("tree.pl", "w")
for i in parents:
	fout.write('father({}, {}).\nmother({}, {}).\n'.format(
	i[0],i[2],i[1],i[2]))
for i in sex:
	fout.write('sex({}, {}).\n'.format(i[0],i[1]))
fout.close()

import re

lineArg = 'execute @e[type=armor_stand,r=3,rm=2,m=a,type=!player,name="example 1",l=10,lm=4,dx=6,dy=3,dz=7,scores={example=7},x=7,y=4,z=-636]'
getArg = re.search(r'\@.\[(.+)\]',lineArg)
getArg = getArg.group(0)
print(getArg)
argList = re.findall(r'r=[0-9]+|type=(.+),|type=(.+)]',getArg)
print(argList)
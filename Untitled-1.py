import re

cmdLine = 'execute @a ~ ~ ~ summon zombie ~ ~ ~'
exeCmd = cmdLine.rfind(r'.\s.\s.\s.\s.')
print(exeCmd)
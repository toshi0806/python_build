import re
exeCmd = 0
cmdLine = 'execute @a[scores={sn=5,test=17..83},tag=select] ~ ~ ~ summon zombie ~ ~ ~'

cmdLine2 = '@a[scores={sn=5,test=17..83}'
exeCmd = re.search(r'\{.*\,.*\}',cmdLine2).group(0)
print(exeCmd)
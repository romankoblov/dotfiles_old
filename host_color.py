#!/usr/bin/env python
import commands, hashlib
colorTuples = zip( [0]*8 + [1]*8, range(30,39)*2 )
hostname = commands.getoutput( 'hostname' )
index = int( hashlib.md5(hostname).hexdigest(), 16 ) % len(colorTuples)
hostColor = r'%d;%dm' % colorTuples[index]
print '\e['+str(hostColor)

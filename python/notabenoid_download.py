#! /usr/bin/python
# encoding=utf8

import sys
import urllib2
import subprocess

# define url at notabenoid to parse
if len(sys.argv) > 1 and sys.argv[1] != '-v' :
    url = sys.argv[1]
else:
    url = 'http://notabenoid.com/book/16716' # Friends all seasons

# define where to save files, using %s as name replacement
if len(sys.argv) > 2 and sys.argv[2] != '-v' :
    dest = sys.argv[2]
else:
    dest = 'subs/%s.srt'

data = urllib2.urlopen(url).read().replace('\'', '"')
lines = data.split("<tr")
task = []
for line in lines:
    try:
        parts = line.split('<td class="t"><a href="')[1].split('</a>')[0].split('">')
        if parts[0].startswith('/'):
            parts[0] = '/'.join(url.split('/')[:3]) + parts[0]
    
    except:
        pass
    else:
        task.append(parts)
        
curl = "/usr/bin/curl '%s/download?algorithm=0&skip_neg=0&author_id=0&format=s&enc=UTF-8&crlf=0'\
 -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8'\
 -H 'Accept-Encoding: gzip, deflate'\
 -H 'Accept-Language: ru,en-us;q=0.7,en;q=0.3'\
 -H 'Connection: keep-alive'\
 -H 'Host: %s'\
 -H 'Referer: %s/ready' > %s" 

for line in temp:
    cmd = curl % (line[0], \
                  url.split('/')[2], \
                  line[0], \
                  (dest % line[1]
                      .replace('х','x')
                      .replace('"', "'")
                      .replace("'","\\'")
                      .replace(' ', '\ '))
                      .replace('..', '.'))
                      
    if '-v' in sys.argv:
        print(cmd)
        
    subprocess.check_call(cmd, shell=True)

︠6291d62d-0604-4d73-974a-ebe99a634deb︠
f=open("wiki.txt")
line=f.readlines()
Graf={}
n=len(line)
a=[]
for element in range(0,100):
    if a[0] == '#':
        continue #preskoci komentarje
    a=line[element].split("\t")
    a[1]=a[1].rstrip()
    a[0]=int(a[0])
    a[1]=int(a[1])
    if a[0] in Graf:
        Graf[a[0]].append(a[1])
    if a[0] not in Graf:
        Graf[a[0]]=[a[1]]
    if a[1] in Graf:
        Graf[a[1]].append(a[0])
    if a[1] not in Graf:
        Graf[a[1]]=[a[0]]
print(Graf)
graf=Graph(Graf)
graf.show(figsize=[10,10])
G.cliques_maximal()
︡1894a1ee-831b-45aa-91d0-56700a6e5ede︡{"stderr":"Error in lines 6-18\nTraceback (most recent call last):\n  File \"/cocalc/lib/python2.7/site-packages/smc_sagews/sage_server.py\", line 1013, in execute\n    exec compile(block+'\\n', '', 'single') in namespace, locals\n  File \"\", line 3, in <module>\nIndexError: list index out of range\n"}︡{"done":true}︡︡︡︡︡︡
︠e141a105-f5cc-418b-9b18-5c3ae0728a7f︠











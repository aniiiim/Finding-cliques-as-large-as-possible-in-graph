#Iskanje maksimalnih klik na primeru neki.txt

f=open("neki.txt")
line=f.readlines()
Graf1={}
n=len(line)
a=[]
for element in range(0,len(line)):
    a=line[element].split(" ")
    a[1]=a[1].rstrip()
    a[0]=int(a[0])
    a[1]=int(a[1])
    if a[0] in Graf1:
        Graf1[a[0]].append(a[1])
    if a[0] not in Graf1:
        Graf1[a[0]]=[a[1]]
    if a[1] in Graf1:
        Graf1[a[1]].append(a[0])
    if a[1] not in Graf1:
        Graf1[a[1]]=[a[0]]
G=Graph(Graf1)
G.show(figsize=[2,2])

#iskanje neodvisne množice (največje število vozlišč, kjer vsako od teh vozlišč ni povezano z nobenim drugim v tej množici)

p = MixedIntegerLinearProgram(maximization = True)
b = p.new_variable(binary = True)
p.set_objective( sum([b[v] for v in G]) )

for u,v in G.edges(labels = False):
    p.add_constraint( b[u] + b[v] <= 1 )

p.solve()
b = p.get_values(b)
print [v for v,i in b.items() if i]














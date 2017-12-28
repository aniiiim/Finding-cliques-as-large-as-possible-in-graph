︠204f9153-f415-4095-b57f-f751dc52a86d︠
#Iskanje maksimalnih klik na primeru neki.txt
︡9738b181-ecba-41a7-9103-17414419c541︡
︠b6a9c7a6-41b6-4772-af7e-e955e42aa987s︠
def addEdge(d, u, v):
    if u not in d:
        d[u] = set()
    d[u].add(v)

d = {}
with open("neki.txt") as f:
    for i, ln in enumerate(f):
        if ln[0] == '#':
            continue #preskoci komentarje
        u, v = [int(x) for x in ln.split()]
        addEdge(d, u, v)
        addEdge(d, v, u) #dodajanje obojestranskih povezav, da bo graf neusmerjen

Graf1 = Graph({k: list(v) for k, v in d.iteritems()})
G=Graph(Graf1)
G.show(figsize=[2,2])
K=G.cliques_maximal()
K
︡46fe06bc-9f77-4eab-824e-d5079aff71d2︡{"file":{"filename":"/home/user/.sage/temp/project-1423de7e-c095-41be-b622-3fa4b992099b/116/tmp_xpSxMY.svg","show":true,"text":null,"uuid":"3d575293-7a84-45f6-ac4a-8f7ef1e62bf8"},"once":false}︡{"stdout":"[[1, 2, 3], [1, 3, 4], [1, 7], [2, 3, 5], [4, 6], [5, 7], [6, 7]]\n"}︡{"done":true}︡
︠a86f23d3-f2ab-42e4-abfa-842c4b3b9842︠
#iskanje neodvisne mnozice (najvecje stevilo vozlisc, kjer vsako od teh vozlisc ni povezano z nobenim drugim v tej mnozici)

︡f522c912-0e17-4fc8-8089-6fa75cb2c0f5︡
︠7003a1b4-db50-4a2a-bee2-b51feda64622s︠
︠b112da19-ea38-4390-8dc8-cde38226dacfs︠
p = MixedIntegerLinearProgram(maximization = True)
b = p.new_variable(binary = True)
p.set_objective( sum([b[v] for v in G]) )

for u,v in G.edges(labels = False):
    p.add_constraint( b[u] + b[v] <= 1 )

p.solve()
b1 = p.get_values(b)
print [v for v,i in b1.items() if i]
︡078baa19-9465-4c82-b479-2943d07ffba8︡{"stderr":"Error in lines 3-3\nTraceback (most recent call last):\n  File \"/cocalc/lib/python2.7/site-packages/smc_sagews/sage_server.py\", line 1013, in execute\n    exec compile(block+'\\n', '', 'single') in namespace, locals\n  File \"\", line 1, in <module>\nNameError: name 'G' is not defined\n"}︡{"done":true}︡
︠fa06f7c0-ed59-46fd-aad9-b91d5b110761s︠
#Ideja:
#iskanje neodvisne mnozice na komplementu grafa, ki bo enaka maksimalnim klikam na originalnem grafu
# komplement grafa

#do C = G.complement() koda odvec
︡23d392e8-e7f0-4843-a1d2-6373126fffb9︡{"stdout":"3.0\n"}︡{"stdout":"[1, 5, 6]\n"}︡{"done":true}︡
︠4c8ca7d3-d6b0-40f7-917d-449fe69343c1s︠
a=[]
for u in Graf1:
    for v in Graf1[u]:
        if v not in a:
            a.append(v)
#a
#a = seznam vseh vozlisc

Graf2 = {}
for u in Graf1:
    for v in a:
        if v != u:
            if v not in Graf1[u]:
                Graf2[u]=[v]
    if u not in Graf2:
        Graf2[u] = []
#print(Graf2)

C = G.complement()tdef78f05-7316-4474-bfb7-7395f3fc3c74︡
︠1679aeea-d7f2-4b84-a38a-dc64638c999fs︠
︠7a3f5a69-a8fc-4b83-9aaa-9053ffccfacas︠
︠2d750238-e615-4984-89cc-7a50c271b5d2s︠
︠853134fe-a17c-438f-b4a6-c9a9c2330d30s︠
︡bed826e6-e3ad-4772-a3d5-d3257432baa3︡
︠d2bc6296-6b92-4b40-aa88-7f027de47bf3s︠
C = G.complement()() #komplement originalnega grafa
C.show(figsize = [2,2])

#Funkcija, ki dobi graf kot parameter, pripravi ustrezen celostevilski linearni program, ga resi in vrne resitev

def f(C):
    p = MixedIntegerLinearProgram(maximization = True)
    b = p.new_variable(binary = True)

    n = C.order() # stevilo vozlisc komplementa grafa G
    p.set_objective( sum([b[v] * (1 + random()/n) for v in C]) ) #random() vrne nakljucno stevilo na intervalu [0, 1)

    for u,v in C.edges(labels = False):
        p.add_constraint( b[u] + b[v] <= 1 )

    p.solve()
    b1 = p.get_values(b) #vrne slovar ustreznih vrednosti, nakljucno vrne [1,2,3] ali pa [1,3,4]

    return[v for v,i in b1.items() if i] #seznam tistih vozlisc, ki so v neodvisni mnozici - vrne samo eno optimalno resitev

neodvisna_mnozica = f(C)
neodvisna_mnozica
︡
︠bdd33dda-50c3-4cc8-89b6-73f72e55fa33s︠
︡902be35f-b7ab-4717-b699-6acfe872264dneodvisna_mnozica = f(C)
neodvisna_mnozica
︡5affcba3-eba6-496b-ae3a-281b03d80440︡{"file":{"filename":"/home/user/.sage/temp/project-1423de7e-c095-41be-b622-3fa4b992099b/224/tmp_HqcBGh.svg","show":true,"text":null,"text":null,"uuid":"7ae3add3-51a3-4c14-903b-3d5ced358331"},"once":false}︡{"stdout":"[1, 2, 3, 5]\n"}a72803a2-fe06-4580-b902-bf6e84af0f51︡
︠8a3504bf-af22-4603-a3a4-64557e1470dfs︠
︡dde8501b-c6e5-4413-8f41-eff5698310bb︡{"done":true}︡
︠bdd33dda-50c3-4cc8-89b6-73f72e55fa33s︠
︡902be35f-b7ab-4717-b699-6acfe872264d︡{"d













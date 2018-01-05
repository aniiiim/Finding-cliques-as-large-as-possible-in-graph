︠9ee1f1ad-2c2d-4c77-896c-667cbe258c5b︠
#Iskanje maksimalnih klik na primeru neki.txt

#Uvoz grafa
︡b60a72bb-8de5-4e3b-9561-294b478ad975︡
︠c9bc817d-7fc7-402c-847c-b0f16d9a43e6s︠
def addEdge(d, u, v):
    if u not in d:
        d[u] = set()
    d[u].add(v)

d = {}
with open("neki.txt") as f:
    for i, line in enumerate(f):
        if line[0] == '#':
            continue #preskoci komentarje
        u, v = [int(x) for x in line.split()]
        addEdge(d, u, v)
        addEdge(d, v, u) #dodajanje obojestranskih povezav, da bo graf neusmerjen

Graf1 = Graph({k: list(v) for k, v in d.iteritems()})
generator = ({k: list(v) for k, v in d.iteritems()})
generator
G=Graph(Graf1)
G.show(figsize=[2,2])
#Test ce dobimo prave maksimalne klike
K=G.cliques_maximal()
K
#Ideja:
#iskanje neodvisne mnozice na komplementu grafa, ki bo enaka maksimalnim klikam na originalnem grafu
# komplement grafa

C  = G.complement() #komplement originalnega grafa
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
    b1 = p.get_values(b) #vrne slovar ustreznih vrednosti (nakljucno)
    return[v for v,i in b1.items() if i] #seznam tistih vozlisc, ki so v neodvisni mnozici - vrne samo eno optimalno resitev

neodvisna_mnozica = f(C)
neodvisna_mnozica
︡5b125385-1df0-431d-a7e2-d721d3679e52︡{"stdout":"{1: [2, 3, 4, 7], 2: [1, 3, 5], 3: [1, 2, 4, 5], 4: [1, 3, 6], 5: [2, 3, 7], 6: [4, 7], 7: [1, 5, 6]}\n"}︡{"file":{"filename":"/home/user/.sage/temp/project-1423de7e-c095-41be-b622-3fa4b992099b/221/tmp_hKg1vA.svg","show":true,"text":null,"uuid":"9ec78ee3-051b-4723-b548-d61ea511f226"},"once":false}︡{"stdout":"[[1, 2, 3], [1, 3, 4], [1, 7], [2, 3, 5], [4, 6], [5, 7], [6, 7]]\n"}︡{"file":{"filename":"/home/user/.sage/temp/project-1423de7e-c095-41be-b622-3fa4b992099b/221/tmp_zmUf_b.svg","show":true,"text":null,"uuid":"b9e75b93-8e2f-40b7-8b0b-3a945eb484c6"},"once":false}︡{"stdout":"[1, 3, 4]\n"}︡{"done":true}︡
︠61e9b6f8-a78c-4da1-9fcd-3693a76e5365︠










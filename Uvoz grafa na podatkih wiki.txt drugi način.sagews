︠44e2e51a-b2f5-4b7e-9903-eaa8c1e392f2︠
#uvoz podatkov
#dodajanje povezav v graf
def addEdge(d, u, v):
    if u not in d:
        d[u] = set()
    d[u].add(v)

d = {}
with open("wiki.txt") as f:
    for i, ln in f:
        if ln[0] == '#':
            continue #preskoci komentarje
        u, v = [int(x) for x in ln.split()]
        addEdge(d, u, v)
        addEdge(d, v, u) #dodajanje obojestranskih povezav, da bo graf neusmerjen

graf = Graph({k: list(v) for k, v in d.iteritems()})

#graf.show(figsize = [10, 10])










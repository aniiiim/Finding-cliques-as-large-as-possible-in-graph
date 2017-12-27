#uvoz podatkov
#dodajanje povezav v graf

def addEdge(d, u, v):
    if u not in d:
        d[u] = set()
    d[u].add(v)

d = {}
with open("wiki.txt") as f:
    for ln in f:
        if ln[0] == '#':
            continue #preskoči komentarje
        u, v = [int(x) for x in ln.split()]
        addEdge(d, u, v)
        addEdge(d, v, u) #dodajanje obojestranskih povezav, da bo graf neusmerjen

graf = Graph(d)

graf.show(figsize = [10, 10])

#graf
#G = Graph(d)
#graf.show(figsize = [10, 10])










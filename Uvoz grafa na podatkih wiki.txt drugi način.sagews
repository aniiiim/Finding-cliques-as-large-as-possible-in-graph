︠4ecb7c48-c7dc-4255-81b1-9ffa8c14942cs︠
#uvoz podatkov
#dodajanje povezav v graf
︡98a22596-4e00-4d38-883f-e6bd0f603664︡
︠8f6d9508-e6c6-4349-95b7-56228b105144s︠
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
︡331537a7-7011-404f-9ef8-29d91daa6273︡{"stderr":"\n\n*** WARNING: Code contains non-ascii characters    ***\n\n\nError in lines 13-13\nTraceback (most recent call last):\n  File \"/cocalc/lib/python2.7/site-packages/smc_sagews/sage_server.py\", line 1013, in execute\n    exec compile(block+'\\n', '', 'single') in namespace, locals\n  File \"\", line 1, in <module>\n  File \"/ext/sage/sage-8.1/local/lib/python2.7/site-packages/sage/graphs/graph.py\", line 1129, in __init__\n    raise ValueError(\"This input cannot be turned into a graph\")\nValueError: This input cannot be turned into a graph\n"}︡{"done":true}︡
︠19ab20a2-3720-4d0c-a04e-5e271b501629︠










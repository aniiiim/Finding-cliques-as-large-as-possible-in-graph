︠a11a4866-4ac6-48cc-8e71-8f4ff534bfdb︠
#uvoz podatkov
#dodajanje povezav v graf
︡92e0f9dc-df89-48cd-a21d-d9bff65be8bd︡
︠0ad4ef80-9e34-4a47-9205-eef33cfc7d40s︠
def addEdge(d, u, v):
    if u not in d:
        d[u] = set()
    d[u].add(v)

d = {}
with open("wiki.txt") as f:
    for i, ln in enumerate(f):
        if ln[0] == '#':
            continue #preskoci komentarje
        u, v = [int(x) for x in ln.split()]
        addEdge(d, u, v)
        addEdge(d, v, u) #dodajanje obojestranskih povezav, da bo graf neusmerjen

Graf1 = Graph({k: list(v) for k, v in d.iteritems()})

#Graf1.show(figsize = [10, 10])

#Ideja:
#iskanje neodvisne mnozice na komplementu grafa, ki bo enaka maksimalnim klikam na originalnem grafu
# komplement grafa

C = G.complement() #komplement originalnega grafa
#C.show(figsize = [10,10])

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
︡c68aab75-d1c2-4193-8afe-2546c398d4f3︡{"stderr":"Error in lines 6-12\n"}︡{"stderr":"Traceback (most recent call last):\n  File \"/cocalc/lib/python2.7/site-packages/smc_sagews/sage_server.py\", line 1013, in execute\n    exec compile(block+'\\n', '', 'single') in namespace, locals\n  File \"\", line 5, in <module>\nValueError: too many values to unpack\n"}︡{"done":true}︡
︠3205c2c6-bf39-4bbb-aafc-c20ef36cf4e4︠










#uvoz podatkov
#dodajanje povezav v graf

def addEdge(d, u, v):
    if u not in d:
        d[u] = set()
    d[u].add(v)

d = {}
with open("wiki.txt") as f: #with, da se datoteka po koncu izvajanja samodejno zapre
    for i, line in enumerate(f): #v vsakem obhodu zanke, dobi vrstico vhodne datoteke
        if line[0] == '#':
            continue #preskoci komentarje
        u, v = [int(x) for x in line.split()] #razbije vsako vrstico in elemente v vrstici pretvori v int; split() razbija privzeto po presledkih in tabulatorjih
        addEdge(d, u, v) #elementi vrstice se dodajo kot povezava v graf
        addEdge(d, v, u) #dodajanje obojestranskih povezav, da bo graf neusmerjen
#graf je predstavljen kot slovar mnozic, tako da se nobena povezava ne pojavi dvakrat

Graf1 = Graph({k: list(v) for k, v in d.iteritems()}) #iteritems za razliko od items namesto seznama vrne generator parov
G = Graph(Graf1)

#  Nakljucni povezan podgraf
G1 = G.subgraph(G.connected_component_containing_vertex(3)) #zacnemo z najvecjo povezano komponento - ta vsebuje vozlisce 3
n = 100 #velikost podgrafa (za hitrejsi prevod zaenkrat samo n = 100, kasneje n = 300)
s, t = set(), set()
v = G1.random_vertex() #nakljucno izberemo eno vozlisce iz G1
while len(s) < n:
    s.add(v)
    t.update(G1[v])
    t -= s #iz mnozice t odstranimo vse elemente, ki so v mnozici s
    v, = sample(t, 1) #nakljucen vzorec velikosti 1 iz mnozice t v obliki seznama
                      #v spremenljivko v vrne vrednost elementa v vrnjenem seznamu
                      #v je nakljucno vozlisce iz mnozice t
H = G1.subgraph(s)

#Funkcija, ki dobi graf kot parameter, pripravi ustrezen celostevilski linearni program, ga resi in vrne resitev
def max_klika(G):
    p = MixedIntegerLinearProgram(maximization = True)
    b = p.new_variable(binary = True) #objekt, ki predstavlja mnozico spremenljivk in ga je mogoce indeksirati; ta objekt se ne vsebuje vrednosti

    n = G.order() # stevilo vozlisc grafa G
    p.set_objective( sum([b[v] * (1 + random()/n) for v in G]) ) #random() vrne nakljucno stevilo na intervalu [0, 1)
                                                                 #izbira nakljucnih koeficientov

    for u,v in G.complement().edges(labels = False):
        p.add_constraint( b[u] + b[v] <= 1 ) #pogoj, da nobeni dve nesosednji vozlisci v C nista hkrati v resitvi

    p.solve()
    b1 = p.get_values(b) # za dani objekt vrne slovar ustreznih vrednosti; b1[u] vsebuje vrednost ustrezne spremenljivke v najdeni optimalni resitvi

    return[v for v, i in b1.items() if i] #metoda items na slovarju vrne seznam parov (kljuc, vrednost)
                                          #seznam, ki ima vrednost v za vsak pa (v, i), za katerega velja i = seznam vozlisc, za katere ima ustrezna spremenljivka                                             vrednost 1 (je v neodvisni mnozici)
                                          #seznam tistih vozlisc, ki so v neodvisni mnozici - vrne samo eno optimalno resitev

def max_psevdoklika(G, k, a): #vrne maksimalno k-psevdokliko v C velikosti najvec k
    p = MixedIntegerLinearProgram(maximization = True, solver = "GLPK") #zopet maksimiramo stevilo vozlisc
    x = p.new_variable(binary = True) #x spremenljivka za vsako vozlisce
    y = p.new_variable(binary = True) #y spremenljivka za vsak par vozlisc uv; potencialna povezava (neurejen par razlicnih vozlisc)
                                      #y_uv = 1, ce je x_u = x_v = 1 in je uv povezava v grafu

    #n = G.order()
    #p.set_objective( sum([x[v] * (1 + random()/n) for v in G]) )
    p.set_objective( sum([x[v] for v in G]) )

    for u, v in G.edges(labels = False):
        p.add_constraint(y[u, v] <= x[u])
        p.add_constraint(y[u, v] <= x[v])

    #for u, v in G.edges(labels = False):
    #    p.add_constraint( x[u] + x[v] <= 1 )

    #for u,v in G.edges(labels = False): #pogoj ne zagotavlja, da bo dobljena kvaziklika imela dovolj povezav
    p.add_constraint(sum(y[u,v] for u,v in G.edges(labels = False)) >= a * ((k-1)/2)*(sum(x[v] for v in G)) ) #tu vzameva k = len(najvecja_klika)

    p.add_constraint(sum(x[v] for v in G) <= k) #pogoj, da je velikost resitve najvec k
    p.solve()
    x1 = p.get_values(x) #vrne slovar ustreznih vrednosti
    y1 = p.get_values(y)
    return[v for v,i in x1.items() if i] #seznam tistih vozlisc, ki so v neodvisni mnozici - vrne samo eno optimalno resitev

def bisekcija(G, a = 0.9): #privzeta vrednost a = 0.9
    najvecja_klika = max_klika(G)
    r = len(najvecja_klika) #obstaja kvaziklika velikosti vsaj r: r vozlisc
    s, z = r, G.order() #zacetni meji za bisekcijo
    while s <= z:
        k = floor((s + z)/2)
        max_k_psevdoklika = max_psevdoklika(G, k, a) #poiscemo maksimalno k-psevdokliko v C velikosti najvec k
        m = len(max_k_psevdoklika)
        if m == 0: #k-psevdoklika v C velikosti najvec k ne obstaja
            #maksimalna kvaziklika ima ocitno velikost pod k
            z = k - 1 #popravimo zgornjo mejo
        elif k == m: #dobimo kvazikliko velikosti k
                   #maksimalna kvaziklika ima velikost vsaj k
            K = max_k_psevdoklika
            s = k + 1 #popravimo spodnjo mejo
        else: # m < k, kvaziklika velikosti m + 1 <= k ne obstaja
            return max_k_psevdoklika
    return K

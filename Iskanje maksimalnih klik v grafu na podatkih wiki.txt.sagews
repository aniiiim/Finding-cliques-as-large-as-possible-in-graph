︠c6b7dff4-c2af-4574-83f3-998705cf71a7︠
#uvoz podatkov
#dodajanje povezav v graf
︡0ada55eb-295e-4afe-8899-76eb236e3a2d︡
︠63c39896-de41-4888-a93f-202d26763e00s︠
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
#Graf1.show(figsize = [10, 10])

#  Nakljucni povezan podgraf
def nakljucni_podgraf(n ):
    G1 = G.subgraph(G.connected_component_containing_vertex(3)) #zacnemo z najvecjo povezano komponento - ta vsebuje vozlisce 3
    #n = 100 velikost podgrafa (za hitrejsi prevod zaenkrat samo n = 100, kasneje n = 300)
    s, t = set(), set()
    v = G1.random_vertex() #nakljucno izberemo eno vozlisce iz G1
    while len(s) < n:
        s.add(v)
        t.update(G1[v])
        t -= s #iz mnozice t odstranimo vse elemente, ki so v mnozici s
        v, = sample(t, 1) #nakljucen vzorec velikosti 1 iz mnozice t v obliki seznama
                          #v spremenljivko v vrne vrednost elementa v vrnjenem seznamu
                          #v je nakljucno vozlisce iz mnozice t
    return G1.subgraph(s)

H = nakljucni_podgraf(n=100)

#Ideja:
#iskanje neodvisne mnozice na komplementu grafa, ki bo enaka maksimalnim klikam na originalnem grafu

#C = H.complement() #komplement originalnega grafa (podgrafa)

#Funkcija, ki dobi graf kot parameter, pripravi ustrezen celostevilski linearni program, ga resi in vrne resitev
def max_klika(G):
    p = MixedIntegerLinearProgram(maximization = True)
    b = p.new_variable(binary = True) #objekt, ki predstavlja mnozico spremenljivk in ga je mogoce indeksirati; ta objekt se ne vsebuje vrednosti

    n = G.order() # stevilo vozlisc grafa G
    p.set_objective( sum([b[v] * (1 + random()/n) for v in G]) ) #random() vrne nakljucno stevilo na intervalu [0, 1)
                                                                 #izbira nakljucnih koeficientov

    for u,v in G.complement().edges(labels = False):
        p.add_constraint( b[u] + b[v] <= 1 ) #pogoj, da nobeni dve nesosednji vozlisci v komplementu podanega grafa G nista hkrati v resitvi

    p.solve()
    b1 = p.get_values(b) # za dani objekt vrne slovar ustreznih vrednosti; b1[u] vsebuje vrednost ustrezne spremenljivke v najdeni optimalni resitvi

    return[v for v, i in b1.items() if i] #metoda items na slovarju vrne seznam parov (kljuc, vrednost)
                                          #seznam, ki ima vrednost v za vsak pa (v, i), za katerega velja i = seznam vozlisc, za katere ima ustrezna spremenljivka                                             vrednost 1 (je v neodvisni mnozici)
                                          #seznam tistih vozlisc, ki so v neodvisni mnozici - vrne samo eno optimalno resitev

#najvecja_klika = max_klika(H) # = najvecja klika prvotnega grafa (podgrafa) = neodvisna mnozica na komplementu
#najvecja_klika

#iskanje kvazi klik
#mnozica tistih vozlisc, pri katerih je vsaj (a*100)% povezav, ki bi v kliki morale biti, tudi zares tam
#maksimiziramo stevilo vozlisc

#najmanjsi k, pri katerem bo imela optimalna resitev dovolj povezav
#k velikost najvecje klike, kot prej, k = len(najvecja_klika)
#bolj ucinkovito: bisekcija, kjer isceva najmanjsi k, pri katerem bo optimalna resitev imela dovolj povezav

def max_psevdoklika(G, k, a): #vrne maksimalno k-psevdokliko v G velikosti najvec k
    p = MixedIntegerLinearProgram(maximization = True) #zopet maksimiramo stevilo vozlisc
    x = p.new_variable(binary = True) #x spremenljivka za vsako vozlisce
    y = p.new_variable(binary = True) #y spremenljivka za vsak par vozlisc uv; potencialna povezava (neurejen par razlicnih vozlisc)
                                      #y_uv = 1, ce je x_u = x_v = 1 in je uv povezava v grafu

    #n = G.order()
    #p.set_objective( sum([x[v] * (1 + random()/n) for v in G]) )
    p.set_objective( sum([x[v] for v in G]) )

    for u, v in G.edges(labels = False):
        p.add_constraint(y[u, v] <= x[u])
        p.add_constraint(y[u, v] <= x[v])

    #for u, v in G.edges(labels = False): #za iskanje kvaziklik ta pogoj ni potreben
    #    p.add_constraint( x[u] + x[v] <= 1 )

    #naslednji pogoj ne zagotavlja, da bo dobljena kvaziklika imela dovolj povezav
    p.add_constraint(sum(y[u,v] for u,v in G.edges(labels = False)) >= a * ((k-1)/2)*(sum(x[v] for v in G)) ) 
    #tu vzameva k = len(najvecja_klika)
    
    #naslednji pogoj zagotovi, da ce dobljena k-psevdoklika obstaja, je tudi kvaziklika:
    p.add_constraint(sum(x[v] for v in G) <= k) #pogoj, da je velikost resitve najvec k
    p.solve()
    x1 = p.get_values(x) #vrne slovar ustreznih vrednosti

    return[v for v,i in x1.items() if i] #vrne samo eno optimalno resitev

#m = max_psevdoklika(H, len(najvecja_klika), a = 0.9) #psevdoklika na originalnem grafu
#m

#C.subgraph(kvazi_klika).density() ... vrne delez povezav glede na vse mozne

def bisekcija(G, a = 0.9): #privzeta vrednost a = 0.9
    najvecja_klika = max_klika(G)
    r = len(najvecja_klika) #obstaja kvaziklika velikosti vsaj r: r vozlisc
    s, z = r, G.order() #zacetni meji za bisekcijo
    while s <= z:
        k = floor((s + z)/2)
        max_k_psevdoklika = max_psevdoklika(G, k, a) #poiscemo maksimalno k-psevdokliko v G velikosti najvec k
        m = len(max_k_psevdoklika)
        if m == 0: #preveri, ali je seznam prazen
            #k-psevdoklika v G velikosti najvec k ne obstaja
            #maksimalna kvaziklika ima ocitno velikost pod k
            z = k - 1 #popravimo zgornjo mejo
        elif k == m: #dobimo kvazikliko velikosti k
                   #maksimalna kvaziklika ima velikost vsaj k
            K = max_k_psevdoklika
            s = k + 1 #popravimo spodnjo mejo
        else: # m < k, kvaziklika velikosti m + 1 <= k ne obstaja
            return max_k_psevdoklika
    return K

#kvazi_klika
#H
#H.size()
#najvecja_klika = max_klika(H) #najvecja klika na podgrafu originalnega grafa G
#najvecja_klika
#len(najvecja_klika)

#a = 0.9
#n = 300
#k = floor((len(najvecja_klika) + n)/2) #tak k vzame prvi korak bisekcije
#max_k_psevdoklika = max_psevdoklika(G, k, a)
#max_k_psevdoklika
#len(max_k_psevdoklika)

#H.vertices()

#ukazi, ki naj se izvedejo

def test(H, a = 0.9):
    from time import time
    n = H.order()
    print "\n\nStevilo vozlisc: %d" % n
    s = time()
    najvecja_klika = max_klika(H)
    t = time()
    print "Cas iskanja najvecje klike: %.2f s" % (t-s)
    print "Najvecja klika: %s" % najvecja_klika
    print "Velikost najvecje klike: %s" % len(najvecja_klika)

    k = len(najvecja_klika)
    s = time()
    max_k_psevdoklika = max_psevdoklika(H, k, a)
    t = time()
    print "Cas iskanja najvecje %d-psevdoklike: %.2f s" % (k, t-s)
    print "Najvecja %d-psevdoklika: %s" % (k, max_k_psevdoklika)
    print "Velikost najvecje %d-psevdoklike: %s" % (k, len(max_k_psevdoklika))

    s = time()
    kvazi_klika = bisekcija(H, a)
    t = time()
    print "Cas iskanja najvecje kvaziklike: %.2f s" % (t-s)
    print "Najvecja kvaziklika: %s" % kvazi_klika
    print "Velikost najvecje kvaziklike: %s" % len(kvazi_klika)
︡7226b146-5f88-4a3f-99c0-fbd6eef30f7e︡{"done":true}︡
︠fc179717-0210-441f-a605-e8c46c43e629sr︠
rezultat=test(H,a=0.9)
rezultat
︡8c36ba36-7f0e-40f5-aed4-7d71cbc3fb18︡{"stdout":"\n\nStevilo vozlisc: 100\nCas iskanja najvecje klike: 1.13 s"}










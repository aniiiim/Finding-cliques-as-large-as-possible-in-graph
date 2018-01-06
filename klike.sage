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
def nakljucni_podgraf(n = 100):
    G1 = G.subgraph(G.connected_component_containing_vertex(3)) #zacnemo z najvecjo povezano komponento - ta vsebuje vozlisce 3
    #n = 100 #velikost podgrafa (za hitrejsi prevod zaenkrat samo n = 100, kasneje n = 300)
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
    p = MixedIntegerLinearProgram(maximization = True) #zopet maksimiramo stevilo vozlisc
    x = p.new_variable(binary = True) #x spremenljivka za vsako vozlisce
    y = p.new_variable(binary = True) #y spremenljivka za vsak par vozlisc uv; potencialna povezava (neurejen par razlicnih vozlisc)
                                      #y_uv = 1, ce je x_u = x_v = 1 in je uv povezava v grafu

    #p.set_objective( sum([x[v] * (1 + random()/n) for v in G]) )
    p.set_objective( sum([x[v] for v in G]) )

    for u, v in G.edges(labels = False):
        p.add_constraint(y[u, v] <= x[u])
        p.add_constraint(y[u, v] <= x[v])

    #pogoj ne zagotavlja, da bo dobljena kvaziklika imela dovolj povezav
    p.add_constraint(sum(y[u,v] for u,v in G.edges(labels = False)) >= a * ((k-1)/2)*(sum(x[v] for v in G)) ) #tu vzameva k = len(najvecja_klika)
    
    #naslednji pogoj zagotovi, da ce dobljena k-psevdoklika obstaja, je tudi kvaziklika:
    p.add_constraint(sum(x[v] for v in G) <= k) #pogoj, da je velikost resitve najvec k
    p.solve()
    x1 = p.get_values(x) #vrne slovar ustreznih vrednosti
    return[v for v,i in x1.items() if i]

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

def test(H, a = 0.9):
    from time import time
    print "\n\nStevilo vozlisc: %d" % H.order()
    s = time()
    najvecja_klika = max_klika(H)
    t = time()
    k = len(najvecja_klika)
    print "Cas iskanja najvecje klike: %.2f s" % (t-s)
    print "Najvecja klika: %s" % najvecja_klika
    print "Velikost najvecje klike: %s" % k

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

H300 = G.subgraph([9, 15, 21, 23, 46, 51, 58, 61, 81, 95, 128, 132, 136, 147,
                   193, 214, 258, 290, 304, 407, 415, 425, 456, 465, 467, 546,
                   560, 592, 633, 640, 659, 698, 722, 737, 766, 771, 787, 826,
                   844, 848, 857, 869, 892, 893, 928, 934, 975, 1011, 1013,
                   1029, 1032, 1043, 1044, 1061, 1066, 1102, 1125, 1140, 1142,
                   1154, 1190, 1202, 1218, 1297, 1326, 1350, 1352, 1377, 1390,
                   1403, 1413, 1419, 1446, 1497, 1532, 1566, 1587, 1622, 1633,
                   1638, 1689, 1733, 1734, 1741, 1744, 1792, 1799, 1836, 1858,
                   1908, 1925, 1944, 1967, 1979, 1993, 2004, 2071, 2073, 2114,
                   2116, 2120, 2134, 2144, 2178, 2205, 2215, 2273, 2285, 2312,
                   2322, 2330, 2364, 2369, 2485, 2508, 2516, 2542, 2550, 2570,
                   2587, 2594, 2620, 2676, 2696, 2699, 2754, 2796, 2833, 2838,
                   2902, 2904, 2947, 2981, 2983, 3051, 3054, 3056, 3073, 3081,
                   3105, 3120, 3126, 3160, 3166, 3173, 3188, 3225, 3247, 3309,
                   3317, 3321, 3334, 3338, 3345, 3352, 3379, 3381, 3433, 3446,
                   3480, 3482, 3520, 3521, 3542, 3571, 3607, 3614, 3631, 3643,
                   3660, 3661, 3726, 3772, 3784, 3788, 3792, 3856, 3871, 3872,
                   3914, 3927, 3945, 3956, 3977, 3985, 4020, 4192, 4200, 4201,
                   4247, 4266, 4290, 4310, 4324, 4355, 4361, 4437, 4509, 4524,
                   4536, 4574, 4587, 4716, 4719, 4725, 4764, 4780, 4792, 4811,
                   4814, 4829, 4883, 4980, 4981, 4982, 5048, 5050, 5162, 5190,
                   5233, 5246, 5289, 5301, 5321, 5384, 5454, 5463, 5499, 5568,
                   5599, 5635, 5638, 5650, 5673, 5738, 5743, 5750, 5761, 5773,
                   5828, 5855, 5911, 5913, 5993, 6032, 6123, 6178, 6183, 6199,
                   6313, 6347, 6415, 6417, 6423, 6528, 6560, 6576, 6580, 6582,
                   6615, 6619, 6714, 6837, 6859, 6873, 6881, 6885, 6914, 6948,
                   6991, 7047, 7054, 7092, 7142, 7149, 7162, 7168, 7345, 7359,
                   7365, 7381, 7427, 7429, 7490, 7567, 7624, 7659, 7662, 7719,
                   7769, 7832, 7833, 7835, 7860, 7991, 7994, 8051, 8079, 8163,
                   8290])

H500 = G.subgraph([4, 27, 28, 31, 47, 49, 54, 66, 109, 122, 125, 126, 127,
                   132, 143, 144, 185, 187, 204, 224, 243, 246, 249, 250, 307,
                   311, 313, 315, 317, 320, 321, 335, 339, 347, 370, 387, 399,
                   402, 407, 411, 423, 426, 430, 431, 440, 457, 460, 461, 488,
                   607, 611, 635, 643, 645, 657, 658, 661, 663, 675, 681, 691,
                   706, 714, 739, 769, 771, 789, 826, 832, 849, 850, 854, 856,
                   859, 863, 868, 870, 872, 898, 916, 933, 947, 959, 962, 982,
                   1002, 1033, 1035, 1123, 1129, 1132, 1133, 1164, 1166, 1184,
                   1186, 1187, 1192, 1193, 1203, 1235, 1236, 1243, 1247, 1281,
                   1282, 1305, 1331, 1335, 1350, 1353, 1378, 1384, 1419, 1427,
                   1463, 1464, 1470, 1493, 1501, 1506, 1525, 1542, 1549, 1553,
                   1564, 1573, 1587, 1608, 1625, 1627, 1633, 1638, 1644, 1654,
                   1658, 1678, 1683, 1716, 1730, 1733, 1734, 1769, 1780, 1787,
                   1788, 1790, 1795, 1802, 1803, 1879, 1880, 1893, 1901, 1931,
                   1947, 1976, 1980, 2041, 2066, 2101, 2108, 2114, 2116, 2145,
                   2151, 2168, 2180, 2181, 2242, 2297, 2299, 2307, 2323, 2410,
                   2427, 2440, 2444, 2470, 2482, 2522, 2523, 2526, 2530, 2534,
                   2541, 2546, 2548, 2575, 2612, 2629, 2646, 2650, 2653, 2662,
                   2669, 2674, 2685, 2689, 2696, 2708, 2724, 2727, 2764, 2811,
                   2814, 2830, 2851, 2855, 2859, 2892, 2902, 2918, 2933, 2950,
                   2968, 3003, 3006, 3018, 3027, 3050, 3055, 3080, 3089, 3098,
                   3103, 3104, 3144, 3152, 3175, 3180, 3189, 3193, 3227, 3242,
                   3257, 3260, 3275, 3291, 3297, 3346, 3374, 3383, 3393, 3408,
                   3447, 3451, 3455, 3459, 3460, 3473, 3479, 3480, 3489, 3496,
                   3516, 3530, 3535, 3549, 3562, 3567, 3639, 3642, 3643, 3647,
                   3660, 3670, 3714, 3748, 3762, 3813, 3843, 3885, 3893, 3912,
                   3919, 3922, 3932, 3946, 3956, 3960, 3961, 3965, 3983, 3985,
                   4001, 4009, 4037, 4046, 4062, 4065, 4067, 4071, 4098, 4149,
                   4184, 4195, 4248, 4266, 4290, 4310, 4316, 4326, 4332, 4349,
                   4365, 4373, 4385, 4401, 4402, 4434, 4443, 4453, 4468, 4489,
                   4530, 4557, 4558, 4625, 4631, 4633, 4653, 4661, 4682, 4683,
                   4725, 4751, 4756, 4760, 4777, 4788, 4805, 4814, 4827, 4831,
                   4885, 4893, 4894, 4929, 4937, 4946, 4983, 4993, 5010, 5026,
                   5044, 5079, 5083, 5100, 5114, 5152, 5155, 5162, 5200, 5202,
                   5204, 5207, 5208, 5253, 5263, 5271, 5296, 5305, 5313, 5361,
                   5427, 5446, 5457, 5465, 5466, 5545, 5558, 5584, 5591, 5614,
                   5626, 5660, 5671, 5697, 5753, 5757, 5768, 5773, 5776, 5798,
                   5799, 5800, 5801, 5802, 5818, 5871, 5931, 5933, 5937, 5941,
                   5942, 5969, 5973, 5998, 6047, 6068, 6094, 6097, 6216, 6243,
                   6251, 6280, 6293, 6295, 6296, 6299, 6327, 6378, 6388, 6417,
                   6441, 6472, 6486, 6488, 6520, 6554, 6589, 6590, 6607, 6619,
                   6630, 6649, 6666, 6711, 6751, 6759, 6772, 6776, 6784, 6809,
                   6860, 6865, 6913, 6916, 6949, 6955, 6960, 6967, 6997, 7005,
                   7029, 7057, 7073, 7106, 7113, 7117, 7121, 7185, 7230, 7239,
                   7280, 7293, 7304, 7306, 7310, 7337, 7352, 7359, 7425, 7497,
                   7511, 7561, 7625, 7630, 7632, 7642, 7649, 7679, 7682, 7688,
                   7694, 7733, 7771, 7808, 7842, 7901, 7904, 7908, 7910, 7932,
                   7946, 7949, 7952, 7996, 8134, 8168, 8209, 8211, 8224, 8248,
                   8249, 8282, 8290, 8291, 8296])

%time test(H300)
%time test(H500)

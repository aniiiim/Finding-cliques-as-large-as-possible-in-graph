︠10ab0b0b-74aa-4cd8-9fdc-55079a78b9c1︠
#Iskanje maksimalnih klik na primeru neki.txt
︡48380238-9e01-4706-bd28-1c2111dd77ac︡
︠db0aa617-4e65-4e51-8a33-e513ad2fe779s︠
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
︡891e5b02-9f11-409b-ad4b-45ec90a45b5a︡{"file":{"filename":"/home/user/.sage/temp/project-1423de7e-c095-41be-b622-3fa4b992099b/615/tmp_sXhypF.svg","show":true,"text":null,"uuid":"8a68c85d-e2e9-443d-97d9-ab799b943b38"},"once":false}︡{"done":true}︡
︠5fc6f998-2c64-4ba3-8554-5d6e0324a7b1︠


#iskanje neodvisne množice (največje število vozlišč, kjer vsako od teh vozlišč ni povezano z nobenim drugim v tej množici)

p = MixedIntegerLinearProgram(maximization = True)
b = p.new_variable(binary = True)
p.set_objective( sum([b[v] for v in G]) )

for u,v in G.edges(labels = False):
    p.add_constraint( b[u] + b[v] <= 1 )

p.solve()
b = p.get_values(b)
print [v for v,i in b.items() if i]
︡6e9f1ad7-d884-4abe-9c68-a43929b06d14︡{"stdout":"2.0\n"}︡{"stdout":"[2, 4]\n"}︡{"done":true}︡
︠fa06f7c0-ed59-46fd-aad9-b91d5b110761︠

#ideja brez uporabe neodvisne množice:
#iskanje maksimalnega induciranega trianguliranega podgrafa T pod G
#ko najdeš T, poišči maksimalno kliko na T - ta klika bo spodnja meja za velikost maksimalne klike (mogoče tudi že maksimalna)
#uporaba hevrističnega postopka barvanja za razširitev T v večji (maksimalni) podgraf, ki nima večje klike od trenutne maksimalne klike
#z uporabo hevrističnega barvanja na grafu (DSATUR - degree of saturation largest first) lahko najdemo zgornjo mejo za velikost maximum klike

#iskanje neodvisne množice je enako komplementu iskanja maksimalne klike

















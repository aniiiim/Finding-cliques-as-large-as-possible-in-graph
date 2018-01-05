︠b3273804-b7c5-4ad3-bab9-6275562f162b︠
#Primer s strani: http://doc./en/reference/graphs/sage/graphs/graph.html#sage.graphs.graph.Graph.cliques_maximal
G = Graph({0:[1,2,3], 1:[2], 3:[0,1]})
G.show(figsize=[2,2])
G.cliques_maximal()
#[[0, 1, 2], [0, 1, 3]]
︡37abbee9-fce0-462c-aabb-a08af751613f︡{"file":{"filename":"/home/user/.sage/temp/project-1423de7e-c095-41be-b622-3fa4b992099b/293/tmp_eb_VbU.svg","show":true,"text":null,"uuid":"08ec6ed8-9f66-4bef-b61a-d3352061295a"},"once":false}︡{"stdout":"[[0, 1, 2], [0, 1, 3]]\n"}︡{"done":true}︡
︠dc8e22f9-12fe-4892-af0b-8a50297ba0a5︠

#Uvoz grafa na primeru neki.txt
f=open("neki.txt")
line=f.readlines()
#line
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
print(Graf1)
G=Graph(Graf1)
G.show(figsize=[2,2])
G.cliques_maximal()
︡983cb804-a0fb-450c-8370-9d8b30a433b0︡{"stdout":"{1: [3, 2, 4], 2: [1, 3], 3: [1, 2, 4], 4: [1, 3]}\n"}︡{"file":{"filename":"/home/user/.sage/temp/project-1423de7e-c095-41be-b622-3fa4b992099b/293/tmp_A1Skpl.svg","show":true,"text":null,"uuid":"b4a9d9ed-f9c0-488f-9be8-e7dd6cf4c62a"},"once":false}︡{"stdout":"[[1, 2, 3], [1, 3, 4]]\n"}︡{"done":true}︡
︠165dfda1-ab4b-4e77-aba0-80a80d73ac59︠










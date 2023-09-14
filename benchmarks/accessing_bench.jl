using RadixTrees:Radix
using BenchmarkTools
using DataStructures

# benchmarking accessing to leaf
@benchmark r[toast] setup=(
    r = Radix{Char, Int}();
    r["tester"]=1; r["slow"]=2; r["water"]=3; r["slower"]=4; 
    r["test"]=5; r["team"]=6; r["toast"]=7;
    tester=('t','e','s','t','e','r');
    toast=('t','o','a','s','t');
 )

# compare with trie
@benchmark t["toast"] setup=(t = Trie{Int}(); t["tester"]=1; t["slow"]=2; t["water"]=3; t["slower"]=4; t["test"]=5; t["team"]=6; t["toast"]=7)
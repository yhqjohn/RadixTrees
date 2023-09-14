using RadixTrees:Radix
using BenchmarkTools
using DataStructures

# benchmarking insertion to root
@benchmark r["water"] = 3 setup=(r = Radix{Char, Int}(); r["test"]=1; r["slow"]=2)

# compare with trie
@benchmark t["water"] = 3 setup=(t = Trie{Int}(); t["test"]=1; t["slow"]=2)

# benchmarking insertion to leaf
@benchmark r["tester"] = 12 setup=(r = Radix{Char, Int}(); r["test"]=1; r["slow"]=2)

# benchmarking insertion to middle
@benchmark r["team"] = 6 setup=(r = Radix{Char, Int}(); r["test"]=1; r["slow"]=2)

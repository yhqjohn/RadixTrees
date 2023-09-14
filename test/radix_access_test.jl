using RadixTrees
using Test, Plots, TreeRecipe

r = Radix{Char, Int}()
r["tester"] = 1
r["slow"] = 2
r["water"] = 3
r["slower"] = 4
r["test"] = 5
r["team"] = 6
r["toast"] = 7
r["tester"] = 12
r["t"] = 13
display(r)

for (k, v) in r
    println(k, " => ", v)
end

println(collect(values(r)))
println(join.(collect(keys(r))))

@test r["tester"] == 12
@test r["slow"] == 2
@test r["water"] == 3
@test r["slower"] == 4
@test r["test"] == 5
@test r["team"] == 6
@test r["toast"] == 7

@test get(r, "tester", 0) == 12
@test get(r, "t", 0) == 13
@test get(r, "slow", 0) == 2
@test get(r, "bullshit", 0) == 0
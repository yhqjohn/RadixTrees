using RadixTrees.RadixSets: RadixSet
using Test

r1 = RadixSet{Char, Int}()
push!(r1, "tester"=>1, "tester"=>2)
push!(r1, "slow"=>3)
push!(r1, "water"=>4, "slower"=>5)
push!(r1, "test"=>6)
push!(r1, "team"=>7)
push!(r1, "toast"=>8)
push!(r1, "t"=>9)

display(r1)

r2 = RadixSet{Char, Int}(
    "tester"=>1,
    "tester"=>2,
    "slow"=>3,
    "water"=>4,
    "slower"=>5,
    "test"=>6,
    "team"=>7,
    "toast"=>8,
    "t"=>9
)

@test issetequal(r1, r2)
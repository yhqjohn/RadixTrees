using RadixTrees
using Test

r = Radix{Char, Int}()
r["tester"] = 1
r["slow"] = 2
r["water"] = 3
r["slower"] = 4
r["test"] = 5
r["team"] = 6
r["toast"] = 7

# test delete leaf from root
delete!(r, "water")
display(r)

# test delete leaf from non-root
delete!(r, "slower")
display(r)

# test delete non-leaf
delete!(r, "test")
display(r)
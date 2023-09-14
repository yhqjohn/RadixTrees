using RadixTrees, AbstractTrees
using Test, Plots, TreeRecipe

r = Radix{Char, Int}()
r["tester"] = 1
r["slow"] = 2
r["water"] = 3
display(r)
r["slower"] = 4
display(r)
r["test"] = 5
display(r)
r["team"] = 6
display(r)
r["toast"] = 7
display(r)
r["tester"] = 12
display(r)
r["t"] = 13
display(r)

plot(r)


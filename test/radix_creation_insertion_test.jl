using RadixTrees, Test, Plots, TreeRecipe

r = Radix{Char, Int}()
r["tester"] = 1
r["slow"] = 2
r["water"] = 3
r["slower"] = 4
r["test"] = 5
r["team"] = 6
r["toast"] = 7

plot(r)


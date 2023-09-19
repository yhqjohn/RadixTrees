module RadixSets

using ..RadixTrees: Radix, subtree
using AbstractTrees

mutable struct RadixSet{K, V} <: AbstractNode{Vector{V}}
    content::Radix{K, Vector{V}}
end
RadixSet{K, V}() where {K, V} = RadixSet{K, V}(Radix{K, Vector{V}}())
function RadixSet{K, V}(ps::Vararg{Pair{S, V}}) where {K, S, V}
    r = RadixSet{K, V}()
    for pair in ps
        push!(r, pair)
    end
    return r
end
function Base.push!(r::RadixSet{K, V}, ps::Vararg{Pair{S, V}}) where {K, S, V}
    for (k, v) in ps
        if !haskey(r.content, k)
            r.content[k] = Vector{V}()
        end
        push!(r.content[k], v)
    end
end
Base.length(r::RadixSet{K, V}) where {K, V} = sum(length.(values(r.content)))
Base.isempty(r::RadixSet{K, V}) where {K, V} = all(isempty.(values(r.content)))
Base.values(r::RadixSet{K, V}) where {K, V} = vcat(values(r.content)...)
Base.values(r::RadixSet{K, V}, key) where {K, V} = values(subtree(r.content, key))
Base.getindex(r::RadixSet{K, V}, key) where {K, V} = values(subtree(r.content, key)) 

AbstractTrees.children(r::RadixSet{K, V}) where {K, V} = [RadixSet{K, V}(c) for c in values(r.content.children)]
function AbstractTrees.printnode(io::IO, r::RadixSet{K, V}) where {K, V}
    valuestr = [string(v) for v in values(r)]
    valuelen = length(valuestr) + sum(length.(valuestr))
    if valuelen <= 20
        print(io, r.content.key, ":{", join(valuestr, ", "), "}")
    elseif length(valuestr) <= 10 && valuelen <= 100
        print(io, r.content.key, ":\n", "{", join(valuestr, ", \n"), "}")
    else 
        print(io, r.content.key, ":\n", "{", join(valuestr[1:10], ", \n"), ", \n...}")
    end
end

Base.Set(r::RadixSet{K, V}) where {K, V} = Set{V}(values(r))

export RadixSet

end
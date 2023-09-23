module RadixSeperations

using ..RadixTrees: Radix, subtree, prefixes
using AbstractTrees

mutable struct RadixSeperation{K, V} <: AbstractNode{Vector{V}}
    content::Radix{K, Vector{V}}
end
RadixSeperation{K, V}() where {K, V} = RadixSeperation{K, V}(Radix{K, Vector{V}}())
function RadixSeperation{K, V}(ps::Vararg{Pair{S, V}}) where {K, S, V}
    r = RadixSeperation{K, V}()
    for pair in ps
        push!(r, pair)
    end
    return r
end
function Base.push!(r::RadixSeperation{K, V}, ps::Vararg{Pair{S, V}}) where {K, S, V}
    for (k, v) in ps
        if !haskey(r.content, k)
            if k === ()
                r.content.value = Vector{V}()
                r.content.is_key = true
            else
                r.content[k] = Vector{V}()
            end
        end
        push!(r.content[k], v)
    end
end
Base.push!(r::RadixSeperation{K, V}, ps::Vararg{Pair{S, V2}}) where {K, S, V, V2} = push!(r, convert.(Pair{S, V}, ps)...)
Base.length(r::RadixSeperation{K, V}) where {K, V} = sum(length.(values(r.content)))
Base.isempty(r::RadixSeperation{K, V}) where {K, V} = all(isempty.(values(r.content)))
Base.values(r::RadixSeperation{K, V}) where {K, V} = vcat(values(r.content)...)
function Base.values(r::RadixSeperation{K, V}, key) where {K, V} 
    st = subtree(r.content, key)
    if st === nothing
        return Vector{V}()
    else
        return vcats(values(st)...)
    end
end
Base.getindex(r::RadixSeperation{K, V}, key) where {K, V} = values(subtree(r.content, key)) 
prefixvalues(r::RadixSeperation{K, V}, key) where {K, V} = vcat([v for (_, v) in prefixes(r.content, key)]...)

AbstractTrees.children(r::RadixSeperation{K, V}) where {K, V} = [RadixSeperation{K, V}(c) for c in values(r.content.children)]
function AbstractTrees.printnode(io::IO, r::RadixSeperation{K, V}) where {K, V}
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

Base.Set(r::RadixSeperation{K, V}) where {K, V} = Set{V}(values(r))

export RadixSeperation, prefixvalues

end
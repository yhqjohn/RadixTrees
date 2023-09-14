module RadixSets

using ..RadixTrees: Radix, subtree

mutable struct RadixSet{K, V}
    content::Radix{K, Vector{V}}
end
RadixSet{K, V}() where {K, V} = RadixSet{K, V}(Radix{K, Vector{V}}())
function Base.push!(r::RadixSet{K, V}, ps::Vararg{Pair{K, V}}) where {K, V}
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
Base.getindex(r::RadixSet{K, V}, key) where {K, V} = values(subtree(r.content, key)) 

end
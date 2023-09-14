
using AbstractTrees

AbstractTrees.children(t::Radix{K, V}) where {K, V} = values(t.children)
function AbstractTrees.printnode(io::IO, t::Radix{K, V}) where {K, V}
    value = isdefined(t, :value) ? t.value : nothing
    key = if K == Char
        string(t.key...)
    else
        t.key
    end
    if t.is_key
        print(io, "$key: $value")
    else
        print(io, "$key")
    end
end
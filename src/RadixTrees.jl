module RadixTrees

using AbstractTrees

mutable struct Radix{K, V} <: AbstractNode{V}
    children::Dict{K, Radix{K, V}}
    is_key::Bool
    key::Tuple{Vararg{K}}
    value::V
    Radix{K, V}() where {K, V} = new{K, V}(Dict{K, Radix{K, V}}(), false, ())
end


function Base.setindex!(t::Radix{K, V}, val, key) where {K, V}
    if ! isa(key, Tuple)
        key = tuple(key...)
    end
    if key == ()
        throw(ArgumentError("key cannot be empty to ensure integrity of the tree"))
    end
    value = convert(V, val) # we don't want to iterate before finding out it fails
    node = t

    if haskey(t.children, key[1])
        original_node = node.children[key[1]]
        original_key = original_node.key
        common, rest1, rest2 = compareprefix(original_key, key)
        if rest1 == () # original key isa prefix of the new key
            if rest2 == () # the two keys are the same
                original_node.value = value
                original_node.is_key = true
                return value
            else # the original key isa prefix of the new key
                return original_node[rest2] = value
            end
        elseif rest2 == () # new key isa prefix of the original key
            newnode = Radix{K, V}()
            newnode.children[rest1[1]] = original_node
            original_node.key = rest1
            newnode.is_key = true
            newnode.value = value
            newnode.key = common
            node.children[key[1]] = newnode
            return value
        else # the two keys have a common prefix
            newstem = Radix{K, V}()
            newstem.children[rest1[1]] = original_node
            original_node.key = rest1
            newstem[rest2] = value
            newstem.key = common
            node.children[key[1]] = newstem
            return value
        end
    else # case where the key is not in the tree, add the node onto the root
        newnode = node.children[key[1]] = Radix{K, V}()
        newnode.is_key = true
        newnode.value = value
        newnode.key = key
        return value
    end
end

function Base.getindex(r::Radix, key)
    node = subtree(r, key)
    if node !== nothing && node.is_key
        return node.value
    else
        throw(KeyError(key))
    end
end

function Base.get(r::Radix, key, default)
    node = subtree(r, key)
    if node !== nothing && node.is_key
        return node.value
    else
        return default
    end
end

function Base.haskey(r::Radix, key)
    node = subtree(r, key)
    return node !== nothing && node.is_key
end

function Base.delete!(r::Radix, key)
    parent, node = _access_subtree(r, key)
    if node === nothing
        raise(KeyError("key not found $key"))
    end
    if ! node.is_key
        raise(KeyError("key not found $key"))
    end
    if length(node.children) > 0
        node.is_key = false
        node.value = nothing
    else
        delete!(parent.children, key[1])
    end
end

"""
    compareprefix(s1::Tuple, s2::Tuple)
Compare the prefix of two tuples.
For example:
```julia
julia> compareprefix((1,2,3), (1,2,4))
(1, 2), (3), (4)
```
It returns the common prefix, and the rest of the two tuples.
"""
function compareprefix(s1::Tuple, s2::Tuple)
    i = 1
    while i <= length(s1) && i <= length(s2) && s1[i] == s2[i]
        i += 1
    end
    return s1[1:i-1], s1[i:end], s2[i:end]
end

function stripprefix(prefix::Tuple, s::Tuple)::Union{Tuple, Nothing}
    if length(prefix) > length(s)
        return nothing
    end
    if prefix == s[1:length(prefix)]
        return s[length(prefix)+1:end]
    else
        return nothing
    end
end

function subtree(r::Radix, key)
    parent, node = _access_subtree(r, key)
    return node
end

function _access_subtree(r::Radix, key) # return the parent and the subtree node
    if ! isa(key, Tuple)
        key = tuple(key...)
    end
    if key == ()
        return nothing, r # the root has no extra access
    end
    node = r
    parent = nothing
    while haskey(node.children, key[1])
        parent = node
        node = node.children[key[1]]
        if node.key == key
            return parent, node
        end
        key = stripprefix(node.key, key)
        if key === nothing
            return nothing, nothing
        end
    end
    return nothing, nothing
end


AbstractTrees.children(t::Radix{K, V}) where {K, V} = values(t.children)
function AbstractTrees.printnode(io::IO, t::Radix{K, V}) where {K, V}
    value = isdefined(t, :value) ? t.value : nothing
    key = if K == Char
        string(t.key...)
    else
        t.key
    end
    print(io, key, ": ", isdefined(t, :value) ? t.value : nothing)
end

export Radix

end # module Radices

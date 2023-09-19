RadixSet{K} = Radix{K, Nothing}

Base.push!(r::Radix{K, Nothing}, key::Tuple{Vararg{K}}) where {K} = r[key] = nothing
Base.push!(r::Radix{K, Nothing}, key) where {K} = push!(r, tuple(key...))

function Radix{K}(keys::Vararg{Tuple{Vararg{K}}}) where {K}
    r = Radix{K, Nothing}()
    for key in keys
        push!(r, key)
    end
    return r
end

function AbstractTrees.printnode(io::IO, t::Radix{K, Nothing}) where K
    key = if K == Char
        string(t.key...)
    else
        t.key
    end
    if t.is_key
        print(io, key)
    else
        print(io, key, "...")
    end
end
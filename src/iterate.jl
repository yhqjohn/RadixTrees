Optional{T} = Union{T, Nothing}

mutable struct RadixCursor{K, V}
    node::Radix{K, V}
    parent::Optional{RadixCursor{K, V}}
    restsiblings::Vector{Radix{K, V}}
    prefix::Tuple{Vararg{K}}
    seenchildren::Bool
end

function Base.iterate(r::Radix{K, V}) where {K, V}
    return iterate(
        r,
        RadixCursor{K, V}(r, nothing, [], (), false)
    )
end

function Base.iterate(r::Radix{K, V}, cursor::Optional{RadixCursor{K, V}}) where {K, V}
    # if the cursor is nothing, then return nothing
    cursor === nothing && return nothing
    # first attempt to visit the children
    if (!cursor.seenchildren) && (!isempty(cursor.node.children))
        cursor.seenchildren = true 
        newparent = cursor
        newprefix = (cursor.prefix..., cursor.node.key...)
        newsiblings = collect(values(cursor.node.children))
        newnode = pop!(newsiblings)
        newcursor = RadixCursor{K, V}(
            newnode,
            newparent,
            newsiblings,
            newprefix,
            false
        )
        return iterate(r, newcursor)
    else
        # attempt to collect the current node value
        # but before that, decide the next siblingstate
        # first check if the current node is the last child
        if !isempty(cursor.restsiblings)
            # if we are not the last child, then we should return the next sibling
            newnode = pop!(cursor.restsiblings)
            newcursor = RadixCursor{K, V}(
                newnode,
                cursor.parent,
                cursor.restsiblings,
                cursor.prefix,
                false
            )            
        else
            # if we are the last child, then we should return the parent
            # but first, we should check if the parent is the root
            if cursor.parent === nothing
                # if we are the root, then there is nothing left to iterate
                newcursor = nothing
            else
                newcursor = cursor.parent
            end
        end
        # try to collect the current node value
        if cursor.node.is_key
            return (cursor.prefix..., cursor.node.key...) => cursor.node.value, newcursor
        else
            return iterate(r, newcursor)
        end
    end
end

Base.keys(r::Radix{K, V}) where {K, V} = map(x -> x[1], iterate(r))
Base.values(r::Radix{K, V}) where {K, V} = map(x -> x[2], iterate(r))
function Base.length(r::Radix{K, V}) where {K, V}
    _length = 0
    if r.is_key
        _length += 1
    end
    for child in values(r.children)
        _length += length(child)
    end
    return _length
end

subset(r::Radix{K, V}, key) where {K, V} = values(subtree(r, key))

        



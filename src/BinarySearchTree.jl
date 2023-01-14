
export BinaryNode, find_parent, search, push!

using AbstractTrees

if !isdefined(Base, :isnothing)        # Julia 1.0 support
    using AbstractTrees: isnothing
end

mutable struct BinaryNode{T}
    data::T
    parent::Union{Nothing,BinaryNode{T}}
    left::Union{Nothing,BinaryNode{T}}
    right::Union{Nothing,BinaryNode{T}}

    function BinaryNode{T}(data, parent=nothing, l=nothing, r=nothing) where T
        new{T}(data, parent, l, r)
    end
end

BinaryNode(data) = BinaryNode{typeof(data)}(data)

function find_place(root::BinaryNode, value)

    if root.data < value
        if isnothing(root.right)
            return root 
        end
        return find_parent(root.right, value)

    elseif root.data > value

        if isnothing(root.left)
            return nothing 
        end
        return find_parent(root.left, value)
    else

        return root 
    end
end

function search(parent::BinaryNode, value)
    if parent.data < value
        if isnothing(parent.right)
            return nothing 
        end
        return search(parent.right, value)
    elseif parent.data > value

        if isnothing(parent.left)
            return nothing 
        end
        return search(parent.left, value)
    else
        if parent.data != value
            return nothing 
        end
        return parent
    end
end

function push!(root::BinaryNode, value)
    if root.data < value
        if isnothing(root.left)
            root.left = BinaryNode(value)
        end
        return push!(root.left, value)

    elseif root.data > value

        if isnothing(root.right)
            root.right = BinaryNode(value)
        end
        return push!(root.right, value)
    else
        nothing
    end
end

## Things we need to define
function AbstractTrees.children(node::BinaryNode)
    if isnothing(node.left) && isnothing(node.right)
        ()
    elseif isnothing(node.left) && !isnothing(node.right)
        (node.right,)
    elseif !isnothing(node.left) && isnothing(node.right)
        (node.left,)
    else
        (node.left, node.right)
    end
end

AbstractTrees.nodevalue(n::BinaryNode) = n.data

AbstractTrees.ParentLinks(::Type{<:BinaryNode}) = StoredParents()
AbstractTrees.parent(n::BinaryNode) = n.parent

AbstractTrees.SiblingLinks(::Type{<:BinaryNode}) = ImplicitSiblings()
AbstractTrees.NodeType(::Type{<:BinaryNode{T}}) where {T} = HasNodeType()
AbstractTrees.nodetype(::Type{<:BinaryNode{T}}) where {T} = BinaryNode{T}

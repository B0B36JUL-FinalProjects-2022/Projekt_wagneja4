#https://en.wikipedia.org/wiki/Branch_and_bound#generic_version
export ULBoundTree, ULBoundNode, expand!

using AbstractTrees

if !isdefined(Base, :isnothing)        # Julia 1.0 support
    using AbstractTrees: isnothing
end

mutable struct ULBoundNode{T} <: AbstractNode{T}
    trunk
    data::T
    parent::Union{Nothing, ULBoundNode{T}}
    children::AbstractVector#{ULBoundNode{T}}
    lower_bound::Number
    solution::Number
    function ULBoundNode{T}(data) where T
        new{T}(nothing, data, nothing, Array{ULBoundNode}(undef, 0), Inf, -Inf)
    end
end
ULBoundNode(data) = ULBoundNode{typeof(data)}(data)
mutable struct ULBoundTree{T}
    root:: ULBoundNode{T}
    best::Union{Nothing, AbstractNode{T}}
    candidates::AbstractVector#{ AbstractNode{T}}
    upper_bound::Number
    function ULBoundTree{T}(data) where T
        node = ULBoundNode(data)
        node.trunk = new{T}(node, nothing, [node], Inf)
        return node.trunk
    end
end
ULBoundTree(data) = ULBoundTree{typeof(data)}(data)

function settrunks!(trunk::ULBoundTree{T}, nodes::AbstractVector{ULBoundNode{T}}) where T
    
    for node in nodes
        node.trunk = trunk
    end
end
function setparents!(parent::ULBoundNode{T}, nodes::AbstractVector{ULBoundNode{T}}) where T
    
    for node in nodes
        node.parent = parent
    end
end
function ULBoundNode(trunk, data)
    ret = ULBoundNode{typeof(data)}(data)
    ret.trunk = trunk
    return ret
end

function upper_bound!(trunk::ULBoundTree{T}, best::ULBoundNode{T}) where T
    trunk.best = best
    trunk.upper_bound = trunk.best.solution # is it upper?
end

lower_bound!(node::ULBoundNode, lower::Number) = node.solution = lower #::ULBoundNode

function expand!(root::ULBoundNode{<: Number})

    if length(root.children) == 0
        root.children = [-1 , 1] .+ root.data .|> ULBoundNode
        setparents!(root, root.children)
        settrunks!(root.trunk, root.children)
        append!(root.trunk.candidates, root.children)
    end
end

function expand!(trunk::ULBoundTree)
    filter!(∘(!, is_solved), trunk.candidates)
    filter!(∘(!, (x) -> prune_by_upperbound(trunk, x)), trunk.candidates)
    (trunk.candidates |> length > 0) && argmin(get_result, trunk.candidates) |> expand!
end


solve!(root::ULBoundNode{<: Number}) = root.data
is_solved(root::ULBoundNode{<: Number}) = root.data <= 0 || root.children |> length != 0
function prune_by_upperbound(trunk::ULBoundTree, root::ULBoundNode)
    return root |> get_result >= trunk.upper_bound
end
get_result(root::ULBoundNode{<: Number}) = root.data

## Things we need to define
AbstractTrees.children(trunk::ULBoundTree) = children(trunk.root)
function AbstractTrees.children(node::ULBoundNode)
    if isnothing(node.children)
        []
    else
        node.children
    end
end

AbstractTrees.nodevalue(n::ULBoundNode) = n.data
AbstractTrees.nodevalue(trunk::ULBoundTree) = trunk.root.data

AbstractTrees.ParentLinks(::Type{<:ULBoundNode}) = StoredParents()
AbstractTrees.parent(n::ULBoundNode) = n.parent

AbstractTrees.SiblingLinks(::Type{<:ULBoundNode}) = ImplicitSiblings()
AbstractTrees.NodeType(::Type{<:ULBoundNode{T}}) where {T} = HasNodeType()
AbstractTrees.nodetype(::Type{<:ULBoundNode{T}}) where {T} = ULBoundNode{T}

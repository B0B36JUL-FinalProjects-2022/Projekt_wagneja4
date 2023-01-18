#https://en.wikipedia.org/wiki/Branch_and_bound#generic_version
export ULBoundTree, ULBoundNode, expand!

using JuMP, AbstractTrees

if !isdefined(Base, :isnothing)        # Julia 1.0 support
    using AbstractTrees: isnothing
end

mutable struct ULBoundNode{T} <: AbstractNode{T}
    trunk
    model::T
    parent::Union{Nothing, ULBoundNode{T}}
    children::AbstractVector{ULBoundNode{T}}
    lower_bound::Number
    solution::Number
    variables::AbstractVector{VariableRef}
    function ULBoundNode{T}(model, variables) where T
        new{T}(nothing, model, nothing, Array{ULBoundNode{T}}(undef, 0), Inf, -Inf, variables)
    end
end
ULBoundNode(model, variables) = ULBoundNode{typeof(model)}(model, variables)

mutable struct ULBoundTree{T}
    root:: ULBoundNode{T}
    best::Union{Nothing, AbstractNode{T}}
    candidates::AbstractVector#{ AbstractNode{T}}
    upper_bound::Number
    function ULBoundTree{T}(model, variables) where T
        node = ULBoundNode(model, variables)
        node.trunk = new{T}(node, nothing, [node], Inf)
        return node.trunk
    end
end
ULBoundTree(model, variables) = ULBoundTree{typeof(model)}(model, variables)

function settrunks!(trunk::ULBoundTree{T}, nodes::AbstractVector{ULBoundNode{T}}) where T
    
    for node in nodes
        node.trunk = trunk
    end
end
get_result(node::ULBoundNode) = node.model |> get_result

function setparents!(parent::ULBoundNode{T}, nodes::AbstractVector{ULBoundNode{T}}) where T
    
    for node in nodes
        node.parent = parent
    end
end

function ULBoundNode(trunk, model)
    ret = ULBoundNode{typeof(model)}(model)
    ret.trunk = trunk
    return ret
end

function upper_bound!(best_node::ULBoundNode)
    best_node.trunk.best = best_node
    best_node.trunk.upper_bound = best_node.solution # is it upper?
end

function lower_bound!(node::ULBoundNode)
    node.lower_bound = node.model |> objective_value
end

function solve!(trunk::ULBoundTree)
    expand!(trunk.root)
    while trunk.candidates |> length > 0
        expand!(trunk.root)
    end
end

function expand!(trunk::ULBoundTree)
    filter!(∘(!, is_solved), trunk.candidates)
    filter!((x) -> in_upperbound(trunk, x), trunk.candidates)
    #filter!((x) -> in_lowerbound(trunk, x), trunk.candidates)
    (trunk.candidates |> length > 0) && argmin(get_result, trunk.candidates) |> expand!
end

computation_completed(trunk::ULBoundTree) = trunk.candidates |> length == 0
function in_upperbound(trunk::ULBoundTree, root::ULBoundNode)
    return root.model |> get_result < trunk.upper_bound
end

function in_lowerbound(trunk::ULBoundTree, root::ULBoundNode)
    return root.model |> get_result > trunk.lower_bound
end

function add_children(node::ULBoundNode{T}, children::AbstractVector{ULBoundNode{T}}) where T
    node.children = children
    setparents!(node, node.children)
    settrunks!(node.trunk, node.children)
    append!(node.trunk.candidates, node.children)
end

## Things we need to define
AbstractTrees.children(trunk::ULBoundTree) = children(trunk.root)

function AbstractTrees.children(node::ULBoundNode)
    if isnothing(node.children)
        []
    else
        node.children
    end
end

AbstractTrees.nodevalue(n::ULBoundNode) = n.model |> get_result
AbstractTrees.nodevalue(trunk::ULBoundTree) = trunk.root.model |> get_result

AbstractTrees.ParentLinks(::Type{<:ULBoundNode}) = StoredParents()
AbstractTrees.parent(n::ULBoundNode) = n.parent

AbstractTrees.SiblingLinks(::Type{<:ULBoundNode}) = ImplicitSiblings()
AbstractTrees.NodeType(::Type{<:ULBoundNode{T}}) where {T} = HasNodeType()
AbstractTrees.nodetype(::Type{<:ULBoundNode{T}}) where {T} = ULBoundNode{T}

include("ULBoundTreeNumber.jl")
include("ILPNode.jl")

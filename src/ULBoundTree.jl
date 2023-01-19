#https://en.wikipedia.org/wiki/Branch_and_bound#generic_version
export ULBoundTree, ULBoundNode, solve!, solution_args, solution_value

using JuMP, AbstractTrees, MathOptInterface

if !isdefined(Base, :isnothing)        # Julia 1.0 support
    using AbstractTrees: isnothing
end

mutable struct ULBoundNode{T} <: AbstractNode{T}
    trunk
    model ::T
    parent ::Union{Nothing, ULBoundNode{T}}
    children ::AbstractVector{ULBoundNode{T}}
    lower_bound ::Number
    solution ::Number
    function ULBoundNode{T}(model) where T
        new{T}(nothing, model, nothing, Array{ULBoundNode{T}}(undef, 0), Inf, -Inf)
    end
end

ULBoundNode(model) = ULBoundNode{typeof(model)}(model)

mutable struct ULBoundTree{T}
    root ::ULBoundNode{T}
    best ::Union{Nothing, AbstractNode{T}}
    candidates ::AbstractVector#{ AbstractNode{T}}
    upper_bound ::Number
    optimizer
    function ULBoundTree{T}(model, optimizer) where T
        node = ULBoundNode(model)
        node.trunk = new{T}(node, nothing, [node], Inf, optimizer)
        return node.trunk
    end
end

ULBoundTree(model, optimizer) = ULBoundTree{typeof(model)}(model, optimizer)

function settrunks!(trunk::ULBoundTree{T}, nodes::AbstractVector{ULBoundNode{T}}) where T
    
    for node in nodes
        node.trunk = trunk
    end
end

function solution_value(trunk::ULBoundTree) 
    if trunk.best |> isnothing
        println("No solution available.")
        return
    else
        trunk.best |> get_result
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
    trunk.root |> solve! && return
    trunk |> expand! .|> solve!
    while trunk.candidates |> length > 0
        best = trunk |> best_candidate 
        children_ = best |> expand!
        children_ .|> solve!
        return 
    end
end

solve!(node::Nothing) = return

function best_candidate(trunk::ULBoundTree)
    if trunk.candidates |> length > 0
        argmin(get_result, trunk.candidates)
    else
        nothing
    end
end

function solution_args(trunk::ULBoundTree)
    if trunk.best |> isnothing
        println("No solution available.")
        return
    else
        return trunk.best |> get_arg_values 
    end 
end

function prune_tree!(trunk::ULBoundTree)
    filter!(∘(!, is_solved), trunk.candidates)
    filter!(∘(!, (x) -> in_upperbound(trunk, x)), trunk.candidates)
end

expand!(trunk::ULBoundTree) = trunk.root |> expand!

function in_upperbound(trunk::ULBoundTree, root::ULBoundNode)
    return root |> get_result < trunk.upper_bound
end

function in_lowerbound(trunk::ULBoundTree, root::ULBoundNode)
    return root |> get_result > trunk.lower_bound
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

AbstractTrees.nodevalue(n::ULBoundNode) = n |> get_result
AbstractTrees.nodevalue(trunk::ULBoundTree) = trunk.root |> get_result

AbstractTrees.ParentLinks(::Type{<:ULBoundNode}) = StoredParents()
AbstractTrees.parent(n::ULBoundNode) = n.parent

AbstractTrees.SiblingLinks(::Type{<:ULBoundNode}) = ImplicitSiblings()
AbstractTrees.NodeType(::Type{<:ULBoundNode{T}}) where {T} = HasNodeType()
AbstractTrees.nodetype(::Type{<:ULBoundNode{T}}) where {T} = ULBoundNode{T}

include("ULBoundTreeNumber.jl")
include("ILPNode.jl")

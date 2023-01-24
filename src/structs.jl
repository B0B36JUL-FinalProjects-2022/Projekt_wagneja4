using JuMP, AbstractTrees, MathOptInterface


"""
    ULBoundNode{T} <: AbstractNode{T}

A problem instance struct to hold a node in ULBound tree. The struct is generic, so it is possible to 
implement few methods to get your custom problem instance struct working.
"""
mutable struct ULBoundNode{T} <: AbstractNode{T}
    trunk
    model ::T
    parent ::Union{Nothing, ULBoundNode{T}}
    children ::AbstractVector{ULBoundNode{T}}
    upper_bound ::Number
    expanded :: Bool
    function ULBoundNode{T}(model) where T
        model |> objective_sense != MathOptInterface.MIN_SENSE && throw(ArgumentError("Passed model is not minimalisation model!"))
        new{T}(nothing, model, nothing, Array{ULBoundNode{T}}(undef, 0), Inf, false)
    end
end


"""
    ULBoundTree{T}

The tree structure holds some shared variables for [`ULBoundNode{T}`](@ref) for
less verbose implementation.
"""
mutable struct ULBoundTree{T}
    root ::ULBoundNode{T}
    best ::Union{Nothing, AbstractNode{T}}
    candidates ::AbstractVector # wanted to make it abstract vector of Abstract nodes, but couldnt get it to working
    upper_bound ::Number
    optimizer
    function ULBoundTree{T}(model, optimizer) where T
        node = ULBoundNode(model)
        node.trunk = new{T}(node, nothing, [node], Inf, optimizer)
        return node.trunk
    end
end

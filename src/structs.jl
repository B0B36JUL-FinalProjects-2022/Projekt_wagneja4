using JuMP, AbstractTrees, MathOptInterface

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

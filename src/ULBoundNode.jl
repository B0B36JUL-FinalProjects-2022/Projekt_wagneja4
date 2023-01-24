using JuMP, AbstractTrees, MathOptInterface

ULBoundNode(model) = ULBoundNode{typeof(model)}(model)

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

function upper_bound!(node::ULBoundNode)
    if node.trunk.best |> isnothing
        node.trunk.best = node
        node.trunk.upper_bound = node.upper_bound
        return nothing
    elseif node.trunk.upper_bound > node.upper_bound
        node.trunk.best = node
        node.trunk.upper_bound = node.upper_bound    
        return nothing
    end
    return nothing
end

function lower_bound!(node::ULBoundNode)
    node.lower_bound = node.model |> objective_value
end

function add_children(node::ULBoundNode{T}, children_::AbstractVector{ULBoundNode{T}}) where T
    node.children = children_
    setparents!(node, node.children)
    settrunks!(node.trunk, node.children)
    append!(node.trunk.candidates, node.children)
end

function AbstractTrees.children(node::ULBoundNode)
    if isnothing(node.children)
        []
    else
        node.children
    end
end

AbstractTrees.nodevalue(n::ULBoundNode) = n |> get_result

AbstractTrees.ParentLinks(::Type{<:ULBoundNode}) = StoredParents()
AbstractTrees.parent(n::ULBoundNode) = n.parent

AbstractTrees.SiblingLinks(::Type{<:ULBoundNode}) = ImplicitSiblings()
AbstractTrees.NodeType(::Type{<:ULBoundNode{T}}) where {T} = HasNodeType()
AbstractTrees.nodetype(::Type{<:ULBoundNode{T}}) where {T} = ULBoundNode{T}

function under_upperbound(node::ULBoundNode)
    return node |> get_result < node.trunk.upper_bound
end

function was_expanded(node::ULBoundNode)
    return node.expanded
end

#function above_lowerbound(node::ULBoundNode)
#    node.trunk.best |> isnothing && return true
#    return node |> get_result > node.trunk.best.lower_bound
#end

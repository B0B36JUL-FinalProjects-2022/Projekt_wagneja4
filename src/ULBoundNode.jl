using JuMP, AbstractTrees, MathOptInterface
export ULBoundNode

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

function upper_bound!(best_node::ULBoundNode)
    best_node.trunk.best = best_node
    best_node.trunk.upper_bound = best_node.solution # is it upper?
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

function in_upperbound(node::ULBoundNode)
    return node |> get_result < node.trunk.upper_bound
end

function in_lowerbound(node::ULBoundNode)
    return node |> get_result > node.trunk.lower_bound
end

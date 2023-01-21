using JuMP, AbstractTrees, MathOptInterface
export is_solved

"""
solve!(node::ULBoundNode{<: Model})

    The method for calling the solver on the ULBoundNode{<: Model} instance.
    
    This function has to be implemented for each ULBound instance.
"""
function solve!(node::ULBoundNode{<: Model})

    set_optimizer(node.model, node.trunk.optimizer)
    set_silent(node.model)
    optimize!(node.model)

    if node |> is_unfeasible 
        return true
    elseif node |> is_solved
        upper_bound!(node)
        lower_bound!(node)
        return true
    end

    lower_bound!(node)
    return false
end

"""
get_result(node::ULBoundNode{<: Model})


    A method for retrieving objective value from solved! ULBoundNode{<: Model} instance.
    
    This function has to be implemented for each ULBound instance.
"""
function get_result(node::ULBoundNode{<: Model})
    node |> is_unfeasible && return Inf
    return node.model |> objective_value
end

"""
get_arg_values(node::ULBoundNode{<: Model})

    A method for retrieving argument resulting in objective value of ULBoundNode{<: Model} instance.
    This function has to be implemented for each ULBound instance.

"""
get_arg_values(node::ULBoundNode{<: Model}) = node.model |> all_variables .|> value


"""
expand!(node::ULBoundNode{<: Model})

A method for branching a node. This function has to ensure that !children |> isnothing
and has to add children to its ULBoundNode{T}.children field and appending to
ULBoundTree{T}.candidates.

This function has to be implemented for each ULBound instance.
    """
function expand!(node::ULBoundNode{<: Model})
    children_ = partition(node)
    children_ |> isnothing && return
    add_children(node, children_)
    return children_
end

"""
is_solved(node::ULBoundNode{<: Model})

Predicate that return true, if node is solved and wont be further branching.

This function has to be implemented for each ULBound instance.
"""
function is_solved(node::ULBoundNode{<: Model})
    node.model |> all_variables .|> value .|> isinteger |> all
end

"""
is_unfeasible(node::ULBoundNode{<: Model})

A predicate if node is unfeasible and wont be further branching.

This function has to be implemented for each ULBound instance.
"""
is_unfeasible(node::ULBoundNode{<: Model}) = node.model |> is_unfeasible

"""
AbstractTrees.children(node::ULBoundNode{<: Model})

A predicate if node is unfeasible and wont be further branching.

This function has to be implemented for each ULBound instance in order
to print custom nodes in tree print. Otherwise get_result is used.
"""
function AbstractTrees.nodevalue(node::ULBoundNode{<: Model})
    node |> is_unfeasible && return "Unfeasible"
    return (node |> get_result, node |> get_arg_values)
end

function partition(node::ULBoundNode{<: Model})

    for var in node.model |> all_variables
        if ! (var |> value |> isinteger)
           low = var |> value |> floor
           high = var |> value |> ceil

           low_model, low_object_map = copy_model(node.model)
           @constraint(low_model, low_object_map[var] ≤ low)
           low_node = ULBoundNode(low_model)
           high_model, high_object_map = copy_model(node.model)
           @constraint(high_model, high_object_map[var] ≥ high)
           high_node = ULBoundNode(high_model)

           return node.children = [low_node, high_node]
        end
    end
    return Array{ULBoundNode{Model}}(undef, 0)
end

function is_unfeasible(model::Model)
    status = termination_status(model)
    status == MathOptInterface.TerminationStatusCode[MathOptInterface.INFEASIBLE] && return true
    status == MathOptInterface.INFEASIBLE && return true
    return false
end

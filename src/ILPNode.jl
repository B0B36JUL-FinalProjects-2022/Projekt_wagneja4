using JuMP, AbstractTrees, MathOptInterface
export is_solved

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
    else
        lower_bound!(node)
        return false
    end
end

function expand!(node::ULBoundNode{<: Model})
    children_ = partition(node)
    children_ |> isnothing && return
    add_children(node, children_)
    return children_
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
end

function get_result(node::ULBoundNode{<: Model})
    node |> is_unfeasible && return Inf
    return node.model |> objective_value
end

is_solved(node::ULBoundNode{<: Model}) = node.model |> all_variables .|> value .|> isinteger |> all

is_unfeasible(node::ULBoundNode{<: Model}) = node.model |> is_unfeasible

function is_unfeasible(model::Model)
    status = termination_status(model)
    status == MathOptInterface.INFEASIBLE && return true
    status == MathOptInterface.ALMOST_INFEASIBLE && return true
end

get_arg_values(node::ULBoundNode{<: Model}) = node.model |> all_variables .|> value


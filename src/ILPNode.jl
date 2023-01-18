using MathOptInterface
relax!(node::ULBoundNode{<: Model}) = relax_integrality(node.model)

function expand!(node::ULBoundNode{<: Model})
    undo = relax_integrality(node.model)
    optimize!(node.model)
    node.lower_bound = node.model |> objective_value
    if node |> is_unfeasible 
        undo(node.model)
        return
    end
    solution = node.variables .|> value
    if solution .|> isinteger |> all
        upper_bound!(node)
    else
        lower_bound!(node)
        children = partition(node)
        add_children(node, children)
    end
    undo()

end

function partition(node::ULBoundNode{<: Model})

    for var in node.variables
        if ! (var |> value |> isinteger)
           low = var |> value |> floor
           high = var |> value |> ceil
           low_model, object_map = copy_model(node.model)
           @constraint(low_model, object_map[var] ≤ low)
           low_node = ULBoundNode(low_model, node.variables)
           high_model, object_map = copy_model(node.model)
           @constraint(high_model, object_map[var] ≥ high)
           high_node = ULBoundNode(high_model, node.variables)
           return node.children = [low_node, high_node]
        end
    end
end
function get_result(model::Model)
    model |> termination_status == MathOptInterface.OPTIMIZE_NOT_CALLED && return Inf
    return model |> objective_value

end
function is_unfeasible(node::ULBoundNode{<: Model})
    status = termination_status(node.model)
    status == MathOptInterface.INFEASIBLE && return true
    status == MathOptInterface.ALMOST_INFEASIBLE && return true
end


using JuMP, AbstractTrees, MathOptInterface
export ULBoundTree, ULBoundNode, solve!, solution_args, solution_value

if !isdefined(Base, :isnothing)        # Julia 1.0 support
    using AbstractTrees: isnothing
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

function solve!(trunk::ULBoundTree)
    trunk.root |> solve! && return
    trunk |> expand! .|> solve!
    while trunk.candidates |> length > 0
        best = trunk |> best_candidate 
        children_ = best |> expand!
        children_ .|> solve!
        trunk |> prune_tree!
    end
end

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

AbstractTrees.nodevalue(trunk::ULBoundTree) = trunk.root |> get_result

AbstractTrees.children(trunk::ULBoundTree) = children(trunk.root)

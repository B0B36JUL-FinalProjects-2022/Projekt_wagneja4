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

"""
solution_value(trunk::ULBoundTree)

The method for retrieving the objective value from the tree structure.
"""
function solution_value(trunk::ULBoundTree) 
    if trunk.best |> isnothing
        println("No solution available.")
        return
    else
        trunk.best |> get_result
    end
end

"""
solution_args(trunk::ULBoundTree)

The method for retrieving the arguments which produce the objective value
[`solution_value(trunk::ULBoundTree)`](@ref).
"""
function solution_args(trunk::ULBoundTree)
    if trunk.best |> isnothing
        println("No solution available.")
        return
    else
        return trunk.best |> get_arg_values 
    end 
end

"""
solve!(trunk::ULBoundTree)

The method for calling the solver. The results can be later retrieved by
[`solution_value(trunk::ULBoundTree)`](@ref)
"""
function solve!(trunk::ULBoundTree)
    trunk.root |> solve! && return
    trunk |> expand! .|> solve!
    while trunk.candidates |> length > 0
        trunk |> best_candidate |> expand! .|> solve!
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

function prune_tree!(trunk::ULBoundTree)
    filter!(∘(!, is_unfeasible), trunk.candidates)
    filter!(∘(!, is_solved), trunk.candidates)
    filter!(in_upperbound, trunk.candidates)
end

expand!(trunk::ULBoundTree) = trunk.root |> expand!

AbstractTrees.nodevalue(trunk::ULBoundTree) = trunk.root |> get_result

AbstractTrees.children(trunk::ULBoundTree) = children(trunk.root)

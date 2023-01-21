using Revise
using JuMP, HiGHS, BBforILP, AbstractTrees

function print_comparison(name::String, tree::ULBoundTree, model::Model)

    "Example: " * name |> println
    "My solution: " |> println
    solution_value(tree) |> println
    solution_args(tree) |> println
    "BB Tree: " |> println
    tree.root |> print_tree
    undo()
    set_optimizer(model, HiGHS.Optimizer);
    optimize!(model)
    "HiGHS integer solution: " |> println
    model |> objective_value |> println
    model |> all_variables .|> value |> println
    "" |> println
end

include("KnapsackInt.jl")
include("GenericILP.jl")

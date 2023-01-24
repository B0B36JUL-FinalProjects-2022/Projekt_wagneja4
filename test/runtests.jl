using BBforILP
using Test
using JuMP, HiGHS

function compare_solvers(reference_model::Model, ref_optimizer)
    undo = relax_integrality(reference_model);
    test_model, _ = copy_model(reference_model);     
    tree = ULBoundTree(test_model, ref_optimizer)
    BBforILP.solve!(tree)
    undo()
    optimize!(reference_model)
    test_args = tree |> solution_args
    test_value = tree |> solution_value
    ref_args = reference_model |> all_variables .|> value
    ref_value = reference_model |> objective_value
    return test_args, test_value, ref_args, ref_value
end

function construct_knapsack(capacity::Number, weights::AbstractVector{<:Number}, profits::AbstractVector{<:Number})

    model = Model();
    set_silent(model);
    
    @variable(model, x[1:(weights |> length)], Int)

    @constraint(model, x[1:(weights |> length)] .≥ 0)
    @constraint(model, x[1:(weights |> length)] .≤ 1)

    @objective(model, Min, -profits' * x);

    @constraint(model, weights' * x <= capacity)
    return model
end

@testset "BBforILP.jl" begin
    include("BBforILP.jl")
end


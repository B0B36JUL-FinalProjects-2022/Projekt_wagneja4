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
    test_ret = tree |> solution_value
    ref_ret = reference_model |> objective_value
    return test_ret, (test_ret == ref_ret)
end

function construct_knapsack(capacity::Number, weights::AbstractVector{<:Number}, profits::AbstractVector{<:Number})

    model = Model();
    set_silent(model);
    
    @variable(model, x[1:(weights |> length)], Int)

    @constraint(model, x[1:(weights |> length)] .≥ 0)
    @constraint(model, x[1:(weights |> length)] .≤ 1)

    @objective(model, Max, profits' * x);

    @constraint(model, weights' * x <= capacity)
    return model
end

@testset "BBforILP.jl" begin
    include("BBforILP.jl")
end


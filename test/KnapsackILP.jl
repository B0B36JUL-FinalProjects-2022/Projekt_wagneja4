@testset "Simple KnapsackILP" begin
    reference_model = Model();
    ref_optimizer = HiGHS.Optimizer
    set_silent(reference_model);
    set_optimizer(reference_model, ref_optimizer);
    
    # Define the variables
    @variable(reference_model, green >= 0, Int);
    @variable(reference_model, blue >= 0, Int);
    @variable(reference_model, orange >= 0, Int);
    @variable(reference_model, yellow >= 0, Int);
    @variable(reference_model, gray >= 0, Int);
    
    # Define the constraints 
    @constraint(reference_model, weight,
        green * 12 + blue * 2 + orange * 1 + yellow * 4 + gray * 1 <= 15 
    )
    
    # Define the objective function
    @objective(reference_model, Min,
        -(green * 4 + blue * 1 + yellow * 10 + gray * 2)
    )

    test_args, test_value, ref_args, ref_value = compare_solvers(reference_model, ref_optimizer)
    @test (test_args .== ref_args) |> all
    @test test_value == ref_value
end
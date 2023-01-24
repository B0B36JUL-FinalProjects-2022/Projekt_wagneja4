@testset "Throws not MIN model" begin
    reference_model = Model();
    ref_optimizer = HiGHS.Optimizer
    set_silent(reference_model);
    set_optimizer(reference_model, ref_optimizer);
    
    # Define the variables
    @variable(reference_model, green >= 0, Int);
    
    # Define the constraints 
    @constraint(reference_model, weight, green * 12 <= 15)
    
    # Define the objective function
    @objective(reference_model, Max, green * 4)

    @test_throws ArgumentError BBforILP.ULBoundTree(reference_model, ref_optimizer)
end
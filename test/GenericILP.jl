@testset "Simple GenericILP 1" begin
    reference_model = Model();
    ref_optimizer = HiGHS.Optimizer
    set_silent(reference_model);
    set_optimizer(reference_model, ref_optimizer);

    @variable(reference_model, x>=0, Int);
    @variable(reference_model, y>=0, Int);

    @constraint(reference_model, x+y<=5);
    @constraint(reference_model, 10x+6y<=45);

    @objective(reference_model, Max, 5x+4y);

    args, match =  compare_solvers(reference_model, ref_optimizer)
    @test match
end

@testset "Simple ILP" begin

    @testset "Simple ILP 1" begin
        reference_model = Model();
        ref_optimizer = HiGHS.Optimizer
        set_silent(reference_model);
        set_optimizer(reference_model, ref_optimizer);

        @variable(reference_model, x, Int);
        @variable(reference_model, y, Int);

        @constraint(reference_model, x+y<=5);
        @constraint(reference_model, 10x+6y<=45);

        @objective(reference_model, Max, 5x+4y);
        undo = relax_integrality(reference_model);
        test_model, _ = copy_model(reference_model);     
        tree = ULBoundTree(test_model, ref_optimizer)
        BBforILP.solve!(tree)
        undo()
        optimize!(reference_model)
        test_ret = tree |> solution_value
        ref_ret = reference_model |> objective_value
        @test (test_ret == ref_ret)
    end
end

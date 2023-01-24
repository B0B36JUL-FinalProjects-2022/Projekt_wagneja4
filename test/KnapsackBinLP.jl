@testset "Simple KnapsackILP" begin
    reference_model = construct_knapsack(15,
                                        [12, 2, 1, 4, 1],
                                        [4, 1, 0, 10, 2])
    
    ref_optimizer = HiGHS.Optimizer
    set_optimizer(reference_model, ref_optimizer);

    test_args, test_value, ref_args, ref_value = compare_solvers(reference_model, ref_optimizer)
    @test (test_args .== ref_args) |> all
    @test test_value == ref_value
end

#https://people.sc.fsu.edu/~jburkardt/datasets/knapsack_01/knapsack_01.html
@testset "KnapsackBin 1" begin
    reference_model = construct_knapsack(15,
                                        [23,31,29,44,53,38,63,85,89,82],
                                        [92,57,49,68,60,43,67,84,87,72])
    optimum = [1,1,1,1,0,1,0,0,0,0]
    ref_optimizer = HiGHS.Optimizer
    set_optimizer(reference_model, ref_optimizer);

    test_args, test_value, ref_args, ref_value = compare_solvers(reference_model, ref_optimizer)
    @test (test_args .== ref_args) |> all
    # BB and HiGHS optimizer agrees, but hardcoded reference does not
    @test (test_args .== optimum) |> all
    @test test_value == ref_value
end


@testset "KnapsackBin 2" begin
    reference_model = construct_knapsack(26,
                                        [12,7,11,8,9],
                                        [24,13,23,15,16])
    optimum = [0,1,1,1,0]
    ref_optimizer = HiGHS.Optimizer
    set_optimizer(reference_model, ref_optimizer);

    test_args, test_value, ref_args, ref_value = compare_solvers(reference_model, ref_optimizer)
    @test (test_args .== ref_args) |> all
    @test (test_args .== optimum) |> all
    @test test_value == ref_value
end

@testset "KnapsackBin 3" begin
    reference_model = construct_knapsack(190,
                                        [56,59,80,64,75,17],
                                        [50,50,64,46,50,5])
    optimum = [1,1,0,0,1,0]
    ref_optimizer = HiGHS.Optimizer
    set_optimizer(reference_model, ref_optimizer);

    test_args, test_value, ref_args, ref_value = compare_solvers(reference_model, ref_optimizer)
    @test (test_args .== ref_args) |> all
    @test (test_args .== optimum) |> all
    @test test_value == ref_value
end

@testset "KnapsackBin 4" begin
    reference_model = construct_knapsack(50,
                                        [31,10,20,19, 4, 3, 6],
                                        [70,20,39,37, 7, 5,10])
    optimum = [1,0,0,1,0,0,0]
    ref_optimizer = HiGHS.Optimizer
    set_optimizer(reference_model, ref_optimizer);

    test_args, test_value, ref_args, ref_value = compare_solvers(reference_model, ref_optimizer)
    @test (test_args .== ref_args) |> all
    @test (test_args .== optimum) |> all
    @test test_value == ref_value
end

@testset "KnapsackBin 5" begin
    reference_model = construct_knapsack(104,
                                        [25,35,45, 5,25, 3, 2, 2],
                                        [350,400,450, 20, 70,  8,  5,  5])
    optimum = [1,0,1,1,1,0,1,1]
    ref_optimizer = HiGHS.Optimizer
    set_optimizer(reference_model, ref_optimizer);

    test_args, test_value, ref_args, ref_value = compare_solvers(reference_model, ref_optimizer)
    @test (test_args .== ref_args) |> all
    @test (test_args .== optimum) |> all
    @test test_value == ref_value
end

@testset "KnapsackBin 6" begin
    reference_model = construct_knapsack(170,
                                        [41,50,49,59,55,57,60],
                                        [442,525,511,593,546,564,617])
    
    optimum = [0,1,0,1,0,0,1]
    ref_optimizer = HiGHS.Optimizer
    set_optimizer(reference_model, ref_optimizer);

    test_args, test_value, ref_args, ref_value = compare_solvers(reference_model, ref_optimizer)
    @test (test_args .== ref_args) |> all
    @test (test_args .== optimum) |> all
    @test test_value == ref_value
end

@testset "KnapsackBin 7" begin
    reference_model = construct_knapsack(750,
                                        [70,73,77,80,82,87,90,94,98,106,110,113,115,118,120],
                                        [135,139,149,150,156,163,173,184,192,201,210,214,221,229,240])
    
    optimum = [1,0,1,0,1,0,1,1,1,0,0,0,0,1,1]
    ref_optimizer = HiGHS.Optimizer
    set_optimizer(reference_model, ref_optimizer);

    test_args, test_value, ref_args, ref_value = compare_solvers(reference_model, ref_optimizer)
    @test (test_args .== ref_args) |> all
    @test (test_args .== optimum) |> all
    @test test_value == ref_value
end


@testset "KnapsackBin 8" begin
    reference_model = construct_knapsack(24,
                                        [382745,799601,909247,729069,467902, 44328, 34610,98150,823460,903959,853665,551830,610856,670702,488960,951111,323046,446298,931161, 31385,496951,264724,224916,169684],
                                        [825594,1677009,1676628,1523970, 943972,  97426,  69666,1296457,1679693,1902996,1844992,1049289,1252836,1319836, 953277,2067538, 675367, 853655,1826027,  65731, 901489, 577243, 466257, 369261])
    #          1,1,0,1,1,1,0,0,0,1,1,0,1,0,0,1,0,0,0,0,0,1,1,1
    optimum = [1,1,0,1,1,1,0,0,0,1,1,0,1,0,0,1,0,0,0,0,0,1,1,1]
    ref_optimizer = HiGHS.Optimizer
    set_optimizer(reference_model, ref_optimizer);

    test_args, test_value, ref_args, ref_value = compare_solvers(reference_model, ref_optimizer)
    @test (test_args .== ref_args) |> all
    # BB and and HiGHS optimizer agrees, but hardcoded reference does not
    @test (test_args .== optimum) |> all
    @test test_value == ref_value
end
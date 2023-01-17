@testset "Breadth, depth" begin
    tree = ULBoundTree(2)
    expand!(tree)
    expand!(tree)
    expand!(tree)
    @test tree |> treeheight == 3
    @test tree |> treebreadth == 4
end

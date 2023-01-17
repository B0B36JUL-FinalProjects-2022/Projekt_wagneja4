using AbstractTrees
@testset "Breadth, depth" begin
    tree = BinaryNode(0)
    BBforILP.push!(tree, -10)
    BBforILP.push!(tree, 10)
    BBforILP.push!(tree, 9)
    BBforILP.push!(tree, 11)
    @test tree |> treeheight == 2 
    @test tree |> treebreadth == 3 
end

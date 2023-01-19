using BBforILP
using Test
using JuMP, HiGHS

@testset "BinaryTree.jl" begin
    include("BinaryTree.jl")
end

#@testset "ULBoundTree.jl" begin
#    include("ULBoundTree.jl")
#end

@testset "BBforILP.jl" begin
    include("BBforILP.jl")
end


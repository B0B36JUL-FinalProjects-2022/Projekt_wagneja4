using Revise
using BBforILP

tree = BinaryNode(0)
push!(tree, 10)
push!(tree, -10)
push!(tree, 11)
push!(tree, 9)
print_tree(tree)

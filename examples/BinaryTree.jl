using BBforILP
using AbstractTrees

tree = BinaryNode(0)
BBforILP.push!(tree, -10)
BBforILP.push!(tree, 10)
BBforILP.push!(tree, 9)
BBforILP.push!(tree, 11)

print_tree(tree)

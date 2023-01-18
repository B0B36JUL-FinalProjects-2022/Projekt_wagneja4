using BBforILP
using AbstractTrees

using JuMP, HiGHS

model = Model();
set_optimizer(model, HiGHS.Optimizer);

variables = []
append!(variables, [@variable(model, x, Int)])
append!(variables, [@variable(model, y, Int)])

# Define the constraints 
@constraint(model, x+y<=5);
@constraint(model, 10x+6y<=45);

# Define the objective function
@objective(model, Max, 5x+4y);

tree = ULBoundTree(model, variables)

BBforILP.expand!(tree.root)
tree.root.lower_bound
tree.root

using BBforILP
using AbstractTrees

using JuMP, HiGHS

model = Model();
set_silent(model);
set_optimizer(model, HiGHS.Optimizer);

@variable(model, x>=0)
@variable(model, y>=0)

# Define the constraints 
@constraint(model, x+y<=5);
@constraint(model, 10x+6y<=45);

# Define the objective function
@objective(model, Max, 5x+4y);

tree = ULBoundTree(model, HiGHS.Optimizer)
BBforILP.solve!(tree)
solution_value(tree)
solution_args(tree)

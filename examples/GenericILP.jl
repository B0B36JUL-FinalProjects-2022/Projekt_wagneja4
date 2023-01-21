using BBforILP
using AbstractTrees
using JuMP, HiGHS

model = Model();
set_silent(model);

@variable(model, x>=0, Int)
@variable(model, y>=0, Int)

# Define the constraints 
@constraint(model, x+y<=5);
@constraint(model, 10x+6y<=45);

# Define the objective function
@objective(model, Max, 5x+4y);

undo = relax_integrality(model)
set_optimizer(model, HiGHS.Optimizer);
tree = ULBoundTree(model, HiGHS.Optimizer)
BBforILP.solve!(tree)

print_comparison("Generic ILP", tree, model)

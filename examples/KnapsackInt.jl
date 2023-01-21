using JuMP, HiGHS, BBforILP

model = Model();
set_optimizer(model, HiGHS.Optimizer);
# Define the variables
@variable(model, green >= 0, Int);
@variable(model, blue >= 0, Int);
@variable(model, orange >= 0, Int);
@variable(model, yellow >= 0, Int);
@variable(model, gray >= 0, Int);

# Define the constraints 
@constraint(model, weight,
    green * 12 + blue * 2 + orange * 1 + yellow * 4 + gray * 1 <= 15 
)

# Define the objective function
@objective(model, Max,
    green * 4 + blue * 1 + yellow * 10 + gray * 2
)

undo = relax_integrality(model)
set_optimizer(model, HiGHS.Optimizer);
tree = ULBoundTree(model, HiGHS.Optimizer)
BBforILP.solve!(tree)
"My solution: " |> println
solution_value(tree) |> println
solution_args(tree) |> println
"BB Tree: " |> println
tree.root |> print_tree
undo()
set_optimizer(model, HiGHS.Optimizer);
optimize!(model)
"HiGHS integer solution: " |> println
model |> objective_value |> println
model |> all_variables .|> value |> println

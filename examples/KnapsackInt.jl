using JuMP, HiGHS

m = Model();
set_optimizer(m, HiGHS.Optimizer);
# Define the variables
@variable(m, green >= 0, Int);
@variable(m, blue >= 0, Int);
@variable(m, orange >= 0, Int);
@variable(m, yellow >= 0, Int);
@variable(m, gray >= 0, Int);

# Define the constraints 
@constraint(m, weight,
    green * 12 + blue * 2 + orange * 1 + yellow * 4 + gray * 1 <= 15 
)

# Define the objective function
@objective(m, Max,
    green * 4 + blue * 1 + yellow * 10 + gray * 2
)

# Run the solver
optimize!(m);

# Output
boxes = [green, blue, orange, yellow, gray]
for box in boxes
    println(box, "\t =", value(box))
end
value(weight)
objective_value(m)
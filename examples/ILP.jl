using JuMP, HiGHS

m = Model();
set_optimizer(m, HiGHS.Optimizer);
# Define the variables
@variable(m, x, Int);
@variable(m, y, Int);

# Define the constraints 
@constraint(m, x+y<=5);
@constraint(m, 10x+6y<=45);

# Define the objective function
@objective(m, Max, 5x+4y);

# Run the solver
optimize!(m);

# Output
println(objective_value(m)) # optimal value z
println("x = ", value.(x), "\n","y = ",value.(y)) # optimal solution x & y
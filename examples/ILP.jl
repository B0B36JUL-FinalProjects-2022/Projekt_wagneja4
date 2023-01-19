using JuMP, HiGHS

m = Model();
set_silent(m);
set_optimizer(m, HiGHS.Optimizer);
# Define the variables
@variable(m, x>=0, Int);
@variable(m, y>=0, Int);

# Define the constraints 
@constraint(m, x+y<=5);
@constraint(m, 10x+6y<=45);

# Define the objective function
@objective(m, Max, 5x+4y);

# Run the solver
optimize!(m);

# Output
objective_value(m)
m |> all_variables .|> value
m |> termination_status
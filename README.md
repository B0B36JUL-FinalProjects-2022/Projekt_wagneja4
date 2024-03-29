
<a id='BBforILP'></a>

<a id='BBforILP-1'></a>

## BBforILP


This package implements the branch and bound method for solving integer linear programs. It uses a custom tree structure, with nodes subtyping AbstractNode{T} from package AbstractTrees.jl, which defines a useful environment for working and visualizing tree structures. One of the benefits of AbstractTrees.jl, is the ability to print nice string representations of tree instances and the ability to export the trees to svg, latex and more formats.

Fow documention check out the wiki.

ILPNode instance show representation for model


```julia
using JuMP, HiGHS, BBforILP

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
solution_value(tree)
solution_args(tree)
tree.root
```


```
(23.75, [3.75, 1.25])
├─ (23.0, [3.0, 2.0])
└─ (23.3333, [4.0, 0.833333])

```


<a id='Possible-improvements'></a>

<a id='Possible-improvements-1'></a>

# Possible improvements


The tree structure is not using full potential of AbstractTrees. There could be implemented improvements such as more effective tree structure representation, implementing iterators, implementing the interface of abstract trees for usage with plot recepies to plot the trees into latex or svg and more.


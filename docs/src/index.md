# Example.jl Documentation

```@contents
```

## Package idea
This package implements the branch and bound method for solving integer linear programs.
It uses a custom tree structure, with nodes subtyping AbstractNode{T} from package
AbstractTrees.jl, which defines a useful environment for working and visualizing tree
structures. One of the benefits of AbstractTrees.jl, is the ability to print nice string
representations of tree instances and the ability to export the trees to svg, latex and
more formats.

## ULBound structs

```@docs
BBforILP.ULBoundNode{T}
```

```@docs
BBforILP.ULBoundTree{T}
```

## ULBound functions

```@docs
BBforILP.solution_value(trunk::ULBoundTree)
```

```@docs
BBforILP.solution_args(trunk::ULBoundTree)
```

```@docs
BBforILP.solve!(trunk::ULBoundTree)
```

## ULBound{<: Model} struct instance

```@docs
BBforILP.solve!(node::ULBoundNode{<: Model})
```

```@docs
BBforILP.get_result(node::ULBoundNode{<: Model})
```

```@docs
BBforILP.get_arg_values(node::ULBoundNode{<: Model})
```

```@docs
BBforILP.expand!(node::ULBoundNode{<: Model})
```

```@docs
BBforILP.is_unfeasible(node::ULBoundNode{<: Model})
```

```@docs
BBforILP.is_solved(node::ULBoundNode{<: Model})
```

```@docs
BBforILP.AbstractTrees.nodevalue(node::ULBoundNode{<: Model})
```

## Index

```@index
```

# Example.jl Documentation


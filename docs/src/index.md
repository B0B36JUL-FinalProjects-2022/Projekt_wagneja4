# Example.jl Documentation

```@contents
```

## Package idea

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


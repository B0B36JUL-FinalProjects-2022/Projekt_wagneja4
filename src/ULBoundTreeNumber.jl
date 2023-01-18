function expand!(root::ULBoundNode{<: Number})

    if length(root.children) == 0
        root.children = [-1 , 1] .+ root.model .|> get_result .|> ULBoundNode
        solve!(root)
        setparents!(root, root.children)
        settrunks!(root.trunk, root.children)
        append!(root.trunk.candidates, root.children)
    end
end

solve!(root::ULBoundNode{<: Number}) = root.model |> get_result
is_solved(root::ULBoundNode{<: Number}) = root.model |> get_result <= 0 || root.children |> length != 0
get_result(model::Number) = model
ULBoundTree(model::Number) = ULBoundTree{typeof(model)}(model, [])
ULBoundNode(model::Number) = ULBoundNode{typeof(model)}(model, [])
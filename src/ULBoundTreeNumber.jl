lower_bound!(node::ULBoundNode, lower::Number) = node.solution = lower #::ULBoundNode

function expand!(root::ULBoundNode{<: Number})

    if length(root.children) == 0
        root.children = [-1 , 1] .+ root.data .|> ULBoundNode
        setparents!(root, root.children)
        settrunks!(root.trunk, root.children)
        append!(root.trunk.candidates, root.children)
    end
end

solve!(root::ULBoundNode{<: Number}) = root.data
is_solved(root::ULBoundNode{<: Number}) = root.data <= 0 || root.children |> length != 0
get_result(root::ULBoundNode{<: Number}) = root.data

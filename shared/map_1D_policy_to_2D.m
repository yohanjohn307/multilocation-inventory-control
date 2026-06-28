function U_2D = map_1D_policy_to_2D(U_1D, x_vec, X1, U1, N)
    U_2D = zeros(numel(X1), N-1);
    for k = 1:N-1
        for i = 1:length(x_vec)
            for j = 1:length(x_vec)
                state_idx = sub2ind(size(X1), i, j);
                ui = U_1D(i, k);
                uj = U_1D(j, k);
                action_idx = sub2ind(size(U1), ui, uj);
                U_2D(state_idx, k) = action_idx;
            end
        end
    end
end

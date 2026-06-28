function [J_basestock,U_basestock] = exhaustive_base_stock_evaluation(X1,X2,U1,U2,...
    SASPM_coupled,SACM_coupled,N,gamma,alpha,beta)
    
    x_vec = X1(1,:);
    u_vec = U1(1,:);
    J_basestock = cell(1,length(x_vec));
    U_basestock = cell(1,length(x_vec));
    for S_idx = 1:length(x_vec)
        % construct base-stock policy
        S = x_vec(S_idx);
        U_decoupled_1D = ones(length(x_vec),1);
        ordering_states = x_vec < S; 
        if any(ordering_states)
            U_decoupled_1D(ordering_states) = find(u_vec == (S - x_vec(ordering_states))' );
            [~,U_decoupled_1D(ordering_states)] = ismember((S - x_vec(ordering_states))',u_vec);
        end

        % map 1D policy to 2D
        U_decoupled = map_1D_policy_to_2D(U_decoupled_1D, x_vec, X1, U1, N);
        
        % policy evaluation
        dim_flag = '2D';
        J_basestock{S_idx} = decoupled_policy_evaluation(X1,X2,U_decoupled,...
        SASPM_coupled,SACM_coupled,N,gamma,alpha,beta,dim_flag);
        U_basestock{S_idx} = U_decoupled;
    end

end

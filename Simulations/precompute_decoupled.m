function [SASPM,SACM] = precompute_decoupled(T_vec,U_vec,b,w_vals,w_probs,alpha,beta,l,h,K,K_h,x_switch,order_flag)

    T_left = min(T_vec); T_right = max(T_vec);
    
    % Build state-action-state transition probability map: 
    % [current state, action, next state] -> transition probability
    SASPM = zeros(numel(T_vec), numel(U_vec), numel(T_vec));
    for ti = 1:length(T_vec)
        for ui = 1:length(U_vec)
            for wi = 1:length(w_probs)
                next_state = T_vec(ti) + b*U_vec(ui) + w_vals(wi);
                next_state(next_state < T_left) = T_left;
                next_state(next_state > T_right) = T_right;
                t_next_idx = find(abs(T_vec - next_state) < 1e-9);
                SASPM(ti, ui, t_next_idx) = ...
                    SASPM(ti, ui, t_next_idx) + w_probs(wi);
            end
        end
    end
    
    % Build state-action-cost matrix:
    % [state, action] -> cost
    dim_flag = '1D';
    SACM = zeros([numel(T_vec), numel(U_vec)]);
    for ui = 1:numel(U_vec)
        SACM(:,ui) = reshape(order_cost(U_vec(ui)*ones(size(T_vec)),l,h,K,K_h,x_switch,order_flag,dim_flag) ...
            + state_cost(T_vec,alpha,beta,dim_flag), numel(T_vec), []);
    end

end
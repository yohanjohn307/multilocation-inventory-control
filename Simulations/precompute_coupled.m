function [SASPM,SACM] = precompute_coupled(T1,T2,U1,U2,B,w_vals,w_probs,alpha,beta,l,h,K,K_h,x_switch,order_flag)

    T_vec = T1(1,:);
    U_vec = U1(1,:);
    T_left = min(T_vec); T_right = max(T_vec);

    % Build state-action-state transition probability map: 
    % [current state, action, next state] -> transition probability
    SASPM = zeros(numel(T1), numel(U1), numel(T1));
    f = waitbar(0,'Building coupled SASPM...');
    for i = 1:length(T_vec)
        for j = 1:length(T_vec)
            state_idx = sub2ind(size(T1),i,j);
            
            for ui = 1:length(U_vec)
                for uj = 1:length(U_vec)
                    action_idx = sub2ind(size(U1),ui,uj);
    
                    for wi = 1:length(w_probs)
                        for wj = 1:length(w_probs)
                            next_state = [T1(i,j); T2(i,j)] + B*[U1(ui,uj); U2(ui,uj)] + [w_vals(wi); w_vals(wj)];
                            next_state(next_state < T_left) = T_left;
                            next_state(next_state > T_right) = T_right;
                            col_idx = find(abs(T_vec - next_state(1)) < 1e-9);
                            row_idx = find(abs(T_vec - next_state(2)) < 1e-9);
                            next_state_idx = sub2ind(size(T1),row_idx,col_idx); 
                            SASPM(state_idx, action_idx, next_state_idx) = ...
                                SASPM(state_idx, action_idx, next_state_idx) + w_probs(wi)*w_probs(wj);
                        end
                    end
                end
            end
        end
        waitbar(i/length(T_vec),f,'Building coupled SASPM...');
    end
    close(f)

    % Build state-action-cost matrix:
    % [state, action] -> cost
    dim_flag = '2D';
    SACM = zeros([numel(T1), numel(U1)]);
    for i = 1:numel(U1)
        [ui,uj] = ind2sub(size(U1),i);
        U = cat(3,U1(ui,uj)*ones(size(T1)),U2(ui,uj)*ones(size(T1)));
        SACM(:,i) = reshape(order_cost(U,l,h,K,K_h,x_switch,order_flag,dim_flag) ...
            + state_cost(cat(3,T1,T2),alpha,beta,dim_flag), numel(T1), []);
    end

end
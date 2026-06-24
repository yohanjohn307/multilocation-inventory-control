function [cost_coupled,cost_decoupled,cost_online] = monte_carlo_policy_evaluation(X1,X2,U1,U2,...
    U_coupled,U_decoupled,N,B,N_sims,w_vals,w_probs,alpha,beta,l,h,K,K_h,x_switch,order_flag)

    cost_coupled = zeros(numel(X1),N_sims);
    cost_decoupled = zeros(numel(X1),N_sims);
    cost_online = zeros(numel(X1),N_sims);
    w_bins = cumsum(w_probs);
    x_vec = X1(1,:);
    x_left = min(x_vec); x_right = max(x_vec);
    dim_flag = '2D';
    f = waitbar(0,'Running MC sims...');
    % loop through simulation runs
    for i = 1:length(x_vec)
        for j = 1:length(x_vec)
            idx = sub2ind(size(X1),i,j);
            for n = 1:N_sims
                % initial conditions
                x_coupled = [X1(i,j); X2(i,j)];
                x_decoupled = [X1(i,j); X2(i,j)];
                x_online = [X1(i,j); X2(i,j)];
            
                % initial state cost
                cost_coupled(idx,n) = state_cost(reshape(x_coupled,[1 1 2]),alpha,beta,dim_flag);
                cost_decoupled(idx,n) = cost_coupled(idx,n);
                cost_online(idx,n) = cost_coupled(idx,n);
                
                % loop through time
                for k = 1:N-1
                    % choose action
                    [state_idx_i,state_idx_j] = find(abs(X1 - x_coupled(1)) < 1e-9 & ...
                        abs(X2 - x_coupled(2)) < 1e-9);
                    state_idx = sub2ind(size(X1),state_idx_i,state_idx_j);
                    action_idx = U_coupled(state_idx,k);
                    [action_idx_i,action_idx_j] = ind2sub(size(U1),action_idx);
                    u_coupled = [U1(action_idx_i,action_idx_j); U2(action_idx_i,action_idx_j)];
                    cost_coupled(idx,n) = cost_coupled(idx,n) + ...
                        order_cost(reshape(u_coupled,[1 1 2]),l,h,K,K_h,x_switch,order_flag,dim_flag);
            
                    [state_idx_i,state_idx_j] = find(abs(X1 - x_decoupled(1)) < 1e-9 & ...
                        abs(X2 - x_decoupled(2)) < 1e-9);
                    state_idx = sub2ind(size(X1),state_idx_i,state_idx_j);
                    action_idx = U_decoupled(state_idx,k);
                    [action_idx_i,action_idx_j] = ind2sub(size(U1),action_idx);
                    u_decoupled = [U1(action_idx_i,action_idx_j); U2(action_idx_i,action_idx_j)];
                    cost_decoupled(idx,n) = cost_decoupled(idx,n) + ...
                        order_cost(reshape(u_decoupled,[1 1 2]),l,h,K,K_h,x_switch,order_flag,dim_flag);
        
                    if strcmp(order_flag,'sector')
                        u_online = [dual_balancing_policy(x_online(1),x_vec,k,N,w_vals,w_probs,alpha,beta,dim_flag);
                            dual_balancing_policy(x_online(2),x_vec,k,N,w_vals,w_probs,alpha,beta,dim_flag)];
                    elseif strcmp(order_flag,'affine')
                        u_online = [randomized_balancing_policy(x_online(1),x_vec,k,N,K,w_vals,w_probs,alpha,beta,dim_flag);
                            randomized_balancing_policy(x_online(2),x_vec,k,N,K,w_vals,w_probs,alpha,beta,dim_flag)];
                    else
                        error('Invalid flag.')
                    end
                    cost_online(idx,n) = cost_online(idx,n) + ...
                        order_cost(reshape(u_online,[1 1 2]),l,h,K,K_h,x_switch,order_flag,dim_flag);
        
                    % state evolution
                    [~,idx_w1] = find(rand(1) < w_bins,1);
                    [~,idx_w2] = find(rand(1) < w_bins,1);
                    w = w_vals([idx_w1; idx_w2])';
            
                    x_coupled = x_coupled + B*u_coupled + w;
                    x_coupled(x_coupled > x_right) = x_right;
                    x_coupled(x_coupled < x_left) = x_left;
            
                    x_decoupled = x_decoupled + B*u_decoupled + w;
                    x_decoupled(x_decoupled > x_right) = x_right;
                    x_decoupled(x_decoupled < x_left) = x_left;
        
                    x_online = x_online + B*u_online + w;
                    x_online(x_online > x_right) = x_right;
                    x_online(x_online < x_left) = x_left;
            
                    % state cost
                    cost_coupled(idx,n) = cost_coupled(idx,n) + ...
                        state_cost(reshape(x_coupled,[1 1 2]),alpha,beta,dim_flag);
                    cost_decoupled(idx,n) = cost_decoupled(idx,n) + ...
                        state_cost(reshape(x_decoupled,[1 1 2]),alpha,beta,dim_flag);
                    cost_online(idx,n) = cost_online(idx,n) + ...
                        state_cost(reshape(x_online,[1 1 2]),alpha,beta,dim_flag);
                end
            end
        end
        waitbar(i/length(x_vec),f,'Running MC sims...');
    end
    close(f)
    cost_coupled = cost_coupled / N;
    cost_decoupled = cost_decoupled / N;
    cost_online = cost_online / N;
end

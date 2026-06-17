% randomized-balancing policy
function u_rb = randomized_balancing_policy(x,x_vec,k,N,K,w_vals,w_probs,alpha,beta,dim_flag)
    
    dx = mean(diff(w_vals));
    
    % Compute balancing quantity u_hat
    % --------------------------------
    u_lims = [0 max(x_vec)-min(w_vals)-x];
    % bisection
    while u_lims(2) - u_lims(1) > dx
        u = round(mean(u_lims)/dx)*dx;
        holding_cost = expected_holding_cost(u,x,k,N,w_vals,w_probs,alpha,beta,dim_flag);
        backlog_cost = expected_backlog_cost(u,x,w_vals,w_probs,alpha,beta,dim_flag);
        if holding_cost <= backlog_cost
            u_lims(1) = u;
        else
            u_lims(2) = u;
        end
    end
    % check final limits
    u = u_lims(1);
    holding_cost_1 = expected_holding_cost(u,x,k,N,w_vals,w_probs,alpha,beta,dim_flag);
    backlog_cost_1 = expected_backlog_cost(u,x,w_vals,w_probs,alpha,beta,dim_flag);
    delta_1 = abs(holding_cost_1 - backlog_cost_1);

    u = u_lims(2);
    holding_cost_2 = expected_holding_cost(u,x,k,N,w_vals,w_probs,alpha,beta,dim_flag);
    backlog_cost_2 = expected_backlog_cost(u,x,w_vals,w_probs,alpha,beta,dim_flag);
    delta_2 = abs(holding_cost_2 - backlog_cost_2);

    if delta_1 < delta_2
        u_hat = u_lims(1);
        theta = max(holding_cost_1,backlog_cost_1);
    else
        u_hat = u_lims(2);
        theta = max(holding_cost_2,backlog_cost_2);
    end

    % Compute holding cost K quantity u_tilde
    % ---------------------------------------
    u_lims = [0 max(x_vec)-min(w_vals)-x];
    % bisection
    while u_lims(2) - u_lims(1) > dx
        u = round(mean(u_lims)/dx)*dx;
        holding_cost = expected_holding_cost(u,x,k,N,w_vals,w_probs,alpha,beta,dim_flag);
        if holding_cost <= K
            u_lims(1) = u;
        else
            u_lims(2) = u;
        end
    end
    % check final limits
    u = u_lims(1);
    holding_cost = expected_holding_cost(u,x,k,N,w_vals,w_probs,alpha,beta,dim_flag);
    delta_1 = abs(holding_cost - K);

    u = u_lims(2);
    holding_cost = expected_holding_cost(u,x,k,N,w_vals,w_probs,alpha,beta,dim_flag);
    delta_2 = abs(holding_cost - K);
    
    if delta_1 < delta_2
        u_tilde = u_lims(1);
    else
        u_tilde = u_lims(2);
    end
    
    backlog_cost_tilde = expected_backlog_cost(u_tilde,x,w_vals,w_probs,alpha,beta,dim_flag);
    backlog_cost_zero = expected_backlog_cost(0,x,w_vals,w_probs,alpha,beta,dim_flag);
    
    % Randomized policy
    % -----------------
    if theta >= K
        u_rb = u_hat;
    else
        p_t = backlog_cost_zero / (K + backlog_cost_zero - backlog_cost_tilde);
        if rand(1) <= p_t
            u_rb = u_tilde;
        else
            u_rb = 0;
        end
    end

end

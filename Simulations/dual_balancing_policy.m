% dual-balancing policy
function u_db = dual_balancing_policy(x,x_vec,k,N,w_vals,w_probs,alpha,beta,dim_flag)
    dx = mean(diff(w_vals));
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
    holding_cost = expected_holding_cost(u,x,k,N,w_vals,w_probs,alpha,beta,dim_flag);
    backlog_cost = expected_backlog_cost(u,x,w_vals,w_probs,alpha,beta,dim_flag);
    delta_1 = abs(holding_cost - backlog_cost);

    u = u_lims(2);
    holding_cost = expected_holding_cost(u,x,k,N,w_vals,w_probs,alpha,beta,dim_flag);
    backlog_cost = expected_backlog_cost(u,x,w_vals,w_probs,alpha,beta,dim_flag);
    delta_2 = abs(holding_cost - backlog_cost);

    if delta_1 < delta_2
        u_db = u_lims(1);
    else
        u_db = u_lims(2);
    end
end

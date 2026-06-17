% expected backlog cost at next time step
function out = expected_backlog_cost(u,x,w_vals,w_probs,alpha,beta,dim_flag)
    out = w_probs*state_cost(min(w_vals + x + u,0),alpha,beta,dim_flag)';
end
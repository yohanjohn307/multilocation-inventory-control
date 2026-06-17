% expected holding cost of ordered units from time t to end of horizon
function out = expected_holding_cost(u,x,k,N,w_vals,w_probs,alpha,beta,dim_flag)
    out = 0;
    dw = mean(diff(w_vals));
    w_max = max(-w_vals);
    w_probs_t = w_probs;
    ct = 1;
    for t_idx = k+1:N
        w_vals_t = 0:dw:w_max*ct;
        dh = w_probs_t*state_cost(max(u - max(w_vals_t - x,0),0),alpha,beta,dim_flag)';
        out = out + dh;
        if dh < 1e-12
            break
        end
        w_probs_t = conv(w_probs_t,w_probs);
        ct = ct + 1;
    end
end
function out = state_cost(x,alpha,beta,dim_flag)
    if strcmp(dim_flag,'1D')
        out = alpha*max(0,x) + beta*max(0,-x);
    elseif strcmp(dim_flag,'2D')
        out = alpha*max(0,x) + beta*max(0,-x);
        out = sum(out,3);
    else
        error('Invalid flag value.')
    end
end
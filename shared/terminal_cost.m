function J_N = terminal_cost(X1,X2,alpha,beta,dim_flag)

    if strcmp(dim_flag,'1D')
        J_N = reshape(state_cost(X1,alpha,beta,dim_flag), numel(X1), 1);
    elseif strcmp(dim_flag,'2D')
        J_N = reshape(state_cost(cat(3,X1,X2),alpha,beta,dim_flag), numel(X1), 1);
    else
        error('Invalid flag value.')
    end

end

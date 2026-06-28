function [J,U] = finite_horizon_dp(T1,T2,SASPM,SACM,N,gamma,alpha,beta,dim_flag)

    J = zeros(numel(T1), N);
    U = zeros(numel(T1),N-1);
    % terminal cost
    J(:,N) = terminal_cost(T1,T2,alpha,beta,dim_flag);
    % iterate backwards through time
    for k = N-1:-1:1
        % iterate through state space
        J_u = SACM + tensorprod(SASPM, gamma*J(:,k+1), 3, 1);
        % choose minimum-cost action
        [J(:,k), U(:,k)] = min(J_u,[],2);
    end

end

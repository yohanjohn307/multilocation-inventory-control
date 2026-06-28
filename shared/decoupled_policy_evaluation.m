% evaluate given policy in 2 evaporator setting
function J_decoupled = decoupled_policy_evaluation(X1,X2,U_decoupled,SASPM,SACM,N,gamma,alpha,beta,dim_flag)

    J_decoupled = zeros(numel(X1), N);
    % terminal cost
    J_decoupled(:,N) = terminal_cost(X1,X2,alpha,beta,dim_flag);
    SSPM = zeros(size(SASPM,1,3));
    SC_vec = zeros(numel(X1),1);
    for i = 1:numel(X1)
        SSPM(i,:) = SASPM(i,U_decoupled(i),:);
        SC_vec(i) = SACM(i,U_decoupled(i));
    end

    % iterate backwards through time
    for k = N-1:-1:1
        J_decoupled(:,k) = SC_vec + gamma*SSPM*J_decoupled(:,k+1);
    end

end

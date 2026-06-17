clear; clc;

%% Inputs
b = 1; % dynamics: x_{k+1} = x_k + b*u_k - w_k
N = 20; % finite horizon length
N_sims = 100; % number of Monte Carlo sims
gamma = 1; % discount factor
dx = 0.5; % inventory level discretization
x_left = -2; x_right = 8; % inventory level limits
w_left = -1.5; w_right = 0; % disturbance limits
u_left = 0; u_right = x_right-x_left-w_left; % control limits
order_flag = 'affine'; % ordering cost flag: 'sector' or 'affine'
l = 1; h = 2; % ordering cost sector bounds
x_switch = 6; % x-value of switch between segments of piecewise linear ordering cost
K = 4; K_h = 4; % fixed ordering cost and upper bound
alpha = 0.2; beta = 10; % per-unit holding/backlog costs

% BE SURE TO ALSO SET ORDER/STATE COST AS DESIRED!

%% Problem Setup
B = b*eye(2);
x_vec = x_left:dx:x_right;
u_vec = u_left:dx:u_right;
w_vals = w_left:dx:w_right; % disturbance support discretization
% w_probs = 1/length(w_vals)*ones(size(w_vals)); % uniform
w_probs = binopdf(0:length(w_vals)-1,length(w_vals)-1,0.5); % binomial

figure
bar(w_vals,w_probs)
xlabel('Disturbance'); ylabel('Probability');

figure
plot(2*u_left:dx:2*u_right,order_cost(2*u_left:dx:2*u_right,l,h,K,K_h,x_switch,order_flag,'2D'),'LineWidth',1.5)
xlabel('Order Quantity'); ylabel('Cost');

figure
plot(x_vec,state_cost(x_vec,alpha,beta,'2D'),'LineWidth',1.5)
xlabel('Inventory Level'); ylabel('Cost');

[X1,X2] = meshgrid(x_vec,x_vec);
[U1,U2] = meshgrid(u_vec,u_vec);

%% Coupled DP
% Pre-computation:
%   > SASPM: state-action-state probability matrix
%   > SACM: state-action-cost matrix
[SASPM_coupled,SACM_coupled] = precompute_coupled(X1,X2,U1,U2,...
    B,w_vals,w_probs,alpha,beta,l,h,K,K_h,x_switch,order_flag);

% DP
dim_flag = '2D';
[J_coupled,U_coupled] = ...
    finite_horizon_dp(X1,X2,SASPM_coupled,SACM_coupled,N,gamma,alpha,beta,dim_flag);

%% Decoupled DP
% Pre-computation
%   > SASPM: state-action-state probability matrix
%   > SACM: state-action-cost matrix
[SASPM_decoupled,SACM_decoupled] = precompute_decoupled(x_vec,u_vec,b,...
    w_vals,w_probs,alpha,beta,l,h,K,K_h,x_switch,order_flag);

% DP
dim_flag = '1D';
[~,U_decoupled_1D] = ...
    finite_horizon_dp(x_vec,[],SASPM_decoupled,SACM_decoupled,N,gamma,alpha,beta,dim_flag);

% Map 1D policy to 2D
U_decoupled = zeros(size(U_coupled));
for k = 1:N-1
    for i = 1:length(x_vec)
        for j = 1:length(x_vec)
            state_idx = sub2ind(size(X1),i,j);
            ui = U_decoupled_1D(i,k);
            uj = U_decoupled_1D(j,k);
            action_idx = sub2ind(size(U1),ui,uj);
            U_decoupled(state_idx,k) = action_idx;
        end
    end
end

% policy evaluation
J_decoupled = decoupled_policy_evaluation(X1,X2,U_decoupled,...
    SASPM_coupled,SACM_coupled,N,gamma,alpha,beta);

%% Monte Carlo Policy Evaluation 
[cost_coupled,cost_decoupled,cost_online] = monte_carlo_policy_evaluation(X1,X2,U1,U2,...
    U_coupled,U_decoupled,N,B,N_sims,w_vals,w_probs,alpha,beta,l,h,K,K_h,x_switch,order_flag);

%% Post-processing
visualize(x_vec,U1,U2,U_coupled,U_decoupled,J_coupled,J_decoupled,...
    cost_coupled,cost_decoupled,cost_online,order_flag)

clear; clc;

%% Inputs
b = 1; % dynamics: x_{k+1} = x_k + b*u_k - w_k
N = 2; % finite horizon length
N_sims = 1; % number of Monte Carlo sims
gamma = 1; % discount factor
dx = 1; % inventory level discretization
x_left = -2; x_right = 2; % temperature limits
w_left = -1; w_right = 0; % disturbance limits
u_left = 0; u_right = x_right-x_left+w_right; % control limits
order_flag = 'sector'; % ordering cost flag: 'sector' or 'affine'
l = 2; h = 4; % ordering cost sector bounds
K = 0; K_h = 0; % fixed ordering cost and upper bound
alpha = 1; beta = 10; % per-unit holding/backlog costs

% BE SURE TO ALSO SET ORDER/STATE COST AS DESIRED!

%% Problem Setup
B = b*eye(2);
x_vec = x_left:dx:x_right;
u_vec = u_left:dx:u_right;
w_vals = w_left:dx:w_right; % disturbance support discretization
w_probs = 1/length(w_vals)*ones(size(w_vals)); % uniform
% w_probs = binopdf(0:length(w_vals)-1,length(w_vals)-1,0.5); % binomial

figure
bar(w_vals,w_probs)
xlabel('Disturbance'); ylabel('Probability');

[X1,X2] = meshgrid(x_vec,x_vec);
[U1,U2] = meshgrid(u_vec,u_vec);

%% Coupled DP
% Pre-computation:
%   > SASPM: state-action-state probability matrix
%   > SACM: state-action-cost matrix
[SASPM_coupled,SACM_coupled] = precompute_coupled(X1,X2,U1,U2,...
    B,w_vals,w_probs,alpha,beta,l,h,K,K_h,order_flag);

% DP
dim_flag = '2D';
[J_coupled,U_coupled] = ...
    finite_horizon_dp(X1,X2,SASPM_coupled,SACM_coupled,N,gamma,alpha,beta,dim_flag);

%% Optimized Base-Stock Policy
% Policy evaluation
[J_basestock,U_basestock] = exhaustive_base_stock_evaluation(X1,X2,U1,U2,...
    SASPM_coupled,SACM_coupled,N,gamma,alpha,beta);

% Policy selection
[J_basestock,U_basestock] = base_stock_selection(x_vec,J_basestock,U_basestock);

%% Post-processing
visualize(x_vec,U1,U2,U_coupled,U_basestock,J_coupled,J_basestock)

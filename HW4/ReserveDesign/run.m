addpath('/Users/yinghanxu/Downloads/HW4/MDPtoolbox')
% Generate the species richness matrix
rand('seed',0)
M=round(rand(7,20));

% Generate the transition and reward matrix
[P, R] = mdp_example_reserve(M, 0.2);
mdp_check(P, R)
% Solve the reserve design problem
  % value iteration
  tic
%[policy1, iter1, cpu_time1] = mdp_value_iteration(P, R, 0.96, 0.001);
  toc
  % policy iteration
tic
  %[value_func, policy2, iter2, cpu_time2] = mdp_policy_iteration_modified(P, R, 0.96, 0.001);
toc

% Explore solution with initial state all sites available
%explore_solution_reserve([0 0 0 0 0 0 0],policy1,M,P,R)
%explore_solution_reserve([0 0 0 0 0 0 0],policy2,M,P,R)

% Q Learning 
tic
[Q, V, policy3, mean_discrepancy] = mdp_Q_learning(P, R, 0.96);
toc
%figure()
%xlabel('iteration time/10')
%ylabel('mean of discrepancy')
explore_solution_reserve([0 0 0 0 0 0 0],policy3,M,P,R)
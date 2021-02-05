clc;clear; 

rng('default'); % for reproducibility
sz = [1, 8000];   % the dimension of x [rows, cols]
mu = 5;         % mean of the normal distribution 
sigma = 10;      % how unstable/stationary the distribution is ()
y = normrnd(mu,sigma,sz);
y = y'; 

out = EN_CSSR(y, 5, 0.001, 'median')



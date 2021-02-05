clear;  
%% Use HCTSA 
x = 1:10; 
try 
    x = ST_Length(x); 
catch 
    hctsa_startup_path = fullfile('..', '..', '..', 'startup.m');
    run(hctsa_startup_path)
end
clear x hctsa_startup_file 

%%
rng('default'); % for reproducibility
sz = [1, 50000];   % the dimension of x [rows, cols]
mu = 5;         % mean of the normal distribution 
sigma = 10;      % how unstable/stationary the distribution is ()
y = normrnd(mu,sigma,sz);
y = y'; 

out = EN_CSSR(y, 8, 0.005, 'median'); 




clc; clear;
 
%% Create random Markov chain (or namely Epsilon machine)
rng(1); % For reproducibility
mc = mcmix(6);
figure(1);
graphplot(mc,'ColorEdges',true);

% mc = dtmc(P)
%% Simulation of Statistical Complexity 
disp('Start to simulate.......')
numSteps = 8000;  % how many times to execute the same random process.  
X = simulate(mc,numSteps); 
disp('Simulation finished. ')
indata = char(X' + 48);
% clipboard('copy',indata) 

disp('Start to CSSR.......')
% using CSSR to compute statistical complexity
for i = 1:floor(log(numSteps)/log(6))
    Cu = CSSR('123456', indata, i, 0.001)  
end 

disp('CSSR finished.')
%% Real Statistical Complexity of this random Markov Chain
Cu_real = my_statistical_complexity('123456', indata)


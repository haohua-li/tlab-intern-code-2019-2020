function out = EN_CSSR(indata, history_len, sigma_level, mode, order, tau)

%% convert to a vector 
indata = indata'; 

%% produce a discrete symbolised sequence for CSSR algorithm.
% use the median split 
if strcmp(mode,'median') && nargin == 4
    [alphabet, discrete_sequence] = median_binarise(indata); 
% use the difference split 
elseif strcmp(mode,'diff') && nargin == 4
    [alphabet, discrete_sequence] = diff_binarise(indata);
% use the multi-level split, default number of level is four. 
elseif strcmp(mode,'top') && nargin == 4
    [alphabet, discrete_sequence] = multi_level_discretiser(indata); 
elseif strcmp(mode,'top') && nargin == 5
    [alphabet, discrete_sequence] = multi_level_discretiser(indata, order); 
% use the symbolic transformation, by default,order is two and delay is one
elseif strcmp(mode,'symbolic') && nargin == 4 
    [alphabet, discrete_sequence] = symbolic_transfer_discretiser(indata);   
elseif strcmp(mode,'symbolic') && nargin == 6
    [alphabet, discrete_sequence] = symbolic_transfer_discretiser(indata, order, tau); 
% throw an error if none of discretiser matched. 
else
    error('Unrecognised discrete scheme.')
end


%% Invalid parameters ?
% Check history length 
if history_len - round(history_len) ~= 0
    error('History length must be an integer.')
end 
if history_len < 2 
    error('History length must be equal or greater 2.')
end 

% the limit of history length (return NaN)
N = size(indata,   2); 
A = size(alphabet, 2); 
history_len_limit = floor(log(N)/log(A));
% if the given history length is higher than limitation, return all NaN values 
if history_len > history_len_limit - 1 || history_len > 10
    warning('History length is too large (less than 11 and %u).', history_len_limit)
    warning('Try to use a shorter history length or provide more data.')
    % forward properties 
    out.Cmu_forward = NaN;  
    out.hmu_forward = NaN;  
    % temporal asymmetry properties 
    out.Cmu_reverse = NaN;  
    out.causal_irreversibility = NaN; 
    out.crypticity = NaN; 
    out.KLS = NaN; 
    return 
end 

% Check significant level 
if sigma_level > 1 || sigma_level < 0
    error('Significant level is out of range(should be in [0,1]).')
end 
%% Statistical Complexity  

% forward statistical complexity 
[out.Cu_forward, out.hmu_forward, forward_stationary_distri_states, forward_state_series_txt_file]= CSSR(alphabet, discrete_sequence, history_len, sigma_level); 
forward_state_series = readmatrix([forward_state_series_txt_file '_state_series.txt']); % read forward state series 
forward_state_series = forward_state_series(1, history_len-1:end); % truncate NaN values

% If CSSR can not synchronize to a state, it has a fatal errror. 
if isnan(out.Cu_forward) 
    warning('Unable to measure time-asymmetry of the current time series')
    warning('CSSR can never synchronize to a state at all.')
    warning('Use a longer history length, if possible, and to provide more data.')
    out.Cmu_reverse = NaN;  
    out.causal_irreversibility = NaN; 
    out.crypticity = NaN; 
    out.KLS = NaN; 
    return 
end 
fprintf('Forward epsilon machine has been constructed...\n')

% reverse statistical complexity 
[out.Cu_reverse, ~, reverse_stationary_distri_states , reverse_state_series_txt_file] = CSSR(alphabet,  flip(discrete_sequence), history_len, sigma_level); 
reverse_state_series = readmatrix([reverse_state_series_txt_file '_state_series.txt']);  % read reverse state series 
reverse_state_series = flip(reverse_state_series(1, history_len-1:end)); % truncate NaN values and then flip 

% If CSSR has to re-synchronize at some point, then time-asymmetry is unable to be measured. 
if size(forward_state_series, 2) ~= size(reverse_state_series, 2) || isnan(out.Cu_reverse)
    disp('Unable to measure time-asymmetry of the current time series')
    disp('The data in the state series needed to be resynchronized. ')
    warning('Try to use a longer history length.')
    out.Cmu_reverse = NaN;  
    out.causal_irreversibility = NaN; 
    out.crypticity = NaN; 
    out.DKLS = NaN; 
    return 
end 

fprintf('Reverse epsilon machine has been constructed...\n')

% construct bi-directional epsilon machine 
num_forward_state = max(forward_state_series) + 1; % matlab start from i=0 
num_reverse_state = max(reverse_state_series) + 1; 
count_bi_state = sparse(num_forward_state, num_reverse_state); 
% iterate all state pairs 
for k = 1:size(forward_state_series, 2)
    % count the occurrence of each state pair.  
    m = forward_state_series(k) + 1; % the forward time state at t = k 
    n = reverse_state_series(k) + 1; % the reverse time state at t = k 
    % occurrence of a pair of states
    if (~isnan(m) && ~isnan(n))
        count_bi_state(m, n) = count_bi_state(m, n) + 1; 
    end
end

% calculate Bi-directional Cmu 
num_state_series = sum(count_bi_state, 'all');
% probability of a state that appears in the state series 
count_bi_state = count_bi_state / num_state_series; 
% entropy of this state,  H = -sum(P(Si)*log2(P(Si)))
count_bi_state = -count_bi_state.*log2(count_bi_state);
count_bi_state(isnan(count_bi_state)) = 0;  %sets NaN values since 0*log(0) to =0
% add the entropy of this state into the Cmu of bi-direction epsilon machine 
Cu_bidirection = sum(count_bi_state, 'all');
fprintf('Bidirectional epsilon machine has been constructed...\n')

% KL divergence of (M+|M-) and (M-|M+) 
[kl_f_r1, kl_r_f1] = KL_divergence_two_epsilon_machine(... 
                         11, char(alphabet(end) + 1), alphabet(1), ...  
                         forward_stationary_distri_states, reverse_stationary_distri_states, ... 
                         [forward_state_series_txt_file '_inf(2).txt'], ... 
                         [reverse_state_series_txt_file '_inf(2).txt']); 
 
[kl_f_r2, kl_r_f2] = KL_divergence_two_epsilon_machine(... 
                         12, char(alphabet(end) + 1), alphabet(1), ...  
                         forward_stationary_distri_states, reverse_stationary_distri_states, ... 
                         [forward_state_series_txt_file '_inf(2).txt'], ... 
                         [reverse_state_series_txt_file '_inf(2).txt']); 

fprintf('KL divergence has completed...\n')

% Gradient 
gradKL_f_r = kl_f_r2 - kl_f_r1;
gradKL_r_f = kl_r_f2 - kl_r_f1; 

%% Temporal asymetry 
% causal irreversibility
out.causal_irreversibility = out.Cu_forward - out.Cu_reverse; 

% crypticity
out.crypticity = 2*Cu_bidirection - out.Cu_forward - out.Cu_reverse; 

% Rate of KL divergence between two machines M1 and M2
out.DKLS = gradKL_f_r + gradKL_r_f;

end
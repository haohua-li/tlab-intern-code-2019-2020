function [kl_p_q, kl_q_p] = KL_divergence_two_epsilon_machine(history_len, base, initial_digit, ipi_p, ipi_q, machine_p_dot, machine_q_dot)

% 
% By default, MATLAB uses 16 digits of precision. 

% perform KL divergence between two epsilon machine 
%   inspired by Aidan's forward algorithm 
%   modified by Haohua Li. 
% see <https://github.com/aidan-zec/brain_machine>
%     <https://github.com/randoruf>
%__________________________________________________________________________

%% Read dot file 
% construct a dictionary of transition edges 
trans_p = containers.Map; 
trans_q = containers.Map; 

% read the first epsilon machine 
fid  = fopen(machine_p_dot, 'r');
while ~feof(fid)
    % read the next new line....
    tline = fgetl(fid);
    % reach the end of file 
    if isempty(tline)
        break
    end 

    % edge in the epsilon machine 
    E = textscan(tline, '%d %d %c %f');
    % key of edge 
    mkey = [num2str(E{1}) '(' E{3} ')' ];
    % value of edge 
    mval = {E{2}, E{4}}; 
    % add to dictionary
    trans_p(mkey) = mval;
end
% finishing all the jobs....
fclose(fid); 

%---------------------------------
% read the second epsilon machine 
fid  = fopen(machine_q_dot, 'r');
while ~feof(fid)
    % read the next new line....
    tline = fgetl(fid); 
    % reach the end of file 
    if isempty(tline)
        break
    end 
    
    % edge in the epsilon machine 
    E = textscan(tline, '%d %d %c %f');
    % key of edge 
    mkey = [num2str(E{1}) '(' E{3} ')' ];
    % value of edge 
    mval = {E{2}, E{4}}; 
    % add into the dictionary 
    trans_q(mkey) = mval;
end
% finishing all the jobs....
fclose(fid); 

%% Generate all possible sequence 
seq = repmat(initial_digit, [1, history_len]);  % the very first sequence 
iter = 0; 

% initilise the KL divergence 
kl_p_q = 0; 
kl_q_p = 0; 

% Following by the next possible sequence. 
next_seq = next_possible_sequence(base, initial_digit, seq); 

% used for testing.... total_p and total_q should be 1 in the end.  
total_p = 0; 
total_q = 0; 

% compute the normal probability distributions of two epsilon machine 
while (~isempty(next_seq))
    % Generate the correct sequence with L (L > history length of e-machine)
    if iter ~= 0
        seq = next_seq;    
    end
    % Compute the probability of observing the sequence in this epsilon machine model 
    % disp(seq)
    %% In the p epsilon machine....
    prob_p = eps; 
    % start from each casual state, and finally add all probilities together 
    for i = 0:length(ipi_p)-1
        % start from a casual state S(i) 
        tmp = ipi_p(i+1);   % initial probability of state S(i)
        current_state = i;  % starting point/state
        
        % find out a possible transitioning path which emits symbols same as the input sequence.
        for j = 1:length(seq)
            mkey = [num2str(current_state) '(' seq(j) ')']; % the key for searching in the dictionary  
            % can the current state emit a symbol at seq[j]
            if isKey(trans_p, mkey)
                tmp_val = trans_p(mkey); % this state can emit the symbol seq[j] 
                tmp = tmp * tmp_val{2}; 
                current_state = tmp_val{1};% update the current state after transitioning.
            else
                tmp = 0; % impossible to emit the given sequence from the current state  
                break
            end 
        end
        % add this possible transitioning path to the probability of the input sequence. 
        prob_p = prob_p + tmp; 
    end
    
    % disp the probility of this sequence
    total_p = total_p + prob_p;   % total_p is supposed to be 1.0 since all possible sequence has been listed.  
    
    %% In the q epsilon machine....
    prob_q = eps; 
    for i = 0:length(ipi_q)-1
        % start from a casual state S(i) 
        tmp = ipi_q(i+1); % get the stationary probability of q. 
        current_state = i;
        % find out a possible transitioning path which emits symbols same as the input sequence.
        for j = 1:length(seq)
            mkey = [num2str(current_state) '(' seq(j) ')']; % the key for searching in the dictionary  
            % can the current state emit a symbol at seq[j]
            if isKey(trans_q, mkey)
                tmp_val = trans_q(mkey); % this state can emit the symbol seq[j] 
                tmp = tmp * tmp_val{2}; 
                current_state = tmp_val{1};% update the current state 
            else
                tmp = 0; % impossible to emit the given sequence from the current state  
                break
            end 
        end
        % add this possible transitioning path to the probability of the input sequence. 
        prob_q = prob_q + tmp; 
    end 
    
    % disp the probility of this sequence
    total_q = total_q + prob_q;   % total_p is supposed to be 1.0 since all possible sequence has been listed.  
    
    
    %% compute the KL divergence of this sequence 
    kl_p_q = kl_p_q + prob_p*log2(prob_p/prob_q);
    kl_q_p = kl_q_p + prob_q*log2(prob_q/prob_p);
        
    % THE END OF THIS SEQUENCE
    
    %% obtain the next possible sequence.
    next_seq = next_possible_sequence(base, initial_digit, seq);
    iter = iter + 1; 
end

% total_p
% total_q

% Check probabilities (should sum to 1)
% if abs(1 - total_p) > 0.0001 || abs(1 - total_q) > 0.0001  
%     errro('Unexpected error. Probability distribution can not sum up to one.')
% end







end 
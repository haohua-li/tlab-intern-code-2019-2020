%% stationary distribution of casual states 
ipi = [0.123737, ]; 

%% Read dot file 
file_name = 'tpb7b1b162_50b5_40a4_849e_cc67aaa706f4_inf(2).txt'; 

% construct a dictionary of transition edges 
trans = containers.Map; 

% open the file handle
fid  = fopen(file_name, 'r');
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
    trans(mkey) = mval;
    
    % disp(tline)
end

% finishing all the jobs....
fclose(fid); 

%% Generate all possible sequence 
% The first time to execute commands (there is not do-while loop in Matlab).
base = 'C'; 
initial_digit = 'A'; 
L = 10; 
seq = repmat(initial_digit, [1, L]);

iter = 0;

total_p = 0; % used for testing, total_p supposed to be 1.0, remove this line after finalished. 

% Following by the next possible sequence. 
num_seq = 0;
next_seq = next_possible_sequence(base, initial_digit, seq); 
while (~isempty(next_seq))
    num_seq = num_seq  + 1;
    % Generate the correct sequence with L (L > history length of e-machine)
    if iter ~= 0
        seq = next_seq;    
    end
    
    % Compute the probability of observing the sequence in this epsilon machine model 
    % disp(seq)
    % p is the probability of observing the sequence
    p = 0; 
    % start from each casual state, and finally add all probilities together 
    for i = 0:length(ipi)-1
        % start from a casual state S(i) 
        tmp = ipi(i+1); 
        current_state = i;
    
        % find out a possible transitioning path which emits symbols same as the input sequence.
        for j = 1:length(seq)
            mkey = [num2str(current_state) '(' seq(j) ')']; % the key for searching in the dictionary  
            % can the current state emit a symbol at seq[j]
            if isKey(trans, mkey)
                tmp_val = trans(mkey); % this state can emit the symbol seq[j] 
                tmp = tmp * tmp_val{2}; 
                current_state = tmp_val{1};% update the current state 
            else
                tmp = 0; % impossible to emit the given sequence from the current state  
                break
            end 
        end
    
        % add this possible transitioning path to the probability of the input sequence. 
        p = p + tmp; 
    end 
    
    % disp the probility of this sequence 
    total_p = total_p + p;   % total_p is supposed to be 1.0 since all possible sequence has been listed.  
    
    % obtain the next possible sequence.
    next_seq = next_possible_sequence(base, initial_digit, seq);
    iter = iter + 1; 
end

total_p


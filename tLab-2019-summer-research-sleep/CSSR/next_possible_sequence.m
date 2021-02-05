function Oseq = next_possible_sequence(base, initial_digit, current_sequence)
% Lazy sequence 

% INPUTS
%   base, the base of the sequence. For example, in binary representation,
%          base = 2 and initial_digit = 0 
%   initial_digit, the beginning symbol. It usually 0 or 'A'. 
%   current_sequence, a vector that represents a sequence. 
% ----------
% OUTPUT
%   Oseq, either an empty vector or a vector that represents a sequence. 
% ----------
% EXAMPLES
%   next_possible_sequence('2', '0', '000') will return '001'
%   next_possible_sequence('E', 'A', 'ABCD') will return 'ABDA'
%   ---- 
%   next_possible_sequence(10, [9 9 8]) will return [9, 9, 9] 
%   next_possible_sequence(10, [9 9 9]) will return []
% ----------
% ISSUES 
%   next_possible_sequence('10', '0', '000') will NOT WORK.
%   next_possible_sequence(10, 0, [0 0 0]) instead.
%__________________________________________________________________________

% copy the input sequence
Oseq(:) = current_sequence(:);

% % characters or numbers? 
% if ischar(base) && length(base)==1 && ... 
%    ischar(initial_digit) && length(initial_digit)==1 && ...
%    ischar(current_sequence) && base > initial_digit
%    % disp('Alphanumeric sequence...')
% elseif isnumeric(base) && length(base)==1 && ... 
%    isnumeric(initial_digit) && length(initial_digit)==1 && ...
%    isnumeric(current_sequence) && base > initial_digit
%    % disp('Numeric sequence...')
% else
%     error('Illegal input parameters.')
% end 


% add 1 to current_sequence[0] to 
N = length(current_sequence);
Oseq(N) = Oseq(N) + 1; 

% loop the whole sequence and find any digit that excesses the given base. 
for i = N:-1:2
    if (Oseq(i) >= base)
        Oseq(i-1) = Oseq(i-1) + 1; % carry 
        Oseq(i)   = initial_digit; % clear
    end
end

% check whether this sequence is valid by looking at the leading symbol.
if Oseq(1) >= base 
    Oseq = [];
end 
 

end 
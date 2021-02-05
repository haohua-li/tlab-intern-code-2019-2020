A = 4; 
B = 3; 
for i = 1:length(idx)
    if idx(i) == A
        idx(i) = B; 
    elseif idx(i) == B
        idx(i) = A;
    end 
end 

tmp = C(A, :); 
C(A, :) = C(B, :); 
C(B, :) = tmp; 
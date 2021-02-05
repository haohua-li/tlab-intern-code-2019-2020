function [Cu, hu, stationary_distri_states, tmp_file] = CSSR(alphabet, indata, history_len, sigma_level)
%__________________________________________________________________________
% EN_CSSR
%  By converting a real number time series (e.g. EEG, ECoG, LFP) into a 
%  sequence of symbols, CSSR is able to extract features from real-world 
%  neuroscience data. One of the most important features is statistical
%  complexity. See Ref[1,2]. 
%--------------------------------------------------------------------------
%---INPUTS
% indata, a real number time series.
% history_len, the maximum history length used by CSSR algorithm.  
% sigma_level, the significance level used by CSSR algorithm. 
% (order), optinal, used to specify the size of oridinal pattern      
% (tau), optional, used to specify the temporal distance between samples.
%---OUTPUT
% Cu,    statistical complexity. 
%--------------------------------------------------------------------------
% EXAMPLE USAGES
%  EN_CSSR(x,L,S,'median'), use meidan binarisation 
%  EN_CSSR(x,L,S,'diff'),   use difference binarisation 
%  EN_CSSR(x,L,S,'top'),    use multip level split to convert time series
%                           to a sequence. By default, there are 4 levels,
%                           which are 0~25%, 25~50%, 50~75%, 75~100%. 
%  EN_CSSR(x,L,S,'top',5),  specify the number of symbols as 5 (5 levels).
%  EN_CSSR(x,L,S,'symbolic'), use symbolic transformation. By default,
%                             order is 2 and tau is 1. In this case, there
%                             are (order+1)!=6 ordinal patterns/symbols.
%                             When tau is 1, all samples in ordinal
%                             patterns are successive. 
%  EN_CSSR(x,L,S,'symbolic',3,2), specify the order of oridinal pattern as 
%                                  as 3 and delay as 2. 
%--------------------------------------------------------------------------
% REFERENCE
% [1] C. R. Shalizi and K. L. Shalizi, 'Blind Construction of Optimal Nonlinear Recursive Predictors for Discrete Sequences', arXiv:cs/0406011, Jun. 2004.
% [2] R. N. Muñoz et al., 'Distinguishing states of conscious arousal using statistical complexity', arXiv:1905.13173 [physics, q-bio], Aug. 2019.
%--------------------------------------------------------------------------
% CSSR source code <http://bactra.org/CSSR/> 
% CSSR is an algorithm developed by Cosma Shalizi and Kristina Klinkner. 
%--------------------------------------------------------------------------
% This Matlab script was written by Haohua Li, 2020. 
% Visit my github <https://github.com/randoruf>
%--------------------------------------------------------------------------
% This function is free software: you can redistribute it and/or modify it under
% the terms of the GNU General Public License as published by the Free Software
% Foundation, either version 3 of the License, or (at your option) any later
% version.
%
% This program is distributed in the hope that it will be useful, but WITHOUT
% ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
% FOR A PARTICULAR PURPOSE. See the GNU General Public License for more
% details.
%
% You should have received a copy of the GNU General Public License along with
% this program. If not, see <http://www.gnu.org/licenses/>.
%__________________________________________________________________________

% CSSR parameters (alphabet and input sequence)
if ~ischar(alphabet)
    error('Alphabet must be a character array.')
end
if size(alphabet, 1) ~= 1 
    error('Alphabet must be a 1-dimensional string.')
end
if ~ischar(indata)
    error('Input data must be a character array.')
end 
if size(indata, 1) ~= 1 
    error('Input data sequence must be a 1-dimensional string. ')
end 
 
% Invoke CSSR algorithm. 
tmp_file = tempname;
fprintf('Writing temporary state series text file \n%s...\n', tmp_file); 

try 
    [Cu, hu, stationary_distri_states] = CSSR_core(tmp_file, alphabet, indata, num2str(history_len), num2str(sigma_level)); 
catch  
    Cu = NaN; 
    hu = NaN; 
    stationary_distri_states = NaN; 
end 


end
%=========================================================================
% CSSR Toolbox Installation for HCTSA 
%   HCTSA project       - https://github.com/benfulcher/hctsa
%   CSSR source code    - http://bactra.org/CSSR/ 
%   TsuchiyaLab(tlab)   - https://sites.google.com/monash.edu/tlab/home 
% ________________________________________________________________________
% Compilations had been tested in various conditions. 
%   - gcc 7.4, Ubuntu Linux 
%   - CLang 11.0, macOS
%   - Microsoft Visual C++ , MSVC 19.23.28106.4, Windows 
%_________________________________________________________________________
% REFERNCE: 
%   Fulcher, B. D. & Jones, N. S. hctsa: A Computational Framework for Automated Time-Series Phenotyping Using Massive Feature Extraction. Cell Systems 5, 527-531.e3 (2017).
%   Fulcher, B. D., Little, M. A. & Jones, N. S. Highly comparative time-series analysis: the empirical structure of time series and their methods. J. R. Soc. Interface 10, 20130048 (2013).
%   Shalizi, C. R. & Shalizi, K. L. Blind Construction of Optimal Nonlinear Recursive Predictors for Discrete Sequences. arXiv:cs/0406011 (2004).
% _________________________________________________________________________
% This script was written by Haohua Li on 19/12/2019. 
% Visit my github <https://github.com/randoruf>
%--------------------------------------------------------------------------
%__________________________________________________________________________

% change directory to the path of current script 
cd(fileparts(which(mfilename)));

% CSSR home directory 
mfile_name          = mfilename('fullpath');
[cssr_path,~,~]  = fileparts(mfile_name);

% check mex version, and specify C++ standard as C++11/C++14
cc_opt_prefix = 'COMPFLAGS=''$COMPFLAGS'; 
myCCompiler = mex.getCompilerConfigurations('C++'); 
if strcmp(myCCompiler.Manufacturer, 'Microsoft')
    cc_opt = strcat(cc_opt_prefix, ' /Wall /std:c++14'''); 
elseif strcmp(myCCompiler.Manufacturer, 'Apple')
    cc_opt = strcat(cc_opt_prefix, ' -Wall -std:c++11'''); 
elseif strcmp(myCCompiler.Manufacturer, 'GNU')
    cc_opt = strcat(cc_opt_prefix, ' -Wall -std:c++11'''); 
else 
    error('CSSR: the C/C++ compiler which Matlab is using does not support. Check the compiler version with ''mex -setup C++''')
end 

% Create objects files (without linking) 
eval(['mex -c -outdir cpp ' cc_opt ' ' fullfile(cssr_path, 'cpp','Hash.cpp')])
eval(['mex -c -outdir cpp ' cc_opt ' ' fullfile(cssr_path, 'cpp','States.cpp')])
eval(['mex -c -outdir cpp ' cc_opt ' ' fullfile(cssr_path, 'cpp','AllStates.cpp')])
eval(['mex -c -outdir cpp ' cc_opt ' ' fullfile(cssr_path, 'cpp','ParseTree.cpp')])
eval(['mex -c -outdir cpp ' cc_opt ' ' fullfile(cssr_path, 'cpp','G_Array.cpp')])
eval(['mex -c -outdir cpp ' cc_opt ' ' fullfile(cssr_path, 'cpp','Hash2.cpp')])
eval(['mex -c -outdir cpp ' cc_opt ' ' fullfile(cssr_path, 'cpp','Machine.cpp')])
eval(['mex -c -outdir cpp ' cc_opt ' ' fullfile(cssr_path, 'cpp','TransTable.cpp')])
eval(['mex -c -outdir cpp ' cc_opt ' ' fullfile(cssr_path, 'cpp','Test.cpp')])

% link object files to a single program : CSSR 
if ispc 
   eval('mex -output CSSR_core cpp/Main.cpp cpp/hash.obj cpp/states.obj cpp/allStates.obj cpp/parsetree.obj cpp/g_array.obj cpp/hash2.obj cpp/machine.obj cpp/transtable.obj cpp/test.obj') 
elseif isunix || ismac 
   eval('mex -output CSSR_core cpp/Main.cpp cpp/hash.o cpp/states.o cpp/allStates.o cpp/parsetree.o cpp/g_array.o cpp/hash2.o cpp/machine.o cpp/transtable.o cpp/test.o') 
else 
   error('Platform not supported. (Only for Liunx, macOS and Windows)')
end 



% inform the user that CSSR has been successfully generated. 
disp('CSSR has been successfully compiled.')


/////////////////////////////////////////////////////////////////////////////
//Title:	Main.cpp (for program CSSR)
//Author:	Kristina Klinkner
//Date:		July 23, 2003
//Description:	Creates separate causal states for each history of data
//		with a singular probability distribution.  History length
//		increases incrementally until cutoff point is reached.  Then
//              removes transient states, determinizes remaining states, and
//              calculates various metrics for the resulting state machine.
//              Outputs a file of states, a file of state sequences, a dot
//              file, and an information file with the metrics.
//
/////////////////////////////////////////////////////////////////////////////

/////////////////////////////////////////////////////////////////////////////
//
//    Copyright (C) 2002 Kristina Klinkner
//    This file is part of CSSR
//
//    CSSR is free software; you can redistribute it and/or modify
//    it under the terms of the GNU General Public License as published by
//    the Free Software Foundation; either version 2 of the License, or
//    (at your option) any later version.
//
//    CSSR is distributed in the hope that it will be useful,
//    but WITHOUT ANY WARRANTY; without even the implied warranty of
//    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//    GNU General Public License for more details.
//
//    You should have received a copy of the GNU General Public License
//    along with CSSR; if not, write to the Free Software
//    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
//
//////////////////////////////////////////////////////////////////////////////


#include "Main.h"


/////////////////////////////////////////////////////////////////////////////
void mexFunction(int nlhs, mxArray* plhs[], int nrhs, const mxArray* prhs[]) {
  // Check the number of inputs (on the right hand side )
  if (nrhs != 5) {
    mexErrMsgIdAndTxt("MATLAB:CSSR:nargin", "CSSR requires five arguments.");
  }
  // check the number of outouts (on the left hand side )
  if (nlhs > 3) { 
    mexErrMsgIdAndTxt( "MATLAB:CSSR:nargout", "Too many outputs!");
  }

  // convert Matlab arguments to C arguments.
  int argc    = nrhs;  
  char **argv = new char*[nrhs];    // an array that store pointer (char*)
  for (int i = 0; i < nrhs ; i++){
    argv[i] = mxArrayToString(prhs[i]); 
    // fail to duplicate string. 
    if (argv[i] == NULL){
      mexErrMsgIdAndTxt("CSSR:ConvertString", "Could not convert string data.");
    }
  }

  ///////////////////////////////////////////////////
  // CSSR algorithm starting point
  int max_length;
  HashTable2 *alphaHash;
  bool isMulti = false;
  bool stateRemoved = false; //dummy
  Machine *machine;
  double sigLevel = SIGLEVEL;
  // bool isSigLevel = false;
  bool isChi = false;
  char *alphabet_vector, *data_vector;  

  /* ./CSSR      alphabet_file    data_file    L         S      
     argv[0]    argv[1]          argv[2]      argv[3]   argv[4]   
        argv[0] unique filename for temporary file.
        argv[1] is alphabet vector.  
        argv[2] is data sequence vector. 
        argv[3] is maximum length L 
        argv[4] is the significance level
  */ 

  // check if the number arguments is valid.
  if (argc != 5) {
    PrintError();
  }
  
  //set the history length (L >= 1)
  max_length = atoi(argv[3]);
  if (max_length < 1){
    mexErrMsgTxt("History length must be positive.");
  }  

  // set the signifacent level (0.0 ~ 1.0)
  sigLevel = std::atof(argv[4]); 
  if (isnan(sigLevel) || sigLevel > 1 || sigLevel < 0) {
    mexErrMsgTxt("Significance level must be in range of [0, 1].");
	}
  
  // std::cout << "Significance level set to " << sigLevel << "." << std::endl;

  //create parse tree to store all strings in data
  ParseTree parsetree(max_length);

  // Multi-line mode is always off. read in data and alphabet from input vectors. 
  // argv[1] and argv[2] are arrays of char type. 
  alphabet_vector = argv[1]; 
  data_vector = argv[2]; 
  parsetree.ReadInput(alphabet_vector, data_vector);
  //enter data in tree
  parsetree.FillTree();

  //make hash table of alpha symbols and indices
  alphaHash = parsetree.MakeAlphaHash();

  //create array of states
  AllStates allstates(parsetree.getAlphaSize(), sigLevel, isChi);

  //calculate frequency of occurence of symbols
  allstates.InitialFrequencies(parsetree);

  //check all possible strings up to max 
  //length and compare distributions
  for (int k = 1; k <= max_length; k++) {
    allstates.CalcNewDist(k, parsetree);
  }

  //remove shorter strings
  stateRemoved = allstates.DestroyShortHists(max_length, parsetree);

  //remove all non-recurring states
  allstates.CheckConnComponents(parsetree);

  //check futures longer than 1,
  //by using determinism of states
  allstates.Determinize(parsetree);

  //remove all non-recurring states (again, since there may be new ones)
  allstates.CheckConnComponents(parsetree);

  //store transitions from state to state
  allstates.StoreTransitions(parsetree.getMaxLength(), parsetree.getAlpha());

  //calculate distribution/frequency of states.
  //  to write state series to a text file called "state_series.txt" 
  char *output_name = new char[strlen(argv[0]) + 23 + END_STRING] ; 
  sprintf(output_name, "%s_state_series.txt", argv[0]);
  allstates.GetStateDistsMulti(parsetree, output_name, alphaHash, isMulti);

  //calculate information values
  machine = new Machine(&allstates);
  machine->CalcRelEnt(parsetree, alphaHash, isMulti);
  machine->CalcRelEntRate(parsetree, alphaHash, isMulti);
  machine->CalcCmu();
  machine->CalcEntRate();
  machine->CalcVariation(parsetree, alphaHash, isMulti);

  //print out states
  sprintf(output_name, "%s_results.txt", argv[0]);
  allstates.PrintOut(output_name, parsetree.getAlpha());
  //print out machine and calculations
  sprintf(output_name, "%s_info.txt", argv[0]);
  machine->PrintOut(output_name, alphabet_vector, argv[0], max_length, sigLevel, isMulti, isChi, parsetree.getAlphaSize());
  sprintf(output_name, "%s_inf.dot", argv[0]);
  machine->PrintDot(output_name, parsetree.getAlpha());
  sprintf(output_name, "%s_inf(2).txt", argv[0]);
  machine->PrintDot2(output_name, parsetree.getAlpha());
  
  // clean up to avoid memory leak.
  delete machine;

  //////////////////////////////////////////////////////////////////////////////////////////
  // MATLAB outputs 

  int num_inferred_states = allstates.getArraySize();
  // allocate memory space for output, statistical complexity 
  plhs[0] = mxCreateNumericMatrix(1, 1, mxDOUBLE_CLASS, mxREAL); // memory-allocation 
  plhs[1] = mxCreateNumericMatrix(1, 1, mxDOUBLE_CLASS, mxREAL); 
  plhs[2] = mxCreateNumericMatrix(1, num_inferred_states, mxDOUBLE_CLASS, mxREAL); 

  // write results to Matlab parameters on the left hand side. 
  double* Cmu = (double*) mxGetData(plhs[0]);  // acquire the pointer 
  double* hmu = (double*) mxGetData(plhs[1]); 
  *Cmu = machine->getCMu();
  *hmu = machine->getEntRate(); 

  // write the probability distribution of causal states. 
  double* stationary_distribution_causal_state = (double*) mxGetData(plhs[2]); 
  for (int i = 0; i < num_inferred_states; i++){
    stationary_distribution_causal_state[i] = allstates.getState(i)->getFrequency(); 
  }

  // clean up to avoid memory leak 
  for (int i = 0; i < nrhs; i++){
    // free space created by MATLAB.
    mxFree(argv[i]);    
  } 
  // free space created by C++ (not MATLAB). 
  delete[] argv;   


  return ;
}
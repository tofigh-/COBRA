
# COBRA: Feature selection Toolkit

To run this program you can follow these steps: first need to install mi library and Yalmip in MATLAB. 

1- Make sure you have mutual information toolbox installed in your MATLAB. If not, first download it from http://penglab.janelia.org/proj/mRMR/#matlab 

 and follow its instruction to install it.
 
2- Make sure you have Yalmip tool box installed on your MATLAB. If not, download it from http://users.isy.liu.se/johanl/yalmip/pmwiki.php?n=Main.Download and follow  its installation instruction.

3- Make sure (the last make sure ;)) that you have SDPNAL solver installed on your matlab. If not, download it from: http://www.math.nus.edu.sg/~mattohkc/SDPNAL.html and install it.

4- Done! run the demo_COBRA.m to see how COBRA works.

PS: This final version of COBRA is a bit different than what discussed in the paper (A Semidefinite Programming Based Search
Strategy for Feature Selection with Mutual Information Measure). I found it a bit easier and faster to work with. In this variation, the number of features, i.e. P do not need to be passed as an input to COBRA. Instead, a parameter called beta which is a penalization factor should be set. It somehow controls the ratio between sum of class-dependent terms (I(X_i;C)) and inter-feature mutual information terms ( I(X_i;X_j) ). If not given, the program takes care of it and sets it to a value such that the ratio between sum of class-dependent terms (I(X_i;C)) and inter-feature mutual information terms ( I(X_i;X_j) ) becomes 1.



function [Q]= Q_const(X,C,mrmr)
%{
 It is a Q matrix constructor and constructs a Q matrix as in eq(22) of "A Semidefinite Programming Based Search
Strategy for Feature Selection with Mutual Information Measure ,IEEE Trans. on pami".
 Inputs:
 C: is the class label
 X: is the (ob x N) dimension data matrix containg N features (at each col)
 and ob number of observations (data). Missing values should be denoted by
 NaN in X matrix.
 mrmr: if it is positive, mRMR mutlain ofmraiton matrix is calculated whereoff diagonal elemetns are I(X_i;X_j) otherwise JMI
 is used where offdiags are I(X_i;X_j;C)

 %output: [Q] which is the mutual information matrix with diag elements
 equal to I(X_i;C) and offdiag equal to I(X_i;_Xj)



Example1:
X=randn(20,10);
C=sign(randi([0,1],20,1)-.5)
Q = Q_const(X,C);

%}
%Uncomment the following lines for mex file generation./
coder.extrinsic('mutualinfo','condmutualinfo','waitbar','delete');

N = size(X,2);
ob = size(X,1);

Q = double(zeros(N,N));
if(mrmr)  
h_wait = waitbar(0,'Please wait...');
        
       for i = 1 : N
            ind_notNan = (~isnan(X(:,i)));
            Q(i,i) = 2*mutualinfo(X(ind_notNan,i),C(ind_notNan));
            
            for j = (i+1) : N
                  ind_notNan_intersect = find(~isnan(X(:,j)) & ind_notNan) ;
                  
                  Q(i,j) = -1*mutualinfo(X(ind_notNan_intersect,i),X(ind_notNan_intersect,j));
                  Q(j,i)=Q(i,j);
            end
            
            waitbar(i/N)
        
        end
  delete(h_wait);
else
    h_wait = waitbar(0,'Please wait...');
        
       for i = 1 : N
            ind_notNan = (~isnan(X(:,i)));
            Q(i,i) =  2*mutualinfo(X(ind_notNan,i),C(ind_notNan));
            
            for j = (i+1) : N
                  ind_notNan_intersect = (~isnan(X(:,j)) & ind_notNan) ;
                  Q(i,j) =  condmutualinfo(X(ind_notNan_intersect,i),C(ind_notNan_intersect),X(ind_notNan_intersect,j));
                  Q(i,j)= Q(i,j) -.5*Q(i,i) ;
                  Q(j,i)=Q(i,j);
            end
            
            waitbar(i/N)
        
        end
  delete(h_wait);
   
    
end
        
        

%To generate C code from this function
%cfg = coder.config('mex');
%cfg.DynamicMemoryAllocation = 'AllVariableSizeArrays';
%codegen -config cfg Q_const.m -args {coder.typeof(double(0), [Inf Inf]), coder.typeof(double(0), [Inf 1]), 1 }


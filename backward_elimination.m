function S=backward_elimination(beta,Q)
%USed for backward eliminiation feature selection.
%Inputs:
% [Q] : mutual information matrix which can be constructed from data with Q_const.m 
% [beta]: penalization factor between dependence (I(X_i;X_j))terms and class dependent
% (I(X_i;C)) if not given set to  |sum(diag(Q))/sum(sum(Q)) *N|
% terms
% [p_max]: max number of features. Default p_max= N.
%
%Output: [S] selected features which are ranked from best to worst
%

N =  size(Q,1);
p_max=0;

if(nargin==1)
   ff=sum(diag(Q));
    qq=abs((sum(sum(Q))-ff)/(N^2));
    ff=ff/N;
    
    beta= qq/(qq+ff);
end

Q=Q.*toeplitz([beta;ones(N-1,1)*(1-beta)]) ;
ind = 1 : N;

S_el = zeros(N,1);



for j = N : -1 : 1
    temp=inf;
    temp_ind=1;
    for ll = 1 : length(ind)
        ind_temp = [ ind(ll) ; ind(ind ~= ind(ll))' ];
        temp_sum = sum(Q(ind_temp,ind(ll)).*[1;ones(length(ind_temp)-1,1)/(j-1)]);
        
        
        if(temp_sum<temp)
            temp_ind =ind(ll);
            temp=temp_sum;
        end
        
    end
    S_el(j) = temp_ind;
    ind=ind(ind~=temp_ind);
    
end
S= S_el;
 
%To generate C code from this function
%cfg = coder.config('mex');
%cfg.DynamicMemoryAllocation = 'AllVariableSizeArrays';
%codegen -config cfg backward_elimination.m -args {1,coder.typeof(double(0), [Inf Inf],2)}

function S=forward_selection(beta,Q)
%USed for forward feature selection.
%Inputs:
% [Q] : mutual information matrix which can be constructed from data with Q_const.m 
% [beta]: penalization factor between dependence (I(X_i;X_j))terms and class dependent
% (I(X_i;C)) if not given set to  |sum(diag(Q))/sum(sum(Q)) *N|
% terms
% 
%Output: [S] selected features which are ranked from best to worst
%

N =  size(Q,1);

if(nargin==1)
   ff=sum(diag(Q));
    qq=abs((sum(sum(Q))-ff)/(N^2));
    ff=ff/N;
    
    beta= qq/(qq+ff);
end

Q=Q.*toeplitz([beta;ones(N-1,1)*(1-beta)]) ;
   ind = 1 : N;
   S= zeros(N,1);
   [~, S(1)] = max(diag(Q));
 
   ind =ind(ind~=S(1));
   for j = 2 : N
          temp=-inf;
          temp_ind=1;
          for ll = 1 : length(ind)  
              ind_temp = [ind(ll); S(1:(j-1))];
              temp_sum = sum(Q(ind_temp,ind(ll)).*[1;ones(length(ind_temp)-1,1)/(j-1)]);
      
              
              if(temp_sum>temp)
                  temp_ind =ind(ll);
                  temp=temp_sum;
              end
              
          end
           S(j) = temp_ind;
           ind=ind(ind~=S(j));
          
   end
   %Togenerate C code from this function
%cfg = coder.config('mex');
%cfg.DynamicMemoryAllocation = 'AllVariableSizeArrays';
%codegen -config cfg forward_selection.m -args {1,coder.typeof(double(0), [Inf Inf],2)}
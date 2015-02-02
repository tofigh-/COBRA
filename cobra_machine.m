function [S U ss] = cobra_machine(Q,beta)
% The sdp-solver part of the algorithm. It uses sdpnal solver to solve the
% (SDP) equation.
%Inpute: The input matrix Q can be constructed with Q_const function 
%and beta is a positive constant considered as the penalization factor of the dependence (I(X_i,X_j) or correlation) terms i.e., the the
%diag(Q)- beta* (offdiag(Q))


%Output: 
  %U : the N+1xN+1 solution of the (SDP)
  %S : A vector containing the id of the selected features 
  N = size(Q,1);
if(nargin<2)
    ff=sum(diag(Q));
    qq = abs((sum(sum(Q))-ff));
    
    beta= ff/(qq);
end
 beta_prin=(1-exp(-beta))/(1+exp(-beta));
 Q=Q.*toeplitz([1;ones(N-1,1)*(beta)]) ;
 u = sum(Q,1);


%Q=Q-diag(diag(Q)); can be done should not change the final result
R_n = [0 u;u' Q];
clear Q
tic
ops = sdpsettings('solver','sdpnal','cachesolver',1,'verbos',0);
%ops_lr = sdpsettings('solver','sdplr','sdplr.feastol',1e-03,'sdplr.limit',1000,'verbos',0);

X = sdpvar(N+1,N+1);
obj = sum(sum(R_n.*X));
warning('off','YALMIP:nonstrict')
F = set(X>0) + set(diag(X)==1); %  last one can be trace(X)==N+1
%F = set(X>0) + set(diag(X)==1); %  last one can be trace(X)==N+1
[Fd,objd,~,~] =dualize(F,-obj);
out_sdpnal = solvesdp(Fd,-objd,ops);
toc

U=double(X);
uu = sign(U(1,:));
ss=find(uu==uu(1))-1;
ss=ss(2:end);
if(isempty(ss))
    S=[];
    return
end
S = randomized_rounding(U,R_n);
disp(['Number of selected features: ' num2str(length(S))])

disp(['beta = ' num2str(beta)])


function [S] = randomized_rounding(U,Q)
T=1000;
N = size(U,1);


[ss, vv, ~] = svd(U);
s_var = ss*vv^.5;

   u=s_var*randn(N,T);

    x_hat =sign(u);
    x_hat =x_hat.*repmat(x_hat(1,:),N,1);
binaryU = zeros(T,1);
for i =  1 : T
    tp=x_hat(:,i);
    binaryU (i)= tp'* Q * tp;
end


[val, ind] = max(binaryU);
disp(['val = ' num2str(val)])
S = find(x_hat(2:end,ind)==1); 



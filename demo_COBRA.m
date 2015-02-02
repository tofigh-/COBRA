%first we need to load the dataset
dbw= dlmread('dbw_filter_500.data',',');
%extract class labels
C=dbw(:,1);
%extract variables
X=dbw(:,2:501);
%construct the mutual information matrix mRMR and JMI
%%
Q_mrmr=Q_const(X,C,1);

Q_jmi=Q_const(X,C,0);
%%
%Using forward and backward selection over Q_mrmr and Q_jmi, when first
%argument is -1, beta is automatically calculated
S_fmrmr=forward_selection(Q_mrmr);
S_bmrmr=backward_elimination(Q_mrmr);
%%
S_fjmi=forward_selection(Q_jmi);
S_bjmi=backward_elimination(Q_jmi);
%% selecting mRMR features with COBRA with automatic beta calculation
[S_mcobra_auto,~,ss]=cobra_machine(Q_mrmr);
%%
%% selecting mRMR features with COBRA with given beta
[S_mcobra,~,ss]=cobra_machine(Q_mrmr,.02);
%% selecting JMI features with COBRA
[S_jmicobra,~,ss]=cobra_machine(Q_jmi);
%%
%train a decision tree to evaluate the quality of the features
acc=0;
X_tr=X(:,S_mcobra(1:100));
%Leave-one-out cross-validation
for i = 1 : size(X_tr,1)
    ind=1:size(X_tr,1);
    ind=ind(ind~=i);
tree = fitctree(X_tr(ind,:),C(ind));
label = predict(tree,X_tr(i,:) );
 acc =( label==C(i) ) + acc;
end
acc=acc/ size(X_tr,1)



function [sensitivity,specificity,accuracy,ppv,npv,f1score,auc,time,best_tperf,num_epochs] = resultsnn(t,outputs,tr)
[~,cm,~,~] = confusion(t(:,tr.testInd),outputs(:,tr.testInd));

cm = cm';

tp = zeros(1,size(cm,1)-1);%true positives for each target class
tn = zeros(1,size(cm,1)-1);%true negatives for each target class
fp = zeros(1,size(cm,1)-1);%false positives for each target class
fn = zeros(1,size(cm,1)-1);%false negatives for each target class

for k = 1:1:size(cm,1)%calculating true positives for each classes
    tp(k) = cm(k,k);
end
for k = 1:1:size(cm,1)%calculating true negatives for each classes
    aux = cm;
    aux(:,k) = [];
    aux(k,:) = [];
    tn(k) = sum(sum(aux));
end
for k = 1:1:size(cm,1)
    aux = cm(k,:);
    aux(k) = [];
    fp(k) = sum(aux);
end
for k = 1:1:size(cm,1)
    aux = cm(:,k);
    aux(k) = [];
    fn(k) = sum(aux);
end

[tpr,fpr,~] = roc(t(:,tr.testInd),outputs(:,tr.testInd));

sensitivity = tp./(tp+fn);
specificity = tn./(tn+fp);
accuracy = (tp+tn)./(tp+tn+fp+fn);
ppv = tp./(tp+fp);
npv = tn./(tn+fn);
f1score = (2*tp)./(2*tp + fp + fn);
auc = trapz(fpr{1,2},tpr{1,2});
time = tr.time(end);
best_tperf = tr.best_tperf;
num_epochs = tr.num_epochs;
end


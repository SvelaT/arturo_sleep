disp('-------------------------------------------------------');
disp('-------------------------------------------------------');
disp('Results Summary:');
disp(['Accuracy: ' num2percent(min(min(Total_Accuracies)),2) ' Min,' num2percent(mean(mean(Total_Accuracies)),2) ' Avg, ' num2percent(max(max(Total_Accuracies)),2) ' Max,' num2percent(std(reshape(Total_Accuracies,[],1)),2) 'Std']);
disp(['Sensitivity: ' num2percent(min(min(Total_Sensitivities)),2) ' Min, ' num2percent(mean(mean(Total_Sensitivities)),2) ' Avg, ' num2percent(max(max(Total_Sensitivities)),2) ' Max,' num2percent(std(reshape(Total_Sensitivities,[],1)),2) 'Std']);
disp(['Specificity: ' num2percent(min(min(Total_Specificities)),2) ' Min, ' num2percent(mean(mean(Total_Specificities)),2) ' Avg, ' num2percent(max(max(Total_Specificities)),2) ' Max,' num2percent(std(reshape(Total_Specificities,[],1)),2) 'Std']);
disp(['Score: ' num2percent(min(min(Total_Scores)),2) ' Min, ' num2percent(mean(mean(Total_Scores)),2) ' Avg, ' num2percent(max(max(Total_Scores)),2) ' Max,' num2percent(std(reshape(Total_Scores,[],1)),2) 'Std']);
disp(['AUC: '  num2percent(min(min(Total_Aucs)),2) ' Min, ' num2percent(mean(mean(Total_Aucs)),2) ' Avg, ' num2percent(max(max(Total_Aucs)),2) ' Max,' num2percent(std(reshape(Total_Aucs,[],1)),2) 'Std']);
disp(['Training Time: ' num2str(sum(sum(Total_Times))) ' s Total, ' num2str(mean(mean(Total_Times))) ' s Avg']);
disp(['Number of Training Epochs: ' num2str(mean(mean(Total_Epochs))) ' Avg']);
disp('-------------------------------------------------------');

[arrayMax,indexesX] = max(Total_Aucs);
[value,indexY]  = max(arrayMax);

indexX = indexesX(indexY);

disp('Best AUC Results:');
disp(['Acc: ' num2str(round(100*Total_Accuracies(indexX,indexY),2)) '%, Sen: ' num2str(round(100*Total_Sensitivities(indexX,indexY),2)) '%, Spe: ' num2str(round(100*Total_Specificities(indexX,indexY),2)) '%, AUC: ' num2str(round(100*Total_Aucs(indexX,indexY),2)) ', Sco:' num2str(round(100*Total_Scores(indexX,indexY),2)) '%']);
disp('-------------------------------------------------------');

[arrayMax,indexesX] = max(Total_Scores);
[value,indexY]  = max(arrayMax);

indexX = indexesX(indexY);

disp('Best Score Results:');
disp(['Acc: ' num2percent(Total_Accuracies(indexX,indexY),2) ', Sen: ' num2percent(Total_Sensitivities(indexX,indexY),2) ', Spe: ' num2percent(Total_Specificities(indexX,indexY),2) ', AUC: ' num2percent(Total_Aucs(indexX,indexY),2) ', Sco:' num2percent(Total_Scores(indexX,indexY),2)]);
disp('-------------------------------------------------------');

[arrayMax,indexesX] = max(Total_Accuracies);
[value,indexY]  = max(arrayMax);

indexX = indexesX(indexY);

disp('Best Accuracy Results:');
disp(['Acc: ' num2percent(Total_Accuracies(indexX,indexY),2) ', Sen: ' num2percent(Total_Sensitivities(indexX,indexY),2) ', Spe: ' num2percent(Total_Specificities(indexX,indexY),2) ', AUC: ' num2percent(Total_Aucs(indexX,indexY),2) ', Sco:' num2percent(Total_Scores(indexX,indexY),2)]);
disp('-------------------------------------------------------');

[arrayMax,indexesX] = max(Total_Sensitivities);
[value,indexY]  = max(arrayMax);

indexX = indexesX(indexY);

disp('Best Sensitivity Results:');
disp(['Acc: ' num2percent(Total_Accuracies(indexX,indexY),2) ', Sen: ' num2percent(Total_Sensitivities(indexX,indexY),2) ', Spe: ' num2percent(Total_Specificities(indexX,indexY),2) ', AUC: ' num2percent(Total_Aucs(indexX,indexY),2) ', Sco:' num2percent(Total_Scores(indexX,indexY),2)]);
disp('-------------------------------------------------------');

[arrayMax,indexesX] = max(Total_Specificities);
[value,indexY]  = max(arrayMax);

indexX = indexesX(indexY);

disp('Best Specificity Results:');
disp(['Acc: ' num2percent(Total_Accuracies(indexX,indexY),2) ', Sen: ' num2percent(Total_Sensitivities(indexX,indexY),2) ', Spe: ' num2percent(Total_Specificities(indexX,indexY),2) ', AUC: ' num2percent(Total_Aucs(indexX,indexY),2) ', Sco:' num2percent(Total_Scores(indexX,indexY),2)]);

f1 = figure;
plottrainstate(Best_TR);
title('Train State plot for the best AUC Network');
f2 = figure;
plotroc(Best_Targets(2,Best_TR.testInd),Best_Outputs(2,Best_TR.testInd));
title('ROC Chart for the best AUC Network');
f3 = figure;
plotconfusion(Best_Targets(:,Best_TR.testInd),Best_Outputs(:,Best_TR.testInd));
title('Confusion Matrix for the best AUC Network');
f4 = figure;
plotperform(Best_TR);
title('Performance plot for the best AUC Network');
Errors = Best_Targets - Best_Outputs;
f5 = figure;
ploterrhist(Errors);
title('Error Histogram for the best AUC Network');

uniqueFolds = [];
uniqueFoldsNumResults = [];
uniqueFoldsResultsAUC = [];
uniqueFoldsResultsSen = [];
uniqueFoldsResultsSpe = [];
uniqueFoldsResultsAcc = [];
uniqueFoldsResultsSco = [];


for i = 1:1:size(crossvals,1)
    for j = 1:1:size(crossvals,2)
        [contains,index] = containsArray(uniqueFolds,crossvals{i,j});
        if ~contains
            index = size(uniqueFolds,1)+1;
            uniqueFolds{index,1} = crossvals{i,j};
            uniqueFoldsNumResults(index) = 0;
        end
        uniqueFoldsResultsAUC(index,uniqueFoldsNumResults(index)+1) = Total_Aucs(i,j);
        uniqueFoldsResultsSen(index,uniqueFoldsNumResults(index)+1) = Total_Sensitivities(i,j);
        uniqueFoldsResultsSpe(index,uniqueFoldsNumResults(index)+1) = Total_Specificities(i,j);
        uniqueFoldsResultsAcc(index,uniqueFoldsNumResults(index)+1) = Total_Accuracies(i,j);
        uniqueFoldsResultsSco(index,uniqueFoldsNumResults(index)+1) = Total_Scores(i,j);
        uniqueFoldsNumResults(index) = uniqueFoldsNumResults(index)+1;
    end
end

aux = sort(uniqueFoldsResultsAUC','descend');
AUCFolds(1,:) = diag(aux(uniqueFoldsNumResults,:))';
aux = sort(uniqueFoldsResultsSen','descend');
SenFolds(1,:) = diag(aux(uniqueFoldsNumResults,:))';
aux = sort(uniqueFoldsResultsSpe','descend');
SpeFolds(1,:) = diag(aux(uniqueFoldsNumResults,:))';
aux = sort(uniqueFoldsResultsAcc','descend');
AccFolds(1,:) = diag(aux(uniqueFoldsNumResults,:))';
aux = sort(uniqueFoldsResultsSco','descend');
ScoFolds(1,:) = diag(aux(uniqueFoldsNumResults,:))';

AUCFolds(2,:) = sum(uniqueFoldsResultsAUC')./uniqueFoldsNumResults;
SenFolds(2,:) = sum(uniqueFoldsResultsSen')./uniqueFoldsNumResults;
SpeFolds(2,:) = sum(uniqueFoldsResultsSpe')./uniqueFoldsNumResults;
AccFolds(2,:) = sum(uniqueFoldsResultsAcc')./uniqueFoldsNumResults;
ScoFolds(2,:) = sum(uniqueFoldsResultsSco')./uniqueFoldsNumResults;

AUCFolds(3,:) = max(uniqueFoldsResultsAUC');
SenFolds(3,:) = max(uniqueFoldsResultsSen');
SpeFolds(3,:) = max(uniqueFoldsResultsSpe');
AccFolds(3,:) = max(uniqueFoldsResultsAcc');
ScoFolds(3,:) = max(uniqueFoldsResultsSco');

disp('-------------------------------------------------------');
disp('-------------------------------------------------------');
disp('FOLD RESULTS:');
disp('-------------------------------------------------------');
for i = 1:1:size(uniqueFolds,1)
    disp([array2str(uniqueFolds{i}) ' : ']);
    disp(['    AUC: ' num2percent(AUCFolds(1,i),2) ' Min, ' num2percent(AUCFolds(2,i),2) ' Avg, ' num2percent(AUCFolds(3,i),2) ' Max']);
    disp(['    Sen: ' num2percent(SenFolds(1,i),2) ' Min, ' num2percent(SenFolds(2,i),2) ' Avg, ' num2percent(SenFolds(3,i),2) ' Max']);
    disp(['    Spe: ' num2percent(SpeFolds(1,i),2) ' Min, ' num2percent(SpeFolds(2,i),2) ' Avg, ' num2percent(SpeFolds(3,i),2) ' Max']);
    disp(['    Acc: ' num2percent(AccFolds(1,i),2) ' Min, ' num2percent(AccFolds(2,i),2) ' Avg, ' num2percent(AccFolds(3,i),2) ' Max']);
    disp(['    Sco: ' num2percent(ScoFolds(1,i),2) ' Min, ' num2percent(ScoFolds(2,i),2) ' Avg, ' num2percent(ScoFolds(3,i),2) ' Max']);
end
disp(['Val Checks:']);
for i = 1:1:size(Best_TR.val_fail,2)
    disp(['(' num2str(i-1) ',' num2str(Best_TR.val_fail(i)) ')']);
end

disp(['Gradient:']);
for i = 1:1:size(Best_TR.gradient,2)
    disp(['(' num2str(i-1) ',' num2str(Best_TR.gradient(i)) ')']);
end

disp(['V-perf:']);
for i = 1:1:size(Best_TR.vperf,2)
    disp(['(' num2str(i-1) ',' num2str(Best_TR.vperf(i)) ')']);
end

disp(['T-perf:']);
for i = 1:1:size(Best_TR.tperf,2)
    disp(['(' num2str(i-1) ',' num2str(Best_TR.tperf(i)) ')']);
end

disp(['perf:']);
for i = 1:1:size(Best_TR.perf,2)
    disp(['(' num2str(i-1) ',' num2str(Best_TR.perf(i)) ')']);
end

function [contains,index] = containsArray(arrofarr,arr)
    contains = 0;
    index = 0;
    for i = 1:1:size(arrofarr,1)
        if prod(arrofarr{i} == arr) > 0
            contains = 1;
            index = i;
            return;
        end
    end
end

function arrayStr = array2str(array)
    arrayStr = '[';
    for i = 1:1:size(array,2)
        arrayStr = [arrayStr,num2str(array(i))];
        if i < size(array,2)
            arrayStr = [arrayStr,','];
        end
    end
    arrayStr = [arrayStr,']'];
end

function percentStr = num2percent(num,cases)
    percentStr = [num2str(round(100*num,cases)) ' %'];
end



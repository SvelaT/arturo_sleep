%this code is used to run the classification neural network with the generated features
useErrorWeights = 1;%set to 1 to use error weights as an alternative to undersampling and oversampling
useApnea = 1;
splitApnea = 0;
kfold = 19;%number of blocks for cross validation
networksPerBlock = 10;%number of repeated neural network simulations for each fold
useGPU = 0;
valPatients = 3;%number of patients used for validation
valFromTrain = 1;%set to 1 to use training patients for validation ou 0 to use test patients for validation
usePatients = 1:19;
initialize = 1;

regularizationValue = 0;
activationFunction = 'tansig';
maxEpochs = 5000;
maxValidationChecks = 10;
costFunction = 'crossentropy';
learningAlgorithm = 'trainrp';
numHiddenLayers = 1;

Total_Aucs = zeros(networksPerBlock,kfold);
Total_Performances = zeros(networksPerBlock,kfold);%contains the performance values for all the neural networks
Total_Sensitivities = zeros(networksPerBlock,kfold);
Total_Specificities = zeros(networksPerBlock,kfold);
Total_Accuracies = zeros(networksPerBlock,kfold);
Total_Times = zeros(networksPerBlock,kfold);
Total_Tperfs = zeros(networksPerBlock,kfold);
Total_Epochs = zeros(networksPerBlock,kfold);
Total_Scores = zeros(networksPerBlock,kfold);

if initialize
    MRMR_Results_Aucs = zeros(size(idx,2),4);
    MRMR_Results_Sensitivities = zeros(size(idx,2),4);
    MRMR_Results_Specificities = zeros(size(idx,2),4);
    MRMR_Results_Accuracies = zeros(size(idx,2),4);
    MRMR_Results_Performance = zeros(size(idx,2),4);
    MRMR_Results_Score = zeros(size(idx,2),4);
end

fieldsi = fieldnames(inputs);
patient_indexes = zeros(size(fieldsi,1),2);%contains the indexes of the patient within the allInputs sample matrix
apnea_patients = [16,17,18,19];


numberSimulations = kfold*networksPerBlock;

if useErrorWeights
    [x,t,patient_indexes] = joinallinputs(inputs,targets);
end

initialFeatureIndex = 1;

for k = initialFeatureIndex:1:size(idx,2)
    selectedInputs = idx(1:k);
    for j = 1:1:networksPerBlock
        crossval = gencrossval(kfold,usePatients,splitApnea,apnea_patients);
        
        for i= 1:1:kfold
            if useErrorWeights
                [trainSetIndexes,valSetIndexes,testSetIndexes] = gensets2(crossval,i,patient_indexes,valFromTrain,valPatients);
                errorWeights = classweights(t);
            else
                [x,t,trainSetIndexes,valSetIndexes,testSetIndexes] = gensets(crossval,i,inputs,targets,inputs_balanced,targets_balanced,valFromTrain,valPatients);
                errorWeights = [];
            end
            
            progress = (j-1)*kfold + i;
            
            hiddenLayerNeurons = 2*k+1;
            
            [tr,outputs,performance,errors,net] = runnetwork(x,t,trainSetIndexes,valSetIndexes,testSetIndexes,hiddenLayerNeurons,numHiddenLayers,learningAlgorithm,costFunction,activationFunction,regularizationValue,maxEpochs,maxValidationChecks,selectedInputs,errorWeights,useGPU);
            
            [sensitivity,specificity,accuracy,auc,time,best_tperf,num_epochs] = resultsnn(t,outputs,tr);
            
            scoreValue = (sensitivity(2)+specificity(2)+accuracy(2))/3;
            
            Total_Aucs(j,i) = auc;
            Total_Sensitivities(j,i) = sensitivity(2);
            Total_Specificities(j,i) = specificity(2);
            Total_Accuracies(j,i) = accuracy(2);
            Total_Performances(j,i) = performance;
            Total_Times(j,i) = time;
            Total_Tperfs(j,i) = best_tperf;
            Total_Epochs(j,i) = num_epochs;
            Total_Scores(j,i) = scoreValue;
        end
    end
    
    MRMR_Results_Aucs(k,1) = mean(mean(Total_Aucs));
    MRMR_Results_Sensitivities(k,1) = mean(mean(Total_Sensitivities));
    MRMR_Results_Specificities(k,1) = mean(mean(Total_Specificities));
    MRMR_Results_Accuracies(k,1) = mean(mean(Total_Accuracies));
    MRMR_Results_Performance(k,1) = mean(mean(Total_Performances));
    MRMR_Results_Score(k,1) = mean(mean(Total_Scores));
    
    MRMR_Results_Aucs(k,2) = max(max(Total_Aucs));
    MRMR_Results_Sensitivities(k,2) = max(max(Total_Sensitivities));
    MRMR_Results_Specificities(k,2) = max(max(Total_Specificities));
    MRMR_Results_Accuracies(k,2) = max(max(Total_Accuracies));
    MRMR_Results_Performance(k,2) = max(max(Total_Performances));
    MRMR_Results_Score(k,2) = max(max(Total_Scores));
    
    MRMR_Results_Aucs(k,3) = min(min(Total_Aucs));
    MRMR_Results_Sensitivities(k,3) = min(min(Total_Sensitivities));
    MRMR_Results_Specificities(k,3) = min(min(Total_Specificities));
    MRMR_Results_Accuracies(k,3) = min(min(Total_Accuracies));
    MRMR_Results_Performance(k,3) = min(min(Total_Performances));
    MRMR_Results_Score(k,3) =  min(min(Total_Scores));
    
    MRMR_Results_Aucs(k,4) = std(reshape(Total_Aucs,[],1));
    MRMR_Results_Sensitivities(k,4) = std(reshape(Total_Sensitivities,[],1));
    MRMR_Results_Specificities(k,4) = std(reshape(Total_Specificities,[],1));
    MRMR_Results_Accuracies(k,4) = std(reshape(Total_Accuracies,[],1));
    MRMR_Results_Performance(k,4) = std(reshape(Total_Performances,[],1));
    MRMR_Results_Score(k,4) = std(reshape(Total_Scores,[],1));
    disp(['Testing MRMR for ' k ' features']);
    save('backupmrmr.mat');
    
end

clearvars net i j outputs errors performance useErrorWeights networkPerBlock selectedInputs patient_indexes wait kfold t x errorWeights numberSimulations apnea_patients Total_Aucs Total_Sensitivities Total_Specificities Total_Accuracies Total_Performances

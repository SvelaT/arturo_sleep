%this code is used to run the classification neural network with the generated features
useErrorWeights = 1;%set to 1 to use error weights as an alternative to undersampling and oversampling
useApnea = 1;
splitApnea = 0;
kfold = 2;%number of blocks for cross validation
networksPerBlock = 1;%number of repeated neural network simulations for each fold
useGPU = 0;
valPatients = 3;%number of patients used for validation
valFromTrain = 1;%set to 1 to use training patients for validation ou 0 to use test patients for validation
usePatients = 1:19;
featuresIndex = 1:98;
initialize = 1;

regularizationValue = 0.07;
activationFunction = 'logsig';
hiddenLayerNeurons = 190;
maxEpochs = 5000;
maxValidationChecks = 10;
costFunction = 'crossentropy';
learningAlgorithm = 'trainrp';
numHiddenLayers = 2;

Total_Aucs = zeros(networksPerBlock,kfold);
Total_Performances = zeros(networksPerBlock,kfold);%contains the performance values for all the neural networks
Total_Sensitivities = zeros(networksPerBlock,kfold);
Total_Specificities = zeros(networksPerBlock,kfold);
Total_Accuracies = zeros(networksPerBlock,kfold);
Total_Times = zeros(networksPerBlock,kfold);
Total_Tperfs = zeros(networksPerBlock,kfold);
Total_Epochs = zeros(networksPerBlock,kfold);
Total_Scores = zeros(networksPerBlock,kfold);
num_time_tests = 50;

if initialize
    Time_Results = zeros(num_time_tests,1);
end

fieldsi = fieldnames(inputs);
patient_indexes = zeros(size(fieldsi,1),2);%contains the indexes of the patient within the allInputs sample matrix
apnea_patients = [16,17,18,19];


numberSimulations = kfold*networksPerBlock;

if useErrorWeights
    [x,t,patient_indexes] = joinallinputs(inputs,targets);
end


for w = 1:1:num_time_tests
    size_inputs = randi(98);
    selectedInputs = randperm(98,size_inputs);
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
    
    Time_Results(w) = mean(mean(Total_Times));
end

clearvars net i j outputs errors performance useErrorWeights networkPerBlock selectedInputs patient_indexes wait kfold t x errorWeights numberSimulations apnea_patients Total_Aucs Total_Sensitivities Total_Specificities Total_Accuracies Total_Performances

%this code is used to run the classification neural network with the generated features
useErrorWeights = 1;%set to 1 to use error weights as an alternative to undersampling and oversampling
useApnea = 1;
splitApnea = 0;
kfold = 2;%number of blocks for cross validation
networksPerBlockFull = [1,2,3,4,5,6,7,8,9,10];%number of repeated neural network simulations for each fold
numOfTests = 10;
useGPU = 0;
valPatients = 3;%number of patients used for validation
valFromTrain = 1;%set to 1 to use training patients for validation ou 0 to use test patients for validation
usePatients = 1:19;
initialize = 1;

bestScore = 0;
worstScore = inf;

regularizationValue = 0.07;
hiddenLayerNeurons = 50;
selectedInputs = [1:26];%indexes of the inputs to be used on the neural network training process
activationFunction = 'tansig';
maxEpochs = 5000;
maxValidationChecks = 10;
costFunction = 'crossentropy';
learningAlgorithm = 'trainrp';
numHiddenLayers = 1;

fieldsi = fieldnames(inputs);
patient_indexes = zeros(size(fieldsi,1),2);%contains the indexes of the patient within the allInputs sample matrix
apnea_patients = [16,17,18,19];

wait = waitbar(0,'Running the neural networks...');

if useErrorWeights
    [x,t,patient_indexes] = joinallinputs(inputs,targets);
end

for y = 1:1:size(networksPerBlockFull,2)
    networksPerBlock = networksPerBlockFull(w);
    Total_Aucs = zeros(networksPerBlock,kfold);
    Total_Performance = zeros(networksPerBlock,kfold);%contains the performance values for all the neural networks
    Total_Sensitivities = zeros(networksPerBlock,kfold);
    Total_Specificities = zeros(networksPerBlock,kfold);
    Total_Accuracies = zeros(networksPerBlock,kfold);
    Total_Times = zeros(networksPerBlock,kfold);
    Total_Tperfs = zeros(networksPerBlock,kfold);
    Total_Epochs = zeros(networksPerBlock,kfold);
    Total_Scores = zeros(networksPerBlock,kfold);
    for w = 1:1:numOfTests
        numberSimulations = kfold*networksPerBlock;
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
                
                waitbar(progress/numberSimulations,wait,append('Running neural network number ',int2str(progress),' of ',int2str(numberSimulations)));
                
                [tr,outputs,performance,errors,net] = runnetwork(x,t,trainSetIndexes,valSetIndexes,testSetIndexes,hiddenLayerNeurons,numHiddenLayers,learningAlgorithm,costFunction,activationFunction,regularizationValue,maxEpochs,maxValidationChecks,selectedInputs,errorWeights,useGPU);
                
                [sensitivity,specificity,accuracy,auc,time,best_tperf,num_epochs] = resultsnn(t,outputs,tr);
                
                scoreValue = (sensitivity(2)+specificity(2)+accuracy(2))/3;
                
                Total_Aucs(j,i) = auc;
                Total_Sensitivities(j,i) = sensitivity(2);
                Total_Specificities(j,i) = specificity(2);
                Total_Accuracies(j,i) = accuracy(2);
                Total_Performance(j,i) = performance;
                Total_Times(j,i) = time;
                Total_Tperfs(j,i) = best_tperf;
                Total_Epochs(j,i) = num_epochs;
                Total_Scores(j,i) = scoreValue;
                
                if Total_Aucs(j,i) > bestScore
                    bestScore = Total_Aucs(j,i);
                    Best_Errors = errors;
                    Best_Targets = t;
                    Best_Outputs = outputs;
                    Best_NET = net;
                    Best_TR = tr;
                    Best_Sensitivity = sensitivity(2);
                    Best_Specificity = specificity(2);
                    Best_Accuracy = accuracy(2);
                    Best_Score = scoreValue;
                    Best_Time = time;
                    Best_Tperf = best_tperf;
                    Best_Epochs = num_epochs;
                end
                if Total_Aucs(j,i) < worstScore
                    worstScore = Total_Aucs(j,i);
                    Worst_Errors = errors;
                    Worst_Targets = t;
                    Worst_Outputs = outputs;
                    Worst_NET = net;
                    Worst_TR = tr;
                    Worst_Sensitivity = sensitivity(2);
                    Worst_Specificity = specificity(2);
                    Worst_Accuracy = accuracy(2);
                    Worst_Score = scoreValue;
                    Worst_Time = time;
                    Worst_Tperf = best_tperf;
                    Worst_Epochs = num_epochs;
                end
            end
        end
        Average_Aucs_I(w) = mean(mean(Total_Aucs));
        Average_Scores_I(w) = mean(mean(Total_Scores));
    end
    Average_Aucs(y) = mean(Average_Aucs_I);
    Average_Scores(y) = mean(Average_Scores_I);
    Std_Aucs(y) = std(Average_Aucs_I);
    Std_Scores(y) = std(Average_Scores_I);
    MaxMin_Aucs(y) = max(Average_Aucs_I)-min(Average_Aucs_I);
    MaxMin_Scores(y) = max(Average_Scores_I)-min(Average_Scores_I);
end

clearvars net i j outputs errors performance useErrorWeights networkPerBlock selectedInputs patient_indexes wait kfold t x errorWeights numberSimulations apnea_patients 

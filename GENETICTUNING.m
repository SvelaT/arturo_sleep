%this code is used to run the classification neural network with the generated features
global useErrorWeights;
global networksPerBlock;
global kfold;
global patient_indexes;
global splitApnea;
global gen1Values;
global gen2Values;
global gen3Values;
global gen4Values;
global gen5Values;
global nBitsGen;
global valPatients;
global x;
global t;
global evaluatedIndividuals;
global usePatients;
global valFromTrain;
global useGPU;
global regularizationValue;
global hiddenLayerNeurons;
global selectedInputs;
global activationFunction;
global maxEpochs;
global maxValidationChecks;
global costFunction;
global learningAlgorithm;
global numHiddenLayers;
global apnea_patients;

useErrorWeights = 1;%set to 1 to use error weights as an alternative to undersampling and oversampling
useApnea = 1;
splitApnea = 1;
kfold = 2;%number of blocks for cross validation
networksPerBlock = 5;%number of repeated neural network simulations for each fold
useGPU = 0;
valPatients = 3;%number of patients used for validation
valFromTrain = 1;%set to 1 to use training patients for validation ou 0 to use test patients for validation
usePatients = 1:19;

regularizationValue = 0.07;
hiddenLayerNeurons = 150;
selectedInputs = [1:26];%indexes of the inputs to be used on the neural network training process
activationFunction = 'tansig';
maxEpochs = 5000;
maxValidationChecks = 10;
costFunction = 'crossentropy';
learningAlgorithm = 'traincgb';
numHiddenLayers = 1;

%TUNING USING GENETIC ALGORITHM
gen1Values = (1:2:32)*10;%number hidden neurons
gen2Values = ["trainrp" "trainscg" "trainbfg" "traincgb" "traincgf" "traingdx" "trainoss" "traincgp"];
gen3Values = [0 0.01 0.04 0.07];%regularization
gen4Values = ["tansig" "logsig"];%hidden layer activation function
gen5Values = [1 2];

genNValues(1) = size(gen1Values,2);
genNValues(2) = size(gen2Values,2);
genNValues(3) = size(gen3Values,2);
genNValues(4) = size(gen4Values,2);
genNValues(5) = size(gen5Values,2);

nBitsGen(1) = log2(genNValues(1));
nBitsGen(2) = log2(genNValues(2));
nBitsGen(3) = log2(genNValues(3));
nBitsGen(4) = log2(genNValues(4));
nBitsGen(5) = log2(genNValues(5));

evaluatedIndividuals = [];

fieldsi = fieldnames(inputs);
patient_indexes = zeros(size(fieldsi,1),2);%contains the indexes of the patient within the allInputs sample matrix
apnea_patients = [16,17,18,19];

if useErrorWeights
    [x,t,patient_indexes] = joinallinputs(inputs,targets);
end

NGenerations = 50;
populationSize = 20;
numElitism = 2;
percentMutation = [ones(1,5)*0.3,ones(1,5)*0.25,ones(1,5)*0.2,ones(1,5)*0.15,ones(1,5)*0.1,ones(1,25)*0.05];
numSelection = 5;

numberOfVariables = sum(nBitsGen);
population = [];
initialGeneration = 1;
populations = {};
scoresGen = {};

population = round(rand(populationSize,numberOfVariables));
for i = initialGeneration:1:NGenerations
    options = optimoptions('ga','PopulationType','bitstring','MutationFcn',{@mutationuniform, percentMutation(i)},'CrossoverFraction',0.9,'MaxGenerations',2,'SelectionFcn',{@selectiontournament,4},'PopulationSize',populationSize,'CrossoverFcn','crossovertwopoint','EliteCount',numElitism,'Display','iter','InitialPopulationMatrix',population);
    fun = @FitnessFunction;
    [out,Fval,exitFlag,Output,population,scores] = ga(fun,numberOfVariables,options);
    populations{i} = population;
    scoresGen{i} = scores;
    distances(i) = calcDiversity(population);
    bestScores(i) = min(scores);
    avgScores(i) = mean(scores);
    disp('Finished running for Generation');
    save('backupga.mat');
end


clearvars net i j outputs errors performance useErrorWeights networkPerBlock selectedInputs patient_indexes wait kfold t x errorWeights numberSimulations apnea_patients 

function optimized_pra = FitnessFunction(chromossome)
try
global useErrorWeights;
global networksPerBlock;
global kfold;
global patient_indexes;
global splitApnea;
global gen1Values;
global gen2Values;
global gen3Values;
global gen4Values;
global gen5Values;
global nBitsGen;
global valPatients;
global x;
global t;
global evaluatedIndividuals;
global usePatients;
global valFromTrain;
global useGPU;
global regularizationValue;
global hiddenLayerNeurons;
global selectedInputs;
global activationFunction;
global maxEpochs;
global maxValidationChecks;
global costFunction;
global learningAlgorithm;
global numHiddenLayers;
global apnea_patients;

[resultTemp,flag] = getIndResult(chromossome,evaluatedIndividuals);
if flag
    optimized_pra = resultTemp;
    return;
end

Total_Aucs = zeros(networksPerBlock,kfold);
Total_Performance = zeros(networksPerBlock,kfold);%contains the performance values for all the neural networks
Total_Sensitivities = zeros(networksPerBlock,kfold);
Total_Specificities = zeros(networksPerBlock,kfold);
Total_Accuracies = zeros(networksPerBlock,kfold);
Total_Times = zeros(networksPerBlock,kfold);
Total_Tperfs = zeros(networksPerBlock,kfold);
Total_Epochs = zeros(networksPerBlock,kfold);
Total_Scores = zeros(networksPerBlock,kfold);

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
        
        hiddenLayerNeurons = gen1Values(getGenValue(1,nBitsGen,chromossome));
        learningAlgorithm = gen2Values(getGenValue(2,nBitsGen,chromossome));
        regularizationValue = gen3Values(getGenValue(3,nBitsGen,chromossome));
        activationFunction = gen4Values(getGenValue(4,nBitsGen,chromossome));
        numHiddenLayers = gen5Values(getGenValue(5,nBitsGen,chromossome));
        
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
    end
end

optimized_pra = 1-mean(mean(Total_Aucs));
evaluatedIndividual = [chromossome,optimized_pra];
evaluatedIndividuals = [evaluatedIndividuals;evaluatedIndividual];

catch ME
    disp(ME.message);
    disp(['Problem occured with chromossome ' num2str(hiddenLayerNeurons) ' ' learningAlgorithm ' ' num2str(regularizationValue) ' ' activationFunction ' ' num2str(numHiddenLayers)]);
    optimized_pra = 1;
end
disp('Finished running for individual');

end

function genValue = getGenValue(genIndex,nBitsGen,chromossome)
    startBit = sum(nBitsGen(1:genIndex))-nBitsGen(genIndex)+1;
    endBit = startBit+nBitsGen(genIndex)-1;
    
    binaryNum = chromossome(startBit:endBit);
    
    genValue = bi2de(binaryNum)+1;
end

function [indResult,resultFlag] = getIndResult(chromossome,evaluatedResults)
    resultFlag = 0;
    indResult = 1;
    chromossomeSize = length(chromossome);
    for i = 1:1:size(evaluatedResults,1)
        if isequal(chromossome,evaluatedResults(i,1:chromossomeSize))
            indResult = evaluatedResults(i,chromossomeSize+1);
            resultFlag = 1;
        end
    end
end

function diversityValue = calcDiversity(population)
    diversityConstant = 2/(size(population,2)*size(population,1)*(size(population,1)-1));
    hammingDistance = 0;
    for i = 1:1:size(population,1)
        for j = 1:1:i
            if j < i
                hammingDistance = hammingDistance + sum(abs(population(i,:)-population(j,:)));
            end
        end
    end
    diversityValue = hammingDistance*diversityConstant;
end
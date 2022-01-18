gen1Values = (1:2:32)*10;%number hidden neurons
gen2Values = ["trainrp" "trainscg" "trainbfg" "traincgb" "traincgf" "traingdx" "trainoss" "traincgp"];
gen3Values = [0 0.01 0.04 0.07];%regularization
gen4Values = ["tansig" "logsig"];%hidden layer activation function
gen5Values = [1 2];

hiddenLayerNeurons = gen1Values(getGenValue(1,nBitsGen,best_chromossome));
learningAlgorithm = gen2Values(getGenValue(2,nBitsGen,best_chromossome));
regularizationValue = gen3Values(getGenValue(3,nBitsGen,best_chromossome));
activationFunction = gen4Values(getGenValue(4,nBitsGen,best_chromossome));
numHiddenLayers = gen5Values(getGenValue(5,nBitsGen,best_chromossome));

disp(hiddenLayerNeurons);
disp(learningAlgorithm);
disp(regularizationValue);
disp(activationFunction);
disp(numHiddenLayers);

function genValue = getGenValue(genIndex,nBitsGen,chromossome)
    startBit = sum(nBitsGen(1:genIndex))-nBitsGen(genIndex)+1;
    endBit = startBit+nBitsGen(genIndex)-1;
    
    binaryNum = chromossome(startBit:endBit);
    
    genValue = bi2de(binaryNum)+1;
end
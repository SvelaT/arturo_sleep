best_fitnesses = zeros(1,size(fitnesses,2));
mean_fitnesses = zeros(1,size(fitnesses,2));

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

disp('best fitness');
for i = 1:1:size(fitnesses,2)
    best_fitnesses(i) = min(fitnesses{1,i});
    disp(['(' num2str(i) ',' num2str(best_fitnesses(i)) ')']);
    mean_fitnesses(i) = mean(fitnesses{1,i});
    worst_fitnesses(i) = max(fitnesses{1,i});
end

disp('mean fitness');
for i = 1:1:size(mean_fitnesses,2)
    disp(['(' num2str(i) ',' num2str(mean_fitnesses(i)) ')']);
end

diversities = zeros(1,size(populations,2));

disp('diversities');
for i = 1:1:size(diversities,2)
    diversities(i) = calcDiversity(populations{1,i});
    disp(['(' num2str(i) ',' num2str(diversities(i)) ')']);
end


f1 = figure;
plot(1:50,mean_fitnesses);
title('Mean Fitness');
xlabel('Generations');
ylabel('1 - AUC');

f2 = figure;
plot(1:50,best_fitnesses);
title('Best Fitness');
xlabel('Generations');
ylabel('1 - AUC');

f3 = figure;
plot(1:50,diversities);
title('Population Diversity');
xlabel('Generations');
ylabel('Diversity');

f4 = figure;
plot(1:50,worst_fitnesses);
title('Worst Fitness');
xlabel('Generations');
ylabel('1 - AUC');

algorithms = zeros(size(populations,2),genNValues(2));
neurons = zeros(1,size(populations,2));
regularization = zeros(1,size(populations,2));
layers = zeros(size(populations,2),genNValues(5));
actfunc = zeros(size(populations,2),genNValues(5));


for i = 1:1:size(populations,2)
    pop = populations{i};
    neurons_temp = zeros(1,size(pop,1));
    reg_temp = zeros(1,size(pop,1));
    for j = 1:1:size(pop,1)
        chro = pop(j,:);
        genVal = getGenValue(2,nBitsGen,chro);
        algorithms(i,genVal) = algorithms(i,genVal) + 1;
        genVal = getGenValue(4,nBitsGen,chro);
        actfunc(i,genVal) = actfunc(i,genVal) + 1;
        genVal = getGenValue(5,nBitsGen,chro);
        layers(i,genVal) = layers(i,genVal) + 1;
        genVal = gen1Values(getGenValue(1,nBitsGen,chro));
        neurons_temp(j) = genVal;
        genVal = gen3Values(getGenValue(3,nBitsGen,chro));
        reg_temp(j) = genVal;
    end
    neurons(i) = mean(neurons_temp);
    regularization(i) = mean(reg_temp);
end

f5 = figure;
plot(neurons);

f6 = figure;
plot(regularization);

f7 = figure;
area(layers)

f8 = figure;
area(actfunc)

f9 = figure;
area(algorithms)
newcolors = [0.5 0 0; 0 0.5 0; 0 0 0.5; 0.5 0.5 0.3; 0.5 0 0.5; 0 0.5 0.5; 0.75 0.25 0; 0.25 0.75 0];
newcolors = newcolors*1.3;
colororder(newcolors)
legend({'trainrp','trainscg','trainbfg','traincgb','traincgf','traingdx','trainoss','traincgp'},'Location','southeast')


function genValue = getGenValue(genIndex,nBitsGen,chromossome)
    startBit = sum(nBitsGen(1:genIndex))-nBitsGen(genIndex)+1;
    endBit = startBit+nBitsGen(genIndex)-1;
    
    binaryNum = chromossome(startBit:endBit);
    
    genValue = bi2de(binaryNum)+1;
end


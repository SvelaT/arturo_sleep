%this code is used to evaluate the features to be selected for training
corrMatrix = [];%Correlation coefficients matrix of the inputs

fieldsi = fieldnames(inputs1);
fieldsc = fieldnames(CAPLabel1);

allInputs = [];
for i = 1:1:size(fieldsi,1)
    field = fieldsi{i};
    patient_indexes(i,1) = size(allInputs,1)+1;
    allInputs = [allInputs;inputs1.(field)];
    patient_indexes(i,2) = size(allInputs,1);
end

allCAP = [];
for i = 1:1:size(fieldsc,1)
    field = fieldsc{i};
    allCAP = [allCAP;CAPLabel1.(field)];
end

for i = 1:1:size(allInputs,2)
    for j = 1:1:size(allInputs,2)
        corre = corrcoef(allInputs(:,i),allInputs(:,j));
        corrMatrix(i,j) = corre(1,2);%this contains the correlation coefficients between the inputs and is used to measure redundancy between them
    end
end

corrTarget = [];%Correlation coefficients between each input and the output, used for feature selection

for i = 1:1:size(allInputs,2)
    corre = corrcoef(allInputs(:,i),allCAP);
    corrTarget(i) = corre(1,2);
end

varsInputs = var(allInputs);%variance of each of the features, features with low variance should be removed 
stdsInputs = std(allInputs);%std deviation of each of the features, features with low variance should be removed 

%clearvars fieldsi fieldsc i field patient_indexes allInputs allCAP corre 





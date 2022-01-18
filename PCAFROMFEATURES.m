fieldsi = fieldnames(inputs);

features = final_feature_set(1:16);

allInputs = [];
for i = 1:1:size(fieldsi,1)
    field = fieldsi{i};
    allInputs = [allInputs;inputs.(field)];
end

allInputs = allInputs(:,features);

allInputs = mapstd(allInputs');
allInputs = allInputs';

[coeff,score,latent,tsquared,explained,mu] = pca(allInputs);%running the PCA algorithm to obtain the PCA coefficients

coeff = coeff';

pcaNaming = "inputs";

for i = 1:1:size(fieldsi,1)
    pcas.(strcat(pcaNaming,int2str(i))) = [];
end

for i = 1:1:size(fieldsi,1)   
    field = fieldsi{i};
    auxInputs = inputs.(field);
    auxInputs = mapstd(auxInputs');
    auxInputs = auxInputs(features,:);
    
    auxPca = coeff*auxInputs;
  
    pcas.(strcat(pcaNaming,int2str(i))) = auxPca';
end

clearvars allInputs field fieldsi tsquared mu pcaNaming auxInputs auxPca i j 
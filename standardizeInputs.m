fieldsi1 = fieldnames(inputs1);
fieldsi2 = fieldnames(inputs2);

for i = 1:1:size(fieldsi1,1)
    field = fieldsi1{i};
    
%    inputs1.(field) = minMaxNormalizationRemap(inputs1.(field),-1,1);
%    inputs1.(field) = minMaxNormalization(inputs1.(field));
     inputs1.(field) = standardize(inputs1.(field));
end

for i = 1:1:size(fieldsi2,1)
    field = fieldsi2{i};
    
%     inputs2.(field) = minMaxNormalizationRemap(inputs2.(field),-1,1);
%    inputs2.(field) = minMaxNormalization(inputs2.(field));
    inputs2.(field) = standardize(inputs2.(field));
end

function minMaxNormalizationRemap = minMaxNormalizationRemap(inputs,a,b)
    minMaxNormalizationRemap = zeros(size(inputs,1),size(inputs,2));
    for i = 1:1:size(inputs,2)
        aux = inputs(:,i);
        minimum = min(aux);
        maximum = max(aux);
        range = maximum - minimum;
        
        aux = (aux - minimum)/range;
        minMaxNormalizationRemap(:,i) = (aux*(b-a))+a;
    end
end

function minMaxNormalization = minMaxNormalization(inputs)
    minMaxNormalization = zeros(size(inputs,1),size(inputs,2));
    for i = 1:1:size(inputs,2)
        aux = inputs(:,i);
        minimum = min(aux);
        maximum = max(aux);
        range = maximum - minimum;
        
        aux = (aux - minimum)/range;
        minMaxNormalization(:,i) = aux;
    end
end

function standardize = standardize(inputs)
    standardize = zeros(size(inputs,1),size(inputs,2));
    for i = 1:1:size(inputs,2)
        aux = inputs(:,i);
        auxMean = mean(aux);
        auxStd = std(aux);
        
        standardize(:,i) = (aux-auxMean)/auxStd;
    end
end
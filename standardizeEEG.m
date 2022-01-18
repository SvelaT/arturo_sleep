fieldse1 = fieldnames(eeg1);
fieldse2 = fieldnames(eeg2);

for i = 1:1:size(fieldse1,1)
    field = fieldse1{i};
    
    eegSensor = eeg1.(field);
    
    eegSensor = standardize(eegSensor);
    
    eeg1.(field) = eegSensor;
end

for i = 1:1:size(fieldse2,1)
    field = fieldse2{i};
    
    eegSensor = eeg2.(field);
    
    eegSensor = standardize(eegSensor);
    
    eeg2.(field) = eegSensor;
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
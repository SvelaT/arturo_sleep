fieldse1 = fieldnames(eeg1);
fieldsc1 = fieldnames(CAPLabel1);
fieldse2 = fieldnames(eeg2);
fieldsc2 = fieldnames(CAPLabel2);

inputsNaming = "inputs";
targetsNaming = "targets";

wait = waitbar(0,'Starting...');

a = 1;

allInputsSize = 0;

samplingFreq = fix(size(eeg1.(fieldse1{1}),1)/size(CAPLabel1.(fieldsc1{1}),1));

for i = 1:1:size(fieldsc1,1)
    fieldc = fieldsc1{i};
    capLabels = CAPLabel1.(fieldc);
    allInputsSize = allInputsSize + size(capLabels,1);
end

for i = 1:1:size(fieldsc2,1)
    fieldc = fieldsc2{i};
    capLabels = CAPLabel2.(fieldc);
    allInputsSize = allInputsSize + size(capLabels,1);
end

allInputs = zeros(allInputsSize,samplingFreq);

for i = 1:1:size(fieldse1,1)
    
    waitbar(i/size(fieldse1,1),wait,strcat('Converting EEG for patient n',int2str(i)));%update the waitbar
    
    fielde = fieldse1{i};
    fieldc = fieldsc1{i};
    
    eegSignal = eeg1.(fielde);
    capLabels = CAPLabel1.(fieldc);
    
    eegSignal = eegSignal';
    
    newInputs = zeros(size(capLabels,1),samplingFreq);
    
    for j = 1:1:size(capLabels,1)
        start = (j-1)*samplingFreq + 1;
        finish = j*samplingFreq;
        allInputs(a,:) = eegSignal(start:finish);
        a = a + 1;
        newInputs(j,:) = eegSignal(start:finish);
    end
    
    inputs1.(strcat(inputsNaming,int2str(i))) = newInputs;
end

for i = 1:1:size(fieldse2,1)
    
    waitbar(i/size(fieldse2,1),wait,strcat('Converting EEG for patient n',int2str(i)));%update the waitbar
    
    fielde = fieldse2{i};
    fieldc = fieldsc2{i};
    
    eegSignal = eeg2.(fielde);
    capLabels = CAPLabel2.(fieldc);
    
    eegSignal = eegSignal';
    
    newInputs = zeros(size(capLabels,1),samplingFreq);
    
    for j = 1:1:size(capLabels,1)
        start = (j-1)*samplingFreq + 1;
        finish = j*samplingFreq;
        allInputs(a,:) = eegSignal(start:finish);
        a = a + 1;
        newInputs(j,:) = eegSignal(start:finish);
    end
    
    inputs2.(strcat(inputsNaming,int2str(i))) = newInputs;
end

allInputsStd = standardize(allInputs);

waitbar(0,wait,'Running the PCA Algorithm');%update the waitbar

[coeff,score,latent,tsquared,explained,mu] = pca(allInputsStd);%running the PCA algorithm to obtain the PCA coefficients

coeff = coeff';

pcaNaming = "pcas";

fieldsi1 = fieldnames(inputs1);
fieldsi2 = fieldnames(inputs2);

for i = 1:1:size(fieldsi1,1)
    pcas1.(strcat(pcaNaming,int2str(i))) = [];
end

for i = 1:1:size(fieldsi1,1)
    waitbar(i/size(fieldsi1,1),wait,'Multiplying Inputs by the PCA Coefficients');%update the waitbar
    
    field = fieldsi1{i};
    auxInputs = inputs1.(field);
    auxInputs = standardize(auxInputs);
    auxPca = coeff*(auxInputs');
    
    pcas1.(strcat(pcaNaming,int2str(i))) = auxPca';
end

for i = 1:1:size(fieldsi2,1)
    waitbar(i/size(fieldsi2,1),wait,'Multiplying Inputs by the PCA Coefficients');%update the waitbar
    
    field = fieldsi2{i};
    auxInputs = inputs2.(field);
    auxInputs = standardize(auxInputs);
    auxPca = coeff*(auxInputs');
    
    pcas2.(strcat(pcaNaming,int2str(i))) = auxPca';
end

for i = 1:1:size(fieldsc1,1)
    waitbar(i/size(fieldsc1,1),wait,'Converting the Targets');%update the waitbar
    
    fieldc = fieldsc1{i};
    CAPS = CAPLabel1.(fieldc);
    
    newTargets = zeros(size(CAPS,1),4);
    for j = 1:1:size(CAPS,1)
        if CAPS(j) == 0
            newTargets(j,1) = 1;
        elseif CAPS(j) == 1
            newTargets(j,2) = 1;
        elseif CAPS(j) == 2
            newTargets(j,3) = 1;
        elseif CAPS(j) == 3
            newTargets(j,4) = 1;
        end
    end
    
    targets1.(strcat(targetsNaming,int2str(i))) = newTargets;
end

for i = 1:1:size(fieldsc2,1)
    waitbar(i/size(fieldsc2,1),wait,'Converting the Targets');%update the waitbar
    
    fieldc = fieldsc2{i};
    CAPS = CAPLabel2.(fieldc);
    
    newTargets = zeros(size(CAPS,1),4);
    for j = 1:1:size(CAPS,1)
        if CAPS(j) == 0
            newTargets(j,1) = 1;
        elseif CAPS(j) == 1
            newTargets(j,2) = 1;
        elseif CAPS(j) == 2
            newTargets(j,3) = 1;
        elseif CAPS(j) == 3
            newTargets(j,4) = 1;
        end
    end
    
    targets2.(strcat(targetsNaming,int2str(i))) = newTargets;
end

close(wait);

clearvars allInputs field fieldsi allInputsStd tsquared mu pcaNaming auxInputs auxPca i j eegSignal samplingFreq newInputs capLabels inputsNaming fieldse fieldsc

function standard = standardize(inputs)
    standard = zeros(size(inputs,1),size(inputs,2));
    for i = 1:1:size(inputs,2)
        aux = inputs(:,i);
        auxMean = mean(aux);
        auxStd = std(aux);
        
        standard(:,i) = (aux-auxMean)/auxStd;
    end
end
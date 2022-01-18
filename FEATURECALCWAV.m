calculationRange = 3;
waveletFunction = 'db4';
samplingFreq = 100;
numFeatures = 8*9;

fieldse = fieldnames(eeg1);%this contains the field names for the eeg signals for each patient
fieldst = fieldnames(CAPLabel1);%this contains the field names for the CAP labels for each patient

wait = waitbar(0,'Calculating Wavelet Features ...');%a waitbar is used to display the progress of the feature selection 

for fi = 1:1:size(fieldse,1)
    
    waitbar(fi/size(fieldse,1),wait,strcat('Calculating Wavelet Features for n',int2str(fi)));%update the waitbar
    
    aux = fieldse{fi};
    eegSensor = eeg1.(aux);%eeg sensor data of the current patient
    aux = fieldst{fi};
    CAPdata = CAPLabel1.(aux);%CAP Label data of the current patient
    ifieldname = strcat('inputs',int2str(fi));%name of the field where the inputs of the current patient are going to be saved
    
    sensorNum = size(eegSensor,1);%number of values collected by the sensor(100Hz collecting rate)
    sampleNum = size(CAPdata,1);%number of samples

    sampleSize = fix(sensorNum/sampleNum);%number of sensor values per sample(per cap label)
  
    inputs_i = zeros(sampleNum,numFeatures);%initiazing the inputs 
    
    for i = 1:1:sampleNum
        upperIndex = min(i+calculationRange,sampleNum);
        lowerIndex = max(i-calculationRange-1,0);
        upperBound = upperIndex*sampleSize;
        lowerBound = lowerIndex*sampleSize+1;
        
        signal = eegSensor(lowerBound:upperBound);
        
        [c1,c2] = dwt(signal,waveletFunction);%c1-> 0-50Hz| c2 -> 50-100Hz
        [c3,c4] = dwt(c1,waveletFunction);%c3->0-25Hz|c4->25-50Hz
        [c5,c6] = dwt(c3,waveletFunction);%c5->0-12.5Hz|c6->12.5-25Hz
        [c7,c8] = dwt(c4,waveletFunction);%c7->25-37.5Hz|c8->37.5-50Hz
        [c9,c10] = dwt(c5,waveletFunction);%c9->0-6.25Hz|c10->6.25-12.5Hz
        [c11,c12] = dwt(c6,waveletFunction);%c11->12.5-18.75Hz|c12->18.75-25Hz
        [c13,c14] = dwt(c9,waveletFunction);%c13->0-3.125Hz|c14->3.125-6.25Hz
        [c15,c16] = dwt(c10,waveletFunction);%c15->6.25-9.375Hz|c16->9.375-12.5Hz
        [c17,c18] = dwt(c11,waveletFunction);%c17->12.5-15.625Hz|c18 ->15.625-18.75Hz
        [c19,c20] = dwt(c12,waveletFunction);%c19->18.75-21.875Hz|c20->21.875-25Hz
        [c21,c22] = dwt(c13,waveletFunction);%c21->0-1.5625Hz|c22->1.5625-3.125Hz
        [c23,c24] = dwt(c14,waveletFunction);%c23->3.125-4.68755Hz|c24->4.6875-6.25Hz
        [c25,c26] = dwt(c15,waveletFunction);%c25->6.25-7.8125Hz|c26->7.8125-9.375Hz
        [c27,c28] = dwt(c16,waveletFunction);%c27->9.375-10.9375Hz|c24->10.9375-12.5Hz
        [c29,c30] = dwt(c17,waveletFunction);%c29->12.5-14.0625Hz|c24->14.0625-15.625Hz
        [c31,c32] = dwt(c21,waveletFunction);%c31->0-0.78125Hz|c32 ->0.78125-1.5625Hz
        [c33,c34] = dwt(c22,waveletFunction);%c33->1.5625-2.34375Hz|c34->2.34375-3.125Hz
        [c35,c36] = dwt(c23,waveletFunction);%c35->3.125-3.90625Hz|c36->3.90625-4.68755Hz
        [c37,c38] = dwt(c26,waveletFunction);%c37->7.8125-8.59375Hz|c38->8.59375-9.375Hz
        [c39,c40] = dwt(c31,waveletFunction);%c37->0-0.390625Hz|c38->0.390625-0.78125Hz
        
        usedCoefs.c1 = c1;
        usedCoefs.c3 = c3;
        usedCoefs.c4 = c4;
        usedCoefs.c5 = c5;
        usedCoefs.c6 = c6;
        usedCoefs.c9 = c9;
        usedCoefs.c10 = c10;
        usedCoefs.c13 = c13;
        usedCoefs.c14 = c14;
        
        fieldscoef = fieldnames(usedCoefs);
        
        for j = 1:1:size(fieldscoef,1)
            aux = fieldscoef{j};
            coefs = usedCoefs.(aux);
            indexDelay = (j-1)*8;
            
            inputs_i(i,indexDelay+1) = mean(coefs);%mean
            inputs_i(i,indexDelay+2) = var(coefs);%variance
            inputs_i(i,indexDelay+3) = skewness(coefs);%skewness
            inputs_i(i,indexDelay+4) = kurtosis(coefs);%kurtosis
            
            inputs_i(i,indexDelay+5) = wentropy(coefs,'shannon');%shannon entropy
            inputs_i(i,indexDelay+6) = wentropy(coefs,'log energy');%log energy entropy
            inputs_i(i,indexDelay+7) = renyi_entropy_lps(coefs');%shannon entropy
            inputs_i(i,indexDelay+8) = tsallis_entropy_lps(coefs');%log energy entropy
            
        end
    end
    
    inputsWav1.(ifieldname) = inputs_i;
end


fieldse = fieldnames(eeg2);%this contains the field names for the eeg signals for each patient with Apnea
fieldst = fieldnames(CAPLabel2);%this contains the field names for the CAP labels for each patient with Apnea

close(wait);

wait = waitbar(0,'Calculating Features Wavelet for Apnea...');%a waitbar is used to display the progress of the feature selection 

for fi = 1:1:size(fieldse,1)
    
    waitbar(fi/size(fieldse,1),wait,strcat('Calculating Wavelet Features Apnea for n',int2str(fi)));%update the waitbar
    
    aux = fieldse{fi};
    eegSensor = eeg2.(aux);%eeg sensor data of the current patient
    aux = fieldst{fi};
    CAPdata = CAPLabel2.(aux);%CAP Label data of the current patient
    ifieldname = strcat('inputs',int2str(fi));%name of the field where the inputs of the current patient are going to be saved
    
    sensorNum = size(eegSensor,1);%number of values collected by the sensor(100Hz collecting rate)
    sampleNum = size(CAPdata,1);%number of samples

    sampleSize = fix(sensorNum/sampleNum);%number of sensor values per sample(per cap label)
  
    inputs_i = zeros(sampleNum,numFeatures);%initiazing the inputs 
    
    for i = 1:1:sampleNum
        upperIndex = min(i+calculationRange,sampleNum);
        lowerIndex = max(i-calculationRange-1,0);
        upperBound = upperIndex*sampleSize;
        lowerBound = lowerIndex*sampleSize+1;
        
        signal = eegSensor(lowerBound:upperBound);
        
        [c1,c2] = dwt(signal,waveletFunction);%c1-> 0-50Hz| c2 -> 50-100Hz
        [c3,c4] = dwt(c1,waveletFunction);%c3->0-25Hz|c4->25-50Hz
        [c5,c6] = dwt(c3,waveletFunction);%c5->0-12.5Hz|c6->12.5-25Hz
        [c7,c8] = dwt(c4,waveletFunction);%c7->25-37.5Hz|c8->37.5-50Hz
        [c9,c10] = dwt(c5,waveletFunction);%c9->0-6.25Hz|c10->6.25-12.5Hz
        [c11,c12] = dwt(c6,waveletFunction);%c11->12.5-18.75Hz|c12->18.75-25Hz
        [c13,c14] = dwt(c9,waveletFunction);%c13->0-3.125Hz|c14->3.125-6.25Hz
        [c15,c16] = dwt(c10,waveletFunction);%c15->6.25-9.375Hz|c16->9.375-12.5Hz
        [c17,c18] = dwt(c11,waveletFunction);%c17->12.5-15.625Hz|c18 ->15.625-18.75Hz
        [c19,c20] = dwt(c12,waveletFunction);%c19->18.75-21.875Hz|c20->21.875-25Hz
        [c21,c22] = dwt(c13,waveletFunction);%c21->0-1.5625Hz|c22->1.5625-3.125Hz
        [c23,c24] = dwt(c14,waveletFunction);%c23->3.125-4.68755Hz|c24->4.6875-6.25Hz
        [c25,c26] = dwt(c15,waveletFunction);%c25->6.25-7.8125Hz|c26->7.8125-9.375Hz
        [c27,c28] = dwt(c16,waveletFunction);%c27->9.375-10.9375Hz|c24->10.9375-12.5Hz
        [c29,c30] = dwt(c17,waveletFunction);%c29->12.5-14.0625Hz|c24->14.0625-15.625Hz
        [c31,c32] = dwt(c21,waveletFunction);%c31->0-0.78125Hz|c32 ->0.78125-1.5625Hz
        [c33,c34] = dwt(c22,waveletFunction);%c33->1.5625-2.34375Hz|c34->2.34375-3.125Hz
        [c35,c36] = dwt(c23,waveletFunction);%c35->3.125-3.90625Hz|c36->3.90625-4.68755Hz
        [c37,c38] = dwt(c26,waveletFunction);%c37->7.8125-8.59375Hz|c38->8.59375-9.375Hz
        [c39,c40] = dwt(c31,waveletFunction);%c37->0-0.390625Hz|c38->0.390625-0.78125Hz
        
        usedCoefs.c1 = c1;
        usedCoefs.c3 = c3;
        usedCoefs.c4 = c4;
        usedCoefs.c5 = c5;
        usedCoefs.c6 = c6;
        usedCoefs.c9 = c9;
        usedCoefs.c10 = c10;
        usedCoefs.c13 = c13;
        usedCoefs.c14 = c14;
        
        fieldscoef = fieldnames(usedCoefs);
        
        for j = 1:1:size(fieldscoef,1)
            aux = fieldscoef{j};
            coefs = usedCoefs.(aux);
            indexDelay = (j-1)*8;
            
            inputs_i(i,indexDelay+1) = mean(coefs);%mean
            inputs_i(i,indexDelay+2) = var(coefs);%variance
            inputs_i(i,indexDelay+3) = skewness(coefs);%skewness
            inputs_i(i,indexDelay+4) = kurtosis(coefs);%kurtosis
            
            inputs_i(i,indexDelay+5) = wentropy(coefs,'shannon');%shannon entropy
            inputs_i(i,indexDelay+6) = wentropy(coefs,'log energy');%log energy entropy
            inputs_i(i,indexDelay+7) = renyi_entropy_lps(coefs');%shannon entropy
            inputs_i(i,indexDelay+8) = tsallis_entropy_lps(coefs');%log energy entropy
            
        end
    end
    
    inputsWav2.(ifieldname) = inputs_i;
end

    
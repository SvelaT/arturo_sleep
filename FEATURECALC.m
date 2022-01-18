calculationRanges = [3,3,3,3,0,3,3,3,3,3,3,3,3,3,3];
waveletFunction = 'db4';
samplingFreqs = [512,512,512,100,512,128,128,100,128,512,512,200,200,200,100];
samplingFreqsApnea = [256,256,512,256];
divideNfft = 2;
numFeatures = 26;

fieldse = fieldnames(eeg1);%this contains the field names for the eeg signals for each patient
fieldst = fieldnames(CAPLabel1);%this contains the field names for the CAP labels for each patient

wait = waitbar(0,'Calculating Features...');%a waitbar is used to display the progress of the feature selection 

prev2EpochMax = 0;
prevEpochMax = 0;


for fi = 1:1:size(fieldse,1)
    
    waitbar(fi/size(fieldse,1),wait,strcat('Calculating Features for n',int2str(fi)));%update the waitbar
    
    aux = fieldse{fi};
    eegSensor = eeg1.(aux);%eeg sensor data of the current patient
    aux = fieldst{fi};
    CAPdata = CAPLabel1.(aux);%CAP Label data of the current patient
    ifieldname = strcat('inputs',int2str(fi));%name of the field where the inputs of the current patient are going to be saved
    tfieldname = strcat('targets',int2str(fi));%name of the field where the targets of the current patient are going to be saved
    
    sensorNum = size(eegSensor,1);%number of values collected by the sensor(100Hz collecting rate)
    sampleNum = size(CAPdata,1);%number of samples

    sampleSize = fix(sensorNum/sampleNum);%number of sensor values per sample(per cap label)
  
    inputs_i = zeros(sampleNum,numFeatures);%initiazing the inputs 
    
    samplingFreq = samplingFreqs(fi);
    
    %this cycle iterates through the sensor data to create the feature table
    for i = 1:1:sampleNum
        upperIndexes = min([i+calculationRanges;zeros(1,15)+sampleNum]);
        lowerIndexes = max([i-calculationRanges-1;zeros(1,15)]);
        upperBounds = upperIndexes*sampleSize;
        lowerBounds = lowerIndexes*sampleSize + 1;
        
        signal = eegSensor(lowerBounds(1):upperBounds(1));
        inputs_i(i,1) = mean(signal);%mean
        
        signal = eegSensor(lowerBounds(2):upperBounds(2));
        inputs_i(i,2) = var(signal);%variance
        
        signal = eegSensor(lowerBounds(3):upperBounds(3));
        inputs_i(i,3) = skewness(signal);%skewness
        
        signal = eegSensor(lowerBounds(4):upperBounds(4));
        inputs_i(i,4) = kurtosis(signal);%kurtosis
        
        
        signal = eegSensor(lowerBounds(5):upperBounds(5));
        inputs_i(i,5) = max(signal)+(prev2EpochMax-prevEpochMax);%amplitude variation
        prev2EpochMax = prevEpochMax;
        prevEpochMax = max(signal);
        
        signal = eegSensor(lowerBounds(6):upperBounds(6));
        inputs_i(i,6) = std(signal);%standard deviation
        
        signal = eegSensor(lowerBounds(7):upperBounds(7));
        inputs_i(i,7) = max(signal)-min(signal);%range value
        
        
        signal = eegSensor(lowerBounds(8):upperBounds(8));
        inputs_i(i,8) = wentropy(signal,'shannon');%shannon entropy

        signal = eegSensor(lowerBounds(9):upperBounds(9));
        inputs_i(i,9) = wentropy(signal,'log energy');%log energy entropy
        
        signal = eegSensor(lowerBounds(10):upperBounds(10)); 
        inputs_i(i,10) = renyi_entropy_lps(signal');%shannon entropy

        signal = eegSensor(lowerBounds(11):upperBounds(11));
        inputs_i(i,11) = tsallis_entropy_lps(signal');%log energy entropy
        
  
        signal = eegSensor(lowerBounds(12):upperBounds(12));
        inputs_i(i,12) = mean(abs(xcov(signal)));%autocovariance

        signal = eegSensor(lowerBounds(13):upperBounds(13));
        inputs_i(i,13) = mean(abs(xcorr(signal)));%autocorrelation
        
        
        signal = eegSensor(lowerBounds(14):upperBounds(14));
        teager = zeros(1,size(signal,1)-2);
        for j = 1:1:(size(signal,1)-2)
             teager(j) = signal(j+1)*signal(j+1) + signal(j)*signal(j+2);
        end
        inputs_i(i,14) = mean(teager);%TEO
        
        signal = eegSensor(lowerBounds(15):upperBounds(15));
        signalSize = size(signal,1);
        
        nfft = floor(signalSize/divideNfft);
        noverlap = floor(nfft/2);
        fs = samplingFreq;
        
        [pxx,f] = pwelch(signal,hanning(nfft),noverlap,nfft,fs);
        pxx2 = 10*log10(pxx*fs/nfft);
        
        auxUnit = samplingFreq/(2*noverlap);
        baseFrequencies = [0.5,4,8,12,15,24,30];
        freqMatrix = floor(baseFrequencies/auxUnit);
        freqMatrix = auxUnit*freqMatrix;
        
        DeltaBaseFreq = find(f == freqMatrix(1));
        ThetaBaseFreq = find(f == freqMatrix(2));
        AlphaBaseFreq = find(f == freqMatrix(3));
        SigmaBaseFreq = find(f == freqMatrix(4));
        Beta1BaseFreq = find(f == freqMatrix(5));
        Beta2BaseFreq = find(f == freqMatrix(6));
        Beta2MaxFreq = find(f == freqMatrix(7));
        
        inputs_i(i,15) = trapz(pxx2(DeltaBaseFreq:(ThetaBaseFreq-1)));
        inputs_i(i,16) = trapz(pxx2(ThetaBaseFreq:(AlphaBaseFreq-1)));
        inputs_i(i,17) = trapz(pxx2(AlphaBaseFreq:(SigmaBaseFreq-1)));
        inputs_i(i,18) = trapz(pxx2(SigmaBaseFreq:(Beta1BaseFreq-1)));
        inputs_i(i,19) = trapz(pxx2(Beta1BaseFreq:(Beta2BaseFreq-1)));
        inputs_i(i,20) = trapz(pxx2(Beta2BaseFreq:Beta2MaxFreq));
        
        signal = eegSensor(lowerBounds(15):upperBounds(15));
        switch(samplingFreq)
            case 100
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
                %Beta1 Waves [c18 c19] 15.625-21.875Hz
                recons1 = idwt(c19,zeros(size(c19)),waveletFunction);
                recons2 = idwt(zeros(size(c18)),c18,waveletFunction);
                [recons2,recons1] = equilibrate(recons2,recons1);
                recons3 = idwt(recons2,recons1,waveletFunction);
                recons4 = idwt(zeros(size(recons3)),recons3,waveletFunction);
                recons5 = idwt(recons4,zeros(size(recons4)),waveletFunction);
                recons6 = idwt(recons5,zeros(size(recons5)),waveletFunction);%Final
                Beta1Signal = recons6;
                %Beta2 Waves [c20 c7] 21.875-37.5Hz
                recons1 = idwt(zeros(size(c20)),c20,waveletFunction);
                recons2 = idwt(zeros(size(recons1)),recons1,waveletFunction);
                recons3 = idwt(c7,zeros(size(c7)),waveletFunction);
                recons4 = idwt(zeros(size(recons2)),recons2,waveletFunction);
                [recons4,recons3] = equilibrate(recons4,recons3);
                recons5 = idwt(recons4,recons3,waveletFunction);
                recons6 = idwt(recons5,zeros(size(recons5)),waveletFunction);%Final
                Beta2Signal = recons6;
                %Alpha Waves [c38 c27] 8.59375-10.9375Hz
                recons1 = idwt(zeros(size(c38)),c38,waveletFunction);
                recons2 = idwt(c27,zeros(size(c27)),waveletFunction);
                recons3 = idwt(zeros(size(recons1)),recons1,waveletFunction);
                [recons3,recons2] = equilibrate(recons3,recons2);
                recons4 = idwt(recons3,recons2,waveletFunction);
                recons5 = idwt(zeros(size(recons4)),recons4,waveletFunction);
                recons6 = idwt(recons5,zeros(size(recons5)),waveletFunction);
                recons7 = idwt(recons6,zeros(size(recons6)),waveletFunction);
                recons8 = idwt(recons7,zeros(size(recons7)),waveletFunction);%Final
                AlphaSignal = recons8;
                %Theta Waves [c35 c36 c24 c25 c37] 3.125-8.59375Hz
                [c35,c36] = equilibrate(c35,c36);
                recons1 = idwt(c35,c36,waveletFunction);
                recons2 = idwt(c37,zeros(size(c37)),waveletFunction);
                [c25,recons2] = equilibrate(c25,recons2);
                recons3 = idwt(c25,recons2,waveletFunction);
                recons4 = idwt(zeros(size(c24)),c24,waveletFunction);
                recons5 = idwt(recons3,zeros(size(recons3)),waveletFunction);
                recons6 = idwt(zeros(size(recons4)),recons4,waveletFunction);
                [recons6,recons5] = equilibrate(recons6,recons5);
                recons7 = idwt(recons6,recons5,waveletFunction);
                recons8 = idwt(recons7,zeros(size(recons7)),waveletFunction);
                recons9 = idwt(recons8,zeros(size(recons8)),waveletFunction);
                recons10 = idwt(recons9,zeros(size(recons9)),waveletFunction);%Final
                ThetaSignal = recons10;
                %Delta Waves [c40 c32 c33 c34] 0.390625-3.125Hz
                recons1 = idwt(zeros(size(c40)),c40,waveletFunction);
                [c33,c34] = equilibrate(c33,c34);
                recons2 = idwt(c33,c34,waveletFunction);
                [recons1,c32] = equilibrate(recons1,c32);
                recons3 = idwt(recons1,c32,waveletFunction);
                [recons3,recons2] = equilibrate(recons3,recons2);
                recons4 = idwt(recons3,recons2,waveletFunction);
                recons5 = idwt(recons4,zeros(size(recons4)),waveletFunction);
                recons6 = idwt(recons5,zeros(size(recons5)),waveletFunction);
                recons7 = idwt(recons6,zeros(size(recons6)),waveletFunction);
                recons8 = idwt(recons7,zeros(size(recons7)),waveletFunction);
                recons9 = idwt(recons8,zeros(size(recons8)),waveletFunction);%Final
                DeltaSignal = recons9;
                %Spindle [c28 c29 c30]
                [c29,c30] = equilibrate(c29,c30);
                recons1 = idwt(c29,c30,waveletFunction);
                recons2 = idwt(zeros(size(c28)),c28,waveletFunction);
                recons3 = idwt(recons1,zeros(size(recons1)),waveletFunction);
                recons4 = idwt(zeros(size(recons2)),recons2,waveletFunction);
                recons5 = idwt(recons3,zeros(size(recons3)),waveletFunction);
                recons6 = idwt(zeros(size(recons4)),recons4,waveletFunction);
                recons7 = idwt(recons6,recons5,waveletFunction);
                recons8 = idwt(recons7,zeros(size(recons7)),waveletFunction);
                recons9 = idwt(recons8,zeros(size(recons8)),waveletFunction);%Final
                SigmaSignal = recons9;
            case 128
                [c1,c2] = dwt(signal,waveletFunction);%c1-> 0-64Hz| c2 -> 64-128Hz 
                [c3,c4] = dwt(c1,waveletFunction);%c3-> 0-32Hz| c4 -> 32-64Hz
                [c5,c6] = dwt(c3,waveletFunction);%c5-> 0-16Hz| c6 -> 16-32Hz
                [c7,c8] = dwt(c5,waveletFunction);%c7-> 0-8Hz| c8 -> 8-16Hz
                [c9,c10] = dwt(c7,waveletFunction);%c9-> 0-4Hz| c10 -> 4-8Hz
                [c11,c12] = dwt(c8,waveletFunction);%c11-> 8-12Hz| c12 -> 12-16Hz
                [c13,c14] = dwt(c9,waveletFunction);%c13-> 0-2Hz | c14-> 2-4Hz
                [c15,c16] = dwt(c13,waveletFunction);%c15-> 0-1Hz | c16-> 1-2Hz
                [c17,c18] = dwt(c15,waveletFunction);%c17-> 0-0.5Hz | c18-> 0.5-1Hz
                [c19,c20] = dwt(c6,waveletFunction);%c19-> 16-24Hz| c20 -> 24-32Hz
                %Beta1 Waves [c19]
                recons1 = idwt(c19,zeros(size(c19)),waveletFunction);
                recons2 = idwt(zeros(size(recons1)),recons1,waveletFunction);
                recons3 = idwt(recons2,zeros(size(recons2)),waveletFunction);
                recons4 = idwt(recons3,zeros(size(recons3)),waveletFunction);%Final
                Beta1Signal = recons4;
                %Beta2 Waves [c20]
                recons1 = idwt(zeros(size(c20)),c20,waveletFunction);
                recons2 = idwt(zeros(size(recons1)),recons1,waveletFunction);
                recons3 = idwt(recons2,zeros(size(recons2)),waveletFunction);
                recons4 = idwt(recons3,zeros(size(recons3)),waveletFunction);%Final
                Beta2Signal = recons4;
                %Sigma Waves [c12]
                recons1 = idwt(zeros(size(c12)),c12,waveletFunction);
                recons2 = idwt(zeros(size(recons1)),recons1,waveletFunction);
                recons3 = idwt(recons2,zeros(size(recons2)),waveletFunction);
                recons4 = idwt(recons3,zeros(size(recons3)),waveletFunction);
                recons5 = idwt(recons4,zeros(size(recons4)),waveletFunction);%Final
                SigmaSignal = recons5;
                %Alpha Waves [c11]
                recons1 = idwt(c11,zeros(size(c11)),waveletFunction);
                recons2 = idwt(zeros(size(recons1)),recons1,waveletFunction);
                recons3 = idwt(recons2,zeros(size(recons2)),waveletFunction);
                recons4 = idwt(recons3,zeros(size(recons3)),waveletFunction);
                recons5 = idwt(recons4,zeros(size(recons4)),waveletFunction);%Final
                AlphaSignal = recons5;
                %Theta Waves [c10]
                recons1 = idwt(zeros(size(c10)),c10,waveletFunction);
                recons2 = idwt(recons1,zeros(size(recons1)),waveletFunction);
                recons3 = idwt(recons2,zeros(size(recons2)),waveletFunction);
                recons4 = idwt(recons3,zeros(size(recons3)),waveletFunction);
                recons5 = idwt(recons4,zeros(size(recons4)),waveletFunction);%Final
                ThetaSignal = recons5;
                %Delta Waves [c18,c16,c14]
                recons1 = idwt(zeros(size(c18)),c18,waveletFunction);
                [recons1,c16] = equilibrate(recons1,c16);
                recons2 = idwt(recons1,c16,waveletFunction);
                [recons2,c14] = equilibrate(recons2,c14);
                recons3 = idwt(recons2,c14,waveletFunction);
                recons4 = idwt(recons3,zeros(size(recons3)),waveletFunction);
                recons5 = idwt(recons4,zeros(size(recons4)),waveletFunction);
                recons6 = idwt(recons5,zeros(size(recons5)),waveletFunction);
                recons7 = idwt(recons6,zeros(size(recons6)),waveletFunction);
                recons8 = idwt(recons7,zeros(size(recons7)),waveletFunction);%Final
                DeltaSignal = recons8;
            case 200
                [c1,c2] = dwt(signal,waveletFunction);%c1-> 0-100Hz| c2 -> 100-200Hz
                [c3,c4] = dwt(c1,waveletFunction);%c3-> 0-50Hz| c4 -> 50-100Hz
                [c5,c6] = dwt(c3,waveletFunction);%c5->0-25Hz| c6 -> 25-50Hz
                [c7,c8] = dwt(c5,waveletFunction);%c7->0-12.5Hz| c8 -> 12.5-25Hz
                [c9,c10] = dwt(c6,waveletFunction);%c9->25-37.5Hz| c10 -> 37.5-50Hz
                [c11,c12] = dwt(c7,waveletFunction);%c11->0-6.25Hz| c12 -> 6.25-12.5Hz
                [c13,c14] = dwt(c8,waveletFunction);%c11->12.5-18.75Hz|c12->18.75-25Hz
                [c15,c16] = dwt(c11,waveletFunction);%c13->0-3.125Hz|c14->3.125-6.25Hz
                [c17,c18] = dwt(c12,waveletFunction);%c15->6.25-9.375Hz|c16->9.375-12.5Hz
                [c19,c20] = dwt(c13,waveletFunction);%c17->12.5-15.625Hz|c18 ->15.625-18.75Hz
                [c21,c22] = dwt(c14,waveletFunction);%c19->18.75-21.875Hz|c20->21.875-25Hz
                [c23,c24] = dwt(c15,waveletFunction);%c21->0-1.5625Hz|c22->1.5625-3.125Hz
                [c25,c26] = dwt(c16,waveletFunction);%c23->3.125-4.68755Hz|c24->4.6875-6.25Hz
                [c27,c28] = dwt(c17,waveletFunction);%c25->6.25-7.8125Hz|c26->7.8125-9.375Hz
                [c29,c30] = dwt(c18,waveletFunction);%c27->9.375-10.9375Hz|c24->10.9375-12.5Hz
                [c31,c32] = dwt(c19,waveletFunction);%c29->12.5-14.0625Hz|c24->14.0625-15.625Hz
                [c33,c34] = dwt(c23,waveletFunction);%c31->0-0.78125Hz|c32 ->0.78125-1.5625Hz
                [c35,c36] = dwt(c24,waveletFunction);%c33->1.5625-2.34375Hz|c34->2.34375-3.125Hz
                [c37,c38] = dwt(c25,waveletFunction);%c35->3.125-3.90625Hz|c36->3.90625-4.68755Hz
                [c39,c40] = dwt(c28,waveletFunction);%c37->7.8125-8.59375Hz|c38->8.59375-9.375Hz
                [c41,c42] = dwt(c33,waveletFunction);%c37->0-0.390625Hz|c38->0.390625-0.78125Hz
                %Beta1 Waves [c20 c21] 15.625-21.875Hz
                recons1 = idwt(c21,zeros(size(c21)),waveletFunction);
                recons2 = idwt(zeros(size(c20)),c20,waveletFunction);
                [recons2,recons1] = equilibrate(recons2,recons1);
                recons3 = idwt(recons2,recons1,waveletFunction);
                recons4 = idwt(zeros(size(recons3)),recons3,waveletFunction);
                recons5 = idwt(recons4,zeros(size(recons4)),waveletFunction);
                recons6 = idwt(recons5,zeros(size(recons5)),waveletFunction);
                recons7 = idwt(recons6,zeros(size(recons6)),waveletFunction);%Final
                Beta1Signal = recons7;
                %Beta2 Waves [c22 c9] 21.875-37.5Hz
                recons1 = idwt(zeros(size(c22)),c22,waveletFunction);
                recons2 = idwt(zeros(size(recons1)),recons1,waveletFunction);
                recons3 = idwt(c9,zeros(size(c9)),waveletFunction);
                recons4 = idwt(zeros(size(recons2)),recons2,waveletFunction);
                [recons4,recons3] = equilibrate(recons4,recons3);
                recons5 = idwt(recons4,recons3,waveletFunction);
                recons6 = idwt(recons5,zeros(size(recons5)),waveletFunction);
                recons7 = idwt(recons6,zeros(size(recons6)),waveletFunction);%Final
                Beta2Signal = recons7;
                %Alpha Waves [c40 c29] 8.59375-10.9375Hz
                recons1 = idwt(zeros(size(c40)),c40,waveletFunction);
                recons2 = idwt(c29,zeros(size(c29)),waveletFunction);
                recons3 = idwt(zeros(size(recons1)),recons1,waveletFunction);
                [recons3,recons2] = equilibrate(recons3,recons2);
                recons4 = idwt(recons3,recons2,waveletFunction);
                recons5 = idwt(zeros(size(recons4)),recons4,waveletFunction);
                recons6 = idwt(recons5,zeros(size(recons5)),waveletFunction);
                recons7 = idwt(recons6,zeros(size(recons6)),waveletFunction);
                recons8 = idwt(recons7,zeros(size(recons7)),waveletFunction);
                recons9 = idwt(recons8,zeros(size(recons8)),waveletFunction);%Final
                AlphaSignal = recons9;
                %Theta Waves [c37 c38 c26 c27 c39] 3.125-8.59375Hz
                [c37,c38] = equilibrate(c37,c38);
                recons1 = idwt(c37,c38,waveletFunction);
                recons2 = idwt(c39,zeros(size(c39)),waveletFunction);
                [c27,recons2] = equilibrate(c27,recons2);
                recons3 = idwt(c27,recons2,waveletFunction);
                recons4 = idwt(zeros(size(c26)),c26,waveletFunction);
                recons5 = idwt(recons3,zeros(size(recons3)),waveletFunction);
                recons6 = idwt(zeros(size(recons4)),recons4,waveletFunction);
                [recons6,recons5] = equilibrate(recons6,recons5);
                recons7 = idwt(recons6,recons5,waveletFunction);
                recons8 = idwt(recons7,zeros(size(recons7)),waveletFunction);
                recons9 = idwt(recons8,zeros(size(recons8)),waveletFunction);
                recons10 = idwt(recons9,zeros(size(recons9)),waveletFunction);
                recons11 = idwt(recons10,zeros(size(recons10)),waveletFunction);%Final
                ThetaSignal = recons11;
                %Delta Waves [c42 c34 c35 c36] 0.390625-3.125Hz
                recons1 = idwt(zeros(size(c42)),c42,waveletFunction);
                [c35,c36] = equilibrate(c35,c36);
                recons2 = idwt(c35,c36,waveletFunction);
                [recons1,c34] = equilibrate(recons1,c34);
                recons3 = idwt(recons1,c34,waveletFunction);
                [recons3,recons2] = equilibrate(recons3,recons2);
                recons4 = idwt(recons3,recons2,waveletFunction);
                recons5 = idwt(recons4,zeros(size(recons4)),waveletFunction);
                recons6 = idwt(recons5,zeros(size(recons5)),waveletFunction);
                recons7 = idwt(recons6,zeros(size(recons6)),waveletFunction);
                recons8 = idwt(recons7,zeros(size(recons7)),waveletFunction);
                recons9 = idwt(recons8,zeros(size(recons8)),waveletFunction);
                recons10 = idwt(recons9,zeros(size(recons9)),waveletFunction);%Final
                DeltaSignal = recons10;
                %Spindle [c30 c31 c32]
                [c31,c32] = equilibrate(c31,c32);
                recons1 = idwt(c31,c32,waveletFunction);
                recons2 = idwt(zeros(size(c30)),c30,waveletFunction);
                recons3 = idwt(recons1,zeros(size(recons1)),waveletFunction);
                recons4 = idwt(zeros(size(recons2)),recons2,waveletFunction);
                recons5 = idwt(recons3,zeros(size(recons3)),waveletFunction);
                recons6 = idwt(zeros(size(recons4)),recons4,waveletFunction);
                [recons6,recons5] = equilibrate(recons6,recons5);
                recons7 = idwt(recons6,recons5,waveletFunction);
                recons8 = idwt(recons7,zeros(size(recons7)),waveletFunction);
                recons9 = idwt(recons8,zeros(size(recons8)),waveletFunction);
                recons10 = idwt(recons9,zeros(size(recons9)),waveletFunction);%Final
                SigmaSignal = recons10;
            case 512
                [c1,c2] = dwt(signal,waveletFunction);%c1-> 0-256Hz| c2 -> 256-512Hz
                [c3,c4] = dwt(c1,waveletFunction);%c3-> 0-128Hz| c4 -> 128-256Hz
                [c5,c6] = dwt(c3,waveletFunction);%c5-> 0-64Hz| c6 -> 64-128Hz
                [c7,c8] = dwt(c5,waveletFunction);%c7-> 0-32Hz| c8 -> 32-64Hz
                [c9,c10] = dwt(c7,waveletFunction);%c9-> 0-16Hz| c10 -> 16-32Hz
                [c11,c12] = dwt(c9,waveletFunction);%c11-> 0-8Hz| c12 -> 8-16Hz
                [c13,c14] = dwt(c11,waveletFunction);%c13-> 0-4Hz| c14 -> 4-8Hz
                [c15,c16] = dwt(c12,waveletFunction);%c15-> 8-12Hz| c16 -> 12-16Hz
                [c17,c18] = dwt(c13,waveletFunction);%c17-> 0-2Hz | c18-> 2-4Hz
                [c19,c20] = dwt(c17,waveletFunction);%c19-> 0-1Hz | c20-> 1-2Hz
                [c21,c22] = dwt(c19,waveletFunction);%c21-> 0-0.5Hz | c22-> 0.5-1Hz
                [c23,c24] = dwt(c10,waveletFunction);%c23-> 16-24Hz | c24-> 24-32Hz
                %Beta1 Waves [c23]
                recons1 = idwt(c23,zeros(size(c23)),waveletFunction);
                recons2 = idwt(zeros(size(recons1)),recons1,waveletFunction);
                recons3 = idwt(recons2,zeros(size(recons2)),waveletFunction);
                recons4 = idwt(recons3,zeros(size(recons3)),waveletFunction);
                recons5 = idwt(recons4,zeros(size(recons4)),waveletFunction);
                recons6 = idwt(recons5,zeros(size(recons5)),waveletFunction);%Final
                Beta1Signal = recons6;
                %Beta2 Waves [c24]
                recons1 = idwt(zeros(size(c24)),c24,waveletFunction);
                recons2 = idwt(zeros(size(recons1)),recons1,waveletFunction);
                recons3 = idwt(recons2,zeros(size(recons2)),waveletFunction);
                recons4 = idwt(recons3,zeros(size(recons3)),waveletFunction);
                recons5 = idwt(recons4,zeros(size(recons4)),waveletFunction);
                recons6 = idwt(recons5,zeros(size(recons5)),waveletFunction);%Final
                Beta2Signal = recons6;
                %Sigma Waves [c16]
                recons1 = idwt(zeros(size(c16)),c16,waveletFunction);
                recons2 = idwt(zeros(size(recons1)),recons1,waveletFunction);
                recons3 = idwt(recons2,zeros(size(recons2)),waveletFunction);
                recons4 = idwt(recons3,zeros(size(recons3)),waveletFunction);
                recons5 = idwt(recons4,zeros(size(recons4)),waveletFunction);
                recons6 = idwt(recons5,zeros(size(recons5)),waveletFunction);
                recons7 = idwt(recons6,zeros(size(recons6)),waveletFunction);%Final
                SigmaSignal = recons7;
                %Alpha Waves [c15]
                recons1 = idwt(c15,zeros(size(c15)),waveletFunction);
                recons2 = idwt(zeros(size(recons1)),recons1,waveletFunction);
                recons3 = idwt(recons2,zeros(size(recons2)),waveletFunction);
                recons4 = idwt(recons3,zeros(size(recons3)),waveletFunction);
                recons5 = idwt(recons4,zeros(size(recons4)),waveletFunction);
                recons6 = idwt(recons5,zeros(size(recons5)),waveletFunction);
                recons7 = idwt(recons6,zeros(size(recons6)),waveletFunction);%Final
                AlphaSignal = recons7;
                %Theta Waves [c14]
                recons1 = idwt(zeros(size(c14)),c14,waveletFunction);
                recons2 = idwt(recons1,zeros(size(recons1)),waveletFunction);
                recons3 = idwt(recons2,zeros(size(recons2)),waveletFunction);
                recons4 = idwt(recons3,zeros(size(recons3)),waveletFunction);
                recons5 = idwt(recons4,zeros(size(recons4)),waveletFunction);
                recons6 = idwt(recons5,zeros(size(recons5)),waveletFunction);
                recons7 = idwt(recons6,zeros(size(recons6)),waveletFunction);%Final
                ThetaSignal = recons7;
                %Delta Waves [c22,c20,c18]
                recons1 = idwt(zeros(size(c22)),c22,waveletFunction);
                [recons1,c20] = equilibrate(recons1,c20);
                recons2 = idwt(recons1,c20,waveletFunction);
                [recons2,c18] = equilibrate(recons2,c18);
                recons3 = idwt(recons2,c18,waveletFunction);
                recons4 = idwt(recons3,zeros(size(recons3)),waveletFunction);
                recons5 = idwt(recons4,zeros(size(recons4)),waveletFunction);
                recons6 = idwt(recons5,zeros(size(recons5)),waveletFunction);
                recons7 = idwt(recons6,zeros(size(recons6)),waveletFunction);
                recons8 = idwt(recons7,zeros(size(recons7)),waveletFunction);
                recons9 = idwt(recons8,zeros(size(recons8)),waveletFunction);
                recons10 = idwt(recons9,zeros(size(recons9)),waveletFunction);%Final
                DeltaSignal = recons9;
        end
        
        inputs_i(i,21) = (sum(Beta1Signal.^2))/length(Beta1Signal);
        inputs_i(i,22) = (sum(Beta2Signal.^2))/length(Beta2Signal);
        inputs_i(i,23) = (sum(SigmaSignal.^2))/length(SigmaSignal);
        inputs_i(i,24) = (sum(AlphaSignal.^2))/length(AlphaSignal);
        inputs_i(i,25) = (sum(ThetaSignal.^2))/length(ThetaSignal);
        inputs_i(i,26) = (sum(DeltaSignal.^2))/length(DeltaSignal);
        
        
        
    end
    
    targets_i = zeros(sampleNum,4);%initiazing the targets
    
    %this cycle is going to convert the CAPLabel data to a targets matrix for the classification neural network
    for j = 1:1:sampleNum
        if CAPdata(j) == 0
            targets_i(j,1) = 1;
        elseif CAPdata(j) == 1
            targets_i(j,2) = 1;
        elseif CAPdata(j) == 2
            targets_i(j,3) = 1;
        elseif CAPdata(j) == 3
            targets_i(j,4) = 1;
        end
    end
    
    inputs1.(ifieldname) = inputs_i;%saving the inputs of the patient
    targets1.(tfieldname) = targets_i;%saving the targets of the patient
end

fieldse = fieldnames(eeg2);%this contains the field names for the eeg signals for each patient with Apnea
fieldst = fieldnames(CAPLabel2);%this contains the field names for the CAP labels for each patient with Apnea

close(wait);

prev2EpochMax = 0;
prevEpochMax = 0;

wait = waitbar(0,'Calculating Features for Apnea...');%a waitbar is used to display the progress of the feature selection 

for fi = 1:1:size(fieldse,1)
    
    waitbar(fi/size(fieldse,1),wait,strcat('Calculating Features for Apnea n',int2str(fi)));%update the waitbar
    
    aux = fieldse{fi};
    eegSensor = eeg2.(aux);%eeg sensor data of the current patient
    aux = fieldst{fi};
    CAPdata = CAPLabel2.(aux);%CAP Label data of the current patient
    ifieldname = strcat('inputs',int2str(fi));%name of the field where the inputs of the current patient are going to be saved
    tfieldname = strcat('targets',int2str(fi));%name of the field where the targets of the current patient are going to be saved
    
    sensorNum = size(eegSensor,1);%number of values collected by the sensor(100Hz collecting rate)
    sampleNum = size(CAPdata,1);%number of samples

    sampleSize = fix(sensorNum/sampleNum);%number of sensor values per sample(per cap label)
  
    inputs_i = zeros(sampleNum,numFeatures);%initiazing the inputs 
    
    samplingFreq = samplingFreqs(fi);
    
    %this cycle iterates through the sensor data to create the feature table
    for i = 1:1:sampleNum
        upperIndexes = min([i+calculationRanges;zeros(1,15)+sampleNum]);
        lowerIndexes = max([i-calculationRanges-1;zeros(1,15)]);
        upperBounds = upperIndexes*sampleSize;
        lowerBounds = lowerIndexes*sampleSize + 1;
        
        signal = eegSensor(lowerBounds(1):upperBounds(1));
        inputs_i(i,1) = mean(signal);%mean
        
        signal = eegSensor(lowerBounds(2):upperBounds(2));
        inputs_i(i,2) = var(signal);%variance
        
        signal = eegSensor(lowerBounds(3):upperBounds(3));
        inputs_i(i,3) = skewness(signal);%skewness
        
        signal = eegSensor(lowerBounds(4):upperBounds(4));
        inputs_i(i,4) = kurtosis(signal);%kurtosis
        
        
        signal = eegSensor(lowerBounds(5):upperBounds(5));
        inputs_i(i,5) = max(signal)+(prev2EpochMax-prevEpochMax);%amplitude variantion
        prev2EpochMax = prevEpochMax;
        prevEpochMax = max(signal);
        
        signal = eegSensor(lowerBounds(6):upperBounds(6));
        inputs_i(i,6) = std(signal);%standard deviation
        
        signal = eegSensor(lowerBounds(7):upperBounds(7));
        inputs_i(i,7) = max(signal)-min(signal);%range value
        
        
        signal = eegSensor(lowerBounds(8):upperBounds(8));
        inputs_i(i,8) = wentropy(signal,'shannon');%shannon entropy

        signal = eegSensor(lowerBounds(9):upperBounds(9));
        inputs_i(i,9) = wentropy(signal,'log energy');%log energy entropy
        
        signal = eegSensor(lowerBounds(10):upperBounds(10));
        inputs_i(i,10) = renyi_entropy_lps(signal');%shannon entropy

        signal = eegSensor(lowerBounds(11):upperBounds(11));
        inputs_i(i,11) = tsallis_entropy_lps(signal');%log energy entropy
        
        
        signal = eegSensor(lowerBounds(12):upperBounds(12));
        inputs_i(i,12) = mean(abs(xcov(signal)));%autocovariance

        signal = eegSensor(lowerBounds(13):upperBounds(13));
        inputs_i(i,13) = mean(abs(xcorr(signal)));%autocorrelation
        
        
        signal = eegSensor(lowerBounds(14):upperBounds(14));
        teager = zeros(1,size(signal,1)-2);
        for j = 1:1:(size(signal,1)-2)
             teager(j) = signal(j+1)*signal(j+1) + signal(j)*signal(j+2);
        end
        inputs_i(i,14) = mean(teager);%TEO
        
        signal = eegSensor(lowerBounds(15):upperBounds(15));
        signalSize = size(signal,1);
        
        nfft = floor(signalSize/divideNfft);
        noverlap = floor(nfft/2);
        fs = samplingFreq;
        
        [pxx,f] = pwelch(signal,hanning(nfft),noverlap,nfft,fs);
        pxx2 = 10*log10(pxx*fs/nfft);
        
        auxUnit = samplingFreq/(2*noverlap);
        baseFrequencies = [0.5,4,8,12,15,24,30];
        freqMatrix = floor(baseFrequencies/auxUnit);
        freqMatrix = auxUnit*freqMatrix;
        
        DeltaBaseFreq = find(f == freqMatrix(1));
        ThetaBaseFreq = find(f == freqMatrix(2));
        AlphaBaseFreq = find(f == freqMatrix(3));
        SigmaBaseFreq = find(f == freqMatrix(4));
        Beta1BaseFreq = find(f == freqMatrix(5));
        Beta2BaseFreq = find(f == freqMatrix(6));
        Beta2MaxFreq = find(f == freqMatrix(7));
        
        inputs_i(i,15) = trapz(pxx2(DeltaBaseFreq:(ThetaBaseFreq-1)));
        inputs_i(i,16) = trapz(pxx2(ThetaBaseFreq:(AlphaBaseFreq-1)));
        inputs_i(i,17) = trapz(pxx2(AlphaBaseFreq:(SigmaBaseFreq-1)));
        inputs_i(i,18) = trapz(pxx2(SigmaBaseFreq:(Beta1BaseFreq-1)));
        inputs_i(i,19) = trapz(pxx2(Beta1BaseFreq:(Beta2BaseFreq-1)));
        inputs_i(i,20) = trapz(pxx2(Beta2BaseFreq:Beta2MaxFreq));
        
        signal = eegSensor(lowerBounds(15):upperBounds(15));
        switch(samplingFreq)
            case 100
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
                %Beta1 Waves [c18 c19] 15.625-21.875Hz
                recons1 = idwt(c19,zeros(size(c19)),waveletFunction);
                recons2 = idwt(zeros(size(c18)),c18,waveletFunction);
                [recons2,recons1] = equilibrate(recons2,recons1);
                recons3 = idwt(recons2,recons1,waveletFunction);
                recons4 = idwt(zeros(size(recons3)),recons3,waveletFunction);
                recons5 = idwt(recons4,zeros(size(recons4)),waveletFunction);
                recons6 = idwt(recons5,zeros(size(recons5)),waveletFunction);%Final
                Beta1Signal = recons6;
                %Beta2 Waves [c20 c7] 21.875-37.5Hz
                recons1 = idwt(zeros(size(c20)),c20,waveletFunction);
                recons2 = idwt(zeros(size(recons1)),recons1,waveletFunction);
                recons3 = idwt(c7,zeros(size(c7)),waveletFunction);
                recons4 = idwt(zeros(size(recons2)),recons2,waveletFunction);
                [recons4,recons3] = equilibrate(recons4,recons3);
                recons5 = idwt(recons4,recons3,waveletFunction);
                recons6 = idwt(recons5,zeros(size(recons5)),waveletFunction);%Final
                Beta2Signal = recons6;
                %Alpha Waves [c38 c27] 8.59375-10.9375Hz
                recons1 = idwt(zeros(size(c38)),c38,waveletFunction);
                recons2 = idwt(c27,zeros(size(c27)),waveletFunction);
                recons3 = idwt(zeros(size(recons1)),recons1,waveletFunction);
                [recons3,recons2] = equilibrate(recons3,recons2);
                recons4 = idwt(recons3,recons2,waveletFunction);
                recons5 = idwt(zeros(size(recons4)),recons4,waveletFunction);
                recons6 = idwt(recons5,zeros(size(recons5)),waveletFunction);
                recons7 = idwt(recons6,zeros(size(recons6)),waveletFunction);
                recons8 = idwt(recons7,zeros(size(recons7)),waveletFunction);%Final
                AlphaSignal = recons8;
                %Theta Waves [c35 c36 c24 c25 c37] 3.125-8.59375Hz
                [c35,c36] = equilibrate(c35,c36);
                recons1 = idwt(c35,c36,waveletFunction);
                recons2 = idwt(c37,zeros(size(c37)),waveletFunction);
                [c25,recons2] = equilibrate(c25,recons2);
                recons3 = idwt(c25,recons2,waveletFunction);
                recons4 = idwt(zeros(size(c24)),c24,waveletFunction);
                recons5 = idwt(recons3,zeros(size(recons3)),waveletFunction);
                recons6 = idwt(zeros(size(recons4)),recons4,waveletFunction);
                [recons6,recons5] = equilibrate(recons6,recons5);
                recons7 = idwt(recons6,recons5,waveletFunction);
                recons8 = idwt(recons7,zeros(size(recons7)),waveletFunction);
                recons9 = idwt(recons8,zeros(size(recons8)),waveletFunction);
                recons10 = idwt(recons9,zeros(size(recons9)),waveletFunction);%Final
                ThetaSignal = recons10;
                %Delta Waves [c40 c32 c33 c34] 0.390625-3.125Hz
                recons1 = idwt(zeros(size(c40)),c40,waveletFunction);
                [c33,c34] = equilibrate(c33,c34);
                recons2 = idwt(c33,c34,waveletFunction);
                [recons1,c32] = equilibrate(recons1,c32);
                recons3 = idwt(recons1,c32,waveletFunction);
                [recons3,recons2] = equilibrate(recons3,recons2);
                recons4 = idwt(recons3,recons2,waveletFunction);
                recons5 = idwt(recons4,zeros(size(recons4)),waveletFunction);
                recons6 = idwt(recons5,zeros(size(recons5)),waveletFunction);
                recons7 = idwt(recons6,zeros(size(recons6)),waveletFunction);
                recons8 = idwt(recons7,zeros(size(recons7)),waveletFunction);
                recons9 = idwt(recons8,zeros(size(recons8)),waveletFunction);%Final
                DeltaSignal = recons9;
                %Spindle [c28 c29 c30]
                [c29,c30] = equilibrate(c29,c30);
                recons1 = idwt(c29,c30,waveletFunction);
                recons2 = idwt(zeros(size(c28)),c28,waveletFunction);
                recons3 = idwt(recons1,zeros(size(recons1)),waveletFunction);
                recons4 = idwt(zeros(size(recons2)),recons2,waveletFunction);
                recons5 = idwt(recons3,zeros(size(recons3)),waveletFunction);
                recons6 = idwt(zeros(size(recons4)),recons4,waveletFunction);
                recons7 = idwt(recons6,recons5,waveletFunction);
                recons8 = idwt(recons7,zeros(size(recons7)),waveletFunction);
                recons9 = idwt(recons8,zeros(size(recons8)),waveletFunction);%Final
                SigmaSignal = recons9;
            case 128
                [c1,c2] = dwt(signal,waveletFunction);%c1-> 0-64Hz| c2 -> 64-128Hz 
                [c3,c4] = dwt(c1,waveletFunction);%c3-> 0-32Hz| c4 -> 32-64Hz
                [c5,c6] = dwt(c3,waveletFunction);%c5-> 0-16Hz| c6 -> 16-32Hz
                [c7,c8] = dwt(c5,waveletFunction);%c7-> 0-8Hz| c8 -> 8-16Hz
                [c9,c10] = dwt(c7,waveletFunction);%c9-> 0-4Hz| c10 -> 4-8Hz
                [c11,c12] = dwt(c8,waveletFunction);%c11-> 8-12Hz| c12 -> 12-16Hz
                [c13,c14] = dwt(c9,waveletFunction);%c13-> 0-2Hz | c14-> 2-4Hz
                [c15,c16] = dwt(c13,waveletFunction);%c15-> 0-1Hz | c16-> 1-2Hz
                [c17,c18] = dwt(c15,waveletFunction);%c17-> 0-0.5Hz | c18-> 0.5-1Hz
                [c19,c20] = dwt(c6,waveletFunction);%c19-> 16-24Hz| c20 -> 24-32Hz
                %Beta1 Waves [c19]
                recons1 = idwt(c19,zeros(size(c19)),waveletFunction);
                recons2 = idwt(zeros(size(recons1)),recons1,waveletFunction);
                recons3 = idwt(recons2,zeros(size(recons2)),waveletFunction);
                recons4 = idwt(recons3,zeros(size(recons3)),waveletFunction);%Final
                Beta1Signal = recons4;
                %Beta2 Waves [c20]
                recons1 = idwt(zeros(size(c20)),c20,waveletFunction);
                recons2 = idwt(zeros(size(recons1)),recons1,waveletFunction);
                recons3 = idwt(recons2,zeros(size(recons2)),waveletFunction);
                recons4 = idwt(recons3,zeros(size(recons3)),waveletFunction);%Final
                Beta2Signal = recons4;
                %Sigma Waves [c12]
                recons1 = idwt(zeros(size(c12)),c12,waveletFunction);
                recons2 = idwt(zeros(size(recons1)),recons1,waveletFunction);
                recons3 = idwt(recons2,zeros(size(recons2)),waveletFunction);
                recons4 = idwt(recons3,zeros(size(recons3)),waveletFunction);
                recons5 = idwt(recons4,zeros(size(recons4)),waveletFunction);%Final
                SigmaSignal = recons5;
                %Alpha Waves [c11]
                recons1 = idwt(c11,zeros(size(c11)),waveletFunction);
                recons2 = idwt(zeros(size(recons1)),recons1,waveletFunction);
                recons3 = idwt(recons2,zeros(size(recons2)),waveletFunction);
                recons4 = idwt(recons3,zeros(size(recons3)),waveletFunction);
                recons5 = idwt(recons4,zeros(size(recons4)),waveletFunction);%Final
                AlphaSignal = recons5;
                %Theta Waves [c10]
                recons1 = idwt(zeros(size(c10)),c10,waveletFunction);
                recons2 = idwt(recons1,zeros(size(recons1)),waveletFunction);
                recons3 = idwt(recons2,zeros(size(recons2)),waveletFunction);
                recons4 = idwt(recons3,zeros(size(recons3)),waveletFunction);
                recons5 = idwt(recons4,zeros(size(recons4)),waveletFunction);%Final
                ThetaSignal = recons5;
                %Delta Waves [c18,c16,c14]
                recons1 = idwt(zeros(size(c18)),c18,waveletFunction);
                [recons1,c16] = equilibrate(recons1,c16);
                recons2 = idwt(recons1,c16,waveletFunction);
                [recons2,c14] = equilibrate(recons2,c14);
                recons3 = idwt(recons2,c14,waveletFunction);
                recons4 = idwt(recons3,zeros(size(recons3)),waveletFunction);
                recons5 = idwt(recons4,zeros(size(recons4)),waveletFunction);
                recons6 = idwt(recons5,zeros(size(recons5)),waveletFunction);
                recons7 = idwt(recons6,zeros(size(recons6)),waveletFunction);
                recons8 = idwt(recons7,zeros(size(recons7)),waveletFunction);%Final
                DeltaSignal = recons8;
            case 200
                [c1,c2] = dwt(signal,waveletFunction);%c1-> 0-100Hz| c2 -> 100-200Hz
                [c3,c4] = dwt(c1,waveletFunction);%c3-> 0-50Hz| c4 -> 50-100Hz
                [c5,c6] = dwt(c3,waveletFunction);%c5->0-25Hz| c6 -> 25-50Hz
                [c7,c8] = dwt(c5,waveletFunction);%c7->0-12.5Hz| c8 -> 12.5-25Hz
                [c9,c10] = dwt(c6,waveletFunction);%c9->25-37.5Hz| c10 -> 37.5-50Hz
                [c11,c12] = dwt(c7,waveletFunction);%c11->0-6.25Hz| c12 -> 6.25-12.5Hz
                [c13,c14] = dwt(c8,waveletFunction);%c11->12.5-18.75Hz|c12->18.75-25Hz
                [c15,c16] = dwt(c11,waveletFunction);%c13->0-3.125Hz|c14->3.125-6.25Hz
                [c17,c18] = dwt(c12,waveletFunction);%c15->6.25-9.375Hz|c16->9.375-12.5Hz
                [c19,c20] = dwt(c13,waveletFunction);%c17->12.5-15.625Hz|c18 ->15.625-18.75Hz
                [c21,c22] = dwt(c14,waveletFunction);%c19->18.75-21.875Hz|c20->21.875-25Hz
                [c23,c24] = dwt(c15,waveletFunction);%c21->0-1.5625Hz|c22->1.5625-3.125Hz
                [c25,c26] = dwt(c16,waveletFunction);%c23->3.125-4.68755Hz|c24->4.6875-6.25Hz
                [c27,c28] = dwt(c17,waveletFunction);%c25->6.25-7.8125Hz|c26->7.8125-9.375Hz
                [c29,c30] = dwt(c18,waveletFunction);%c27->9.375-10.9375Hz|c24->10.9375-12.5Hz
                [c31,c32] = dwt(c19,waveletFunction);%c29->12.5-14.0625Hz|c24->14.0625-15.625Hz
                [c33,c34] = dwt(c23,waveletFunction);%c31->0-0.78125Hz|c32 ->0.78125-1.5625Hz
                [c35,c36] = dwt(c24,waveletFunction);%c33->1.5625-2.34375Hz|c34->2.34375-3.125Hz
                [c37,c38] = dwt(c25,waveletFunction);%c35->3.125-3.90625Hz|c36->3.90625-4.68755Hz
                [c39,c40] = dwt(c28,waveletFunction);%c37->7.8125-8.59375Hz|c38->8.59375-9.375Hz
                [c41,c42] = dwt(c33,waveletFunction);%c37->0-0.390625Hz|c38->0.390625-0.78125Hz
                %Beta1 Waves [c20 c21] 15.625-21.875Hz
                recons1 = idwt(c21,zeros(size(c21)),waveletFunction);
                recons2 = idwt(zeros(size(c20)),c20,waveletFunction);
                [recons2,recons1] = equilibrate(recons2,recons1);
                recons3 = idwt(recons2,recons1,waveletFunction);
                recons4 = idwt(zeros(size(recons3)),recons3,waveletFunction);
                recons5 = idwt(recons4,zeros(size(recons4)),waveletFunction);
                recons6 = idwt(recons5,zeros(size(recons5)),waveletFunction);
                recons7 = idwt(recons6,zeros(size(recons6)),waveletFunction);%Final
                Beta1Signal = recons7;
                %Beta2 Waves [c22 c9] 21.875-37.5Hz
                recons1 = idwt(zeros(size(c22)),c22,waveletFunction);
                recons2 = idwt(zeros(size(recons1)),recons1,waveletFunction);
                recons3 = idwt(c9,zeros(size(c9)),waveletFunction);
                recons4 = idwt(zeros(size(recons2)),recons2,waveletFunction);
                [recons4,recons3] = equilibrate(recons4,recons3);
                recons5 = idwt(recons4,recons3,waveletFunction);
                recons6 = idwt(recons5,zeros(size(recons5)),waveletFunction);
                recons7 = idwt(recons6,zeros(size(recons6)),waveletFunction);%Final
                Beta2Signal = recons7;
                %Alpha Waves [c40 c29] 8.59375-10.9375Hz
                recons1 = idwt(zeros(size(c40)),c40,waveletFunction);
                recons2 = idwt(c29,zeros(size(c29)),waveletFunction);
                recons3 = idwt(zeros(size(recons1)),recons1,waveletFunction);
                [recons3,recons2] = equilibrate(recons3,recons2);
                recons4 = idwt(recons3,recons2,waveletFunction);
                recons5 = idwt(zeros(size(recons4)),recons4,waveletFunction);
                recons6 = idwt(recons5,zeros(size(recons5)),waveletFunction);
                recons7 = idwt(recons6,zeros(size(recons6)),waveletFunction);
                recons8 = idwt(recons7,zeros(size(recons7)),waveletFunction);
                recons9 = idwt(recons8,zeros(size(recons8)),waveletFunction);%Final
                AlphaSignal = recons9;
                %Theta Waves [c37 c38 c26 c27 c39] 3.125-8.59375Hz
                [c37,c38] = equilibrate(c37,c38);
                recons1 = idwt(c37,c38,waveletFunction);
                recons2 = idwt(c39,zeros(size(c39)),waveletFunction);
                [c27,recons2] = equilibrate(c27,recons2);
                recons3 = idwt(c27,recons2,waveletFunction);
                recons4 = idwt(zeros(size(c26)),c26,waveletFunction);
                recons5 = idwt(recons3,zeros(size(recons3)),waveletFunction);
                recons6 = idwt(zeros(size(recons4)),recons4,waveletFunction);
                [recons6,recons5] = equilibrate(recons6,recons5);
                recons7 = idwt(recons6,recons5,waveletFunction);
                recons8 = idwt(recons7,zeros(size(recons7)),waveletFunction);
                recons9 = idwt(recons8,zeros(size(recons8)),waveletFunction);
                recons10 = idwt(recons9,zeros(size(recons9)),waveletFunction);
                recons11 = idwt(recons10,zeros(size(recons10)),waveletFunction);%Final
                ThetaSignal = recons11;
                %Delta Waves [c42 c34 c35 c36] 0.390625-3.125Hz
                recons1 = idwt(zeros(size(c42)),c42,waveletFunction);
                [c35,c36] = equilibrate(c35,c36);
                recons2 = idwt(c35,c36,waveletFunction);
                [recons1,c34] = equilibrate(recons1,c34);
                recons3 = idwt(recons1,c34,waveletFunction);
                [recons3,recons2] = equilibrate(recons3,recons2);
                recons4 = idwt(recons3,recons2,waveletFunction);
                recons5 = idwt(recons4,zeros(size(recons4)),waveletFunction);
                recons6 = idwt(recons5,zeros(size(recons5)),waveletFunction);
                recons7 = idwt(recons6,zeros(size(recons6)),waveletFunction);
                recons8 = idwt(recons7,zeros(size(recons7)),waveletFunction);
                recons9 = idwt(recons8,zeros(size(recons8)),waveletFunction);
                recons10 = idwt(recons9,zeros(size(recons9)),waveletFunction);%Final
                DeltaSignal = recons10;
                %Spindle [c30 c31 c32]
                [c31,c32] = equilibrate(c31,c32);
                recons1 = idwt(c31,c32,waveletFunction);
                recons2 = idwt(zeros(size(c30)),c30,waveletFunction);
                recons3 = idwt(recons1,zeros(size(recons1)),waveletFunction);
                recons4 = idwt(zeros(size(recons2)),recons2,waveletFunction);
                recons5 = idwt(recons3,zeros(size(recons3)),waveletFunction);
                recons6 = idwt(zeros(size(recons4)),recons4,waveletFunction);
                [recons6,recons5] = equilibrate(recons6,recons5);
                recons7 = idwt(recons6,recons5,waveletFunction);
                recons8 = idwt(recons7,zeros(size(recons7)),waveletFunction);
                recons9 = idwt(recons8,zeros(size(recons8)),waveletFunction);
                recons10 = idwt(recons9,zeros(size(recons9)),waveletFunction);%Final
                SigmaSignal = recons10;
            case 512
                [c1,c2] = dwt(signal,waveletFunction);%c1-> 0-256Hz| c2 -> 256-512Hz
                [c3,c4] = dwt(c1,waveletFunction);%c3-> 0-128Hz| c4 -> 128-256Hz
                [c5,c6] = dwt(c3,waveletFunction);%c5-> 0-64Hz| c6 -> 64-128Hz
                [c7,c8] = dwt(c5,waveletFunction);%c7-> 0-32Hz| c8 -> 32-64Hz
                [c9,c10] = dwt(c7,waveletFunction);%c9-> 0-16Hz| c10 -> 16-32Hz
                [c11,c12] = dwt(c9,waveletFunction);%c11-> 0-8Hz| c12 -> 8-16Hz
                [c13,c14] = dwt(c11,waveletFunction);%c13-> 0-4Hz| c14 -> 4-8Hz
                [c15,c16] = dwt(c12,waveletFunction);%c15-> 8-12Hz| c16 -> 12-16Hz
                [c17,c18] = dwt(c13,waveletFunction);%c17-> 0-2Hz | c18-> 2-4Hz
                [c19,c20] = dwt(c17,waveletFunction);%c19-> 0-1Hz | c20-> 1-2Hz
                [c21,c22] = dwt(c19,waveletFunction);%c21-> 0-0.5Hz | c22-> 0.5-1Hz
                [c23,c24] = dwt(c10,waveletFunction);%c23-> 16-24Hz | c24-> 24-32Hz
                %Beta1 Waves [c23]
                recons1 = idwt(c23,zeros(size(c23)),waveletFunction);
                recons2 = idwt(zeros(size(recons1)),recons1,waveletFunction);
                recons3 = idwt(recons2,zeros(size(recons2)),waveletFunction);
                recons4 = idwt(recons3,zeros(size(recons3)),waveletFunction);
                recons5 = idwt(recons4,zeros(size(recons4)),waveletFunction);
                recons6 = idwt(recons5,zeros(size(recons5)),waveletFunction);%Final
                Beta1Signal = recons6;
                %Beta2 Waves [c24]
                recons1 = idwt(zeros(size(c24)),c24,waveletFunction);
                recons2 = idwt(zeros(size(recons1)),recons1,waveletFunction);
                recons3 = idwt(recons2,zeros(size(recons2)),waveletFunction);
                recons4 = idwt(recons3,zeros(size(recons3)),waveletFunction);
                recons5 = idwt(recons4,zeros(size(recons4)),waveletFunction);
                recons6 = idwt(recons5,zeros(size(recons5)),waveletFunction);%Final
                Beta2Signal = recons6;
                %Sigma Waves [c16]
                recons1 = idwt(zeros(size(c16)),c16,waveletFunction);
                recons2 = idwt(zeros(size(recons1)),recons1,waveletFunction);
                recons3 = idwt(recons2,zeros(size(recons2)),waveletFunction);
                recons4 = idwt(recons3,zeros(size(recons3)),waveletFunction);
                recons5 = idwt(recons4,zeros(size(recons4)),waveletFunction);
                recons6 = idwt(recons5,zeros(size(recons5)),waveletFunction);
                recons7 = idwt(recons6,zeros(size(recons6)),waveletFunction);%Final
                SigmaSignal = recons7;
                %Alpha Waves [c15]
                recons1 = idwt(c15,zeros(size(c15)),waveletFunction);
                recons2 = idwt(zeros(size(recons1)),recons1,waveletFunction);
                recons3 = idwt(recons2,zeros(size(recons2)),waveletFunction);
                recons4 = idwt(recons3,zeros(size(recons3)),waveletFunction);
                recons5 = idwt(recons4,zeros(size(recons4)),waveletFunction);
                recons6 = idwt(recons5,zeros(size(recons5)),waveletFunction);
                recons7 = idwt(recons6,zeros(size(recons6)),waveletFunction);%Final
                AlphaSignal = recons7;
                %Theta Waves [c14]
                recons1 = idwt(zeros(size(c14)),c14,waveletFunction);
                recons2 = idwt(recons1,zeros(size(recons1)),waveletFunction);
                recons3 = idwt(recons2,zeros(size(recons2)),waveletFunction);
                recons4 = idwt(recons3,zeros(size(recons3)),waveletFunction);
                recons5 = idwt(recons4,zeros(size(recons4)),waveletFunction);
                recons6 = idwt(recons5,zeros(size(recons5)),waveletFunction);
                recons7 = idwt(recons6,zeros(size(recons6)),waveletFunction);%Final
                ThetaSignal = recons7;
                %Delta Waves [c22,c20,c18]
                recons1 = idwt(zeros(size(c22)),c22,waveletFunction);
                [recons1,c20] = equilibrate(recons1,c20);
                recons2 = idwt(recons1,c20,waveletFunction);
                [recons2,c18] = equilibrate(recons2,c18);
                recons3 = idwt(recons2,c18,waveletFunction);
                recons4 = idwt(recons3,zeros(size(recons3)),waveletFunction);
                recons5 = idwt(recons4,zeros(size(recons4)),waveletFunction);
                recons6 = idwt(recons5,zeros(size(recons5)),waveletFunction);
                recons7 = idwt(recons6,zeros(size(recons6)),waveletFunction);
                recons8 = idwt(recons7,zeros(size(recons7)),waveletFunction);
                recons9 = idwt(recons8,zeros(size(recons8)),waveletFunction);
                recons10 = idwt(recons9,zeros(size(recons9)),waveletFunction);%Final
                DeltaSignal = recons9;
        end
        
        inputs_i(i,21) = (sum(Beta1Signal.^2))/length(Beta1Signal);
        inputs_i(i,22) = (sum(Beta2Signal.^2))/length(Beta2Signal);
        inputs_i(i,23) = (sum(SigmaSignal.^2))/length(SigmaSignal);
        inputs_i(i,24) = (sum(AlphaSignal.^2))/length(AlphaSignal);
        inputs_i(i,25) = (sum(ThetaSignal.^2))/length(ThetaSignal);
        inputs_i(i,26) = (sum(DeltaSignal.^2))/length(DeltaSignal);
        
        
        
    end
    
    targets_i = zeros(sampleNum,4);%initiazing the targets
    
    %this cycle is going to convert the CAPLabel data to a targets matrix for the classification neural network
    for j = 1:1:sampleNum
        if CAPdata(j) == 0
            targets_i(j,1) = 1;
        elseif CAPdata(j) == 1
            targets_i(j,2) = 1;
        elseif CAPdata(j) == 2
            targets_i(j,3) = 1;
        elseif CAPdata(j) == 3
            targets_i(j,4) = 1;
        end
    end
    
    inputs2.(ifieldname) = inputs_i;%saving the inputs of the patient
    targets2.(tfieldname) = targets_i;%saving the targets of the patient
end

close(wait);

feature_names = ["Mean Power";
    "Variance Power";
    "Skewness Power";
    "Kurtosis Power";
    "Coefficient of Variation Power";
    "Standard Deviation Power";
    "Range Value Power";
    "Shannon Entropy";
    "Log Energy Entropy";
    "Renyi Entropy";
    "Tsallis Entropy";
    "Autocovariance";
    "Autocorrelation";
    "TEO";
    "PSD Pwelch Delta Range";
    "PSD Pwelch Theta Range";
    "PSD Pwelch Alpha Range"
    "PSD Pwelch Sigma Range";
    "PSD Pwelch Beta1 Range";
    "PSD Pwelch Beta2 Range";
    "PSD Wavelet Beta1 Range";
    "PSD Wavelet Beta2 Range";
    "PSD Wavelet Sigma Range";
    "PSD Wavelet Alpha Range";
    "PSD Wavelet Theta Range";
    "PSD Wavelet Delta Range"];

function [firstOutput,secondOutput] = equilibrate(firstInput,secondInput)
    if size(firstInput,1) > size(secondInput,1)
        diffValue = size(firstInput,1) - size(secondInput,1);
        
        firstOutput = firstInput;
        secondOutput = [secondInput;zeros(diffValue,1)];
    elseif size(firstInput,1) < size(secondInput,1)
        diffValue = size(secondInput,1) - size(firstInput,1);
        
        firstOutput = [firstInput;zeros(diffValue,1)];
        secondOutput = secondInput;
    else
        firstOutput = firstInput;
        secondOutput = secondInput;
    end
end
        
        
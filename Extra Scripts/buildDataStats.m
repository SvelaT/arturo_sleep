fieldsc1 = fieldnames(CAPLabel1);
fieldsc2 = fieldnames(CAPLabel2);

allCAPS = [];
percentB = [];

for i = 1:1:size(fieldsc1,1)
    field = fieldsc1{i};
    data = CAPLabel1.(field);
    allCAPS = [allCAPS; data];
    nbsamples = size(find(data==0),1)
    percent = 100 - (nbsamples*100)/(size(data,1));
    percentB = [percentB;percent];
end

for i = 1:1:size(fieldsc2,1)
    field = fieldsc2{i};
    data = CAPLabel2.(field);
    allCAPS = [allCAPS; data];
    nbsamples = size(find(data==0),1)
    percent = 100 - (nbsamples*100)/(size(data,1));
    percentB = [percentB;percent];
end

nbsamples = size(find(allCAPS==0),1);
ntotal = size(allCAPS,1);

figura = figure;
histogram(allCAPS);
xlabel("Label");
ylabel("Frequency");
xticks([0 1 2 3]);
yticks([0.0e+5 1.0e+5 2.0e+5 3.0e+5 4.0e+5 5.0e+5]);
xticklabels({'not-A','A1','A2','A3'});

saveas(figura,'PhaseHistogram.png');

fieldse1 = fieldnames(eeg1);
fieldse2 = fieldnames(eeg2);

varAmp = [];
meanAmp = [];

for i = 1:1:size(fieldse1,1)
    field = fieldse1{i};
    data = eeg1.(field);
    varAmp = [varAmp;var(data)];
    meanAmp = [meanAmp;mean(data)];
end

for i = 1:1:size(fieldse2,1)
    field = fieldse2{i};
    data = eeg2.(field);
    varAmp = [varAmp;std(data)];
    meanAmp = [meanAmp;mean(data)];
end


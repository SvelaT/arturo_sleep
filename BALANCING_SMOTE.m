%this code is used to balance the dataset using the oversampling and undersampling techniques
fieldsi = fieldnames(inputs1);
fieldst = fieldnames(targets1);

wait = waitbar(0,'Balancing the Samples ...');

for w = 1:1:size(fieldsi,1)
 waitbar(w/size(fieldsi,1),wait,strcat('Balancing the Samples for n',int2str(w)));
 
 inputs_i = inputs1.(fieldsi{w});
 targets_i = targets1.(fieldst{w});
 
 PhaseB_targets = targets_i(:,1);
 NumBTargets = sum(PhaseB_targets,'all');
 PhaseA_targets = targets_i;
 PhaseA_targets(:,1) = [];
 NumATargets = sum(PhaseA_targets);
 NumTargets = NumBTargets + sum(NumATargets);
 
 oSampleRatio_PhaseA = zeros(1,size(NumATargets,2));
 
 for i = 1:1:size(NumATargets,2)
    oSampleRatio_PhaseA(i) = round(NumBTargets/NumATargets(i));
 end
 

 %SMOTE oversampling
 new_samples = [];
 new_targets = [];
 i = 1;
 for a = 1:1:size(oSampleRatio_PhaseA,2)
    indexes_i = find(targets_i(:,a+1) == 1);
    samples_i = inputs_i(indexes_i,:);
     
    aux = samples_i;
    aux_2 = samples_i;
    if oSampleRatio_PhaseA(a) > 1
        while size(aux,1) > 0
            aux_2 = samples_i;
            sampleInd = randi([1 size(aux,1)]);
            sample = aux(sampleInd,:);
    
            aux(sampleInd,:) = [];
            aux_2(sampleInd,:) = []; 
    
            neighbourInd = nearNeig(sample,aux_2,oSampleRatio_PhaseA(a)-1);
            for j = 1:1:size(neighbourInd)
                neighbour = aux_2(neighbourInd(j));
    
                vector = neighbour - sample;
                randNumber = rand();
    
                vector = randNumber*vector;
                new_samples(i,:) = sample+vector;
                new_target = zeros(1,size(targets_i,2));
                new_target(1,a+1) = 1;
                new_targets(i,:) = new_target;
                i = i+1;
            end
        end
    end
 end

 inputs_i = [inputs_i; new_samples];
 targets_i = [targets_i; new_targets];

 permutation = randperm(size(inputs_i,1));
 inputs_i = inputs_i(permutation,:);
 targets_i = targets_i(permutation,:);
 
 inputs_balanced1.(fieldsi{w}) = inputs_i;
 targets_balanced1.(fieldst{w}) = targets_i;

end

fieldsi = fieldnames(inputs2);
fieldst = fieldnames(targets2);

wait = waitbar(0,'Balancing the Apnea Samples ...');

for w = 1:1:size(fieldsi,1)
 waitbar(w/size(fieldsi,1),wait,strcat('Balancing the Apnea Samples for n',int2str(w)));
 
 inputs_i = inputs2.(fieldsi{w});
 targets_i = targets2.(fieldst{w});
 
 PhaseB_targets = targets_i(:,1);
 NumBTargets = sum(PhaseB_targets,'all');
 PhaseA_targets = targets_i;
 PhaseA_targets(:,1) = [];
 NumATargets = sum(PhaseA_targets);
 NumTargets = NumBTargets + sum(NumATargets);
 
 oSampleRatio_PhaseA = zeros(1,size(NumATargets,2));
 
 for i = 1:1:size(NumATargets,2)
    oSampleRatio_PhaseA(i) = round(NumBTargets/NumATargets(i));
 end
 

 %SMOTE oversampling
 new_samples = [];
 new_targets = [];
 i = 1;
 for a = 1:1:size(oSampleRatio_PhaseA,2)
    indexes_i = find(targets_i(:,a+1) == 1);
    samples_i = inputs_i(indexes_i,:);
     
    aux = samples_i;
    aux_2 = samples_i;
    if oSampleRatio_PhaseA(a) > 1
        while size(aux,1) > 0
            aux_2 = samples_i;
            sampleInd = randi([1 size(aux,1)]);
            sample = aux(sampleInd,:);
    
            aux(sampleInd,:) = [];
            aux_2(sampleInd,:) = []; 
    
            neighbourInd = nearNeig(sample,aux_2,oSampleRatio_PhaseA(a)-1);
            for j = 1:1:size(neighbourInd)
                neighbour = aux_2(neighbourInd(j));
    
                vector = neighbour - sample;
                randNumber = rand();
    
                vector = randNumber*vector;
                new_samples(i,:) = sample+vector;
                new_target = zeros(1,size(targets_i,2));
                new_target(1,a+1) = 1;
                new_targets(i,:) = new_target;
                i = i+1;
            end
        end
    end
 end

 inputs_i = [inputs_i; new_samples];
 targets_i = [targets_i; new_targets];

 permutation = randperm(size(inputs_i,1));
 inputs_i = inputs_i(permutation,:);
 targets_i = targets_i(permutation,:);
 
 inputs_balanced2.(fieldsi{w}) = inputs_i;
 targets_balanced2.(fieldst{w}) = targets_i;

end

close(wait);

clearvars fieldsi fieldst inputs_i targets_i PhaseB_targets NumBTargets PhaseA_targets NumATargets NumTargets uSampleRatio_PhaseB oSampleRatio_PhaseA count removeNum permutation i a w j indexes_i samples_i aux aux_2 sample sampleInd neighbourInd neighbour vector randNumber new_target wait; 

function numCAP = numCAP(class,t)
    numCAP = sum(t(:,class));
end

function eucSqr = eucSqr(a,b)
    vec = a-b;
    vec = vec.*vec;
    eucSqr = sum(vec);
end

function nearNeig = nearNeig(line,set,k)
    nearNeig = zeros(k,1);
    distances = zeros(size(set,1),1);
    disp(distances);
    for i = 1:1:size(set,1)
        distances(i) = eucSqr(line,set(i,:));
    end
    for i = 1:1:k
        [~,minInd] = min(distances);
        distances(minInd) = NaN;
        nearNeig(i) = minInd;
    end
end






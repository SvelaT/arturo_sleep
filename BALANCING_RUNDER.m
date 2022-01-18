fieldsi = fieldnames(inputs1);
fieldst = fieldnames(targets1);

wait = waitbar(0,'Balancing the Samples ...');

for w = 1:1:size(fieldsi,1)
    waitbar(w/size(fieldsi,1),wait,strcat('Balancing the Samples for n',int2str(w)));
    
    inputs_i = inputs1.(fieldsi{w});
    targets_i = targets1.(fieldst{w});
    
    sample_nums = sum(targets_i);
    
    [value,index] = min(sample_nums);
    
    removePercents = ones(size(sample_nums,1),size(sample_nums,2))-(sample_nums(index)./sample_nums);
    
    removeNums = sample_nums.*removePercents;
    
    for k = 1:1:size(removeNums,2)
        removeNum = removeNums(k);
        if removeNum == 0
            continue;
        end
        sampleIndexes = find(targets_i(:,k)==1);
        randomPerm = randperm(size(sampleIndexes,1));
        removeIndexes = sampleIndexes(randomPerm(1:removeNum));
        targets_i(removeIndexes,:) = [];
        inputs_i(removeIndexes,:) = [];
    end  
    
    inputs_balanced1.(fieldsi{w}) = inputs_i;
    targets_balanced1.(fieldst{w}) = targets_i;
end

close(wait);

fieldsi = fieldnames(inputs2);
fieldst = fieldnames(targets2);

wait = waitbar(0,'Balancing the Samples Apnea ...');

for w = 1:1:size(fieldsi,1)
    waitbar(w/size(fieldsi,1),wait,strcat('Balancing the Samples for Apnea n',int2str(w)));
    
    inputs_i = inputs2.(fieldsi{w});
    targets_i = targets2.(fieldst{w});
    
    sample_nums = sum(targets_i);
    
    [value,index] = min(sample_nums);
    
    removePercents = ones(size(sample_nums,1),size(sample_nums,2))-(sample_nums(index)./sample_nums);
    
    removeNums = sample_nums.*removePercents;
    
    for k = 1:1:size(removeNums,2)
        removeNum = removeNums(k);
        if removeNum == 0
            continue;
        end
        sampleIndexes = find(targets_i(:,k)==1);
        randomPerm = randperm(size(sampleIndexes,1));
        removeIndexes = sampleIndexes(randomPerm(1:removeNum));
        targets_i(removeIndexes,:) = [];
        inputs_i(removeIndexes,:) = [];
    end  
    
    inputs_balanced2.(fieldsi{w}) = inputs_i;
    targets_balanced2.(fieldst{w}) = targets_i;
end

close(wait);
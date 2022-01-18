function [trainSetIndexes,valSetIndexes,testSetIndexes] = gensets2(crossval,fold,patient_indexes,from_train,val_number)
    trainBlock = [];
    valBlock = [];
    testBlock = [];
    
    if from_train
        for i = 1:1:size(crossval,2)
            if i ~= fold
                trainBlock = [trainBlock, crossval{i}];
            end
        end
        
        aux = trainBlock;
        trainBlock = aux(1:(end-val_number));
        valBlock = aux((end+1-val_number):end);
        
        testBlock = crossval{fold};
    else
        for i = 1:1:size(crossval,2)
            if i ~= fold
                trainBlock = [trainBlock, crossval{i}];
            end
        end
        
        aux = crossval{fold};
        testBlock = aux(1:(end-val_number));
        valBlock = aux((end+1-val_number):end);
    end
    
    trainSetIndexes = []; 
    for i = 1:1:size(trainBlock,2)
        patient = trainBlock(i);
        
        trainSetIndexes = [trainSetIndexes,patient_indexes(patient,1):patient_indexes(patient,2)]; 
    end
    
    valSetIndexes = [];
    for i = 1:1:size(valBlock,2)
        patient = valBlock(i);
        
        valSetIndexes = [valSetIndexes,patient_indexes(patient,1):patient_indexes(patient,2)]; 
    end
    
    testSetIndexes = [];
    for i = 1:1:size(testBlock,2)
        patient = testBlock(i);
        
        testSetIndexes = [testSetIndexes,patient_indexes(patient,1):patient_indexes(patient,2)]; 
    end
end
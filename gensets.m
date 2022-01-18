function [x,t,trainSetIndexes,valSetIndexes,testSetIndexes] = gensets(crossval,fold,inputs,targets,inputs_balanced,targets_balanced,from_train,val_number)
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
    fieldsi = fieldnames(inputs);
    fieldst = fieldnames(targets);
    fieldsib = fieldnames(inputs_balanced);
    fieldstb = fieldnames(targets_balanced);
    
    x = [];
    t = [];
    
    for i = 1:1:size(trainBlock,2)
        if isempty(fieldsib)
            field = fieldsi{trainBlock(i)};
            inputs_i = inputs.(field);
            x = [x;inputs_i];
            field = fieldst{trainBlock(i)};
            targets_i = targets.(field);
            t =  [t;targets_i];
        else
            field = fieldsib{trainBlock(i)};
            inputs_i = inputs_balanced.(field);
            x = [x;inputs_i];
            field = fieldstb{trainBlock(i)};
            targets_i = targets_balanced.(field);
            t =  [t;targets_i];
        end
    end
    
    trainSetIndexes = 1:size(x,1);
    valStart = size(x,1)+1;
    %x = x(randperm(size(x,1)),:);
    
    for i = 1:1:size(valBlock,2)
        field = fieldsi{valBlock(i)};
        inputs_i = inputs.(field);
        x = [x;inputs_i];
        field = fieldst{valBlock(i)};
        targets_i = targets.(field);
        t = [t;targets_i];
    end
    
    valSetIndexes = valStart:size(x,1);
    testStart = size(x,1)+1;
    
    for i = 1:1:size(testBlock,2)
        field = fieldsi{testBlock(i)};
        inputs_i = inputs.(field);
        x = [x;inputs_i];
        field = fieldst{testBlock(i)};
        targets_i = targets.(field);
        t = [t;targets_i];
    end
    
    testSetIndexes = testStart:size(x,1);
    x = x';
    t = t';
end


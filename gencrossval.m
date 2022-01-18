function crossval = gencrossval(nfolds,datagroups,split_apnea,apnea_patients)
    crossval = {};
    if split_apnea
        blockSize =  round((size(datagroups,2)-size(apnea_patients,2))/nfolds);
        availableIndexes = setdiff(datagroups,apnea_patients);
    else
        blockSize = round(size(datagroups,2)/nfolds);
        availableIndexes = datagroups;
    end
    
    
    
    for i= 1:1:nfolds
        if i < nfolds
            aux = randperm(size(availableIndexes,2));
            blockIndexes = availableIndexes(aux(1:blockSize));
            availableIndexes = setdiff(availableIndexes,blockIndexes);
            crossval{i} = blockIndexes;
        else
            crossval{i} = availableIndexes(randperm(size(availableIndexes,2)));
        end
    end
    
    if split_apnea
        apnea_patients = apnea_patients(randperm(size(apnea_patients,2)));
        for i = 1:1:size(apnea_patients,2)
            aux = rem(i-1,nfolds)+1;
            crossval{aux} = [crossval{aux},apnea_patients(i)];
        end
    end
end


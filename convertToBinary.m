%This code is used to convert the targets for classification problem to binary classification targets

backup_t1 = targets1;
backup_t2 = targets2;


fieldst1 = fieldnames(targets1);
fieldst2 = fieldnames(targets2);

for i = 1:1:size(fieldst1,1)
    field = fieldst1{i};
    aux = targets1.(field);
    new_targets = zeros(size(aux,1),2);
    for j = 1:1:size(aux,1)
        if aux(j,1) == 1
            new_targets(j,1) = 1;
            new_targets(j,2) = 0;
        else
            new_targets(j,1) = 0;
            new_targets(j,2) = 1;
        end
    end
    targets1.(field) = new_targets;
end

for i = 1:1:size(fieldst2,1)
    field = fieldst2{i};
    aux = targets2.(field);
    new_targets = zeros(size(aux,1),2);
    for j = 1:1:size(aux,1)
        if aux(j,1) == 1
            new_targets(j,1) = 1;
            new_targets(j,2) = 0;
        else
            new_targets(j,1) = 0;
            new_targets(j,2) = 1;
        end
    end
    targets2.(field) = new_targets;
end

clearvars fieldst field aux new_targets i j 
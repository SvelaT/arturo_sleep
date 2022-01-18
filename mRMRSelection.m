fullinputs = [];
fulltargets = [];

fieldsi1 = fieldnames(inputs1);
fieldsi2 = fieldnames(inputs2);
fieldst1 = fieldnames(targets1);
fieldst2 = fieldnames(targets2);

for i = 1:1:size(fieldsi1,1)
    currentfn = fieldsi1{i};
    currenti = inputs1.(currentfn);
    fullinputs = [fullinputs; currenti];
end

for i = 1:1:size(fieldsi2,1)
    currentfn = fieldsi2{i};
    currenti = inputs2.(currentfn);
    fullinputs = [fullinputs; currenti];
end

for i = 1:1:size(fieldst1,1)
    currentfn = fieldst1{i};
    currentt = targets1.(currentfn);
    fulltargets = [fulltargets; currentt];
end

for i = 1:1:size(fieldst2,1)
    currentfn = fieldst2{i};
    currentt = targets2.(currentfn);
    fulltargets = [fulltargets; currentt];
end

[idx,scores] = fscmrmr(fullinputs,fulltargets(:,1));
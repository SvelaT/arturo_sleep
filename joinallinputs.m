function [x,t,patient_indexes] = joinallinputs(inputs,targets)
fieldsi = fieldnames(inputs);
fieldst = fieldnames(targets);
x = [];
t = [];
patient_indexes = zeros(size(fieldsi,1),2);

for i = 1:1:size(fieldsi,1)
    patient_indexes(i,1) = size(x,1)+1;
    field = fieldsi{i};
    inputs_i = inputs.(field);
    x = [x;inputs_i];
    field = fieldst{i};
    targets_i = targets.(field);
    t =  [t;targets_i];
    patient_indexes(i,2) = size(x,1);
end

x = x';
t = t';
end


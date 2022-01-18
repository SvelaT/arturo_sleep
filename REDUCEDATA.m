reduce = 0.6;
fieldsi = fieldnames(inputs);
fieldst = fieldnames(targets);

for i = 1:1:size(fieldsi,1)
    field = fieldsi{i};
    field_t = fieldst{i};
    
    samples = inputs.(field);
    samples_t = targets.(field_t);
    num_samples = size(samples,1);
    
    remove_indexes = randperm(num_samples,round(num_samples*reduce));
    
    samples(remove_indexes,:) = [];
    samples_t(remove_indexes,:) = [];
    
    inputs.(field) = samples;
    targets.(field_t) = samples_t;
end
%this code is used to balance the dataset using the oversampling and undersampling techniques
fieldsi = fieldnames(inputs1);
fieldst = fieldnames(targets1);

wait = waitbar(0,'Balancing the Samples ...');

for w = 1:1:size(fieldsi,1)
 waitbar(w/size(fieldsi,1),wait,strcat('Balancing the Samples for n',int2str(w)));
 
 inputs_i = inputs1.(fieldsi{w});
 targets_i = targets1.(fieldst{w});
 
 targets_i = targets_i(:,2);
 
 [inputs_i,targets_i] = smote(inputs_i, [], 'Class', targets_i);
 
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
 
 targets_i = targets_i(:,2);
 
 [inputs_i,targets_i] = smote(inputs_i, [], 'Class', targets_i);
 
 inputs_balanced2.(fieldsi{w}) = inputs_i;
 targets_balanced2.(fieldst{w}) = targets_i;

end

close(wait);
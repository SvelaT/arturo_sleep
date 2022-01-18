fieldsi1 = fieldnames(inputs1);
fieldsi2 = fieldnames(inputs2);
fieldsw1 = fieldnames(inputsWav1);
fieldsw2 = fieldnames(inputsWav2);

for i = 1:1:size(fieldsi1,1)
    fieldi = fieldsi1{i};
    fieldw = fieldsw1{i};
    
    inputsi = inputs1.(fieldi);
    inputsw = inputsWav1.(fieldw);
    
    inputs1.(fieldi) = [inputsi,inputsw];
end

for i = 1:1:size(fieldsi2,1)
    fieldi = fieldsi2{i};
    fieldw = fieldsw2{i};
    
    inputsi = inputs2.(fieldi);
    inputsw = inputsWav2.(fieldw);
    
    inputs2.(fieldi) = [inputsi,inputsw];
end
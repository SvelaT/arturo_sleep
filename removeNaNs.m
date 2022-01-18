fieldsi1 = fieldnames(inputs1);
fieldsi2 = fieldnames(inputs2);

for i = 1:1:size(fieldsi1,1)
    field = fieldsi1{i};
    
    temp_inputs = inputs1.(field);
    
    replace_value = zeros(1,size(temp_inputs,2));
    for j = 1:1:size(temp_inputs,1)
        for w = 1:1:size(temp_inputs,2)
            if(isnan(temp_inputs(j,w)))
                temp_inputs(j,w) = replace_value(w); 
            else
                replace_value(w) = temp_inputs(j,w); 
            end
        end
    end
    
    inputs1.(field) = temp_inputs;
end

for i = 1:1:size(fieldsi2,1)
    field = fieldsi2{i};
    
    temp_inputs = inputs2.(field);
    
    replace_value = zeros(1,size(temp_inputs,2));
    for j = 1:1:size(temp_inputs,1)
        for w = 1:1:size(temp_inputs,2)
            if(isnan(temp_inputs(j,w)))
                temp_inputs(j,w) = replace_value(w); 
            else
                replace_value(w) = temp_inputs(j,w); 
            end
        end
    end
    
    inputs2.(field) = temp_inputs;
end
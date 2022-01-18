outputs_cap = round(outputs');
caps_array = zeros(1,size(outputs_cap,1));
aphase_size = 0;
aphase_min = 2;
aphase_max = 60;
bphase_min = 2;
bphase_max = 60;
cap_count = 0;

bphase_size = 0;
aphase_size = 0;

for i = 1:1:size(outputs_cap,1)
    if outputs_cap(i,1) == 0
        if(bphase_size < bphase_min || bphase_size > bphase_max)
            bphase_size = 0;
        elseif(aphase_size >= aphase_min)
            cap_count = cap_count+1;
            cap_size = aphase_size + bphase_size;
            caps_array((i-cap_size):(i-1)) = cap_count*ones(1,cap_size);
            aphase_size = 0;
            bphase_size = 0;
        end
        aphase_size = aphase_size + 1;
    else
        if(aphase_size < aphase_min)
            aphase_size = 0;
        end
        bphase_size = bphase_size + 1;
    end
end
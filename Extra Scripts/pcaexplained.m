cumulative = 0;
for i = 1:1:size(explained,1)
    cumulative = cumulative + explained(i);
    disp(['(' num2str(i) ',' num2str(cumulative) ')']);
end
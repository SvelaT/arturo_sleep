data = MRMR_Results_Aucs(:,1);

for i = 1:1:size(data,1)
    disp(['(' num2str(i) ',' num2str(data(i)) ')']);
end
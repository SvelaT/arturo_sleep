load("../DatasetSamples/n1hypnoEEGminutLable2Original");
length = size(Hipno,1);

figura = figure;
indexes = (1:length)/3600;
for i = 1:60:size(Hipno,1)
    disp(['(' num2str(indexes(i)) ',' num2str(Hipno(i)) ')']);
end
plot(indexes,Hipno);
xlabel("Hours of sleep");
ylabel("Sleep Stage");
yticks([0 1 2 3 4 5]);
yticklabels({'Wake','N-REM 1','N-REM 2','N-REM 3','N-REM 4','REM'});

saveas(figura,'Hipnogram.png');

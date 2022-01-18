f1 = figure ;
plot(MRMR_Results_Aucs(:,1));
title('AUC values Normalized');
ylabel('AUC');
xlabel('Number of Features');
saveas(f1,'Results/MRMRAucs.jpg');

close(f1)

f2 = figure ;
plot(MRMR_Results_Accuracies(:,1));
title('Accuracy values Normalized');
ylabel('Accuracy');
xlabel('Number of Features');
saveas(f2,'Results/MRMRAccuracies.jpg');

close(f2)

f3 = figure ;
plot(MRMR_Results_Sensitivities(:,1));
title('Sensitivity Values Normalized');
ylabel('Sensitivity');
xlabel('Number of Features');
saveas(f3,'Results/MRMRSensitivities.jpg');

close(f3)

f4 = figure ;
plot(MRMR_Results_Specificities(:,1));
title('Specificity Values Normalized');
ylabel('Specificity');
xlabel('Number of Features');
saveas(f4,'Results/MRMRSpecificities.jpg');

close(f4)

f5 = figure ;
plot(MRMR_Results_Score(:,1));
title('Score Values Normalized');
ylabel('Score');
xlabel('Number of Features');
saveas(f5,'Results/MRMRScores.jpg');

close(f5)


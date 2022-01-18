figura = figure;
bar(mean(Total_Aucs));
title('Average classification score for each patient')
xlabel("Patient Index");
ylabel("Score Value(AUC)");
xticks([1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19]);

saveas(figura,'PlotAUCSPatients.png');

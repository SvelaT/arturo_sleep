f1 = figure ;
histogram(CAPLabel1.CAPLabel1(1:10000));
title('Patient 1 sample distribution');
ylabel('Number of samples');
xticks([0 1 2 3]);
xticklabels({'not-A','A1','A2','A3'});
saveas(f1,'showimbalance.jpg');
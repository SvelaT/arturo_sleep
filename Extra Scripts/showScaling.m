f1 = figure ;
plot(inputs1.inputs1(1000:1300,6));
title('Standard Deviation Standardized');
ylabel('Value');
xlabel('Epoch');
saveas(f1,'showMean.jpg');

f2 = figure ;
plot(inputs1.inputs1(1000:1300,8));
title('Shannon Entropy Standardized');
ylabel('Value');
xlabel('Epoch');
disp('shannon');
for i = 1000:1:1300
    disp(['(' num2str(i-1000) ',' num2str(inputs1.inputs1(i,8)) ')']);
end
saveas(f2,'showEntropy.jpg');

f3 = figure ;
plot(inputs1.inputs1(1000:1300,14));
title('TEO Standardized');
ylabel('Value');
xlabel('Epoch');
disp('teo');
for i = 1000:1:1300
    disp(['(' num2str(i-1000) ',' num2str(inputs1.inputs1(i,14)) ')']);
end
saveas(f3,'showTEO.jpg');
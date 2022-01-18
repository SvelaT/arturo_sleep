summary = zeros(4,4);

summary(1,1) = mean(mean(Total_Aucs));
summary(2,1) = mean(mean(Total_Accuracies));
summary(3,1) = mean(mean(Total_Sensitivities));
summary(4,1) = mean(mean(Total_Specificities));

summary(1,2) = std(reshape(Total_Aucs,[],1));
summary(2,2) = std(reshape(Total_Accuracies,[],1));
summary(3,2) = std(reshape(Total_Sensitivities,[],1));
summary(4,2) = std(reshape(Total_Specificities,[],1));

summary(1,3) = min(min(Total_Aucs));
summary(2,3) = min(min(Total_Accuracies));
summary(3,3) = min(min(Total_Sensitivities));
summary(4,3) = min(min(Total_Specificities));

summary(1,4) = min(max(Total_Aucs));
summary(2,4) = max(max(Total_Accuracies));
summary(3,4) = max(max(Total_Sensitivities));
summary(4,4) = max(max(Total_Specificities));
features_last = zeros(1,size(SFS_Results_Aucs,2));
features_last_sen = zeros(1,size(SFS_Results_Aucs,2));
features_last_spe = zeros(1,size(SFS_Results_Aucs,2));
features_last_acc = zeros(1,size(SFS_Results_Aucs,2));
features_last_sco = zeros(1,size(SFS_Results_Aucs,2));


for i = 1:1:size(SFS_Results_Aucs,2)
    column = SFS_Results_Aucs(:,i);
    column(column==0) = [];
    features_last(i) = column(end);
    column = SFS_Results_Sensitivities(:,i);
    column(column==0) = [];
    features_last_sen(i) = column(end);
    column = SFS_Results_Specificities(:,i);
    column(column==0) = [];
    features_last_spe(i) = column(end);
    column = SFS_Results_Accuracies(:,i);
    column(column==0) = [];
    features_last_acc(i) = column(end);
    column = SFS_Results_Score(:,i);
    column(column==0) = [];
    features_last_sco(i) = column(end);
end

features_names = ["Mean Power";
    "Variance Power";
    "Skewness Power";
    "Kurtosis Power";
    "Coefficient of Variation Power";
    "Standard Deviation Power";
    "Range Value Power";
    "Shannon Entropy";
    "Log Energy Entropy";
    "Renyi Entropy";
    "Tsallis Entropy";
    "Autocovariance";
    "Autocorrelation";
    "TEO";
    "PSD Pwelch Delta Range";
    "PSD Pwelch Theta Range";
    "PSD Pwelch Alpha Range"
    "PSD Pwelch Sigma Range";
    "PSD Pwelch Beta1 Range";
    "PSD Pwelch Beta2 Range";
    "PSD Wavelet Beta1 Range";
    "PSD Wavelet Beta2 Range";
    "PSD Wavelet Sigma Range";
    "PSD Wavelet Alpha Range";
    "PSD Wavelet Theta Range";
    "PSD Wavelet Delta Range"];

features_names = convertStringsToChars(features_names);

features_wav_names_1 = ["Mean","Variance","Skewness","Kurtosis","Shannon Entropy","Log Energy Entropy","Renyi Entropy","Tsallis Entropy"];

features_wav_names_1 = convertStringsToChars(features_wav_names_1);

features_wav_names_2 = ["c1 0-50 Hz","c3 0-25 Hz","c4 25-50 Hz","c5 0-12.5 Hz","c6 12.5-25 Hz","c9 0-6.25 Hz","c10 6.25-12.5 Hz","c13 0-3.125 Hz","c14 3.125-6.25 Hz"];

features_wav_names_2 = convertStringsToChars(features_wav_names_2);

for i = 1:1:size(final_feature_set,2)
    if final_feature_set(i) <= 26
        disp([num2str(i) 'ª Feature: ' features_names{final_feature_set(i)} ' with AUC = ' num2str(features_last(final_feature_set(i)))]);
    else
        feature_index = final_feature_set(i) - 26;
        feature_type = rem(feature_index,8);
        if feature_type == 0
            feature_type = 8;
        end
        feature_coef = ceil(feature_index/8);
        disp([num2str(i) 'ª Feature: ' features_wav_names_1{feature_type} ' for  coefficients ' features_wav_names_2{feature_coef} ' with AUC = ' num2str(features_last(final_feature_set(i)))]);
    end
end

stop = 16;

for i = 1:1:stop  
    if final_feature_set(i) <= 26
        disp([num2str(final_feature_set(i)) ' & ' features_names{final_feature_set(i)} ' & ' num2str(round(features_last(final_feature_set(i)),3)) ' & ' num2str(round(100*features_last_sen(final_feature_set(i)),1)) ' & ' num2str(round(100*features_last_spe(final_feature_set(i)),1)) ' & ' num2str(round(100*features_last_acc(final_feature_set(i)),1)) '\\']);
    else
        feature_index = final_feature_set(i) - 26;
        feature_type = rem(feature_index,8);
        if feature_type == 0
            feature_type = 8;
        end
        feature_coef = ceil(feature_index/8);
        disp([num2str(final_feature_set(i)) ' & ' features_wav_names_1{feature_type} ' for ' features_wav_names_2{feature_coef} ' & ' num2str(round(features_last(final_feature_set(i)),3)) ' & ' num2str(round(100*features_last_sen(final_feature_set(i)),1)) ' & ' num2str(round(100*features_last_spe(final_feature_set(i)),1)) ' & ' num2str(round(100*features_last_acc(final_feature_set(i)),1)) '\\']);
    end
    disp(['\hline']);
end

[maximum,feature_index] = max(features_last);
index = find(final_feature_set==feature_index);

disp(['Best AUC value of ' num2str(maximum) ' with ' num2str(index) ' features']);

[maxauc,maxaucidx] = max(features_last(final_feature_set));
[maxsco,maxscoidx] = max(features_last_sco(final_feature_set));
[maxspe,maxspeidx] = max(features_last_spe(final_feature_set));
[maxsen,maxsenidx] = max(features_last_sen(final_feature_set));
[maxacc,maxaccidx] = max(features_last_acc(final_feature_set));

maxx = [maxaucidx,maxscoidx,maxspeidx,maxsenidx,maxaccidx];
maxy = [maxauc,maxsco,maxspe,maxsen,maxacc];
plot_auc = features_last(final_feature_set);
plot(1:98,plot_auc,'-o','DisplayName','AUC');
disp('auc');
for i = 1:1:98
    disp(['(' num2str(i) ',' num2str(plot_auc(i)) ')']);
end
hold on
plot_sen = features_last_sen(final_feature_set);
plot(1:98,features_last_sen(final_feature_set),'-x','DisplayName','Sen');
disp('sen');
for i = 1:1:98
    disp(['(' num2str(i) ',' num2str(plot_sen(i)) ')']);
end
plot_spe = features_last_spe(final_feature_set);
plot(1:98,plot_spe,'-^','DisplayName','Spe');
disp('spe');
for i = 1:1:98
    disp(['(' num2str(i) ',' num2str(plot_spe(i)) ')']);
end
plot_acc = features_last_acc(final_feature_set);
plot(1:98,plot_acc,'-s','DisplayName','Acc');
disp('acc');
for i = 1:1:98
    disp(['(' num2str(i) ',' num2str(plot_acc(i)) ')']);
end
plot_sco = features_last_sco(final_feature_set);
plot(1:98,plot_sco,'-d','DisplayName','Sco');
disp('sco');
for i = 1:1:98
    disp(['(' num2str(i) ',' num2str(plot_sco(i)) ')']);
end
plot(maxx,maxy,'gp','MarkerSize',15,'MarkerEdgeColor','b','MarkerFaceColor','b','DisplayName','Max');
hold off
lgd = legend;
lgd.Location = 'southeast';
lgd.FontSize = 16;
xlabel('Number of features','FontSize',16);
xticks(0:5:100);
ylabel('Value','FontSize',16);
yticks((0:5:100)/100);
ytickformat('%.2f');
grid on
grid minor
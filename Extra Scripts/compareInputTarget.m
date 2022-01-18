%this code is used to visualize the relationship between the inputs and the CAP Phases classification
compare_window_1 = 4550:4700;
compare_window_2 = 4850:5000;
compare_window_3 = 4850:5000;

% compare_window_1 = 7540:7690;
% compare_window_2 = 7100:7250;
% compare_window_3 = 8000:8150;

figures_1 = [];
figures_2 = [];
figures_3 = [];

fieldsi = fieldnames(inputs1);
fieldsc = fieldnames(CAPLabel1);

CAPlabel1 = CAPLabel1.(fieldsc{1});
inputs_i = inputs1.(fieldsi{1});

for i = 1:1:size(inputs_i,2)
    input = inputs_i(:,i);

    figures_1(i) = figure;
    subplot(2,1,1);
    plot(CAPlabel1(compare_window_1));
    title('CAP classification');

    subplot(2,1,2);
    plot(input(compare_window_1));
    title(feature_names(i));
    name = strcat('\CompareImages\Range1\InputCompare',int2str(i));
    location = strcat(pwd,name);
    saveas(figures_1(i),strcat(location,'.jpg'));
end

for i = 1:1:size(inputs_i,2)
    input = inputs_i(:,i);

    figures_2(i) = figure;
    subplot(2,1,1);
    plot(CAPlabel1(compare_window_2));
    title('CAP classification');

    subplot(2,1,2);
    plot(input(compare_window_2));
    title(feature_names(i));
    name = strcat('\CompareImages\Range2\InputCompare',int2str(i));
    location = strcat(pwd,name);
    saveas(figures_2(i),strcat(location,'.jpg'));
end

CAPlabel1 = CAPLabel1.(fieldsc{4});
inputs_i = inputs1.(fieldsi{4});

for i = 1:1:size(inputs_i,2)
    input = inputs_i(:,i);

    figures_3(i) = figure;
    subplot(2,1,1);
    plot(CAPlabel1(compare_window_3));
    title('CAP classification');

    subplot(2,1,2);
    plot(input(compare_window_3));
    title(feature_names(i));
    name = strcat('\CompareImages\Range3\InputCompare',int2str(i));
    location = strcat(pwd,name);
    saveas(figures_3(i),strcat(location,'.jpg'));
end

close all;

clearvars compare_window_1 compare_window_2 f1 name figures;


f1 = figure ;
plot(eeg1.eegSensor1(1:10000));
title('EEG Sample');
xlabel('Time');
ylabel('Amplitude');
saveas(f1,'showeeg.jpg');

for i = 1:1:900
    disp(['(' num2str(i) ',' num2str(eeg1.eegSensor1(i)) ')']);
end


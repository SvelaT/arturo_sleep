%this code is used to visualize the relationship between the eeg signal and the CAP Phases classification
fieldse = fieldnames(eeg1);
fieldsc = fieldnames(CAPLabel1);

eegSensor = eeg1.(fieldse{1});
CAPlabel1 = CAPLabel1.(fieldsc{1});

sensorNum = size(eegSensor,1);%number of values collected by the sensor(100Hz collecting rate)
sampleNum = size(CAPlabel1,1);%number of samples

sampleSize = fix(sensorNum/sampleNum);%number of sensor values per sample

signal_window = 1468000:1478000;

signal = eegSensor;
caps = [];

subplot(2,1,1);
plot(highpass(signal(signal_window),1,100));
title('EEG Sensor Signal');

for i = 1:1:size(CAPlabel1,1)
    for j = 1:1:sampleSize
        caps((i-1)*sampleSize+j) = CAPlabel1(i);
    end
end

caps = caps';

subplot(2,1,2);
plot(caps(signal_window));
title('CAP classification');
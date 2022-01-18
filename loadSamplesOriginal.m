%this code is used to load all the samples

%loading samples from patient n1
load('DatasetSamples\n1eegminut2Original.mat');
eeg1.eegSensor1 = eegSensor;

%loading samples from patient n2
load('DatasetSamples\n2eegminut2Original.mat');
eeg1.eegSensor2 = eegSensor;

%loading samples from patient n3
load('DatasetSamples\n3eegminut2Original.mat');
eeg1.eegSensor3 = eegSensor;

%loading samples from patient n4
load('DatasetSamples\n4eegminut2Original.mat');
eeg1.eegSensor4 = eegSensor;

%loading samples from patient n5
load('DatasetSamples\n5eegminut2Original.mat');
eeg1.eegSensor5 = eegSensor;

%loading samples from patient n6
load('DatasetSamples\n6eegminut2Original.mat');
eeg1.eegSensor6 = eegSensor;

%loading samples from patient n7
load('DatasetSamples\n7eegminut2Original.mat');
eeg1.eegSensor7 = eegSensor;

%loading samples from patient n8
load('DatasetSamples\n8eegminut2Original.mat');
eeg1.eegSensor8 = eegSensor;

%loading samples from patient n9
load('DatasetSamples\n9eegminut2Original.mat');
eeg1.eegSensor9 = eegSensor;

%loading samples from patient n10
load('DatasetSamples\n10eegminut2Original.mat');
eeg1.eegSensor10 = eegSensor;

%loading samples from patient n11
load('DatasetSamples\n11eegminut2Original.mat');
eeg1.eegSensor11 = eegSensor;

%loading samples from patient n13
load('DatasetSamples\n13eegminut2Original.mat');
eeg1.eegSensor13 = eegSensor;

%loading samples from patient n14
load('DatasetSamples\n14eegminut2Original.mat');
eeg1.eegSensor14 = eegSensor;

%loading samples from patient n15
load('DatasetSamples\n15eegminut2Original.mat');
eeg1.eegSensor15 = eegSensor;

%loading samples from patient n16
load('DatasetSamples\n16eegminut2Original.mat');
eeg1.eegSensor16 = eegSensor;

% %loading samples from patient 1 with Apnea
load('DatasetSamples\sdb1eegminut2Original.mat');
eeg2.eegSensor1 = eegSensor;

% %loading samples from patient 2 with Apnea
load('DatasetSamples\sdb2eegminut2Original.mat');
eeg2.eegSensor2 = eegSensor;

%loading samples from patient 3 with Apnea
load('DatasetSamples\sdb3eegminut2Original.mat');
eeg2.eegSensor3 = eegSensor;

% %loading samples from patient 4 with Apnea
load('DatasetSamples\sdb4eegminut2Original.mat');
eeg2.eegSensor4 = eegSensor;

%loading CAP target labels for patient n1
load('DatasetSamples\n1eegminutLable2Original.mat');
CAPLabel1.CAPLabel1 = CAPlabel1;

%loading CAP target labels for patient n2
load('DatasetSamples\n2eegminutLable2Original.mat');
CAPLabel1.CAPLabel2 = CAPlabel1;

%loading CAP target labels for patient n3
load('DatasetSamples\n3eegminutLable2Original.mat');
CAPLabel1.CAPLabel3 = CAPlabel1;

%loading CAP target labels for patient n4
load('DatasetSamples\n4eegminutLable2Original.mat');
CAPLabel1.CAPLabel4 = CAPlabel1;

%loading CAP target labels for patient n5
load('DatasetSamples\n5eegminutLable2Original.mat');
CAPLabel1.CAPLabel5 = CAPlabel1;

%loading CAP target labels for patient n6
load('DatasetSamples\n6eegminutLable2Original.mat');
CAPLabel1.CAPLabel6 = CAPlabel1;

%loading CAP target labels for patient n7
load('DatasetSamples\n7eegminutLable2Original.mat');
CAPLabel1.CAPLabel7 = CAPlabel1;

%loading CAP target labels for patient n8
load('DatasetSamples\n8eegminutLable2Original.mat');
CAPLabel1.CAPLabel8 = CAPlabel1;

%loading CAP target labels for patient n9
load('DatasetSamples\n9eegminutLable2Original.mat');
CAPLabel1.CAPLabel9 = CAPlabel1;

%loading CAP target labels for patient n10
load('DatasetSamples\n10eegminutLable2Original.mat');
CAPLabel1.CAPLabel10 = CAPlabel1;

%loading CAP target labels for patient n11
load('DatasetSamples\n11eegminutLable2Original.mat');
CAPLabel1.CAPLabel11 = CAPlabel1;

%loading CAP target labels for patient n13
load('DatasetSamples\n13eegminutLable2Original.mat');
CAPLabel1.CAPLabel13 = CAPlabel1;

%loading CAP target labels for patient n14
load('DatasetSamples\n14eegminutLable2Original.mat');
CAPLabel1.CAPLabel14 = CAPlabel1;

%loading CAP target labels for partient n15
load('DatasetSamples\n15eegminutLable2Original.mat');
CAPLabel1.CAPLabel15 = CAPlabel1;

%loading CAP target labels for partient n16
load('DatasetSamples\n16eegminutLable2Original.mat');
CAPLabel1.CAPLabel16 = CAPlabel1;

% %loading CAP target labels from patient 1 with Apnea
load('DatasetSamples\sdb1eegminutLable2Original.mat');
CAPLabel2.CAPLabel1 = CAPlabel1;

% %loading CAP target labels from patient 2 with Apnea
load('DatasetSamples\sdb2eegminutLable2Original.mat');
CAPLabel2.CAPLabel2 = CAPlabel1;

%loading CAP target labels from patient 3 with Apnea
load('DatasetSamples\sdb3eegminutLable2Original.mat');
CAPLabel2.CAPLabel3 = CAPlabel1;

% %loading CAP target labels from patient 4 with Apnea
load('DatasetSamples\sdb4eegminutLable2Original.mat');
CAPLabel2.CAPLabel4 = CAPlabel1;


clearvars eegSensor CAPlabel1;

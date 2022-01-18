%this code is used to load all the samples

%loading samples from patient n1
load('DatasetSamples\n1eegminut2.mat');
eeg1.eegSensor1 = eegSensor;

%loading samples from patient n2
load('DatasetSamples\n2eegminut2.mat');
eeg1.eegSensor2 = eegSensor;

%loading samples from patient n3
load('DatasetSamples\n3eegminut2.mat');
eeg1.eegSensor3 = eegSensor;

%loading samples from patient n4
load('DatasetSamples\n4eegminut2.mat');
eeg1.eegSensor4 = eegSensor;

%loading samples from patient n5
load('DatasetSamples\n5eegminut2.mat');
eeg1.eegSensor5 = eegSensor;

%loading samples from patient n6
load('DatasetSamples\n6eegminut2.mat');
eeg1.eegSensor6 = eegSensor;

%loading samples from patient n7
load('DatasetSamples\n7eegminut2.mat');
eeg1.eegSensor7 = eegSensor;

%loading samples from patient n8
load('DatasetSamples\n8eegminut2.mat');
eeg1.eegSensor8 = eegSensor;

%loading samples from patient n9
load('DatasetSamples\n9eegminut2.mat');
eeg1.eegSensor9 = eegSensor;

%loading samples from patient n10
load('DatasetSamples\n10eegminut2.mat');
eeg1.eegSensor10 = eegSensor;

%loading samples from patient n11
load('DatasetSamples\n11eegminut2.mat');
eeg1.eegSensor11 = eegSensor;

%loading samples from patient n13
load('DatasetSamples\n13eegminut2.mat');
eeg1.eegSensor13 = eegSensor;

%loading samples from patient n14
load('DatasetSamples\n14eegminut2.mat');
eeg1.eegSensor14 = eegSensor;

%loading samples from patient n15
load('DatasetSamples\n15eegminut2.mat');
eeg1.eegSensor15 = eegSensor;

%loading samples from patient n16
load('DatasetSamples\n16eegminut2.mat');
eeg1.eegSensor16 = eegSensor;

%loading samples from apnea patient n1
load('DatasetSamples\sdb1eegminut2.mat');
eeg2.eegSensor1 = eegSensor;

%loading samples from apnea patient n2
load('DatasetSamples\sdb2eegminut2.mat');
eeg2.eegSensor2 = eegSensor;

%loading samples from apnea patient n3
load('DatasetSamples\sdb3eegminut2.mat');
eeg2.eegSensor3 = eegSensor;

%loading samples from apnea patient n4
load('DatasetSamples\sdb4eegminut2.mat');
eeg2.eegSensor4 = eegSensor;

%loading CAP target labels for patient n1
load('DatasetSamples\n1eegminutLable2');
CAPLabel1.CAPLabel1 = CAPlabel1;

%loading CAP target labels for patient n2
load('DatasetSamples\n2eegminutLable2');
CAPLabel1.CAPLabel2 = CAPlabel1;

%loading CAP target labels for patient n3
load('DatasetSamples\n3eegminutLable2');
CAPLabel1.CAPLabel3 = CAPlabel1;

%loading CAP target labels for patient n4
load('DatasetSamples\n4eegminutLable2');
CAPLabel1.CAPLabel4 = CAPlabel1;

%loading CAP target labels for patient n5
load('DatasetSamples\n5eegminutLable2');
CAPLabel1.CAPLabel5 = CAPlabel1;

%loading CAP target labels for patient n6
load('DatasetSamples\n6eegminutLable2');
CAPLabel1.CAPLabel6 = CAPlabel1;

%loading CAP target labels for patient n7
load('DatasetSamples\n7eegminutLable2');
CAPLabel1.CAPLabel7 = CAPlabel1;

%loading CAP target labels for patient n8
load('DatasetSamples\n8eegminutLable2');
CAPLabel1.CAPLabel8 = CAPlabel1;

%loading CAP target labels for patient n9
load('DatasetSamples\n9eegminutLable2');
CAPLabel1.CAPLabel9 = CAPlabel1;

%loading CAP target labels for patient n10
load('DatasetSamples\n10eegminutLable2');
CAPLabel1.CAPLabel10 = CAPlabel1;

%loading CAP target labels for patient n11
load('DatasetSamples\n11eegminutLable2');
CAPLabel1.CAPLabel11 = CAPlabel1;

%loading CAP target labels for patient n13
load('DatasetSamples\n13eegminutLable2');
CAPLabel1.CAPLabel13 = CAPlabel1;

%loading CAP target labels for patient n14
load('DatasetSamples\n14eegminutLable2');
CAPLabel1.CAPLabel14 = CAPlabel1;

%loading CAP target labels for partient n15
load('DatasetSamples\n15eegminutLable2');
CAPLabel1.CAPLabel15 = CAPlabel1;

%loading CAP target labels for partient n16
load('DatasetSamples\n16eegminutLable2');
CAPLabel1.CAPLabel16 = CAPlabel1;

load('DatasetSamples\sdb1eegminutLable2.mat')
CAPLabel2.CAPLabel1 = CAPlabel1;

load('DatasetSamples\sdb2eegminutLable2.mat')
CAPLabel2.CAPLabel2 = CAPlabel1;

load('DatasetSamples\sdb3eegminutLable2.mat')
CAPLabel2.CAPLabel3 = CAPlabel1;

load('DatasetSamples\sdb4eegminutLable2.mat')
CAPLabel2.CAPLabel4 = CAPlabel1;

clearvars eegSensor CAPlabel1;

%% load data and calculate features
s = load('vibration_datasets\m3_vibration_waveform_data.mat');
inds = 1:4096*500;
m3_1_500 = filter_struct(s, inds);
inds = 4096*500 + (1:4096*500);
m3_501_1000 = filter_struct(s, inds);
f_m3_1_500 = calc_features(m3_1_500);
f_m3_501_1000 = calc_features(m3_501_1000);
clear m3* s inds

s = load('vibration_datasets\m4_vibration_waveform_data.mat');
inds = 1:4096*500;
m4_1_500 = filter_struct(s, inds);
inds = 4096*500 + (1:4096*500);
m4_501_1000 = filter_struct(s, inds);
f_m4_1_500 = calc_features(m4_1_500);
f_m4_501_1000 = calc_features(m4_501_1000);
clear m4* s inds

%% reformat for use in learning algorithms

% training set inputs
train_features = [struct2mat(f_m3_1_500); struct2mat(f_m4_1_500)];
train_labels = [1*ones(500, 1); 2*ones(500, 1)]; % m3 = 1; m4 = 2;
% testing set inputs
test_features = [struct2mat(f_m3_501_1000); struct2mat(f_m4_501_1000)];
test_labels = [1*ones(500, 1); 2*ones(500, 1)]; % m3 = 1; m4 = 2;

%% logistic regression
B = mnrfit(train_features, train_labels);
pihat = mnrval(B, test_features);
legend('M3', 'M4');
grid on; xlabel('Sample #'); ylabel('Likelihood');
title('Logistic Regression');
set(gcf, 'Name', 'Logistic Regression');

err_m3 = (sum(pihat(1:500, 1) < 0.5) + sum(pihat(501:end, 1) >= 0.5)) / 1000
err_m4 = (sum(pihat(1:500, 2) >= 0.5) + sum(pihat(501:end, 2) < 0.5)) / 1000





function test_class_algs(varargin)

%% load data (and maybe calculate features)
if nargin == 0 % calculate features from vibration data
    s = load('vibration_datasets\m3_vibration_waveform_data.mat');
    m3_features = calc_time_features(s);
    clear s
    s = load('vibration_datasets\m4_vibration_waveform_data.mat');
    m4_features = calc_time_features(s);
    clear s
    [m3_feat_mat, m4_feat_mat, title_str] = proc_time_features(m3_features, m4_features);
    clear m3_features m4_features
elseif nargin == 2 % load pre-calculated features
    m3_features = varargin{1};
    m4_features = varargin{2};
    [m3_feat_mat, m4_feat_mat, title_str] = proc_time_features(m3_features, m4_features);
    clear m3_features m4_features
elseif nargin == 1 % if we are passed in the outut of select_features
    m3_inds = logical(varargin{1}(:, end));
    m3_feat_mat = varargin{1}(m3_inds, 1:end-1);
    m4_feat_mat = varargin{1}(~m3_inds, 1:end-1);
    title_str = 'Logistic Regression (Frequency Domain)';
else
    error('Unexpected number of input arguments');
end

% get total number of data points for m3 and m4
m = [size(m3_feat_mat, 1); size(m4_feat_mat, 1)];

%% separate into traning and test sets
train_pct = 0.2:0.1:0.7; 
test_pct  = 0.3;

test_err_m3 = zeros(size(train_pct)); % initialize error (to be calculated later)
test_err_m4 = test_err_m3; 
train_err_m3 = test_err_m3;
train_err_m4 = test_err_m3; 
for ipct = 1:numel(train_pct) % loop over size of training set used
    m_train = floor(m * train_pct(ipct)); % changes
    m_test = ceil(m * test_pct); % stays the same
    train_features = [m3_feat_mat(1:m_train(1), :); m4_feat_mat(1:m_train(2), :)];
    train_labels = [1*ones(m_train(1), 1);  % m3 = 1
        2*ones(m_train(2), 1)];             % m4 = 2
    % testing set inputs
    test_features = [m3_feat_mat(end-m_test(1)+1:end, :); 
        m4_feat_mat(end-m_test(2)+1:end, :)];
    test_labels = [1*ones(m_test(1), 1); % m3 = 1 
        2*ones(m_test(2), 1)];           % m4 = 2;

    %% logistic regression
    % standard (without regularization)
%     B = mnrfit(train_features, train_labels);
    
    % with regularization
    [B_lasso, FitInfo] = lassoglm(train_features, 2-train_labels, 'binomial');
    icol = 1; B2 = [FitInfo.Intercept(icol); B_lasso(:, icol)];
    B = B2;
    
    pihat = mnrval(B, test_features);

    % plot classification results on test set
    figure('Color', 'w');
    plot(pihat, '*'); hold on; xlim([0, numel(test_labels)]);
    plot(m_test(1)*[1, 1], [0, 1], 'k--', 'LineWidth', 1.5);
    legend({'M3', 'M4'}, 'FontSize', 10);
    set(gca, 'FontSize', 11);
    grid on; xlabel('Sample #'); ylabel('Likelihood');
    title('Logistic Regression');
    set(gcf, 'Name', 'Logistic Regression');

%     % plot coefficients found by lasso GLM
%     figure('Color', 'w');
%     plot(B);
%     grid on; set(gca, 'FontSize', 11);
%     xlim([0, 1667]);
%     xlabel('Frequency (Hz)');
%     ylabel('Lasso GLM Coefficient');
    
    % this should work but doesn't due to NaNs
    % err_m3 = sum(round(pihat(:, 1)) ~= (test_labels ~= 2)) / sum(m_test)
    % err_m4 = sum(round(pihat(:, 2)) ~= (test_labels == 2)) / sum(m_test)

    % save off test set error
    test_err_m3(ipct) = (sum(pihat(1:m_test(1), 1) < 0.5) + ...
        sum(pihat(m_test(1)+1:end, 1) >= 0.5)) / sum(m_test);
    test_err_m4(ipct) = (sum(pihat(1:m_test(1), 2) >= 0.5) + ...
        sum(pihat(m_test(1)+1:end, 2) < 0.5)) / sum(m_test);
    
    % calculate and save training set error
    pihat = mnrval(B, train_features);
    train_err_m3(ipct) = (sum(pihat(1:m_train(1), 1) < 0.5) + ...
        sum(pihat(m_train(1)+1:end, 1) >= 0.5)) / sum(m_train);
    train_err_m4(ipct) = (sum(pihat(1:m_train(1), 2) >= 0.5) + ...
        sum(pihat(m_train(1)+1:end, 2) < 0.5)) / sum(m_train);
    
end

% plot training error and test set error 
figure('Color', 'w');
plot(train_pct, [test_err_m3; train_err_m3], 'LineWidth', 1.5);
grid on; xlabel('Percent of Data Used for Training'); ylabel('Error');
set(gca, 'FontSize', 11);
legend({'Test Error', 'Training Error'}, 'FontSize', 10);
title(title_str);


function [m3_mat, m4_mat, title_str] = proc_time_features(m3_features, m4_features)
% weed out some data points (or not)
title_str = 'Logistic Regression';
% test_case = 3;
% switch test_case
%     case 1
%         max_data_age = 60; % use only first 60 days of data
%         title_str = [title_str, sprintf(', %d days', max_data_age)];
%     case 2
%         max_data_age = 95; % first 95 days
%         title_str = [title_str, sprintf(', %d days', max_data_age)];
%     case 3
%         max_data_age = Inf; % all the data
% end
% inds = m3_features.time_delta_days <= max_data_age;
% m3_features = filter_struct(m3_features, inds);
% inds = m4_features.time_delta_days <= max_data_age;
% m4_features = filter_struct(m4_features, inds);

% reformat for use in learning algorithms
% first remove time stamp features
m3_features = remove_time_stamp(m3_features);
m4_features = remove_time_stamp(m4_features);
% then restructure
m3_mat = struct2mat(m3_features);
m4_mat = struct2mat(m4_features);
% % reorder rows to mix up data (so training and test sets will include a
% % variety of data)
% title_str = [title_str, ' (with Reordering)'];
% m = [size(m3_mat, 1); size(m4_mat, 1)];
% reorder_inds = reshape(1:floor(m(1)/3)*3, [], 3)';
% m3_mat = m3_mat([reorder_inds(:); (floor(m(1)/3)*3:m(1))'], :);
% reorder_inds = reshape(1:floor(m(2)/3)*3, [], 3)';
% m4_mat = m4_mat([reorder_inds(:); (floor(m(2)/3)*3:m(2))'], :);




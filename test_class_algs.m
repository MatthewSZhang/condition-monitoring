function test_class_algs(m3_time_features, m4_time_features)

%% load data and calculate features
if nargin == 0
    s = load('vibration_datasets\m3_vibration_waveform_data.mat');
    m3_time_features = calc_time_features(s);
    clear s;
    s = load('vibration_datasets\m4_vibration_waveform_data.mat');
    m4_time_features = calc_time_features(s);
    clear s;
end

%% weed out some data points (or not)
test_case = 1;
switch test_case
    case 1
        max_data_age = 60; % use only first 60 days of data
    case 2
        max_data_age = 95; % first 95 days
    case 3
        max_data_age = Inf; % all the data
end

inds = m3_time_features.time_delta_days <= max_data_age;
m3_time_features = filter_struct(m3_time_features, inds);
inds = m4_time_features.time_delta_days <= 60;
m4_time_features = filter_struct(m4_time_features, inds);
% get total number of data points for m3 and m4
m = [numel(m3_time_features.rms_x_acc); numel(m4_time_features.rms_x_acc)];

%% reformat for use in learning algorithms
% first remove time stamp features
m3_time_features = remove_time_stamp(m3_time_features);
m4_time_features = remove_time_stamp(m4_time_features);
% then restructure
m3_feat_mat = struct2mat(m3_time_features);
m4_feat_mat = struct2mat(m4_time_features);

%% separate into traning and test sets
train_pct = 0.2:0.1:0.7; 
test_pct  = 0.3;

err_m3 = zeros(size(train_pct)); % initialize error (to be calculated later)
err_m4 = err_m3; 
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
    B = mnrfit(train_features, train_labels);
    pihat = mnrval(B, test_features);

    figure('Color', 'w');
    plot(pihat, '*');
    legend('M3', 'M4');
    grid on; xlabel('Sample #'); ylabel('Likelihood');
    title('Logistic Regression');
    set(gcf, 'Name', 'Logistic Regression');

    % this should work but doesn't due to NaNs
    % err_m3 = sum(round(pihat(:, 1)) ~= (test_labels ~= 2)) / sum(m_test)
    % err_m4 = sum(round(pihat(:, 2)) ~= (test_labels == 2)) / sum(m_test)

    err_m3(ipct) = (sum(pihat(1:m_test(1), 1) < 0.5) + ...
        sum(pihat(m_test(1)+1:end, 1) >= 0.5)) / sum(m_test);
    err_m4(ipct) = (sum(pihat(1:m_test(1), 2) >= 0.5) + ...
        sum(pihat(m_test(1)+1:end, 2) < 0.5)) / sum(m_test);
end

figure('Color', 'w');
plot(train_pct, [err_m3; err_m4], 'LineWidth', 1.5);
grid on;


function feat_struct = remove_time_stamp(feat_struct)

if isfield(feat_struct, 'time_stamp')
    feat_struct = rmfield(feat_struct, 'time_stamp');
end
if isfield(feat_struct, 'time_delta_days')
    feat_struct = rmfield(feat_struct, 'time_delta_days');
end





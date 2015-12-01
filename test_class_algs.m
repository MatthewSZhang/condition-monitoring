function [test_err, train_err] = test_class_algs(varargin)

%% load data 
if islogical(varargin{end})
    do_plots = varargin{end};
    varargin(end) = [];
else
    do_plots = true;
end
if isstruct(varargin{1}) % time domain features
    [feature_data, labels, m, title_str] = proc_time_features(varargin);
    n_cats = numel(m);
else % frequency domain features (output of select_features)
    [feature_data, labels, m, n_cats, title_str] = proc_freq_features(varargin{1}, varargin{2});
end

%% separate into traning and test sets
train_pct = 0.2:0.1:0.7; 
test_pct  = 0.3;

% testing set inputs
m_test = ceil(m * test_pct); % # examples for testing stays the same
test_inds = [];
start_ind = 0;
for icat = 1:n_cats
    test_inds = [test_inds, start_ind + ((m(icat)-m_test(icat)):m(icat))];
    start_ind = start_ind + m(icat);
end
test_features = feature_data(test_inds, :); 
test_labels = labels(test_inds); 

test_err = zeros(1, numel(train_pct)); % initialize error (to be calculated later)
train_err = test_err; 
for ipct = numel(train_pct) % loop over size of training set used
    m_train = floor(m * train_pct(ipct)); % # examples for training changes
    train_inds = [];
    start_ind = 0;
    for icat = 1:n_cats
        train_inds = [train_inds, start_ind + (m(icat)-m_train(icat):m(icat))];
        start_ind = start_ind + m(icat);
    end
    train_features = feature_data(train_inds, :); 
    train_labels = labels(train_inds); 

    %% logistic regression
    % standard (without regularization)
    B = mnrfit(train_features, train_labels);
    
%     % with regularization
%     [B_lasso, FitInfo] = lassoglm(train_features, 2-train_labels, 'binomial');
%     icol = 1; B2 = [FitInfo.Intercept(icol); B_lasso(:, icol)];
%     B = B2;
    
    pihat = mnrval(B, test_features);
    [~, category_ids] = max(pihat, [], 2);

    if do_plots
        % plot classification results on test set
        figure('Color', 'w');
        plot(pihat, '*'); hold on; xlim([0, numel(test_labels)]);
        for idiv = 1:n_cats-1
            plot(sum(m_test(1:idiv))*[1, 1], [0, 1], 'k', 'LineWidth', 1);
        end
        legend({'M1', 'M3', 'M4', 'SN41'}, 'FontSize', 10);
        set(gca, 'FontSize', 11);
        grid on; xlabel('Sample #'); ylabel('Likelihood');
        title(title_str);
        set(gcf, 'Name', 'Logistic Regression');
        
        % plot classification results on test set
        figure('Color', 'w');
        plot(category_ids, 'b*'); hold on; 
        xlim([0, numel(test_labels)]);
        y = [0.5, n_cats+0.5];
        ylim(y);
        for idiv = 1:n_cats-1
            plot(sum(m_test(1:idiv))*[1, 1], y, 'k', 'LineWidth', 0.75);
        end
        set(gca, 'YTick', 1:n_cats, 'YTickLabel', {'M1', 'M3', 'M4', 'SN41'});
        set(gca, 'FontSize', 11);
        xlabel('Sample #');
        set(gcf, 'Name', 'Logistic Regression');
    end
%     % plot coefficients found by lasso GLM
%     figure('Color', 'w');
%     plot(B);
%     grid on; set(gca, 'FontSize', 11);
%     xlim([0, 1667]);
%     xlabel('Frequency (Hz)');
%     ylabel('Lasso GLM Coefficient');

    % save off test set error
    test_err(ipct) = sum(category_ids ~= test_labels) / sum(m_test);
    
    % calculate and save training set error
    pihat = mnrval(B, train_features);
    [~, category_ids] = max(pihat, [], 2);
    train_err(ipct) = sum(category_ids ~= train_labels) / sum(m_train);
    
end

% plot training error and test set error 
figure('Color', 'w');
plot(train_pct, [test_err; train_err], 'LineWidth', 1.5);
grid on; xlabel('Percent of Data Used for Training'); ylabel('Error');
set(gca, 'FontSize', 11);
legend({'Test Error', 'Training Error'}, 'FontSize', 10);
title(title_str);
ylim([0, 0.4]);


function [feature_data, labels, m, title_str] = proc_time_features(feature_data)
do_reordering = false; 

% m = # of training examples, broken out by class; sum(m) = total examples
m = zeros(numel(feature_data), 1); 
labels = [];
for icat = 1:numel(feature_data)
    % first remove time stamp features
    feature_data{icat} = remove_time_stamp(feature_data{icat});
    % reformat for use in learning algorithms
    feature_data{icat} = struct2mat(feature_data{icat});
    % tack on labels
    m(icat) = size(feature_data{icat}, 1);
    if do_reordering
        reorder_inds = reshape(1:floor(m(icat)/3)*3, [], 3)';
        feature_data{icat} = feature_data{icat}([reorder_inds(:); 
            (floor(m(icat)/3)*3+1:m(icat))'], :);
    end
    labels = [labels; icat*ones(m(icat), 1)];
end
feature_data = vertcat(feature_data{:});

% reorder rows to mix up data (so training and test sets will include a
% variety of data)
title_str = 'Logistic Regression, Time Domain';
if do_reordering
    title_str = [title_str, ' (with Reordering)'];
end

function [feature_data, labels, m, n_cats, title_str] = ...
    proc_freq_features(data, n_features)
do_reordering = false; 

% assume features are ranked in descending order of correlation
% throw away features that are more than how many we want
feature_data = data(:, 1:n_features);
labels = data(:, end);
n_cats = numel(unique(labels));
m = zeros(n_cats, 1);
start_ind = 0;
for icat = 1:n_cats
    m(icat) = sum(labels == icat);
    % depending on do_reordering flag, either skip the rest, or reorder
    if ~do_reordering, continue; end
    reorder_inds = reshape(1:floor(m(icat)/3)*3, [], 3)' + start_ind;
    leftover_inds = (floor(m(icat)/3)*3+1:m(icat))' + start_ind;
    feature_data(start_ind + (1:m(icat)), :) = ...
        feature_data([reorder_inds(:); leftover_inds], :);
    start_ind = sum(m(1:icat));
end
title_str = 'Logistic Regression, Frequency Domain';
if do_reordering
    title_str = [title_str, ' (with Reordering)'];
end


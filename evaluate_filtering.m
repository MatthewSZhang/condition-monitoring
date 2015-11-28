function evaluate_filtering(feat_struct, machine_name)

% get classification of good points based on rms filtering
[~, good_inds] = clean_data(feat_struct, feat_struct.rms_z_vel, machine_name);

n_trials = 50;
error_rate = nan(n_trials, 1);
min_dist = nan(n_trials, 1);
for itrial = 1:n_trials
    % this is automatic prediction of data being a good point
    [cluster_ids, closest_ind, min_dist(itrial)] = cs229_kmeans(2, feat_struct);
    predicted_inds = (cluster_ids == closest_ind); 

    error_rate(itrial) = sum(good_inds ~= predicted_inds)/numel(good_inds);

%     n_true_positives = sum(~good_inds & ~predicted_inds); % bad, both agree 
%     n_false_positives = sum(good_inds & ~predicted_inds); % algorithm says bad
%     n_false_negatives = sum(~good_inds & predicted_inds); % we think it's bad
%     precision = n_true_positives / (n_true_positives + n_false_positives);
%     recall = n_true_positives / (n_true_positives + n_false_negatives);
end

figure('Color', 'w');
plot(min_dist, error_rate, 'Marker', '*', 'LineStyle', 'none'); 
grid on;
xlabel('Normalized distance between cluster and reference point');
ylabel('Error rate');

% fprintf(1, 'Error rate: %2.2f%%\n', error_rate*100);
% fprintf(1, 'Precision:  %2.2f%%\n', precision*100);
% fprintf(1, 'Recall:     %2.2f%%\n', recall*100);

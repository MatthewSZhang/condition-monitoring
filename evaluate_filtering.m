function evaluate_filtering(feat_struct, machine_name)

% get classification of good points based on rms filtering
[~, good_inds] = clean_data(feat_struct, feat_struct.rms_z_vel, machine_name);
% this is automatic prediction of data being a good point
[cluster_ids, closest_centroid_ind] = cs229_kmeans(2, feat_struct);
predicted_inds = (cluster_ids == closest_centroid_ind); 

error_rate = sum(good_inds ~= predicted_inds)/numel(good_inds);

n_true_positives = sum(~good_inds & ~predicted_inds); % bad, both agree 
n_false_positives = sum(good_inds & ~predicted_inds); % algorithm says bad
n_false_negatives = sum(~good_inds & predicted_inds); % we think it's bad
precision = n_true_positives / (n_true_positives + n_false_positives);
recall = n_true_positives / (n_true_positives + n_false_negatives);

fprintf(1, 'Error rate: %2.2f%%\n', error_rate*100);
fprintf(1, 'Precision:  %2.2f%%\n', precision*100);
fprintf(1, 'Recall:     %2.2f%%\n', recall*100);

function [cluster_ids, centroids] = cs229_kmeans(k, m3_features, m4_features)
% I couldn't think of what to name this function other than kmeans, but 
% that name was already taken!

% reformat for use in learning algorithms
feat_mat = [struct2mat(remove_time_stamp(m3_features)); 
    struct2mat(remove_time_stamp(m4_features))];

% run kmeans
rng(1); % for reproducibility
[cluster_ids, centroids] = kmeans(feat_mat, k);

% print out number of points in each cluster
for icluster = 1:k
    fprintf(1, 'Number of points in cluster %d: %d\n', icluster, sum(cluster_ids == icluster));
end

% plot some data color-coded by cluster
figure('Color', 'w');
cmap = colormap('lines'); hold on;
time_delta = [m3_features.time_delta_days', m4_features.time_delta_days'];
rms_x_acc = [m3_features.rms_x_acc, m4_features.rms_x_acc];
for icluster = 1:k
    inds = cluster_ids == icluster;
    plot(time_delta(inds), rms_x_acc(inds), 'Color', cmap(icluster, :), ...
        'Marker', '*', 'LineStyle', 'None');
end
grid on;

disp(' '); % this is just somewhere to give me a breakpoint
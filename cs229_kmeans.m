function [cluster_ids, centroids] = cs229_kmeans(k, feat_struct)
%CS229_KMEANS is pretty self explanatory
% I couldn't think of what to name this function other than kmeans, but 
% that name was already taken!
%
% Usage:
%   [cluster_ids, centroids] = cs229_kmeans(k, feat_struct);
% 
% Note: plot after clustering won't work unless feat_struct has features
%   time_delta_days and rms_x_acc

% reformat for use in learning algorithms
feat_mat = struct2mat(remove_time_stamp(feat_struct)); 

% run kmeans
rng(1); % for reproducibility
[cluster_ids, centroids] = kmeans(feat_mat, k);

% print out number of points in each cluster
for icluster = 1:k
    fprintf(1, 'Number of points in cluster %d: %d\n', icluster, sum(cluster_ids == icluster));
end

if ~isfield(feat_struct, 'time_delta_days') && isfield(feat_struct, 'rms_x_acc')
    return;
end
% plot some data color-coded by cluster
figure('Color', 'w');
cmap = colormap('lines'); hold on;
for icluster = 1:k
    inds = cluster_ids == icluster;
    plot(feat_struct.time_delta_days(inds), feat_struct.rms_x_acc(inds), ...
        'Color', cmap(icluster, :), 'Marker', '*', 'LineStyle', 'None');
end
grid on; xlabel('Time (days)'); ylabel('RMS X Acceleration');
legend(num2str((1:k)'));
title(sprintf('Kmeans Categorization (k = %d)', k));


function [cluster_ids, closest_ind, norm_min_dist] = cs229_kmeans(k, feat_struct)
%CS229_KMEANS is pretty self explanatory
% I couldn't think of what to name this function other than kmeans, but 
% that name was already taken!
%
% Usage:
%   [cluster_ids, centroids] = cs229_kmeans(k, feat_struct);
% 
% Note: plot after clustering won't work unless feat_struct has features
%   time_delta_days and rms_x_acc

do_plots = true;
if nargout == 3
    do_plots = false;
end

% pull out pre-selected features to use
feat_subset.rms_x_vel = feat_struct.rms_x_vel;
feat_subset.rms_y_vel = feat_struct.rms_y_vel;
feat_subset.rms_z_vel = feat_struct.rms_z_vel;

% reformat for use in learning algorithms
feat_mat = struct2mat(feat_subset);

% % run kmeans
% [cluster_ids, centroids] = kmeans(feat_mat, k);
% title_str = sprintf('Mixture of Gaussians Categorization (k = %d)', k);

% fit a mixture of gaussians model to the filtered data
GMModel = fitgmdist(feat_mat, k);
cluster_ids = cluster(GMModel, feat_mat);
centroids = GMModel.mu;
title_str = sprintf('Mixture of Gaussians Categorization (k = %d)', k);
        
if do_plots && isfield(feat_struct, 'rms_x_acc')
    % plot some data color-coded by cluster
    plot_categorized_data(cluster_ids, feat_struct, title_str)
end


% guess which cluster has the most normal data points in it
ref_point = nan(1, size(feat_mat, 2));
for icol = 1:size(feat_mat, 2)
    % make histogram of the data for this feature using 50 bins
    % using 0 as min for features -- not necessarily valid for
    % all features. change to use min instead? 
    centers = linspace(0, max(feat_mat(:, icol)), 50);
    counts = hist(feat_mat(:, icol), centers);
    % find the max bin, excluding first and last (outlier) bins
    [~, max_bin_minus_one] = max(counts(2:end-1)); 
    ref_point(icol) = centers(max_bin_minus_one+1);
end
dist = centroids - repmat(ref_point, k, 1);
dist = sqrt(sum(dist.^2, 2));
[min_dist, closest_ind] = min(dist);
fprintf(1, 'Minimum distance: %.2f\n', min_dist);
norm_min_dist = min_dist/norm(ref_point);
fprintf(1, 'Normalized: %.2f\n', norm_min_dist);
fprintf(1, 'Reference point: [%.2f, %.2f, %.2f]\n', ref_point(1), ref_point(2), ref_point(3));
closest = centroids(closest_ind, :);
fprintf(1, 'Closest centroid: [%.2f, %.2f, %.2f]\n', closest(1), closest(2), closest(3));


% --
function plot_categorized_data(labels, feat_struct, title_str)
k = numel(unique(labels));
% print out number of points in each cluster
fprintf(1, 'Cluster data for %s\n', title_str);
for icluster = 1:k
    fprintf(1, 'Number of points in cluster %d: %d\n', icluster, ... 
        sum(labels == icluster));
end

if isfield(feat_struct, 'time_delta_days') 
    x = feat_struct.time_delta_days;
else
    x = 1:numel(feat_struct.rms_x_acc);
end
% plot some data color-coded by cluster
figure('Color', 'w');
cmap = colormap('lines'); hold on;
for icluster = 1:k
    inds = labels == icluster;
    plot(x(inds), feat_struct.rms_x_acc(inds), ...
        'Color', cmap(icluster, :), 'Marker', '*', 'LineStyle', 'None');
end
grid on; xlabel('Time (days)'); ylabel('RMS X Acceleration');
legend(num2str((1:k)'));
title(title_str);

% plot some data color-coded by cluster
figure('Color', 'w');
cmap = colormap('lines'); hold on;
for icluster = 1:k
    inds = labels == icluster;
    plot3(feat_struct.rms_x_vel(inds), feat_struct.rms_y_vel(inds), ...
        feat_struct.rms_z_vel(inds), ...
        'Color', cmap(icluster, :), 'Marker', '*', 'LineStyle', 'None');
end
grid on; xlabel('RMS X Velocity'); ylabel('RMS Y Velocity');
legend(num2str((1:k)'));
title(title_str);

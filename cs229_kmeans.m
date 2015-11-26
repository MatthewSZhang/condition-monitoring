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

% % reformat for use in learning algorithms
% feat_mat = struct2mat(remove_time_stamp(feat_struct));

% feat_subset.rms_x_acc = feat_struct.rms_x_acc;
% feat_subset.rms_y_acc = feat_struct.rms_y_acc;
% feat_subset.rms_z_acc = feat_struct.rms_z_acc;
feat_subset.rms_x_vel = feat_struct.rms_x_vel;
feat_subset.rms_y_vel = feat_struct.rms_y_vel;
feat_subset.rms_z_vel = feat_struct.rms_z_vel;

% fnames = fieldnames(feat_struct);
% fnames(cellfun(@isempty, strfind(fnames, 'vel'))) = [];
% fnames(~cellfun(@isempty, strfind(fnames, 'kurtosis'))) = [];
% for ifield = 1:numel(fnames)
%     feat_subset.(fnames{ifield}) = feat_struct.(fnames{ifield});
%     for jfield = ifield:numel(fnames)
%         feat_subset.(fnames{jfield}) = feat_struct.(fnames{jfield});
        feat_mat = struct2mat(feat_subset);

%         fprintf(1, 'Using features %s and %s...\n', fnames{ifield}, fnames{jfield});
        % run kmeans
%         rng(1); % for reproducibility
        [cluster_ids, centroids] = kmeans(feat_mat, k);

        if ~isfield(feat_struct, 'rms_x_acc')
            return;
        end
        % plot some data color-coded by cluster
        title_str = sprintf('Kmeans Categorization (k = %d)', k);
        plot_cateegorized_data(cluster_ids, feat_struct, title_str)

%         feat_subset = rmfield(feat_subset, fnames{jfield});
%     end
%     if isfield(feat_subset, fnames{ifield})
%         feat_subset = rmfield(feat_subset, fnames{ifield});
%     end
% end

GMModel = fitgmdist(feat_mat, k, 'Start', cluster_ids);
cluster_ids = cluster(GMModel, feat_mat);
% plot some data color-coded by cluster
title_str = sprintf('Gaussian Mixture Model Categorization (k = %d)', k);
plot_cateegorized_data(cluster_ids, feat_struct, title_str);

function plot_cateegorized_data(labels, feat_struct, title_str)
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
    plot(feat_struct.rms_x_vel(inds), feat_struct.rms_y_vel(inds), ...
        'Color', cmap(icluster, :), 'Marker', '*', 'LineStyle', 'None');
end
grid on; xlabel('RMS X Velocity'); ylabel('RMS Y Velocity');
legend(num2str((1:k)'));
title(title_str);

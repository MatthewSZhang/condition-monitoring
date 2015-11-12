function plot_feature_pairs(data, labels)
% Inputs:
%   data = array of structures, where each structure follows output format
%       of calc_time_features
%   labels = optional cell array of strings specifying a category or label
%       for each data set in 'data'

n_sets = numel(data);
directions = {'x', 'y', 'z'};

% opening a figure because calling colormap will do that automatically
temp_fig = figure; 
cmap = colormap('lines');
close(temp_fig); % don't need this figure, so get rid of it
marker_list = 'o.^vs*';

% features_template = {'p2p_z_vel', 'p2p_z_accel', 'peak_z_vel', 'peak_z_accel', ...
%     'rms_z_vel', 'rms_z_accel'};
% features_template = {'peak_z_vel', 'peak_z_acc', 'rms_z_vel', 'rms_z_acc', ...
%     'kurtosis_z_vel', 'kurtosis_z_acc'};
features_template = {'crest_factor_z_vel', 'crest_factor_z_acc', ...
    'rms_z_vel', 'rms_z_acc', 'kurtosis_z_vel', 'kurtosis_z_acc'};

h_fig = nan(3, 1);
for iset = 1:n_sets
    for idir = 1:numel(directions)
        features_to_plot = strrep(features_template, '_z_', ['_',directions{idir},'_']);
        fname = [directions{idir}, ' measurement pairs'];
        if iset == 1
            h_fig(idir) = figure('Color', 'w');
            set(h_fig(idir), 'Name', fname);
        else
            figure(h_fig(idir));
        end

        iplot = 1;
        for ifeat = 1:numel(features_template)
            for jfeat = ifeat+1:numel(features_template)
                subplot(3, 5, iplot);
                plot(data(iset).(features_to_plot{ifeat}), ...
                    data(iset).(features_to_plot{jfeat}), ...
                    'Color', cmap(iset, :), 'Marker', marker_list(iset), ...
                    'LineStyle', 'none');
                hold on; grid on;
                if iset == n_sets
                    xlabel(strrep(features_to_plot{ifeat}, '_', ' '));
                    ylabel(strrep(features_to_plot{jfeat}, '_', ' '));
                    if iplot == 1 && exist('labels', 'var')
                        legend(labels, 'Location', 'best');
                    end
                end
                iplot = iplot + 1;
            end
        end
    %     saveas(h_fig, [fname,'.fig']);
    end
end

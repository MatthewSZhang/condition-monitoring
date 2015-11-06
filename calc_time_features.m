function f = calc_time_features(s)
%CALC_TIME_FEATURES takes structure of raw input data and calculates
% several time domain features. Sample size of 4096 is assumed. 
%
% Usage:
%   f = calc_time_features(s);
%
% Inputs:
%   s = structure with fields 'x_velocity', 'x_accel', and same for y, z
%
% Outputs:
%   f = structure with fields '<feat>_<axis>_vel' or '<feat>_<axis>_acc',
%       where <feat> is the feature name, and <axis> is 'x', 'y', or 'z'

directions = {'x', 'y', 'z'};
base_features = {'velocity', 'accel'};
features = {'rms', 'kurtosis', 'peak', 'crest_factor'};

% do some basic error checking on input data
sample_size = 4096; 
n_points = numel(s.x_velocity);
n_batches = n_points/sample_size;
if n_batches - floor(n_batches) ~= 0
    error([mfilename,':input'], ...
        'Number of data points %d is not evenly divisible by sample size %d.', ...
        n_points, sample_size);
end

f = struct; % initialize structure that will hold computed feature data

for idir = 1:3 % loop over x, y, z
    for ibase = 1:2 % loop over velocity and acceleration
        base_fname = [directions{idir},'_',base_features{ibase}];
        for ifeat = 1:numel(features) % loop over features to compute
            derived_fname = [features{ifeat},'_',directions{idir},'_',...
                base_features{ibase}(1:3)];
            % crest factor is derived from peak and rms
            if strcmp(features{ifeat}, 'crest_factor')             
                f.(derived_fname) = ...
                    f.(strrep(derived_fname, 'crest_factor', 'peak')) ./ ...
                    f.(strrep(derived_fname, 'crest_factor', 'rms'));
                continue;
            end
            % other features are computed from raw data
            f.(derived_fname) = calc_feature(s.(base_fname), ...
                features{ifeat}, sample_size);
        end % ifeat
    end % ibase
end % idir
% attach time stamp data
f.time_stamp = s.time_stamp(1:sample_size:end)'; % string format
dn = datenum(f.time_stamp);
f.time_delta_days = dn - dn(1); % days since first time stamp


function output = calc_feature(raw_data, feature, sample_size)
% reshape data so that each column is one sample/batch
data = reshape(raw_data, sample_size, []);

switch feature
    case 'rms'
        output = sqrt(sum(data.^2, 1)/sample_size);
    case 'peak'
        output = max(data, [], 1);
    case 'mean'
        output = mean(data, 1);
    case 'var'
        output = var(data, 1);
    case 'kurtosis'
        mu = calc_feature(raw_data, 'mean', sample_size);
        sigma_sq = calc_feature(raw_data, 'var', sample_size);
        output = mean((data - repmat(mu, sample_size, 1)).^4, 1) ./ (sigma_sq.^2);
    otherwise
        error([mfilename,':input'], 'Feature ''%s'' not recognized.', feature);
end

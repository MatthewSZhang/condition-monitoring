function [freqs, outmat] = select_features(varargin)
%
% Usage: 
%   [freqs, outmat] = select_features(M1_FZvelgood, M3_FZvelgood, ...);
%
% Inputs:
%   M1_FZvelgood, M3_FZvelgood, ... = two or more matrices of features,
%       sized [n x m], where n = # of features and m = # of examples
%
% Outputs:
%   freqs = frequencies, sorted in descending order of abs correlation
%   outmat = all feature data, sorted in descending order of abs
%       correlation, with data label tacked on as last feature

frequencies = 0:2:1666*2;

% if numel(varargin{end}) == 1
%     n_features = varargin{end};
%     varargin(end) = [];
%     frac_features = n_features/1667;
% else
%     frac_features = 0.2;
% end
n_cats = numel(varargin);
m = zeros(n_cats, 1); % m(i) = # training examples for ith category
labels = [];
for icat = 1:n_cats
    m(icat) = size(varargin{icat}, 2);
    labels = [labels; icat*ones(m(icat), 1)];
end
feature_data = [varargin{:}]';

Rvz = corr([feature_data, labels]);
Rvz = Rvz(1:1667,1668);

figure;
hold on;
% plot(frequencies, Raz, 'b')
plot(frequencies, Rvz, 'r')
xlabel('Frequency (Hz)')
ylabel('Correlation')
% legend({'Acceleration'; 'Velocity'});
% title('Velocity and Acceleration in the Z Direction')
title('Velocity in the Z Direction')

[~, rank_inds] = sort(abs(Rvz), 'descend');
% sort features by descending abs(correlation)
freqs = frequencies(rank_inds);
%fnames = strcat('velZ', num2str(freqs')); , {'_Hz'});
outmat = feature_data(:, rank_inds);

%fnames = [fnames; 'label'];
outmat = [outmat, labels];

function [mat, fnames] = struct2mat(s)
%STRUCT2MAT converts a structure of numeric vectors to an array with each
% column corresponding to a field in the input structure. No error checking.
%
% Usage:
%   [mat, fnames] = struct2mat(s);
%
% Inputs:
%   s = struct with n fields, each containing a vector of m numeric values
%
% Outputs: 
%   mat = (m x n) matrix of numeric values
%   fnames = column header for mat

fnames = fieldnames(s);
n_rows = numel(s.(fnames{1}));
n_cols = numel(fnames);

mat = zeros(n_rows, n_cols);
for ifield = 1:n_cols
    mat(:, ifield) = s.(fnames{ifield})(:);
end

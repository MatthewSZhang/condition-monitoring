function s = cat_structs(s1, s2)
%CAT_STRUCTS concatenates all shared fields from two structures into a
% single output structure.
%
% Usage: 
%   s = cat_structs(s1, s2);

% determine field names of output structure from names of input structures
s1_fnames = fieldnames(s1);
s2_fnames = fieldnames(s2);
fnames = intersect(s1_fnames, s2_fnames);
if ~isequal(s1_fnames, s2_fnames)
    warning([mfilename,':input'], 'Field names of input structures are not consistent.');
end

% compare dimensions of data in first field of each structure
s1_size = size(s1.(s1_fnames{1}));
[~, dim1] = max(s1_size);
s2_size = size(s2.(s2_fnames{1}));
[~, dim2] = max(s2_size);
if dim1 == dim2
    flip_dim2 = false;
else
    flip_dim2 = true;
end

% concatenate all the fields
for iname = 1:numel(s1_fnames)
    if flip_dim2
        s.(fnames{iname}) = cat(dim1, s1.(fnames{iname}), s2.(fnames{iname})');
    else
        s.(fnames{iname}) = cat(dim1, s1.(fnames{iname}), s2.(fnames{iname}));
    end
end

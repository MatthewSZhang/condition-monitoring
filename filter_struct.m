function s = filter_struct(s, inds)
%FILTER_STRUCT filters all fields of a structure using given indices, which
% may be numerical or logical indices. No error checking is performed. 
%
% Usage:
%   s = filter_struct(s, inds);
%

fnames = fieldnames(s);
for name = fnames(:)'
    s.(name{1}) = s.(name{1})(inds);
end

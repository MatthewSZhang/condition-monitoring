function feat_struct = remove_time_stamp(feat_struct)

if isfield(feat_struct, 'time_stamp')
    feat_struct = rmfield(feat_struct, 'time_stamp');
end
if isfield(feat_struct, 'time_delta_days')
    feat_struct = rmfield(feat_struct, 'time_delta_days');
end

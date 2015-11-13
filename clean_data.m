function data = clean_data(data, rms_z_vel, machine)

switch lower(machine)
    case 'm1'
        l = 1.25;
        u = 2.5;
    case 'm3'
        l = 0.75;
        u = 1.25;
    case 'm4'
        l = 0.45;
        u = 0.8;
    case 'sn41'
        l = 5.75;
        u= 8;
    otherwise
        error([mfilename,':input'], 'Unrecognized machine ''%s''', machine);
end

good_inds = rms_z_vel >= l & rms_z_vel <= u;
fprintf('Removing %d points and keeping %d points...\n', sum(~good_inds), sum(good_inds));
if isstruct(data)
    data = filter_struct(data, good_inds);
else
    [m, n] = size(data);
    if m == n && numel(good_inds) == m
        warning([mfilename,':input'], 'Array is square. Dimension to filter is ambiguous.');
    end
    if numel(good_inds) == m
        data = data(good_inds, :);
    elseif numel(good_inds) == n
        data = data(:, good_inds);
    else
        error([mfilename,':input'], 'Input sizes are inconsistent.');
    end
end

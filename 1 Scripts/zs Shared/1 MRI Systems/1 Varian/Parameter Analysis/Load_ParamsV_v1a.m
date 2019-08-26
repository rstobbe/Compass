%================================================
% Load Parameters
% - Return Parameters
%================================================

function [Text,err] = Load_ParamsV_v1a(path)

err.flag = 0;
err.msg = '';
Text = '';

file = fopen(path);
if file == -1
    err.msg = 'Not an Experiment Folder (or ''params'' file missing)';
    err.flag = 1;
    return
end

A = fread(file);
Text = char(A');
    
fclose(file);

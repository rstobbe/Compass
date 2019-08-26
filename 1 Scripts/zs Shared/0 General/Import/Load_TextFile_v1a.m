%================================================
% Load TextFile
% 
%================================================

function [Text,err] = Load_TextFile_v1a(path)

err.msg = '';
err.flag = 0;
Text = '';

file = fopen(path);
if file == -1
    err.msg = 'Not an Experiment Folder (or procpar file missing)';
    err.flag = 1;
    return
end

A = fread(file);
Text = char(A');
    
fclose(file);

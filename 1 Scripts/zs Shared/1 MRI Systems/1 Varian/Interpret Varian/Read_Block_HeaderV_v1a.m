%===============================================
% Read Block Header
% - this is used in TRICS 4.5 and later
%===============================================

function [lvl,tlt,ct] = Read_Block_Header(infid)

% 28 bytes total - or 7 4byte words...

scale   = fread(infid, 1, 'short');     %2
status  = fread(infid, 1, 'short');
index   = fread(infid, 1, 'short');
mode    = fread(infid, 1, 'short');
ct      = fread(infid, 1, 'long');      %4
lpval   = fread(infid, 1, 'float');
rpval   = fread(infid, 1, 'float');     %4
lvl     = fread(infid, 1, 'float');
tlt     = fread(infid, 1, 'float');



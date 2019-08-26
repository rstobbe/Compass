%====================================================
%
%====================================================

function [default] = B1MapMultiRcvr_v2b_Default2(SCRPTPATHS)

if strcmp(filesep,'\')
    filtpath = [SCRPTPATHS.voyagerloc,'Image Processing\Underlying\Selectable Functions\Filter Image\Low Pass\'];
elseif strcmp(filesep,'/')
end
filtfunc = 'LowPassFilterKaiser3D_v1a';

m = 1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'Mask (relval)';
default{m,1}.entrystr = '0.1';

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'LowPassfunc';
default{m,1}.entrystr = filtfunc;
default{m,1}.searchpath = filtpath;
default{m,1}.path = [filtpath,filtfunc];
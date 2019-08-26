%====================================================
%
%====================================================

function [default] = PreProc_mpflash3d_v1a_Default2(SCRPTPATHS)

if strcmp(filesep,'\')
    imdccorpath = [SCRPTPATHS.voyagerloc,'Image Creation\Underlying\zz Underlying\Selectable Functions\PreProcess\DCcor Functions\'];
elseif strcmp(filesep,'/')
end
imdccorfunc = 'DCcor_im3D_v1a';
addpath([imdccorpath,imdccorfunc]);

m = 1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'imDCcorfunc';
default{m,1}.entrystr = imdccorfunc;
default{m,1}.searchpath = imdccorpath;
default{m,1}.path = [imdccorpath,imdccorfunc];


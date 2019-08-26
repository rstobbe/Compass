%====================================================
%
%====================================================

function [default] = Create3DGrappa1_v1a_Default2(SCRPTPATHS)

if strcmp(filesep,'\')
    importpath = [SCRPTPATHS.voyagerloc,'Image Creation\Underlying\Selectable Functions\Import FID\'];
    kdccorpath = [SCRPTPATHS.voyagerloc,'Image Creation\Underlying\Selectable Functions\PreProcess\DCcor Functions\'];
    imdccorpath = [SCRPTPATHS.voyagerloc,'Image Creation\Underlying\Selectable Functions\PostProcess\DCcor Functions\'];
    rcvcombpath = [SCRPTPATHS.voyagerloc,'Image Creation\Underlying\Selectable Functions\Receiver Combination\'];
elseif strcmp(filesep,'/')
end
importfunc = 'ImportFIDV_mpflash3d_v1a';
kdccorfunc = 'DCcor_median_v1a';
imdccorfunc = 'DCcor_im3D_v1a';
rcvcombfunc = 'RcvComb_Super_v1a';
addpath([importpath,importfunc]);
addpath([kdccorpath,kdccorfunc]);
addpath([imdccorpath,imdccorfunc]);
addpath([rcvcombpath,rcvcombfunc]);

m = 1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'Image_Name';
default{m,1}.entrystr = '';

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'ImportFIDfunc';
default{m,1}.entrystr = importfunc;
default{m,1}.searchpath = importpath;
default{m,1}.path = [importpath,importfunc];

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'kDCcorfunc';
default{m,1}.entrystr = kdccorfunc;
default{m,1}.searchpath = kdccorpath;
default{m,1}.path = [kdccorpath,kdccorfunc];

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'imDCcorfunc';
default{m,1}.entrystr = imdccorfunc;
default{m,1}.searchpath = imdccorpath;
default{m,1}.path = [imdccorpath,imdccorfunc];

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'RcvCombfunc';
default{m,1}.entrystr = rcvcombfunc;
default{m,1}.searchpath = rcvcombpath;
default{m,1}.path = [rcvcombpath,rcvcombfunc];

m = m+1;
default{m,1}.entrytype = 'RunScrptFunc';
default{m,1}.scrpttype = 'Imaging';
default{m,1}.labelstr = 'Create Image';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Run';
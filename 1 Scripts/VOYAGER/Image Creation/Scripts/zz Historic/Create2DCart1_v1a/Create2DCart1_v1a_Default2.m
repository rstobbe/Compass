%====================================================
%
%====================================================

function [default] = Create2DCart1_v1a_Default2(SCRPTPATHS)

if strcmp(filesep,'\')
    importpath = [SCRPTPATHS.voyagerloc,'Image Creation\Underlying\Selectable Functions\Import FID\'];
    dccorpath = [SCRPTPATHS.voyagerloc,'Image Creation\Underlying\Selectable Functions\DC Correction\'];
    preprocpath = [SCRPTPATHS.voyagerloc,'Image Creation\Underlying\Selectable Functions\PreProcess\'];
    filterpath = [SCRPTPATHS.voyagerloc,'Image Creation\Underlying\Selectable Functions\Filter\'];
    rcvcombpath = [SCRPTPATHS.voyagerloc,'Image Creation\Underlying\Selectable Functions\Receiver Combination\'];
    postprocpath = [SCRPTPATHS.voyagerloc,'Image Creation\Underlying\Selectable Functions\PostProcess\'];
elseif strcmp(filesep,'/')
end
importfunc = 'ImportFIDV_FSEstandard_v1a';
dccorfunc = 'DCcor_median2D_v1a';
preprocfunc = 'PreProc_FSEstandard_v1a';
filterfunc = 'Filter_none_v1a';
rcvcombfunc = 'RcvComb_SingleSuper_v1b';
postprocfunc = 'PostProc_FSEstandard_v1a';
addpath([importpath,importfunc]);
addpath([dccorpath,dccorfunc]);
addpath([preprocpath,preprocfunc]);
addpath([filterpath,filterfunc]);
addpath([postprocpath,postprocfunc]);
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
default{m,1}.labelstr = 'DCcorfunc';
default{m,1}.entrystr = dccorfunc;
default{m,1}.searchpath = dccorpath;
default{m,1}.path = [dccorpath,dccorfunc];

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'PreProcfunc';
default{m,1}.entrystr = preprocfunc;
default{m,1}.searchpath = preprocpath;
default{m,1}.path = [preprocpath,preprocfunc];

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'RcvCombfunc';
default{m,1}.entrystr = rcvcombfunc;
default{m,1}.searchpath = rcvcombpath;
default{m,1}.path = [rcvcombpath,rcvcombfunc];

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'Filterfunc';
default{m,1}.entrystr = filterfunc;
default{m,1}.searchpath = filterpath;
default{m,1}.path = [filterpath,filterfunc];

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'PostProcfunc';
default{m,1}.entrystr = postprocfunc;
default{m,1}.searchpath = postprocpath;
default{m,1}.path = [postprocpath,postprocfunc];

m = m+1;
default{m,1}.entrytype = 'RunScrptFunc';
default{m,1}.scrpttype = 'Imaging';
default{m,1}.labelstr = 'Create Image';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Run';
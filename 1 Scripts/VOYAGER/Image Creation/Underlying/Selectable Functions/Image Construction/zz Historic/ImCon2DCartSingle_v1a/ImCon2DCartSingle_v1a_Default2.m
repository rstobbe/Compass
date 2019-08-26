%====================================================
%
%====================================================

function [default] = ImCon2DCartSingle_v1a_Default2(SCRPTPATHS)

if strcmp(filesep,'\')
    preprocpath = [SCRPTPATHS.voyagerloc,'Image Creation\Underlying\Selectable Functions\PreProcess\'];
    rcvcombpath = [SCRPTPATHS.voyagerloc,'Image Creation\Underlying\Selectable Functions\Receiver Combination\'];
    filterpath = [SCRPTPATHS.voyagerloc,'Image Processing\Underlying\Selectable Functions\Filter Image\'];
    zerofillpath = [SCRPTPATHS.voyagerloc,'Image Processing\Underlying\Selectable Functions\ZeroFill\'];
    postprocpath = [SCRPTPATHS.voyagerloc,'Image Creation\Underlying\Selectable Functions\PostProcess\'];
elseif strcmp(filesep,'/')
end
preprocfunc = 'PreProc_mpflash3d_v1a';
rcvcombfunc = 'RcvComb_SingleSuper_v1b';
filterfunc = 'Filter_none_v1a';
postprocfunc = 'PostProc_mpflash3d_v1a';
zerofillfunc = 'ZeroFill_none_v1a';
addpath([preprocpath,preprocfunc]);
addpath([rcvcombpath,rcvcombfunc]);
addpath([filterpath,filterfunc]);
addpath([zerofillpath,zerofillfunc]);
addpath([postprocpath,postprocfunc]);

m = 1;
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
default{m,1}.labelstr = 'ZeroFillfunc';
default{m,1}.entrystr = zerofillfunc;
default{m,1}.searchpath = zerofillpath;
default{m,1}.path = [zerofillpath,zerofillfunc];

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'PostProcfunc';
default{m,1}.entrystr = postprocfunc;
default{m,1}.searchpath = postprocpath;
default{m,1}.path = [postprocpath,postprocfunc];


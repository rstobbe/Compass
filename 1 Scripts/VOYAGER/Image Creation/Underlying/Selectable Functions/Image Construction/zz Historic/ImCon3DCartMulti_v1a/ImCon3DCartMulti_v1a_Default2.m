%====================================================
%
%====================================================

function [default] = ImCon3DCartMulti_v1a_Default2(SCRPTPATHS)

if strcmp(filesep,'\')
    preprocpath = [SCRPTPATHS.voyagerloc,'Image Creation\Underlying\Selectable Functions\PreProcess\'];
    rcvcombpath = [SCRPTPATHS.voyagerloc,'Image Creation\Underlying\Selectable Functions\Receiver Combination\'];
    filterpath = [SCRPTPATHS.voyagerloc,'Image Processing\Underlying\Selectable Functions\Filter Image\No Filter\'];
    zerofillpath = [SCRPTPATHS.voyagerloc,'Image Processing\Underlying\Selectable Functions\ZeroFill\'];
    orientpath = [SCRPTPATHS.voyagerloc,'Image Creation\Underlying\Selectable Functions\Orient\'];
elseif strcmp(filesep,'/')
end
preprocfunc = 'PreProc_none_v1a';
rcvcombfunc = 'RcvComb_none_v1a';
filterfunc = 'Filter_none_v1a';
zerofillfunc = 'ZeroFill_none_v1a';
orientfunc = 'Orient_SPGR_v1a';
addpath([preprocpath,preprocfunc]);
addpath([rcvcombpath,rcvcombfunc]);
addpath([filterpath,filterfunc]);
addpath([zerofillpath,zerofillfunc]);
addpath([orientpath,orientfunc]);

m = 1;
default{m,1}.entrytype = 'Choose';
default{m,1}.labelstr = 'Visuals';
default{m,1}.entrystr = 'Yes';
default{m,1}.options = {'Yes','No'};

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
default{m,1}.labelstr = 'ZeroFillfunc';
default{m,1}.entrystr = zerofillfunc;
default{m,1}.searchpath = zerofillpath;
default{m,1}.path = [zerofillpath,zerofillfunc];

m = m+1;
default{m,1}.entrytype = 'Choose';
default{m,1}.labelstr = 'ReturnFoV';
default{m,1}.entrystr = 'Yes';
default{m,1}.options = {'Yes','No'};

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'Orientfunc';
default{m,1}.entrystr = orientfunc;
default{m,1}.searchpath = orientpath;
default{m,1}.path = [orientpath,orientfunc];


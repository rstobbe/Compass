%====================================================
%
%====================================================

function [default] = PostGradEddy_v1a_Default2(SCRPTPATHS)

if strcmp(filesep,'\')
    addpath(genpath([SCRPTPATHS.rootloc,'Scanner Related\Field Analysis\Underlying\zz Common']));
    psbgpath = [SCRPTPATHS.rootloc,'Scanner Related\Field Analysis\Underlying\Selectable Functions\Position and Background\'];
    tgpath = [SCRPTPATHS.rootloc,'Scanner Related\Field Analysis\Underlying\Selectable Functions\Transient Gradient\'];
elseif strcmp(filesep,'/')
end
psbgfunc = 'PosBG_v2b';
tgfunc = 'TransGrad_v1a';
addpath([psbgpath,psbgfunc]);
addpath([tgpath,tgfunc]);

m = 1;
default{m,1}.entrytype = 'Choose';
default{m,1}.labelstr = 'System';
default{m,1}.entrystr = 'Varian';
default{m,1}.options = {'SMIS','Varian'};

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'B0 (1% -> uTpG)';
default{m,1}.entrystr = '0.0185';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'G (act% -> V%)';
default{m,1}.entrystr = '0.48';

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'PosBgrndfunc';
default{m,1}.entrystr = psbgfunc;
default{m,1}.searchpath = psbgpath;
default{m,1}.path = [psbgpath,psbgfunc];

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'TransGradfunc';
default{m,1}.entrystr = tgfunc;
default{m,1}.searchpath = tgpath;
default{m,1}.path = [tgpath,tgfunc];

m = m+1;
default{m,1}.entrytype = 'RunScrptFunc';
default{m,1}.scrpttype = 'PostGradEddyMultiDiscrete';
default{m,1}.labelstr = 'Determine Fields';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Run';


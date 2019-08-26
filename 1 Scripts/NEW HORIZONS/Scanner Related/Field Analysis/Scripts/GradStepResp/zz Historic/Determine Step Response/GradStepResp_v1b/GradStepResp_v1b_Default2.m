%====================================================
%
%====================================================

function [default] = GradStepResp_v1b_Default2(SCRPTPATHS)

if strcmp(filesep,'\')
    addpath(genpath([SCRPTPATHS.newhorizonsloc,'Scanner Related\Field Analysis\Underlying\zz Common']));
    psbgpath = [SCRPTPATHS.newhorizonsloc,'Scanner Related\Field Analysis\Underlying\Selectable Functions\Position and Background\'];
    tgpath = [SCRPTPATHS.newhorizonsloc,'Scanner Related\Field Analysis\Underlying\Selectable Functions\Transient Field Calculation\'];
elseif strcmp(filesep,'/')
end
psbgfunc = 'PosBG_v2d';
tgfunc = 'RFPreMultiGrad_v1a';
addpath([psbgpath,psbgfunc]);
addpath([tgpath,tgfunc]);

m = 1;
default{m,1}.entrytype = 'StatInput';
default{m,1}.labelstr = 'StepResp_Name';
default{m,1}.entrystr = '';

m = m+1;
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
default{m,1}.labelstr = 'TransFieldfunc';
default{m,1}.entrystr = tgfunc;
default{m,1}.searchpath = tgpath;
default{m,1}.path = [tgpath,tgfunc];

m = m+1;
default{m,1}.entrytype = 'RunScrptFunc';
default{m,1}.scrpttype = 'EddyCurrents';
default{m,1}.labelstr = 'Determine Fields';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Run';


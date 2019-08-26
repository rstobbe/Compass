%====================================================
%
%====================================================

function [default] = PreGradEddy_v1d_Default2(SCRPTPATHS)

if strcmp(filesep,'\')
    addpath(genpath([SCRPTPATHS.rootloc,'Scanner Related\Field Analysis\Underlying\zz Common']));
    psbgpath = [SCRPTPATHS.rootloc,'Scanner Related\Field Analysis\Underlying\Selectable Functions\Position and Background\'];
    regpath = [SCRPTPATHS.rootloc,'Scanner Related\Field Analysis\Underlying\Selectable Functions\Regression\'];
    plotpath = [SCRPTPATHS.rootloc,'Scanner Related\Field Analysis\Underlying\Selectable Functions\Plot\'];
elseif strcmp(filesep,'/')
end
addpath(genpath(psbgpath));
addpath(genpath(regpath));
addpath(genpath(plotpath));

psbgfunc = 'PosBG_v2a';
regfunc = 'Grad_MonoExp_v2b';
plotfunc = 'Plot_TF_v1a';

m = 1;
default{m,1}.entrytype = 'Choose';
default{m,1}.labelstr = 'System';
default{m,1}.entrystr = 'Varian';
default{m,1}.options = {'SMIS','Varian'};

m = m+1;
default{m,1}.entrytype = 'RunExtFunc';
default{m,1}.labelstr = 'DefFileLoc';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Select';
default{m,1}.runfunc = 'SelDefDataLoc_v2';
default{m,1}.runfuncinput = {SCRPTPATHS.outrootloc};
default{m,1}.runfuncoutput = {SCRPTPATHS.outrootloc};

m = m+1;
default{m,1}.entrytype = 'Choose';
default{m,1}.labelstr = 'DefSearch';
default{m,1}.entrystr = 'Yes';
default{m,1}.options = {'Yes','No'};

m = m+1;
default{m,1}.entrytype = 'RunExtFunc';
default{m,1}.labelstr = 'File_NoGrad1';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Load';
default{m,1}.runfunc = 'SelectFidData_v2';
default{m,1}.runfuncinput = {''};
default{m,1}.runfuncoutput = {''};

m = m+1;
default{m,1}.entrytype = 'RunExtFunc';
default{m,1}.labelstr = 'File_NoGrad2';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Load';
default{m,1}.runfunc = 'SelectFidData_v2';
default{m,1}.runfuncinput = {''};
default{m,1}.runfuncoutput = {''};

m = m+1;
default{m,1}.entrytype = 'RunExtFunc';
default{m,1}.labelstr = 'File_PosLoc1';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Load';
default{m,1}.runfunc = 'SelectFidData_v2';
default{m,1}.runfuncinput = {''};
default{m,1}.runfuncoutput = {''};

m = m+1;
default{m,1}.entrytype = 'RunExtFunc';
default{m,1}.labelstr = 'File_PosLoc2';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Load';
default{m,1}.runfunc = 'SelectFidData_v2';
default{m,1}.runfuncinput = {''};
default{m,1}.runfuncoutput = {''};

m = m+1;
default{m,1}.entrytype = 'RunExtFunc';
default{m,1}.labelstr = 'File_Grad1';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Load';
default{m,1}.runfunc = 'SelectFidData_v2';
default{m,1}.runfuncinput = {''};
default{m,1}.runfuncoutput = {''};

m = m+1;
default{m,1}.entrytype = 'RunExtFunc';
default{m,1}.labelstr = 'File_Grad2';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Load';
default{m,1}.runfunc = 'SelectFidData_v2';
default{m,1}.runfuncinput = {''};
default{m,1}.runfuncoutput = {''};

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
default{m,1}.labelstr = 'Pos / Bgrnd';
default{m,1}.entrystr = psbgfunc;
default{m,1}.searchpath = psbgpath;

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'Regression';
default{m,1}.entrystr = regfunc;
default{m,1}.searchpath = regpath;

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'Plot';
default{m,1}.entrystr = plotfunc;
default{m,1}.searchpath = plotpath;

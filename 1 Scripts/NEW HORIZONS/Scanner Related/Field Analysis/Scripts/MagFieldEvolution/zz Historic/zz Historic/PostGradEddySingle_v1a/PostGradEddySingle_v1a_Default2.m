%====================================================
%
%====================================================

function [default] = PostGradEddySingle_v1a_Default2(SCRPTPATHS)

if strcmp(filesep,'\')
    addpath(genpath([SCRPTPATHS.rootloc,'Scanner Related\Field Analysis\Underlying\zz Common']));
    regpath = [SCRPTPATHS.rootloc,'Scanner Related\Field Analysis\Underlying\Selectable Functions\Regression\'];
    filtpath = [SCRPTPATHS.rootloc,'Scanner Related\Field Analysis\Underlying\Selectable Functions\LowPassFilter\'];
    psbgpath = [SCRPTPATHS.rootloc,'Scanner Related\Field Analysis\Underlying\Selectable Functions\Position and Background\'];
elseif strcmp(filesep,'/')
end

psbg = 'PosBG2_v1a';
gradreg = 'Grad_MonoExp_v2a';
B0reg = 'B0_MonoExp_v2a';
gradfilt = 'Grad_LPF_v1a';
B0filt = 'B0_LPF_v1a';

addpath(genpath(regpath));
addpath(genpath(filtpath));
addpath(genpath(psbgpath));

m = 1;
default{m,1}.entrytype = 'Choose';
default{m,1}.labelstr = 'System';
default{m,1}.entrystr = 'Varian';
default{m,1}.options = {'SMIS','Varian'};

m = m+1;
default{m,1}.entrytype = 'RunFunc';
default{m,1}.labelstr = 'DefFileLoc';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Select';
default{m,1}.runfunc = 'SelDefDataLoc_v1';
default{m,1}.runfuncdata = {SCRPTPATHS.outrootloc};

m = m+1;
default{m,1}.entrytype = 'Choose';
default{m,1}.labelstr = 'DefSearch';
default{m,1}.entrystr = 'Yes';
default{m,1}.options = {'Yes','No'};

m = m+1;
default{m,1}.entrytype = 'RunFunc';
default{m,1}.labelstr = 'File_NoGrad1';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Load';
default{m,1}.runfunc = 'SelectFidData_v1';
default{m,1}.runfuncdata = {''};

m = m+1;
default{m,1}.entrytype = 'RunFunc';
default{m,1}.labelstr = 'File_NoGrad2';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Load';
default{m,1}.runfunc = 'SelectFidData_v1';
default{m,1}.runfuncdata = {''};

m = m+1;
default{m,1}.entrytype = 'RunFunc';
default{m,1}.labelstr = 'File_PosLoc1';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Load';
default{m,1}.runfunc = 'SelectFidData_v1';
default{m,1}.runfuncdata = {''};

m = m+1;
default{m,1}.entrytype = 'RunFunc';
default{m,1}.labelstr = 'File_PosLoc2';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Load';
default{m,1}.runfunc = 'SelectFidData_v1';
default{m,1}.runfuncdata = {''};

m = m+1;
default{m,1}.entrytype = 'RunFunc';
default{m,1}.labelstr = 'File_GradDel1';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Load';
default{m,1}.runfunc = 'SelectFidData_v1';
default{m,1}.runfuncdata = {''};

m = m+1;
default{m,1}.entrytype = 'RunFunc';
default{m,1}.labelstr = 'File_GradDel2';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Load';
default{m,1}.runfunc = 'SelectFidData_v1';
default{m,1}.runfuncdata = {''};

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'Gstart (ms)';
default{m,1}.entrystr = '1';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'Gstop (ms)';
default{m,1}.entrystr = '30';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'B0 (1% -> uTpG)';
default{m,1}.entrystr = '0.0185';

m = m+1;
default{m,1}.entrytype = 'Choose';
default{m,1}.labelstr = 'TransFld Vis';
default{m,1}.entrystr = 'Off';
default{m,1}.options = {'On','Off'};

m = m+1;
default{m,1}.entrytype = 'Choose';
default{m,1}.labelstr = 'MultAcq Vis';
default{m,1}.entrystr = 'Off';
default{m,1}.options = {'On','Off'};

m = m+1;
default{m,1}.entrytype = 'Choose';
default{m,1}.labelstr = 'Do Regress';
default{m,1}.entrystr = 'No';
default{m,1}.options = {'Yes','No'};

m = m+1;
default{m,1}.entrytype = 'Choose';
default{m,1}.labelstr = 'Colour';
default{m,1}.entrystr = 'k';
default{m,1}.options = {'k','r','g','b','c','m','y'};

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'Pos / Bgrnd';
default{m,1}.entrystr = psbg;
default{m,1}.searchpath = psbgpath;

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'Filt_Grad';
default{m,1}.entrystr = gradfilt;
default{m,1}.searchpath = filtpath;

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'Filt_B0';
default{m,1}.entrystr = B0filt;
default{m,1}.searchpath = filtpath;

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'Reg_Grad';
default{m,1}.entrystr = gradreg;
default{m,1}.searchpath = regpath;

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'Reg_B0';
default{m,1}.entrystr = B0reg;
default{m,1}.searchpath = regpath;


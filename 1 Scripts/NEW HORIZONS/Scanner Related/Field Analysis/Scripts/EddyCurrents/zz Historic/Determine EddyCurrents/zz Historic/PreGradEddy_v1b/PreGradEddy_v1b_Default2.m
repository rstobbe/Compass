%====================================================
%
%====================================================

function [default] = PreGradEddy_v1c_Default2(SCRPTPATHS)

if strcmp(filesep,'\')
    addpath(genpath([SCRPTPATHS.rootloc,'Scanner Related\Field Analysis\Underlying\zz Common']));
    regpath = [SCRPTPATHS.rootloc,'Scanner Related\Field Analysis\Underlying\Selectable Functions\Regression\'];
    psbgpath = [SCRPTPATHS.rootloc,'Scanner Related\Field Analysis\Underlying\Selectable Functions\Position and Background\'];
elseif strcmp(filesep,'/')

end

psbg = 'PosBG2_v1a';
gradreg = 'Grad_MonoExp_v2a';
B0reg = 'B0_MonoExp_v2a';

addpath(genpath(regpath));
addpath(genpath(psbgpath));

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
default{m,1}.entrytype = 'Choose';
default{m,1}.labelstr = 'GradTrans Vis';
default{m,1}.entrystr = 'Off';
default{m,1}.options = {'Full','Partial','Off'};

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
default{m,1}.labelstr = 'Reg_Grad';
default{m,1}.entrystr = gradreg;
default{m,1}.searchpath = regpath;

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'Reg_B0';
default{m,1}.entrystr = B0reg;
default{m,1}.searchpath = regpath;


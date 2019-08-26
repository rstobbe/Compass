%====================================================
%
%====================================================

function [default] = REAL_Varian_v1a_Default2(SCRPTPATHS)

if strcmp(filesep,'\')
    addpath(genpath([SCRPTPATHS.rootloc,'Image Creation\Underlying\zz Common']));
    DCcorpath = [SCRPTPATHS.rootloc,'Image Creation\Underlying\Selectable Functions\PreProcess Functions\DCcor Functions\'];
    Gridpath = [SCRPTPATHS.rootloc,'Image Creation\Underlying\Selectable Functions\Grid Functions\'];
elseif strcmp(filesep,'/')
end

addpath(genpath(DCcorpath));
addpath(genpath(Gridpath));

DCcorfunc = 'DCcor_trfid_v1a';
Gridfunc = 'Grid_Standard_v1a';

m = 1;
default{m,1}.entrytype = 'RunFunc';
default{m,1}.labelstr = 'DefFIDDataLoc';
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
default{m,1}.entrytype = 'RunFunc';
default{m,1}.labelstr = 'FIDdata';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Load';
default{m,1}.runfunc = 'SelectFidData_v2';
default{m,1}.runfuncinput = {''};                   
default{m,1}.runfuncoutput = {''};   

m = m+1;
default{m,1}.entrytype = 'RunFunc';
default{m,1}.labelstr = 'IMPfile';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Load';
default{m,1}.runfunc = 'LoadTrajectoryImplementation_v2';
default{m,1}.runfuncinput = {SCRPTPATHS.outloc};
default{m,1}.runfuncoutput = {''};

m = m+1;
default{m,1}.entrytype = 'RunFunc';
default{m,1}.labelstr = 'SDCfile';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Load';
default{m,1}.runfunc = 'LoadTrajectorySDC_v2';
default{m,1}.runfuncinput = {SCRPTPATHS.outloc};
default{m,1}.runfuncoutput = {''};

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'DCcorfunc';
default{m,1}.entrystr = DCcorfunc;
default{m,1}.searchpath = DCcorpath;

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'Gridfunc';
default{m,1}.entrystr = Gridfunc;
default{m,1}.searchpath = Gridpath;

m = m+1;
default{m,1}.entrytype = 'Choose';
default{m,1}.labelstr = 'Colour';
default{m,1}.entrystr = 'k';
default{m,1}.options = {'k','r','g','b','c','m','y'};

m = m+1;
default{m,1}.entrytype = 'Choose';
default{m,1}.labelstr = 'Visuals';
default{m,1}.entrystr = 'Partial';
default{m,1}.options = {'Off','Partial','Full'};
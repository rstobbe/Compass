%====================================================
%
%====================================================

function [default] = VCart3D_v1_Default2(SCRPTPATHS)

if strcmp(filesep,'\')
    addpath(genpath([SCRPTPATHS.rootloc,'\VOYAGER\Image Creation\Underlying\zz Common']));
    dccorpath = [SCRPTPATHS.rootloc,'\VOYAGER\Image Creation\Underlying\Selectable Functions\PreProcess\DCcor\'];
elseif strcmp(filesep,'/')
end
    
DC_cor = 'DCcor_trfid_v1';
addpath(genpath(dccorpath));

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
default{m,1}.labelstr = 'File_FIDdata';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Load';
default{m,1}.runfunc = 'SelectFidData_v1';
default{m,1}.runfuncdata = {''};                   

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'DC corr';
default{m,1}.entrystr = DC_cor;
default{m,1}.searchpath = dccorpath;

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
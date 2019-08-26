%====================================================
%
%====================================================

function [default] = TPI_Ideal_v2a_Default2(SCRPTPATHS)

if strcmp(filesep,'\')
    addpath(genpath([SCRPTPATHS.rootloc,'Trajectory Implementation\Underlying\zz Common']));
    projsamppath = [SCRPTPATHS.rootloc,'Trajectory Implementation\Underlying\Selectable Functions\0 Scanner Related\ProjSamp Functions\TPI'];
    TrajSamppath = [SCRPTPATHS.rootloc,'Trajectory Implementation\Underlying\Selectable Functions\0 Scanner Related\TrajSamp Functions\'];
    plotpath = [SCRPTPATHS.rootloc,'\Trajectory Implementation\Underlying\Selectable Functions\Plotting Functions\']; 
elseif strcmp(filesep,'/')
end
addpath(genpath(TrajSamppath));
addpath(genpath(projsamppath));
addpath(genpath(plotpath));

Imp_Name = 'TPI_Ideal';
Nucleus = '1H';
SlvNo = '1000';
Orient = 'Axial';
TrajSampfunc = 'TrajSamp_TPIideal_v1a';
ProjSampfunc = 'ProjSamp_Cones_v1b';
plotfunc = 'Plot_SampTim_v1a';

m = 1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'Imp_Name';
default{m,1}.entrystr = Imp_Name;

m = m+1;
default{m,1}.entrytype = 'Choose';
default{m,1}.labelstr = 'Nucleus';
default{m,1}.entrystr = Nucleus;
default{m,1}.options = {'1H','23Na'};

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'SlvNo';
default{m,1}.entrystr = SlvNo;

m = m+1;
default{m,1}.entrytype = 'Choose';
default{m,1}.labelstr = 'Orient';
default{m,1}.entrystr = Orient;
default{m,1}.options = {'Axial','Sagittal','Coronal'};

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'TrajSampfunc';
default{m,1}.entrystr = TrajSampfunc;
default{m,1}.searchpath = TrajSamppath;

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'ProjSampfunc';
default{m,1}.entrystr = ProjSampfunc;
default{m,1}.searchpath = projsamppath;

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'Plotfunc';
default{m,1}.entrystr = plotfunc;
default{m,1}.searchpath = plotpath;

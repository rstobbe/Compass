%====================================================
%
%====================================================

function [default] = TPI_Gen_v1b_Default2(SCRPTPATHS)

if strcmp(filesep,'\')
    addpath(genpath([SCRPTPATHS.rootloc,'Trajectory Implementation\Underlying\zz Common']));
    projsamppath = [SCRPTPATHS.rootloc,'Trajectory Implementation\Underlying\Selectable Functions\0 Scanner Related\ProjSamp Functions\'];
    TrajSamppath = [SCRPTPATHS.rootloc,'Trajectory Implementation\Underlying\Selectable Functions\0 Scanner Related\TrajSamp Functions\'];
    QVecSlvpath = [SCRPTPATHS.rootloc,'Trajectory Implementation\Underlying\Selectable Functions\0 Scanner Related\QVecSlv Functions\'];
    GWFMpath = [SCRPTPATHS.rootloc,'Trajectory Implementation\Underlying\Selectable Functions\0 Scanner Related\GWFM Functions\'];
    kSamppath = [SCRPTPATHS.rootloc,'Trajectory Implementation\Underlying\Selectable Functions\1 ImCon Related\kSamp Functions\'];
    plotpath = [SCRPTPATHS.rootloc,'\Trajectory Implementation\Underlying\Selectable Functions\Plotting Functions\']; 
elseif strcmp(filesep,'/')
end
addpath(genpath(TrajSamppath));
addpath(genpath(projsamppath));
addpath(genpath(QVecSlvpath));
addpath(genpath(GWFMpath));
addpath(genpath(kSamppath));

Imp_Name = '-';
System = 'Varian Inova';
SlvNo = '1000';
Orient = 'Axial';
QVecSlvfunc = 'QVecSlv_TPI_v1a';
GWFMfunc = 'GWFM_GSRA_v1b';
TrajSampfunc = 'TrajSamp_TPIstandard_v1a';
ProjSampfunc = 'ProjSamp_Cones_v1b';
kSampfunc = 'kSamp_TPISRI_v2i';
plotfunc = 'Plot_ImpkSpaceOrtho_v1a';
addpath(genpath(plotpath));

m = 1;
default{m,1}.entrytype = 'Comment';
default{m,1}.labelstr = 'System';
default{m,1}.entrystr = System;

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'Imp_Name';
default{m,1}.entrystr = Imp_Name;

m = m+1;
default{m,1}.entrytype = 'Choose';
default{m,1}.labelstr = 'Nucleus';
default{m,1}.entrystr = '23Na';
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
default{m,1}.labelstr = 'QVecSlvfunc';
default{m,1}.entrystr = QVecSlvfunc;
default{m,1}.searchpath = QVecSlvpath;

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'GWFMfunc';
default{m,1}.entrystr = GWFMfunc;
default{m,1}.searchpath = GWFMpath;

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
default{m,1}.labelstr = 'kSampfunc';
default{m,1}.entrystr = kSampfunc;
default{m,1}.searchpath = kSamppath;

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'Plotfunc';
default{m,1}.entrystr = plotfunc;
default{m,1}.searchpath = plotpath;

%====================================================
%
%====================================================

function [default] = LR_Ideal_v2b_Default2(SCRPTPATHS)

if strcmp(filesep,'\')
    addpath(genpath([SCRPTPATHS.pioneerloc,'Trajectory Implementation\Underlying\zz Common']));
    ProjSamppath = [SCRPTPATHS.pioneerloc,'Trajectory Implementation\Underlying\Selectable Functions\0 Scanner Related\ProjSamp Functions\LR\'];
    TrajSamppath = [SCRPTPATHS.pioneerloc,'Trajectory Implementation\Underlying\Selectable Functions\0 Scanner Related\TrajSamp Functions\'];
    kSamppath = [SCRPTPATHS.pioneerloc,'Trajectory Implementation\Underlying\Selectable Functions\1 ImCon Related\kSamp Functions\'];
elseif strcmp(filesep,'/')
end
ProjSampfunc = 'ProjSamp_Discs_v1b';
TrajSampfunc = 'TrajSamp_LRideal_v1b';
kSampfunc = 'kSamp_LRideal_v1a';
addpath([ProjSamppath,ProjSampfunc]);
addpath([TrajSamppath,TrajSampfunc]);
addpath([kSamppath,kSampfunc]);
Default = 'LR_Ideal';
System = 'Varian Inova';
Nucleus = '1H';
Orient = 'Axial';

m = 1;
default{m,1}.entrytype = 'StatInput';
default{m,1}.labelstr = 'Imp_Name';
default{m,1}.entrystr = '';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'Default';
default{m,1}.entrystr = Default;

m = m+1;
default{m,1}.entrytype = 'Choose';
default{m,1}.labelstr = 'Testing Only';
default{m,1}.entrystr = 'Yes';
default{m,1}.options = {'No','Yes'};

m = m+1;
default{m,1}.entrytype = 'RunExtFunc';
default{m,1}.labelstr = 'Des_File';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Load';
default{m,1}.runfunc1 = 'LoadTrajDesCur_v4';
default{m,1}.(default{m,1}.runfunc1).curloc = SCRPTPATHS.outloc;
default{m,1}.(default{m,1}.runfunc1).loadpanel = 'No';
default{m,1}.runfunc2 = 'LoadTrajDesDef_v4';
default{m,1}.(default{m,1}.runfunc2).defloc = SCRPTPATHS.outloc;
default{m,1}.(default{m,1}.runfunc2).loadpanel = 'No';
default{m,1}.searchpath = SCRPTPATHS.scrptshareloc;
default{m,1}.path = SCRPTPATHS.scrptshareloc;

m = m+1;
default{m,1}.entrytype = 'StatInput';
default{m,1}.labelstr = 'System';
default{m,1}.entrystr = System;

m = m+1;
default{m,1}.entrytype = 'Choose';
default{m,1}.labelstr = 'Nucleus';
default{m,1}.entrystr = Nucleus;
default{m,1}.options = {'1H','23Na'};

m = m+1;
default{m,1}.entrytype = 'Choose';
default{m,1}.labelstr = 'Orient';
default{m,1}.entrystr = Orient;
default{m,1}.options = {'Axial','Sagittal','Coronal'};

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'ProjSampfunc';
default{m,1}.entrystr = ProjSampfunc;
default{m,1}.searchpath = ProjSamppath;
default{m,1}.path = [ProjSamppath,ProjSampfunc];

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'TrajSampfunc';
default{m,1}.entrystr = TrajSampfunc;
default{m,1}.searchpath = TrajSamppath;
default{m,1}.path = [TrajSamppath,TrajSampfunc];

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'kSampfunc';
default{m,1}.entrystr = kSampfunc;
default{m,1}.searchpath = kSamppath;
default{m,1}.path = [kSamppath,kSampfunc];

m = m+1;
default{m,1}.entrytype = 'RunScrptFunc';
default{m,1}.scrpttype = 'LR_Gen';
default{m,1}.labelstr = 'Implement';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Run';

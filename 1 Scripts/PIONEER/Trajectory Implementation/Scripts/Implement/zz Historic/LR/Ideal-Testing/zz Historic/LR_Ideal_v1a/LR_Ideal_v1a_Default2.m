%====================================================
%
%====================================================

function [default] = LR_Ideal_v1a_Default2(SCRPTPATHS)

if strcmp(filesep,'\')
    addpath(genpath([SCRPTPATHS.rootloc,'Trajectory Implementation\Underlying\zz Common']));
    TrajSamppath = [SCRPTPATHS.rootloc,'Trajectory Implementation\Underlying\Selectable Functions\0 Scanner Related\TrajSamp Functions\'];
elseif strcmp(filesep,'/')
end
addpath(genpath(TrajSamppath));

Imp_Name = 'LR_Ideal';
Nucleus = '1H';
Orient = 'Axial';
TrajSampfunc = 'TrajSamp_LRIdeal_v1a';

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
default{m,1}.entrytype = 'Choose';
default{m,1}.labelstr = 'Orient';
default{m,1}.entrystr = Orient;
default{m,1}.options = {'Axial','Sagittal','Coronal'};

m = m+1;
default{m,1}.entrytype = 'UnderFunc';
default{m,1}.labelstr = 'TrajSampfunc';
default{m,1}.entrystr = TrajSampfunc;

m = m+1;
default{m,1}.entrytype = 'Choose';
default{m,1}.labelstr = 'ksmp Vis';
default{m,1}.entrystr = 'Off';
default{m,1}.options = {'On','Off'};

m = m+1;
default{m,1}.entrytype = 'Choose';
default{m,1}.labelstr = 'SampTim Vis';
default{m,1}.entrystr = 'Off';
default{m,1}.options = {'On','Off'};



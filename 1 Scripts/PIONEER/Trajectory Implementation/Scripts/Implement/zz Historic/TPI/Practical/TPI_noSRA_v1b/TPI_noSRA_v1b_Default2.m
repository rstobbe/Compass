%====================================================
%
%====================================================

function [default] = TPI_noSRA_v1b_Default2(SCRPTPATHS)

if strcmp(filesep,'\')
    addpath(genpath([SCRPTPATHS.rootloc,'Trajectory Implementation\Underlying\zz Common']));
    TrajSamppath = [SCRPTPATHS.rootloc,'Trajectory Implementation\Underlying\Selectable Functions\0 Scanner Related\TrajSamp Functions\'];
    WFMpath = [SCRPTPATHS.rootloc,'Trajectory Implementation\Underlying\Selectable Functions\0 Scanner Related\GWFM Functions\'];
    kSamppath = [SCRPTPATHS.rootloc,'Trajectory Implementation\Underlying\Selectable Functions\1 ImCon Related\kSamp Functions\'];
elseif strcmp(filesep,'/')
end
addpath(genpath(TrajSamppath));
addpath(genpath(WFMpath));
addpath(genpath(kSamppath));

Imp_Name = 'TPI_noSRA';
System = 'Varian Inova';
SlvNo = '1000';
Orient = 'Axial';
twGseg = '0.30';
Solve_Priority1 = 'iGseg1';
Solve_Priority2 = 'Tro2';
GWFMfunc = 'GWFM_noSRA_v3a';
TrajSampfunc = 'TrajSamp_ConstTR_v3d';
kSampfunc = 'kSamp_SRI_v2g';

m = 1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'Imp_Name';
default{m,1}.entrystr = Imp_Name;

m = m+1;
default{m,1}.entrytype = 'Comment';
default{m,1}.labelstr = 'System';
default{m,1}.entrystr = System;

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
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'twGseg (ms)';
default{m,1}.entrystr = twGseg;

m = m+1;
default{m,1}.entrytype = 'Choose';
default{m,1}.labelstr = 'Solve_Priority1';
default{m,1}.entrystr = Solve_Priority1;
default{m,1}.options = {'TwGseg1','iGseg1','Tro1','OvrSamp1'};

m = m+1;
default{m,1}.entrytype = 'Choose';
default{m,1}.labelstr = 'Solve_Priority2';
default{m,1}.entrystr = Solve_Priority2;
default{m,1}.options = {'TwGseg2','iGseg2','Tro2','OvrSamp2'};

m = m+1;
default{m,1}.entrytype = 'UnderFunc';
default{m,1}.labelstr = 'GWFMfunc';
default{m,1}.entrystr = GWFMfunc;

m = m+1;
default{m,1}.entrytype = 'UnderFunc';
default{m,1}.labelstr = 'TrajSampfunc';
default{m,1}.entrystr = TrajSampfunc;

m = m+1;
default{m,1}.entrytype = 'UnderFunc';
default{m,1}.labelstr = 'kSampfunc';
default{m,1}.entrystr = kSampfunc;

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

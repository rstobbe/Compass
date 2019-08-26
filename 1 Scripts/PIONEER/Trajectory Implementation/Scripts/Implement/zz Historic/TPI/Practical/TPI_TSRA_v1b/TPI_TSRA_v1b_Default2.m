%====================================================
%
%====================================================

function [default] = TPI_TSRA_v1b_Default2(SCRPTPATHS)

if strcmp(filesep,'\')
    addpath(genpath([SCRPTPATHS.rootloc,'Trajectory Implementation\Underlying\zz Common']));
    srafuncpath = [SCRPTPATHS.rootloc,'Trajectory Implementation\Underlying\Selectable Functions\0 Scanner Related\Create Gradient Waveform\TSRA Functions\'];
elseif strcmp(filesep,'/')
end
addpath(genpath(srafuncpath));

Imp_Name = 'TPI_TSRA';
System = 'Varian Inova';
SlvNo = '1000';
Orient = 'Axial';
twGseg = '0.30';
Solve_Priority1 = 'iGseg1';
Solve_Priority2 = 'Tro2';
Grad_WFM = 'SRA_v1a';
srafunc = 'TPI_wfmTSRAlinear_v1a';
Traj_Samp = 'Const_TR_v3d';
k_Samp = 'SRI_v2f';

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
default{m,1}.labelstr = 'Grad_WFM';
default{m,1}.entrystr = Grad_WFM;

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'SRA_Func';
default{m,1}.entrystr = srafunc;
default{m,1}.searchpath = srafuncpath;

m = m+1;
default{m,1}.entrytype = 'UnderFunc';
default{m,1}.labelstr = 'Traj_Samp';
default{m,1}.entrystr = Traj_Samp;

m = m+1;
default{m,1}.entrytype = 'UnderFunc';
default{m,1}.labelstr = 'k_Samp';
default{m,1}.entrystr = k_Samp;

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

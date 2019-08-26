%====================================================
%
%====================================================

function [default] = TPI2a_v2h_Default2(SCRPTPATHS)

if strcmp(filesep,'\')
    addpath(genpath([SCRPTPATHS.pioneerloc,'Trajectory Design\Underlying\zz Common\TPI\']));
    gamfuncpath = [SCRPTPATHS.pioneerloc,'Trajectory Design\Underlying\Selectable Functions\TPI\Gamma Functions\'];
elseif strcmp(filesep,'/')
end
gamfunc = 'Kaiser_v1d';
addpath([gamfuncpath,gamfunc]);

Design_Name = '';
FoV = '250';
Vox = '4';
Tro = '18';
Nproj = '1600';
iseg = '0.3';
Elip = '1';

m = 1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'Design_Name';
default{m,1}.entrystr = Design_Name;

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'FoV (mm)';
default{m,1}.entrystr = FoV;

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'Vox (mm)';
default{m,1}.entrystr = Vox;

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'Tro (ms)';
default{m,1}.entrystr = Tro;

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'Nproj';
default{m,1}.entrystr = Nproj;

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'iSeg';
default{m,1}.entrystr = iseg;

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'Elip';
default{m,1}.entrystr = Elip;

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'Gamfunc';
default{m,1}.entrystr = gamfunc;
default{m,1}.searchpath = gamfuncpath;
default{m,1}.path = [gamfuncpath,gamfunc];

m = m+1;
default{m,1}.entrytype = 'RunScrptFunc';
default{m,1}.scrpttype = 'TPI2';
default{m,1}.labelstr = 'Create Design';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Run';

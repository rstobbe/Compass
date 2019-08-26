%====================================================
%
%====================================================

function [default] = Spiral1a_v1a_Default2(SCRPTPATHS)

if strcmp(filesep,'\')
    addpath(genpath([SCRPTPATHS.pioneerloc,'Trajectory Design\Underlying\zz Common\Spiral']));
    spinpath = [SCRPTPATHS.pioneerloc,'Trajectory Design\Underlying\Selectable Functions\Spiral\Spin Functions\'];      
    DEsoltimpath = [SCRPTPATHS.pioneerloc,'Trajectory Design\Underlying\Selectable Functions\Spiral\DEsoltim Functions\']; 
    accconstpath = [SCRPTPATHS.pioneerloc,'Trajectory Design\Underlying\Selectable Functions\Spiral\ConstEvol Functions\']; 
elseif strcmp(filesep,'/')
end
spinfunc = 'SpinSpiral_Uniform_v2a';
DEsoltimfunc = 'DEst_Spiral1_v1a';
accconstfunc = 'ConstEvol2D_v1a';
addpath([spinpath,spinfunc]);
addpath([DEsoltimpath,DEsoltimfunc]);
addpath([accconstpath,accconstfunc]);

Design_Name = '';
FoV = 240;
Vox = 4;
Tro = 25;
Nproj = 4;

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
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'Spinfunc';
default{m,1}.entrystr = spinfunc;
default{m,1}.searchpath = spinpath;
default{m,1}.path = [spinpath,spinfunc];

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'DeSolTimfunc';
default{m,1}.entrystr = DEsoltimfunc;
default{m,1}.searchpath = DEsoltimpath;
default{m,1}.path = [DEsoltimpath,DEsoltimfunc];

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'ConstEvolfunc';
default{m,1}.entrystr = accconstfunc;
default{m,1}.searchpath = accconstpath;
default{m,1}.path = [accconstpath,accconstfunc];

m = m+1;
default{m,1}.entrytype = 'RunScrptFunc';
default{m,1}.scrpttype = 'Des';
default{m,1}.labelstr = 'Create Design';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Run';




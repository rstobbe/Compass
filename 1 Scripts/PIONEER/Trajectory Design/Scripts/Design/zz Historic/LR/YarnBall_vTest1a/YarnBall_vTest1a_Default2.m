%====================================================
%
%====================================================

function [default] = YarnBall_vTest1a_Default2(SCRPTPATHS)

if strcmp(filesep,'\')
    spinpath = [SCRPTPATHS.pioneerloc,'Trajectory Design\Underlying\Selectable Functions\LR\Spin Functions\'];      
    DEsoltimpath = [SCRPTPATHS.pioneerloc,'Trajectory Design\Underlying\Selectable Functions\LR\DEsoltim Functions\']; 
    accconstpath = [SCRPTPATHS.pioneerloc,'Trajectory Design\Underlying\Selectable Functions\LR\ConstEvol Functions\']; 
    elippath = [SCRPTPATHS.pioneerloc,'Trajectory Design\Underlying\Selectable Functions\LR\Elip Functions\'];     
elseif strcmp(filesep,'/')
end
elipfunc = 'ElipSelection_v1a';
spinfunc = 'Spin_HemlockFreeUsamp_v3b';
DEsoltimfunc = 'DeSolTim_LRMeth2_v1b';
accconstfunc = 'ConstEvol3D_v3c';

FoV = 240;
Vox = 4;
Tro = 8;
Nproj = 128;

m = 1;
default{m,1}.entrytype = 'OutputName';
default{m,1}.labelstr = 'Design_Name';
default{m,1}.entrystr = '';

m = m+1;
default{m,1}.entrytype = 'ScriptName';
default{m,1}.labelstr = 'Script_Name';
default{m,1}.entrystr = '';

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
default{m,1}.labelstr = 'Elipfunc';
default{m,1}.entrystr = elipfunc;
default{m,1}.searchpath = elippath;
default{m,1}.path = [elippath,elipfunc];

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
default{m,1}.scrpttype = 'LR1';
default{m,1}.labelstr = 'Create Design';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Run';




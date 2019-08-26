%=========================================================
% 
%=========================================================

function [default] = DesMeth_YarnBallBasicOptions_v1a_Default2(SCRPTPATHS)

if strcmp(filesep,'\')
    spinpath = [SCRPTPATHS.pioneerloc,'Trajectory Design\Underlying\Selectable Functions\LR\Spin Functions\'];      
    radevpath = [SCRPTPATHS.pioneerloc,'Trajectory Design\Underlying\Selectable Functions\LR\RadSolEv Functions\'];
    desoltimpath = [SCRPTPATHS.pioneerloc,'Trajectory Design\Underlying\Selectable Functions\LR\DEsoltim Functions\']; 
    accconstpath = [SCRPTPATHS.pioneerloc,'Trajectory Design\Underlying\Selectable Functions\LR\ConstEvol Functions\']; 
    elippath = [SCRPTPATHS.pioneerloc,'Trajectory Design\Underlying\Selectable Functions\LR\Elip Functions\'];     
elseif strcmp(filesep,'/')
end
elipfunc = 'ElipSelection_v1a';
spinfunc = 'Spin_HemlockFreeUsamp_v3c';
radevfunc = 'RadSolEv_DesignTest_v1a';
desoltimfunc = 'DeSolTim_YarnBallLookup_v1a';
accconstfunc = 'ConstEvol_Simple_v1a';

m = 1;
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
default{m,1}.labelstr = 'RadSolEvfunc';
default{m,1}.entrystr = radevfunc;
default{m,1}.searchpath = radevpath;
default{m,1}.path = [radevpath,radevfunc];

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'DeSolTimfunc';
default{m,1}.entrystr = desoltimfunc;
default{m,1}.searchpath = desoltimpath;
default{m,1}.path = [desoltimpath,desoltimfunc];

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'ConstEvolfunc';
default{m,1}.entrystr = accconstfunc;
default{m,1}.searchpath = accconstpath;
default{m,1}.path = [accconstpath,accconstfunc];


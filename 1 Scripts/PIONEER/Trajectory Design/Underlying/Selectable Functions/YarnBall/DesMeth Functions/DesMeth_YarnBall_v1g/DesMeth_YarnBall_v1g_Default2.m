%=========================================================
% 
%=========================================================

function [default] = DesMeth_YarnBall_v1g_Default2(SCRPTPATHS)

if strcmp(filesep,'\')
    spinpath = [SCRPTPATHS.pioneerloc,'Trajectory Design\Underlying\Selectable Functions\YarnBall\Spin Functions\'];      
    desoltimpath = [SCRPTPATHS.pioneerloc,'Trajectory Design\Underlying\Selectable Functions\YarnBall\DeSoltim Functions\']; 
    timadjpath = [SCRPTPATHS.pioneerloc,'Trajectory Design\Underlying\Selectable Functions\YarnBall\TimingAdjust Functions\']; 
    elippath = [SCRPTPATHS.pioneerloc,'Trajectory Design\Underlying\Selectable Functions\YarnBall\Elip Functions\']; 
    colourpath = [SCRPTPATHS.pioneerloc,'Trajectory Design\Underlying\Selectable Functions\YarnBall\Colour Functions\'];     
    genprojpath = [SCRPTPATHS.pioneerloc,'Trajectory Design\Underlying\Selectable Functions\YarnBall\GenProj Functions\'];
    destypepath = [SCRPTPATHS.pioneerloc,'Trajectory Design\Underlying\Selectable Functions\YarnBall\DesType Functions\'];   
elseif strcmp(filesep,'/')
end
genprojfunc = 'GenProj_YarnBall_v1c';
colourfunc = 'Colour_Green_v1h';
destypefunc = 'DesType_YarnBallOutSingleEcho_v1b';
elipfunc = 'Elip_Isotropic_v1a';
spinfunc = 'Spin_SportWeight_v1c';
desoltimfunc = 'DeSolTim_YarnBallLookupDesignTest_v1d';
timadjfunc = 'TimingAdjust_SingleCastDesignTest_v1a';

m = 1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'GenProjfunc';
default{m,1}.entrystr = genprojfunc;
default{m,1}.searchpath = genprojpath;
default{m,1}.path = [genprojpath,genprojfunc];

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'Colourfunc';
default{m,1}.entrystr = colourfunc;
default{m,1}.searchpath = colourpath;
default{m,1}.path = [colourpath,colourfunc];

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
default{m,1}.entrystr = desoltimfunc;
default{m,1}.searchpath = desoltimpath;
default{m,1}.path = [desoltimpath,desoltimfunc];

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'TimingAdjustfunc';
default{m,1}.entrystr = timadjfunc;
default{m,1}.searchpath = timadjpath;
default{m,1}.path = [timadjpath,timadjfunc];

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'DesTypefunc';
default{m,1}.entrystr = destypefunc;
default{m,1}.searchpath = destypepath;
default{m,1}.path = [destypepath,destypefunc];



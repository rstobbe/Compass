%=========================================================
% 
%=========================================================

function [default] = DesMeth_YarnBallSpinOptions_v1d_Default2(SCRPTPATHS)

if strcmp(filesep,'\')
    spinpath = [SCRPTPATHS.pioneerloc,'Trajectory Design\Underlying\Selectable Functions\YarnBall\Spin Functions\'];      
%     radevpath = [SCRPTPATHS.pioneerloc,'Trajectory Design\Underlying\Selectable Functions\YarnBall\RadSolEv Functions\'];
%     desoltimpath = [SCRPTPATHS.pioneerloc,'Trajectory Design\Underlying\Selectable Functions\YarnBall\DeSoltim Functions\']; 
%     accconstpath = [SCRPTPATHS.pioneerloc,'Trajectory Design\Underlying\Selectable Functions\YarnBall\ConstEvol Functions\']; 
%     elippath = [SCRPTPATHS.pioneerloc,'Trajectory Design\Underlying\Selectable Functions\YarnBall\Elip Functions\']; 
%     colourpath = [SCRPTPATHS.pioneerloc,'Trajectory Design\Underlying\Selectable Functions\YarnBall\Colour Functions\'];    
%     testpath = [SCRPTPATHS.pioneerloc,'Trajectory Design\Underlying\Selectable Functions\YarnBall\DesTest Functions\'];    
elseif strcmp(filesep,'/')
end
spinfunc = 'Spin_StandardFull_v1a';
% colourfunc = 'Colour_Green_v1a';
% elipfunc = 'Elip_Selection_v1a';
% radevfunc = 'RadSolEv_DesignTest_v1c';
% desoltimfunc = 'DeSolTim_YarnBallLookup_v1b';
% accconstfunc = 'ConstEvol_Simple_v1a';
% testfunc = 'DesTest_Standard_v1a';

% m = 1;
% default{m,1}.entrytype = 'ScrptFunc';
% default{m,1}.labelstr = 'Colourfunc';
% default{m,1}.entrystr = colourfunc;
% default{m,1}.searchpath = colourpath;
% default{m,1}.path = [colourpath,colourfunc];
% 
% m = m+1;
% default{m,1}.entrytype = 'ScrptFunc';
% default{m,1}.labelstr = 'Elipfunc';
% default{m,1}.entrystr = elipfunc;
% default{m,1}.searchpath = elippath;
% default{m,1}.path = [elippath,elipfunc];

m = 1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'Spinfunc';
default{m,1}.entrystr = spinfunc;
default{m,1}.searchpath = spinpath;
default{m,1}.path = [spinpath,spinfunc];

% m = m+1;
% default{m,1}.entrytype = 'ScrptFunc';
% default{m,1}.labelstr = 'RadSolEvfunc';
% default{m,1}.entrystr = radevfunc;
% default{m,1}.searchpath = radevpath;
% default{m,1}.path = [radevpath,radevfunc];
% 
% m = m+1;
% default{m,1}.entrytype = 'ScrptFunc';
% default{m,1}.labelstr = 'DeSolTimfunc';
% default{m,1}.entrystr = desoltimfunc;
% default{m,1}.searchpath = desoltimpath;
% default{m,1}.path = [desoltimpath,desoltimfunc];
% 
% m = m+1;
% default{m,1}.entrytype = 'ScrptFunc';
% default{m,1}.labelstr = 'ConstEvolfunc';
% default{m,1}.entrystr = accconstfunc;
% default{m,1}.searchpath = accconstpath;
% default{m,1}.path = [accconstpath,accconstfunc];
% 
% m = m+1;
% default{m,1}.entrytype = 'ScrptFunc';
% default{m,1}.labelstr = 'DesTestfunc';
% default{m,1}.entrystr = testfunc;
% default{m,1}.searchpath = testpath;
% default{m,1}.path = [testpath,testfunc];


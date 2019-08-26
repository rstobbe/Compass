%=========================================================
% 
%=========================================================

function [default] = DesMeth_YarnBallFullOptions_IO_v1e_Default2(SCRPTPATHS)

if strcmp(filesep,'\')
    spinpath = [SCRPTPATHS.pioneerloc,'Trajectory Design\Underlying\Selectable Functions\YarnBall\Spin Functions\'];      
    desoltimpath = [SCRPTPATHS.pioneerloc,'Trajectory Design\Underlying\Selectable Functions\YarnBall\DeSoltim Functions\']; 
    accconstpath = [SCRPTPATHS.pioneerloc,'Trajectory Design\Underlying\Selectable Functions\YarnBall\ConstEvol Functions\']; 
    elippath = [SCRPTPATHS.pioneerloc,'Trajectory Design\Underlying\Selectable Functions\YarnBall\Elip Functions\']; 
    colourpath = [SCRPTPATHS.pioneerloc,'Trajectory Design\Underlying\Selectable Functions\YarnBall\Colour Functions\'];    
    testpath = [SCRPTPATHS.pioneerloc,'Trajectory Design\Underlying\Selectable Functions\YarnBall\DesTest Functions\'];    
    genprojpath = [SCRPTPATHS.pioneerloc,'Trajectory Design\Underlying\Selectable Functions\YarnBall\GenProj Functions\'];
    turnevolutionpath = [SCRPTPATHS.pioneerloc,'Trajectory Design\Underlying\Selectable Functions\YarnBall\TurnEvolution Functions\']; 
    turnsolutionpath = [SCRPTPATHS.pioneerloc,'Trajectory Design\Underlying\Selectable Functions\YarnBall\TurnSolution Functions\'];    
elseif strcmp(filesep,'/')
end
genprojfunc = 'GenProj_YarnBall_v1a';
colourfunc = 'Colour_Green_v1f';
turnevolutionfunc = 'TurnEvolution_Erf_v1a';
turnsolutionfunc = 'TurnSolution_Standard_v1a';
elipfunc = 'Elip_Selection_v1a';
spinfunc = 'Spin_SportWeight_v1c';
desoltimfunc = 'DeSolTim_YarnBallLookup_v1d';
accconstfunc = 'ConstEvol_Simple_v1a';
testfunc = 'DesTest_Standard_v1a';

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
default{m,1}.labelstr = 'TurnEvolutionfunc';
default{m,1}.entrystr = turnevolutionfunc;
default{m,1}.searchpath = turnevolutionpath;
default{m,1}.path = [turnevolutionpath,turnevolutionfunc];

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'TurnSolutionfunc';
default{m,1}.entrystr = turnsolutionfunc;
default{m,1}.searchpath = turnsolutionpath;
default{m,1}.path = [turnsolutionpath,turnsolutionfunc];

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
default{m,1}.labelstr = 'ConstEvolfunc';
default{m,1}.entrystr = accconstfunc;
default{m,1}.searchpath = accconstpath;
default{m,1}.path = [accconstpath,accconstfunc];

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'DesTestfunc';
default{m,1}.entrystr = testfunc;
default{m,1}.searchpath = testpath;
default{m,1}.path = [testpath,testfunc];


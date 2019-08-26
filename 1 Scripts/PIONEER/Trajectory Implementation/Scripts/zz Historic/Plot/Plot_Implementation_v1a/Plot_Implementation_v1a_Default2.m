%=========================================================
% 
%=========================================================

function [default] = Plot_Implementation_v1a_Default2(SCRPTPATHS)

if strcmp(filesep,'\')
    plotpath = [SCRPTPATHS.pioneerloc,'Trajectory Implementation\Scripts\Plot\zz Underlying\General\'];
elseif strcmp(filesep,'/')
end
plotfunc = 'Plot_ImpGradientsOrtho_v1b';

m = 1;
default{m,1}.entrytype = 'OutputName';
default{m,1}.labelstr = 'Plot_Name';
default{m,1}.entrystr = '';

m = m+1;
default{m,1}.entrytype = 'ScriptName';
default{m,1}.labelstr = 'Script_Name';
default{m,1}.entrystr = '';

m = m+1;
default{m,1}.entrytype = 'RunExtFunc';
default{m,1}.labelstr = 'Imp_File';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Load';
default{m,1}.runfunc1 = 'LoadTrajImpCur';
default{m,1}.(default{m,1}.runfunc1).curloc = SCRPTPATHS.outloc;
default{m,1}.runfunc2 = 'LoadTrajImpDisp';

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'Plotfunc';
default{m,1}.entrystr = plotfunc;
default{m,1}.searchpath = plotpath;
default{m,1}.path = [plotpath,plotfunc];

m = m+1;
default{m,1}.entrytype = 'RunScrptFunc';
default{m,1}.scrpttype = 'Plot';
default{m,1}.labelstr = 'Plot';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Plot';
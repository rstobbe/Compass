%=========================================================
% 
%=========================================================

function [default] = Plot_EddyCurrents_v1a_Default2(SCRPTPATHS)

if strcmp(filesep,'\')
    Plotpath = [SCRPTPATHS.newhorizonsloc,'Scanner Related\Field Analysis\Underlying\Selectable Functions\Field Evolution Plots\'];
elseif strcmp(filesep,'/')
end
Plotfunc = 'Plot_LongEddy_v1a';

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
default{m,1}.labelstr = 'EddyCurrent_File';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Select';
default{m,1}.runfunc1 = 'LoadScriptFileCur';
default{m,1}.(default{m,1}.runfunc1).curloc = SCRPTPATHS.outloc;
default{m,1}.runfunc2 = 'LoadScriptFileDef';
default{m,1}.(default{m,1}.runfunc2).defloc = SCRPTPATHS.outloc;
default{m,1}.searchpath = SCRPTPATHS.scrptshareloc;
default{m,1}.path = SCRPTPATHS.scrptshareloc;

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'EddyPlotfunc';
default{m,1}.entrystr = Plotfunc;
default{m,1}.searchpath = Plotpath;
default{m,1}.path = [Plotpath,Plotfunc];

m = m+1;
default{m,1}.entrytype = 'Choose';
default{m,1}.labelstr = 'SaveOption';
default{m,1}.entrystr = 'No';
default{m,1}.options = {'Yes','No'};

m = m+1;
default{m,1}.entrytype = 'RunScrptFunc';
default{m,1}.scrpttype = 'Plot';
default{m,1}.labelstr = 'Eddy Plot';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Run';
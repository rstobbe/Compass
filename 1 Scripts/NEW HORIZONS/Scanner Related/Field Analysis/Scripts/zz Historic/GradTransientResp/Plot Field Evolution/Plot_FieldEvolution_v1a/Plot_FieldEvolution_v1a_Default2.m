%=========================================================
% 
%=========================================================

function [default] = Plot_FieldEvolution_v1a_Default2(SCRPTPATHS)

if strcmp(filesep,'\')
    Plotpath = [SCRPTPATHS.newhorizonsloc,'Scanner Related\Field Analysis\Underlying\Selectable Functions\Field Evolution Plots\'];
elseif strcmp(filesep,'/')
end
Plotfunc = 'Plot_PosLoc_v1c';

m = 1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'FieldPlot_Name';
default{m,1}.entrystr = '';

m = m+1;
default{m,1}.entrytype = 'RunExtFunc';
default{m,1}.labelstr = 'FieldEvo_File';
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
default{m,1}.labelstr = 'FieldPlotfunc';
default{m,1}.entrystr = Plotfunc;
default{m,1}.searchpath = Plotpath;
default{m,1}.path = [Plotpath,Plotfunc];

m = m+1;
default{m,1}.entrytype = 'RunScrptFunc';
default{m,1}.scrpttype = 'Plot';
default{m,1}.labelstr = 'Field Plot';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Plot';
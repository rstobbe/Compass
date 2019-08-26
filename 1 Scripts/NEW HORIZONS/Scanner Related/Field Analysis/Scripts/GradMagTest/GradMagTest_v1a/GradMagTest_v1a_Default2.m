%====================================================
%
%====================================================

function [default] = GradMagTest_v1a_Default2(SCRPTPATHS)

if strcmp(filesep,'\')
    gmeaspath = [SCRPTPATHS.newhorizonsloc,'Scanner Related\Field Analysis\Underlying\Selectable Functions\Gradient Magnitude Measure\'];
    fevolpath = [SCRPTPATHS.newhorizonsloc,'Scanner Related\Field Analysis\Underlying\Selectable Functions\Field Evolution Load\'];  
elseif strcmp(filesep,'/')
end
gmeasfunc = 'GradMagMeas_v1a';
fevolfunc = 'FieldEvoLoadBasicMRS_v1a';

m = 1;
default{m,1}.entrytype = 'OutputName';
default{m,1}.labelstr = 'Eddy_Name';
default{m,1}.entrystr = '';

m = m+1;
default{m,1}.entrytype = 'ScriptName';
default{m,1}.labelstr = 'Script_Name';
default{m,1}.entrystr = '';

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'FieldEvoLoadfunc';
default{m,1}.entrystr = fevolfunc;
default{m,1}.searchpath = fevolpath;
default{m,1}.path = [fevolpath,fevolfunc];

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'GradMagMeasfunc';
default{m,1}.entrystr = gmeasfunc;
default{m,1}.searchpath = gmeaspath;
default{m,1}.path = [gmeaspath,gmeasfunc];

m = m+1;
default{m,1}.entrytype = 'RunScrptFunc';
default{m,1}.scrpttype = 'GradMag';
default{m,1}.labelstr = 'GradMagTest';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Run';


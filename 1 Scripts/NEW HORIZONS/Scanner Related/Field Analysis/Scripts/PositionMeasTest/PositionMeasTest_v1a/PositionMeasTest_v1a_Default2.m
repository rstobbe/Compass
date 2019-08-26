%====================================================
%
%====================================================

function [default] = PositionMeasTest_v1a_Default2(SCRPTPATHS)

if strcmp(filesep,'\')
    psbgpath = [SCRPTPATHS.newhorizonsloc,'Scanner Related\Field Analysis\Underlying\Selectable Functions\Position and Background\'];
    fevolpath = [SCRPTPATHS.newhorizonsloc,'Scanner Related\Field Analysis\Underlying\Selectable Functions\Field Evolution Load\'];  
elseif strcmp(filesep,'/')
end
fevolfunc = 'FieldEvoLoadBasicMRS_v1a';
psbgfunc = 'PosBgrndMRS47_v3d';

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
default{m,1}.labelstr = 'PosBgrndfunc';
default{m,1}.entrystr = psbgfunc;
default{m,1}.searchpath = psbgpath;
default{m,1}.path = [psbgpath,psbgfunc];

m = m+1;
default{m,1}.entrytype = 'RunScrptFunc';
default{m,1}.scrpttype = 'GradMag';
default{m,1}.labelstr = 'PosMeasTest';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Run';


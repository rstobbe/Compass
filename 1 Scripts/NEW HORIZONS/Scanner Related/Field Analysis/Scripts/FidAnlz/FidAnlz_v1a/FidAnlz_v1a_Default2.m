%====================================================
%
%====================================================

function [default] = FidAnlz_v1a_Default2(SCRPTPATHS)

if strcmp(filesep,'\')
    fidanlzpath = [SCRPTPATHS.newhorizonsloc,'Scanner Related\Field Analysis\Underlying\Selectable Functions\Single Fid Analysis\'];
    fevolpath = [SCRPTPATHS.newhorizonsloc,'Scanner Related\Field Analysis\Underlying\Selectable Functions\Field Evolution Load\'];  
elseif strcmp(filesep,'/')
end
fevolfunc = 'SingleFidLoadSiemens_v1a';
fidanlzfunc = 'SingleFidSmooth_v1a';

m = 1;
default{m,1}.entrytype = 'OutputName';
default{m,1}.labelstr = 'Anlz_Name';
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
default{m,1}.labelstr = 'FidAnlzfunc';
default{m,1}.entrystr = fidanlzfunc;
default{m,1}.searchpath = fidanlzpath;
default{m,1}.path = [fidanlzpath,fidanlzfunc];

m = m+1;
default{m,1}.entrytype = 'RunScrptFunc';
default{m,1}.scrpttype = 'GradMag';
default{m,1}.labelstr = 'PosMeasTest';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Run';


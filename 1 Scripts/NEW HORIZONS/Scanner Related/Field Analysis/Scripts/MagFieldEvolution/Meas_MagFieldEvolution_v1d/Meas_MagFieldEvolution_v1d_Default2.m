%====================================================
%
%====================================================

function [default] = Meas_MagFieldEvolution_v1d_Default2(SCRPTPATHS)

if strcmp(filesep,'\')
    psbgpath = [SCRPTPATHS.newhorizonsloc,'Scanner Related\Field Analysis\Underlying\Selectable Functions\Position and Background\'];
    fevolpath = [SCRPTPATHS.newhorizonsloc,'Scanner Related\Field Analysis\Underlying\Selectable Functions\Field Evolution Load\'];    
    tgpath = [SCRPTPATHS.newhorizonsloc,'Scanner Related\Field Analysis\Underlying\Selectable Functions\Transient Field Calculation\'];
elseif strcmp(filesep,'/')
end
fevolfunc = 'FieldEvoLoadSiemens_v1a';
psbgfunc = 'PosBgrndSmooth_v3d';
tgfunc = 'RFPreGrad_v2a';

m = 1;
default{m,1}.entrytype = 'OutputName';
default{m,1}.labelstr = 'FieldEvo_Name';
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
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'TransFieldfunc';
default{m,1}.entrystr = tgfunc;
default{m,1}.searchpath = tgpath;
default{m,1}.path = [tgpath,tgfunc];

m = m+1;
default{m,1}.entrytype = 'RunScrptFunc';
default{m,1}.scrpttype = 'EddyCurrents';
default{m,1}.labelstr = 'Determine Fields';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Run';


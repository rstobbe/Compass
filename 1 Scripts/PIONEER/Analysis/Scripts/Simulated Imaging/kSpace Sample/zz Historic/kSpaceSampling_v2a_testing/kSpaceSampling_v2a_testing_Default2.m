%=========================================================
% 
%=========================================================

function [default] = kSpaceSampling_v2a_Default2(SCRPTPATHS)

if strcmp(filesep,'\')
    addpath(genpath([SCRPTPATHS.rootloc,'Analysis\Underlying\zz Common']));
    ObjectPath = [SCRPTPATHS.scrptshareloc,'4 NC-SIM\Selectable Functions\Objects\'];
elseif strcmp(filesep,'/')
end
addpath(genpath(ObjectPath));
Objectfunc = 'SimHeadLesion_v1a';

m = 1;
default{m,1}.entrytype = 'RunExtFunc';
default{m,1}.labelstr = 'Imp_File';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Load';
default{m,1}.runfunc = 'LoadTrajectoryImplementation_v3';
default{m,1}.runfuncinput = {SCRPTPATHS.outloc};
default{m,1}.runfuncoutput = {''};

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'Objectfunc';
default{m,1}.entrystr = Objectfunc;
default{m,1}.searchpath = ObjectPath;

m = m+1;
default{m,1}.entrytype = 'RunScrptFunc';
default{m,1}.labelstr = 'Sample kSpace';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Sample';

m = m+1;
default{m,1}.entrytype = 'SaveScrptFunc';
default{m,1}.labelstr = 'Save Sampling';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Save';

m = m+1;
default{m,1}.entrytype = 'LoadScrptFunc';
default{m,1}.labelstr = 'Load Sampling';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Load';


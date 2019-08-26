%=========================================================
% 
%=========================================================

function [default] = SigDec_DataFile_v1a_Default2(SCRPTPATHS)

if strcmp(filesep,'\')
    path = [SCRPTPATHS.rootloc,'Analysis\Underlying\zz Common\Trajectory Analysis\Signal Decay Data Files\'];
elseif strcmp(filesep,'/')
end

m = 1;
default{m,1}.entrytype = 'RunFunc';
default{m,1}.labelstr = 'SigDec File';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Load';
default{m,1}.runfunc = 'SelectMatFile_v2';
default{m,1}.runfuncinput = {path};
default{m,1}.runfuncoutput = {''};

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'TE';
default{m,1}.entrystr = '0.194';

m = m+1;
default{m,1}.entrytype = 'Choose';
default{m,1}.labelstr = 'SigDec Vis';
default{m,1}.entrystr = 'Off';
default{m,1}.options = {'On','Off'};
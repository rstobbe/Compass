%=========================================================
% 
%=========================================================

function [default] = kSamp_TPISRI_v2p_Default2(SCRPTPATHS)

if strcmp(filesep,'\')
    srifuncpath = [SCRPTPATHS.pioneerloc,'Trajectory Implementation\Underlying\zz Underlying\Selectable Functions\kSamp SubFunctions\GSRI Functions\'];
elseif strcmp(filesep,'/')
end
srifunc = 'GSRI_TPIstandard_v2h';

m = 1;
default{m,1}.entrytype = 'Choose';
default{m,1}.labelstr = 'Save GSRI';
default{m,1}.entrystr = 'No';
default{m,1}.options = {'Yes','No'};

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'GSRIfunc';
default{m,1}.entrystr = srifunc;
default{m,1}.searchpath = srifuncpath;
default{m,1}.path = [srifuncpath,srifunc];





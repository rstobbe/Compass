%=========================================================
% 
%=========================================================

function [default] = SubPlotMontage_v1b_Default2(SCRPTPATHS)

if strcmp(filesep,'\')
    montcharspath = [SCRPTPATHS.voyagerloc,'Image Plotting\Underlying\zz Underlying\Montage Chars\'];
    createpath = [SCRPTPATHS.voyagerloc,'Image Plotting\Underlying\Selectable Functions\Figure Creation\'];
elseif strcmp(filesep,'/')
end
montcharsfunc = 'MontageCharsStandard_v1b';
createfunc = 'MontageFigure_v1b';

m = 1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'ImCharsfunc';
default{m,1}.entrystr = montcharsfunc;
default{m,1}.searchpath = montcharspath;
default{m,1}.path = [montcharspath,montcharsfunc];

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'Createfunc';
default{m,1}.entrystr = createfunc;
default{m,1}.searchpath = createpath;
default{m,1}.path = [createpath,createfunc];

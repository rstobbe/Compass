%=========================================================
% 
%=========================================================

function [default] = SubPlotMontage_v1a_Default2(SCRPTPATHS)

if strcmp(filesep,'\')
    montcharspath = [SCRPTPATHS.voyagerloc,'Image Plotting\Underlying\zz Underlying\Montage Chars\'];
    figcharspath = [SCRPTPATHS.voyagerloc,'Image Plotting\Underlying\zz Underlying\Figure Chars\'];
    createpath = [SCRPTPATHS.voyagerloc,'Image Plotting\Underlying\Selectable Functions\Figure Creation\'];
elseif strcmp(filesep,'/')
end
montcharsfunc = 'MontageCharsStandard_v1a';
figcharsfunc = 'FigureCharsStandard_v1a';
createfunc = 'MontageOverlayFigure_v1a';

m = 1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'ImCharsfunc';
default{m,1}.entrystr = montcharsfunc;
default{m,1}.searchpath = montcharspath;
default{m,1}.path = [montcharspath,montcharsfunc];

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'FigCharsfunc';
default{m,1}.entrystr = figcharsfunc;
default{m,1}.searchpath = figcharspath;
default{m,1}.path = [figcharspath,figcharsfunc];

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'Createfunc';
default{m,1}.entrystr = createfunc;
default{m,1}.searchpath = createpath;
default{m,1}.path = [createpath,createfunc];

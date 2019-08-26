%=========================================================
% 
%=========================================================

function [default] = PlotMontage_v1f_Default2(SCRPTPATHS)

if strcmp(filesep,'\')
    loadpath = [SCRPTPATHS.voyagerloc,'Image Format Related\Underlying\Selectable Functions\Load\Mat\'];
    montcharspath = [SCRPTPATHS.voyagerloc,'Image Plotting\Underlying\zz Underlying\Montage Chars\'];
    figcharspath = [SCRPTPATHS.voyagerloc,'Image Plotting\Underlying\zz Underlying\Figure Chars\'];
    createpath = [SCRPTPATHS.voyagerloc,'Image Plotting\Underlying\Selectable Functions\Figure Creation\'];
elseif strcmp(filesep,'/')
end
loadfunc = 'FImageLoad1_v1a';
montcharsfunc = 'MontageCharsStandard_v1a';
figcharsfunc = 'FigureCharsStandard_v1a';
createfunc = 'MontageFigure_v1a';

m = 1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'Plot_Name';
default{m,1}.entrystr = '';

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'ImLoadfunc';
default{m,1}.entrystr = loadfunc;
default{m,1}.searchpath = loadpath;
default{m,1}.path = [loadpath,loadfunc];

m = m+1;
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

m = m+1;
default{m,1}.entrytype = 'Choose';
default{m,1}.labelstr = 'SaveOption';
default{m,1}.entrystr = 'No';
default{m,1}.options = {'Yes','No'};

m = m+1;
default{m,1}.entrytype = 'RunScrptFunc';
default{m,1}.scrpttype = 'PlotImage';
default{m,1}.labelstr = 'Plot';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Plot';


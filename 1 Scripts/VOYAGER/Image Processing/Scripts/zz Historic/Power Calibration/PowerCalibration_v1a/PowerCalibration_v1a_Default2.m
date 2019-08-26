%=========================================================
% 
%=========================================================

function [default] = PowerCalibration_v1a_Default2(SCRPTPATHS)

if strcmp(filesep,'\')
    loadpath = [SCRPTPATHS.voyagerloc,'Image Format Related\Underlying\Selectable Functions\Load\Mat\'];
    disppath = [SCRPTPATHS.voyagerloc,'Image Processing\Underlying\Selectable Functions\Image Display\'];    
    datcolpath = [SCRPTPATHS.voyagerloc,'Image Processing\Underlying\Selectable Functions\Power Calibration\Data Collection\'];
    syswrtpath = [SCRPTPATHS.voyagerloc,'Image Processing\Underlying\Selectable Functions\Power Calibration\System Write\'];
elseif strcmp(filesep,'/')
end
loadfunc = 'FImageLoad1_v1a';
dispfunc = 'SubPlotMontage_v1a';
datcolfunc = 'PointCollect_v1a';
syswrtfunc = 'WritePulseCalV_v1a';

m = 1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'Cal_Name';
default{m,1}.entrystr = '';

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'ImLoadfunc';
default{m,1}.entrystr = loadfunc;
default{m,1}.searchpath = loadpath;
default{m,1}.path = [loadpath,loadfunc];

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'Dispfunc';
default{m,1}.entrystr = dispfunc;
default{m,1}.searchpath = disppath;
default{m,1}.path = [disppath,dispfunc];

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'DatColfunc';
default{m,1}.entrystr = datcolfunc;
default{m,1}.searchpath = datcolpath;
default{m,1}.path = [datcolpath,datcolfunc];

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'SysWrtfunc';
default{m,1}.entrystr = syswrtfunc;
default{m,1}.searchpath = syswrtpath;
default{m,1}.path = [syswrtpath,syswrtfunc];

m = m+1;
default{m,1}.entrytype = 'RunScrptFunc';
default{m,1}.scrpttype = 'Cal';
default{m,1}.labelstr = 'Cal';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Run';
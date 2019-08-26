%====================================================
%
%====================================================

function [default] = Anlz_RFwfmV_v1b_Default2(SCRPTPATHS)

if strcmp(filesep,'\')
    blochpath = [SCRPTPATHS.newhorizonsloc,'\Bloch Simulation\Underlying\zz Underlying\Selectable Functions\Bloch Equations\'];
elseif strcmp(filesep,'/')
end
blochfunc = 'StandardBloch_v1a';
addpath([blochpath,blochfunc]);

m = 1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'Test_Name';
default{m,1}.entrystr = '';

m = m+1;
default{m,1}.entrytype = 'RunExtFunc';
default{m,1}.labelstr = 'RF_File';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Load';
default{m,1}.runfunc1 = 'SelectGeneralFileCur_v4';
default{m,1}.(default{m,1}.runfunc1).curloc = SCRPTPATHS.outloc;
default{m,1}.(default{m,1}.runfunc1).loadpanel = 'No';
default{m,1}.runfunc2 = 'SelectGeneralFileDef_v4';
default{m,1}.(default{m,1}.runfunc2).defloc = SCRPTPATHS.outloc;
default{m,1}.(default{m,1}.runfunc2).loadpanel = 'No';
default{m,1}.searchpath = SCRPTPATHS.scrptshareloc;
default{m,1}.path = SCRPTPATHS.scrptshareloc;

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'FlipAngle (deg)';
default{m,1}.entrystr = '90';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'PlsDur (ms)';
default{m,1}.entrystr = '5.0';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'PlotBW (Hz)';
default{m,1}.entrystr = '1000';

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'Blochfunc';
default{m,1}.entrystr = blochfunc;
default{m,1}.searchpath = blochpath;
default{m,1}.path = [blochpath,blochfunc];

m = m+1;
default{m,1}.entrytype = 'RunScrptFunc';
default{m,1}.scrpttype = 'AnlzRF';
default{m,1}.labelstr = 'Analyze RF';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Run';


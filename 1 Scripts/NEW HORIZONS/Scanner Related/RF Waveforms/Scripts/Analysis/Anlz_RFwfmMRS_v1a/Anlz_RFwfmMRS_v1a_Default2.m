%====================================================
%
%====================================================

function [default] = Anlz_RFwfmMRS_v1a_Default2(SCRPTPATHS)

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
default{m,1}.entrytype = 'RunScrptFunc';
default{m,1}.scrpttype = 'AnlzRF';
default{m,1}.labelstr = 'Analyze RF';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Run';


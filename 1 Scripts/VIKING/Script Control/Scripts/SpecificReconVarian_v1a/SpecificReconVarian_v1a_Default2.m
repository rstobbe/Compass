%====================================================
%
%====================================================

function [default] = SpecificReconVarian_v1a_Default2(SCRPTPATHS)

global COMPASSINFO

m = 1;
default{m,1}.entrytype = 'RunExtFunc';
default{m,1}.labelstr = 'Data_File';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Select';
default{m,1}.runfunc1 = 'LoadVarianDataCur';
default{m,1}.(default{m,1}.runfunc1).curloc = SCRPTPATHS.loc;
default{m,1}.(default{m,1}.runfunc1).defloc = COMPASSINFO.USERGBL.variandataloc;
default{m,1}.runfunc2 = 'LoadVarianDataDisp';
default{m,1}.searchpath = SCRPTPATHS.scrptshareloc;
default{m,1}.path = SCRPTPATHS.scrptshareloc;

m = m+1;
default{m,1}.entrytype = 'RunExtFunc';
default{m,1}.labelstr = 'ReconScript';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Select';
default{m,1}.runfunc1 = 'SelectSavedScriptNoShowCur';
default{m,1}.(default{m,1}.runfunc1).curloc = SCRPTPATHS.loc;
default{m,1}.(default{m,1}.runfunc1).defloc = SCRPTPATHS.defloc;
default{m,1}.runfunc2 = 'SelectSavedScriptNoShowDef';
default{m,1}.(default{m,1}.runfunc2).defloc = SCRPTPATHS.defloc;
default{m,1}.searchpath = SCRPTPATHS.scrptshareloc;
default{m,1}.path = SCRPTPATHS.scrptshareloc;

m = m+1;
default{m,1}.entrytype = 'RunScrptFunc';
default{m,1}.scrpttype = 'Image';
default{m,1}.labelstr = 'Create Image';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Run';


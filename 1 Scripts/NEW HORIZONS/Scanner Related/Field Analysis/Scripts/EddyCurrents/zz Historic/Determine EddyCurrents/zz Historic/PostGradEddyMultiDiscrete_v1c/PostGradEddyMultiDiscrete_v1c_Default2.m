%====================================================
%
%====================================================

function [default] = PostGradEddyMultiDiscrete_v1c_Default2(SCRPTPATHS)

if strcmp(filesep,'\')
    addpath(genpath([SCRPTPATHS.rootloc,'Scanner Related\Field Analysis\Underlying\zz Common']));
    psbgpath = [SCRPTPATHS.rootloc,'Scanner Related\Field Analysis\Underlying\Selectable Functions\Position and Background\'];
elseif strcmp(filesep,'/')
end

addpath(genpath(psbgpath));
psbgfunc = 'PosBG_v2b';

m = 1;
default{m,1}.entrytype = 'Choose';
default{m,1}.labelstr = 'System';
default{m,1}.entrystr = 'Varian';
default{m,1}.options = {'SMIS','Varian'};

m = m+1;
default{m,1}.entrytype = 'RunExtFunc';
default{m,1}.labelstr = 'File_NoGrad1';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Load';
default{m,1}.runfunc1 = 'SelectFidDataCur_v4';
default{m,1}.(default{m,1}.runfunc1).curloc = SCRPTPATHS.loc;
default{m,1}.runfunc2 = 'SelectFidDataDef_v4';
default{m,1}.(default{m,1}.runfunc2).defloc = SCRPTPATHS.loc;

m = m+1;
default{m,1}.entrytype = 'RunExtFunc';
default{m,1}.labelstr = 'File_NoGrad2';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Load';
default{m,1}.runfunc1 = 'SelectFidDataCur_v4';
default{m,1}.(default{m,1}.runfunc1).curloc = SCRPTPATHS.loc;
default{m,1}.runfunc2 = 'SelectFidDataDef_v4';
default{m,1}.(default{m,1}.runfunc2).defloc = SCRPTPATHS.loc;

m = m+1;
default{m,1}.entrytype = 'RunExtFunc';
default{m,1}.labelstr = 'File_PosLoc1';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Load';
default{m,1}.runfunc1 = 'SelectFidDataCur_v4';
default{m,1}.(default{m,1}.runfunc1).curloc = SCRPTPATHS.loc;
default{m,1}.runfunc2 = 'SelectFidDataDef_v4';
default{m,1}.(default{m,1}.runfunc2).defloc = SCRPTPATHS.loc;

m = m+1;
default{m,1}.entrytype = 'RunExtFunc';
default{m,1}.labelstr = 'File_PosLoc2';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Load';
default{m,1}.runfunc1 = 'SelectFidDataCur_v4';
default{m,1}.(default{m,1}.runfunc1).curloc = SCRPTPATHS.loc;
default{m,1}.runfunc2 = 'SelectFidDataDef_v4';
default{m,1}.(default{m,1}.runfunc2).defloc = SCRPTPATHS.loc;

m = m+1;
default{m,1}.entrytype = 'RunExtFunc';
default{m,1}.labelstr = 'File_Grad1';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Load';
default{m,1}.runfunc1 = 'SelectFidDataCur_v4';
default{m,1}.(default{m,1}.runfunc1).curloc = SCRPTPATHS.loc;
default{m,1}.runfunc2 = 'SelectFidDataDef_v4';
default{m,1}.(default{m,1}.runfunc2).defloc = SCRPTPATHS.loc;

m = m+1;
default{m,1}.entrytype = 'RunExtFunc';
default{m,1}.labelstr = 'File_Grad2';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Load';
default{m,1}.runfunc1 = 'SelectFidDataCur_v4';
default{m,1}.(default{m,1}.runfunc1).curloc = SCRPTPATHS.loc;
default{m,1}.runfunc2 = 'SelectFidDataDef_v4';
default{m,1}.(default{m,1}.runfunc2).defloc = SCRPTPATHS.loc;

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'Gstart (ms)';
default{m,1}.entrystr = '1';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'Gstop (ms)';
default{m,1}.entrystr = '30';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'B0 (1% -> uTpG)';
default{m,1}.entrystr = '0.0185';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'G (act% -> V%)';
default{m,1}.entrystr = '0.48';

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'PosBgrndfunc';
default{m,1}.entrystr = psbgfunc;
default{m,1}.searchpath = psbgpath;

m = m+1;
default{m,1}.entrytype = 'RunScrptFunc';
default{m,1}.scrpttype = 'PostGradEddyMultiDiscrete';
default{m,1}.labelstr = 'Determine Fields';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Run';


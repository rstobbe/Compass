%=========================================================
% 
%=========================================================

function [default] = CsfMaskTransFuncExpand_v1a_Default2(SCRPTPATHS)

m = 1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'AbsCsfThresh';
default{m,1}.entrystr = '0.05';

m = m+1;
default{m,1}.entrytype = 'Choose';
default{m,1}.labelstr = 'Direction';
default{m,1}.entrystr = 'Positive';
default{m,1}.options = {'Positive','Negative'};

m = m+1;
default{m,1}.entrytype = 'RunExtFunc';
default{m,1}.labelstr = 'TF_File';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Select';
default{m,1}.runfunc1 = 'LoadScriptFileCur';
default{m,1}.(default{m,1}.runfunc1).curloc = SCRPTPATHS.outloc;
default{m,1}.runfunc2 = 'LoadScriptFileDisp';
default{m,1}.(default{m,1}.runfunc2).defloc = SCRPTPATHS.outloc;

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'PostConvThresh';
default{m,1}.entrystr = '0.2';

%=========================================================
% 
%=========================================================

function [default] = TransFuncExpand_v1a_Default2(SCRPTPATHS)

m = 1;
default{m,1}.entrytype = 'RunExtFunc';
default{m,1}.labelstr = 'TF_File';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Select';
default{m,1}.runfunc1 = 'LoadScriptFileCur';
default{m,1}.(default{m,1}.runfunc1).curloc = SCRPTPATHS.outloc;
default{m,1}.runfunc2 = 'LoadScriptFileDisp';
default{m,1}.(default{m,1}.runfunc2).defloc = SCRPTPATHS.outloc;

m = m+1;
default{m,1}.entrytype = 'Choose';
default{m,1}.labelstr = 'Output';
default{m,1}.entrystr = 'Value';
default{m,1}.options = {'Ones','Value'};

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'MaskThresh';
default{m,1}.entrystr = '0.05';

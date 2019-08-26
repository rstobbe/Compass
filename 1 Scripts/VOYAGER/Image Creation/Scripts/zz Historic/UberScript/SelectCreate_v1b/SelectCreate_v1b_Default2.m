%====================================================
%
%====================================================

function [default] = SelectCreate_v1b_Default2(SCRPTPATHS)

% if strcmp(filesep,'\')
%     addpath(genpath([SCRPTPATHS.voyagerloc,'Image Creation\UberScript\zz Common']));
%     addpath(genpath([SCRPTPATHS.voyagerloc,'Image Creation\UberScript\zy Recon Defaults']));
% elseif strcmp(filesep,'/')
% end

m = 1;
default{m,1}.entrytype = 'RunExtFunc';
default{m,1}.labelstr = 'FIDfile';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Select';
default{m,1}.runfunc1 = 'SelectFidDataCur_v4b';
default{m,1}.(default{m,1}.runfunc1).curloc = SCRPTPATHS.loc;
default{m,1}.runfunc2 = 'SelectFidDataDef_v4b';
default{m,1}.(default{m,1}.runfunc2).defloc = SCRPTPATHS.loc;
default{m,1}.searchpath = SCRPTPATHS.scrptshareloc;
default{m,1}.path = SCRPTPATHS.scrptshareloc;

m = m+1;
default{m,1}.entrytype = 'Choose';
default{m,1}.labelstr = 'Function';
default{m,1}.entrystr = 'Run';
default{m,1}.options = {'LoadDefs','Run'};

m = m+1;
default{m,1}.entrytype = 'RunScrptFunc';
default{m,1}.scrpttype = 'Image';
default{m,1}.labelstr = 'Create Image';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Run';


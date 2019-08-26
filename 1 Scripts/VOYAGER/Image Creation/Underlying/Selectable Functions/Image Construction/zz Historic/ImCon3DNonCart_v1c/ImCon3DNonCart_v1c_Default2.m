%=========================================================
% 
%=========================================================

function [default] = ImCon3DNonCart_v1c_Default2(SCRPTPATHS)

global COMPASSINFO

if strcmp(filesep,'\')
    reconpath = [SCRPTPATHS.voyagerloc,'Image Creation\Underlying\Selectable Functions\Construction Method\'];
    dataorgpath = [SCRPTPATHS.voyagerloc,'Image Creation\Underlying\Selectable Functions\Data Organize\'];   
    returnfovpath = [SCRPTPATHS.voyagerloc,'Image Creation\Underlying\Selectable Functions\ReturnFov\'];
elseif strcmp(filesep,'/')
end
reconfunc = 'Recon3DGriddingSuper_v2k';
dataorgfunc = 'DataOrg_AsIs_v1b';
returnfovfunc = 'ReturnFov_Design_v1a';

m = 1;
default{m,1}.entrytype = 'RunExtFunc';
default{m,1}.labelstr = 'Recon_File';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Load';
default{m,1}.runfunc1 = 'LoadTrajImpCur';
default{m,1}.(default{m,1}.runfunc1).curloc = SCRPTPATHS.outloc;
default{m,1}.(default{m,1}.runfunc1).defloc = COMPASSINFO.USERGBL.trajreconloc;
default{m,1}.runfunc2 = 'LoadTrajImpDisp';

m = m+1;
default{m,1}.entrytype = 'Choose';
default{m,1}.labelstr = 'ZeroFill';
default{m,1}.entrystr = '64';
default{m,1}.options = {'64','80','96','112','128','144','176','192','208','224','256','272','304','336','368','400','432','464','496','528'};

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'DataOrgfunc';
default{m,1}.entrystr = dataorgfunc;
default{m,1}.searchpath = dataorgpath;
default{m,1}.path = [dataorgpath,dataorgfunc];

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'ReturnFovfunc';
default{m,1}.entrystr = returnfovfunc;
default{m,1}.searchpath = returnfovpath;
default{m,1}.path = [returnfovpath,returnfovfunc];

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'Reconfunc';
default{m,1}.entrystr = reconfunc;
default{m,1}.searchpath = reconpath;
default{m,1}.path = [reconpath,reconfunc];

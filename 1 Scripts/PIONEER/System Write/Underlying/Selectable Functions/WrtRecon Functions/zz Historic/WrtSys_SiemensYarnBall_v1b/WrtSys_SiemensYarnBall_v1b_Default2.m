%=========================================================
% 
%=========================================================

function [default] = WrtSys_SiemensYarnBall_v1b_Default2(SCRPTPATHS)

if strcmp(filesep,'\')
    wrgradpath = [SCRPTPATHS.pioneerloc,'System Write\Underlying\zz Underlying\WrtGrad Functions\'];
    wrparampath = [SCRPTPATHS.pioneerloc,'System Write\Underlying\zz Underlying\WrtParam Functions\'];
elseif strcmp(filesep,'/')
end
wrgradfunc = 'WrtGrad_Siemens_v1a';
wrparamfunc = 'WrtParam_SiemensYarnBall_v1b';

m = 1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'Dummies';
default{m,1}.entrystr = 0;

m = m+1;
default{m,1}.entrytype = 'Choose';
default{m,1}.labelstr = 'ReconOnly';
default{m,1}.entrystr = 'Yes';
default{m,1}.options = {'Yes','No'};

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'WrtGradfunc';
default{m,1}.entrystr = wrgradfunc;
default{m,1}.searchpath = wrgradpath;
default{m,1}.path = [wrgradpath,wrgradfunc];

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'WrtParamfunc';
default{m,1}.entrystr = wrparamfunc;
default{m,1}.searchpath = wrparampath;
default{m,1}.path = [wrparampath,wrparamfunc];


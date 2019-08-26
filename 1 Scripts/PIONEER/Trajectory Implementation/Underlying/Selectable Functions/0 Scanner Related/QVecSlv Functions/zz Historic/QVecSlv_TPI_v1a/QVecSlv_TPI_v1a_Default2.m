%=========================================================
% 
%=========================================================

function [default] = QVecSlv_TPI_v1a_Default2(SCRPTPATHS)

if strcmp(filesep,'\')
    QVecpath = [SCRPTPATHS.rootloc,'Trajectory Implementation\Underlying\zz Underlying\Selectable Functions\QVec SubFunctions\'];
elseif strcmp(filesep,'/')
end
addpath(genpath(QVecpath));

QVecfunc = 'QVec_TPI_v1b';
twGseg = '0.30';
Solve_Priority1 = 'iGseg1';
Solve_Priority2 = 'Tro2';

m = 1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'QVecfunc';
default{m,1}.entrystr = QVecfunc;
default{m,1}.searchpath = QVecpath;

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'twGseg (ms)';
default{m,1}.entrystr = twGseg;

m = m+1;
default{m,1}.entrytype = 'Choose';
default{m,1}.labelstr = 'Solve_Priority1';
default{m,1}.entrystr = Solve_Priority1;
default{m,1}.options = {'TwGseg1','iGseg1','Tro1','OvrSamp1'};

m = m+1;
default{m,1}.entrytype = 'Choose';
default{m,1}.labelstr = 'Solve_Priority2';
default{m,1}.entrystr = Solve_Priority2;
default{m,1}.options = {'TwGseg2','iGseg2','Tro2','OvrSamp2'};
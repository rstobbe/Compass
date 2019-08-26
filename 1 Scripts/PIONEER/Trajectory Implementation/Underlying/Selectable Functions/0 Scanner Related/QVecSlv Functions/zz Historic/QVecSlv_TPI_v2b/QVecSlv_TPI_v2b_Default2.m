%=========================================================
% 
%=========================================================

function [default] = QVecSlv_TPI_v2b_Default2(SCRPTPATHS)

if strcmp(filesep,'\')
    QVecpath = [SCRPTPATHS.pioneerloc,'Trajectory Implementation\Underlying\zz Underlying\Selectable Functions\QVec SubFunctions\'];
elseif strcmp(filesep,'/')
end
QVecfunc = 'QVec_TPI_v1e';

twGseg = '0.30';
Solve_Priority1 = 'iGseg1';
Solve_Priority2 = 'Tro2';

m = 1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'twGseg (ms)';
default{m,1}.entrystr = twGseg;

m = m+1;
default{m,1}.entrytype = 'Choose';
default{m,1}.labelstr = 'Solve_Priority1';
default{m,1}.entrystr = Solve_Priority1;
default{m,1}.options = {'TwGseg1','iGseg1','Tro1'};

m = m+1;
default{m,1}.entrytype = 'Choose';
default{m,1}.labelstr = 'Solve_Priority2';
default{m,1}.entrystr = Solve_Priority2;
default{m,1}.options = {'TwGseg2','iGseg2','Tro2'};

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'QVecfunc';
default{m,1}.entrystr = QVecfunc;
default{m,1}.searchpath = QVecpath;
default{m,1}.path = [QVecpath,QVecfunc];
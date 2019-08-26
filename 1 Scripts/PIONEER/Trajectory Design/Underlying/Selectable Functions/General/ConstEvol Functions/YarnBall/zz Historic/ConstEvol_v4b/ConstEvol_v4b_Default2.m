%=========================================================
% 
%=========================================================

function [default] = CAccMeth4a_v1a_Default2(SCRPTPATHS)

if strcmp(filesep,'\')
    gvelprofpath = [SCRPTPATHS.pioneerloc,'Trajectory Design\Underlying\zz Underlying\Selectable Functions\LR\ConstEvol SubFunctions\ConstAccProf Functions\'];
elseif strcmp(filesep,'/')
end
gvelproffunc = 'CAccProf_Exp2Uniform_v1a';

m = 1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'Gacc (mT/m/ms2)';
default{m,1}.entrystr = '8000';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'Gvel (mT/m/ms)';
default{m,1}.entrystr = '160';

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'GvelProf';
default{m,1}.entrystr = gvelproffunc;
default{m,1}.searchpath = gvelprofpath;
default{m,1}.path = [gvelprofpath,gvelproffunc];
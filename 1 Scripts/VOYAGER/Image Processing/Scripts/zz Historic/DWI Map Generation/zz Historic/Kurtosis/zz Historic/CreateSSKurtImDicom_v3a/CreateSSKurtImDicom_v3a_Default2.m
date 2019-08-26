%=========================================================
% 
%=========================================================

function [default] = CreateSSKurtImDicom_v3a_Default2(SCRPTPATHS)

m = 1;
default{m,1}.entrytype = 'RunFunc';
default{m,1}.labelstr = 'FirstDicomFile_Mag';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Select';
default{m,1}.runfunc = 'SelectDicomFile_v2';
default{m,1}.runfuncinput = {SCRPTPATHS.outrootloc};
default{m,1}.runfuncoutput = {''};

m = m+1;
default{m,1}.entrytype = 'RunFunc';
default{m,1}.labelstr = 'FirstDicomFile_Phase';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Select';
default{m,1}.runfunc = 'SelectDicomFile_v2';
default{m,1}.runfuncinput = {SCRPTPATHS.outrootloc};
default{m,1}.runfuncoutput = {''};

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'b-values';
default{m,1}.entrystr = '0 500 1000 1500 2000 2500';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'Tot_b0images';
default{m,1}.entrystr = '15';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'Tot_Slices';
default{m,1}.entrystr = '6';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'Tot_Directions';
default{m,1}.entrystr = '15';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'Averages';
default{m,1}.entrystr = '4';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'Slice';
default{m,1}.entrystr = '1';
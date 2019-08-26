%=========================================================
% 
%=========================================================

function [default] = LoadImageDicomComplex_v1a_Default2(SCRPTPATHS)

m = 1;
default{m,1}.entrytype = 'RunFunc';
default{m,1}.labelstr = 'DicomFile_Abs';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Select';
default{m,1}.runfunc = 'SelectDicomFile_v2';
default{m,1}.runfuncinput = {SCRPTPATHS.outrootloc};
default{m,1}.runfuncoutput = {''};

m = m+1;
default{m,1}.entrytype = 'RunFunc';
default{m,1}.labelstr = 'DicomFile_Phase';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Select';
default{m,1}.runfunc = 'SelectDicomFile_v2';
default{m,1}.runfuncinput = {SCRPTPATHS.outrootloc};
default{m,1}.runfuncoutput = {''};

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'Figure';
default{m,1}.entrystr = '2';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'SliceStart';
default{m,1}.entrystr = '81';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'NumSlices';
default{m,1}.entrystr = '80';


%=========================================================
% 
%=========================================================

function [default] = ImMultiLoadGeneric_v1a_Default2(SCRPTPATHS)

global MULTIFILELOAD

m = 1;
default{m,1}.entrytype = 'RunExtFunc';
default{m,1}.labelstr = 'NumFiles';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Select';
default{m,1}.runfunc1 = 'ImMultiLoadGeneric_v1a_NumFileSel';
default{m,1}.searchpath = SCRPTPATHS.scrptshareloc;
default{m,1}.path = SCRPTPATHS.scrptshareloc;

if isempty(MULTIFILELOAD)
    return
end

for n = 1:MULTIFILELOAD.numfiles
    m = m+1;
    default{m,1}.entrytype = 'RunExtFunc';
    default{m,1}.labelstr = ['Image',num2str(n)];
    default{m,1}.entrystr = '';
    default{m,1}.buttonname = 'Select';
    default{m,1}.runfunc1 = 'LoadImageCur';
    default{m,1}.(default{m,1}.runfunc1).curloc = SCRPTPATHS.experimentsloc;
    default{m,1}.runfunc2 = 'LoadImageDef';
    default{m,1}.(default{m,1}.runfunc2).defloc = SCRPTPATHS.experimentsloc;
    default{m,1}.searchpath = SCRPTPATHS.scrptshareloc;
    default{m,1}.path = SCRPTPATHS.scrptshareloc;
end


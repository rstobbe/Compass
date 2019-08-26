%=========================================================
% 
%=========================================================

function [default] = FullManipulate_v1a_Default2(SCRPTPATHS)

m = 1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'Permute';
default{m,1}.entrystr = '[1,2,3]';

m = m+1;
default{m,1}.entrytype = 'Choose';
default{m,1}.labelstr = 'FlipLR';
default{m,1}.entrystr = 'No';
default{m,1}.options = {'Yes','No'};

m = m+1;
default{m,1}.entrytype = 'Choose';
default{m,1}.labelstr = 'FlipTB';
default{m,1}.entrystr = 'No';
default{m,1}.options = {'Yes','No'};

m = m+1;
default{m,1}.entrytype = 'Choose';
default{m,1}.labelstr = 'FlipIO';
default{m,1}.entrystr = 'No';
default{m,1}.options = {'Yes','No'};
    

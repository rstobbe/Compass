%============================================
% 
%============================================
function axnum = GetFocus(tab)

global IMAGEANLZ;

axnum = 1;
for n = 1:IMAGEANLZ.(tab)(1).axeslen
    if IMAGEANLZ.(tab)(n).highlight
        axnum = n;
    end
end

%============================================
% 
%============================================
function bool = ImAnlz_TestMouseInImage(IMAGEANLZ,mouseloc)

bool = 0;
if mouseloc(1) >= IMAGEANLZ.SCALE.xmin && mouseloc(1) <= IMAGEANLZ.SCALE.xmax && mouseloc(2) >= IMAGEANLZ.SCALE.ymin && mouseloc(2) <= IMAGEANLZ.SCALE.ymax
    bool = 1;
end




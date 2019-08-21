%============================================
% 
%============================================
function IMAGEANLZ = ImAnlz_HoldingTest(IMAGEANLZ,totgblnum)

IMAGEANLZ.ZOOMHOLD = 1;
IMAGEANLZ.SLCHOLD = 1;
IMAGEANLZ.DIMSHOLD = 1;

if isempty(IMAGEANLZ.totgblnum)
    IMAGEANLZ.ZOOMHOLD = 0;
    IMAGEANLZ.SLCHOLD = 0;
    IMAGEANLZ.DIMSHOLD = 0;
    return
end

curimsize = IMAGEANLZ.GetBaseImageSize([]);
newimsize = IMAGEANLZ.GetBaseImageSize(totgblnum);

for n = 1:3
    if newimsize(n) ~= curimsize(n);
        IMAGEANLZ.ZOOMHOLD = 0;
        IMAGEANLZ.SLCHOLD = 0;
    end
end
for n = 4:6
    if newimsize(n) ~= curimsize(n);
        IMAGEANLZ.DIMSHOLD = 0;
    end 
end

curbaseorient = IMAGEANLZ.GetBaseOrient([]);
newbaseorient = IMAGEANLZ.GetBaseOrient(totgblnum);
if not(strcmp(curbaseorient,newbaseorient))
    IMAGEANLZ.ZOOMHOLD = 0;
    IMAGEANLZ.SLCHOLD = 0;
    IMAGEANLZ.DIMSHOLD = 0;
end


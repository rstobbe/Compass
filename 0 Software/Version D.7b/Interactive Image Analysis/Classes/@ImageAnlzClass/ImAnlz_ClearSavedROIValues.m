%==========================================================
% 
%==========================================================
function IMAGEANLZ = ImAnlz_ClearSavedROIValues(IMAGEANLZ)

if strcmp(IMAGEANLZ.presentation,'Ortho') && IMAGEANLZ.axnum ~= 1
    return
end

for n = 1:35
    set(IMAGEANLZ.FIGOBJS.OUTPUT(n,1),'visible','off','string','');
    set(IMAGEANLZ.FIGOBJS.OUTPUT(n,2),'visible','off','string','');
    set(IMAGEANLZ.FIGOBJS.OUTPUT(n,3),'visible','off','string','');
    set(IMAGEANLZ.FIGOBJS.ROINAME(n),'visible','off','string','');
    IMAGEANLZ.ROISOFINTEREST(n) = 0;
    IMAGEANLZ.FIGOBJS.ROINAME(n).ForegroundColor = [0.8 0.8 0.8];
end


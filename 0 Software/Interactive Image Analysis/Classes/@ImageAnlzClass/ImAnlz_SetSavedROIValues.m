%==========================================================
% 
%==========================================================
function IMAGEANLZ = ImAnlz_SetSavedROIValues(IMAGEANLZ)

for n = 1:length(IMAGEANLZ.SAVEDROIS)
    set(IMAGEANLZ.FIGOBJS.OUTPUT(n,1),'visible','on','string',num2str(IMAGEANLZ.SAVEDROIS(n).roivol,'%3.3f'),'foregroundcolor',IMAGEANLZ.COLORORDER{n});
    set(IMAGEANLZ.FIGOBJS.OUTPUT(n,2),'visible','on','string',num2str(IMAGEANLZ.SAVEDROIS(n).roimean,'%2.5f'),'foregroundcolor',IMAGEANLZ.COLORORDER{n});
    set(IMAGEANLZ.FIGOBJS.OUTPUT(n,3),'visible','on','string',num2str(IMAGEANLZ.SAVEDROIS(n).roisdv,'%2.5f'),'foregroundcolor',IMAGEANLZ.COLORORDER{n});
    set(IMAGEANLZ.FIGOBJS.ROINAME(n),'visible','on','string',IMAGEANLZ.SAVEDROIS(n).roiname,'foregroundcolor',IMAGEANLZ.COLORORDER{n});
end


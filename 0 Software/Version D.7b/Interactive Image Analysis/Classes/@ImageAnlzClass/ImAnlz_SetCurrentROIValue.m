%==========================================================
% 
%==========================================================
function IMAGEANLZ = ImAnlz_SetCurrentROIValue(IMAGEANLZ)

set(IMAGEANLZ.FIGOBJS.CURRENT(1),'visible','on','string',num2str(IMAGEANLZ.CURRENTROI.roivol,'%3.3f'),'foregroundcolor','r');
set(IMAGEANLZ.FIGOBJS.CURRENT(2),'visible','on','string',num2str(IMAGEANLZ.CURRENTROI.roimean,'%2.5f'),'foregroundcolor','r');
set(IMAGEANLZ.FIGOBJS.CURRENT(3),'visible','on','string',num2str(IMAGEANLZ.CURRENTROI.roisdv,'%2.5f'),'foregroundcolor','r');



%==========================================================
% 
%==========================================================
function IMAGEROI = ImRoi_DrawROIwOffset(IMAGEROI,IMAGEANLZ,axhand,clr,xoff,yoff)

if isempty(axhand)
    axhand = IMAGEANLZ.GetAxisHandle;
end

for n = 1:length(IMAGEROI.xlocarr)
    xloc = IMAGEROI.xlocarr{n};                               
    yloc = IMAGEROI.ylocarr{n};
    zloc = IMAGEROI.zlocarr{n};
    if zloc == IMAGEANLZ.SLICE
        line(xloc+xoff,yloc+yoff,'parent',axhand,'color',clr);
    end
end


%==========================================================
% 
%==========================================================
function IMAGEROI = ImRoi_OutsideOffsetsDrawROI(IMAGEROI,voff,hoff,slice,axhand,clr,linewidth)

if isempty(axhand)
    axhand = IMAGEANLZ.GetAxisHandle;
end

for n = 1:length(IMAGEROI.xlocarr)
    zloc = IMAGEROI.zlocarr{n};
    if zloc == slice
        xloc = IMAGEROI.xlocarr{n} + hoff;                               
        yloc = IMAGEROI.ylocarr{n} + voff;
        %line(xloc,yloc,'parent',axhand,'color',clr,'linewidth',2);
        line(xloc,yloc,'parent',axhand,'color',clr,'linewidth',linewidth);
    end
end


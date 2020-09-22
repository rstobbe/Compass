%==========================================================
% 
%==========================================================
function IMAGEROI = ImRoi_OutsideDrawROI(IMAGEROI,slice,axhand,clr)

if isempty(axhand)
    axhand = IMAGEANLZ.GetAxisHandle;
end

for n = 1:length(IMAGEROI.xlocarr)
    zloc = IMAGEROI.zlocarr{n};
    if zloc == slice
        xloc = IMAGEROI.xlocarr{n};                               
        yloc = IMAGEROI.ylocarr{n};
        line(xloc,yloc,'parent',axhand,'color',clr);
    end
end


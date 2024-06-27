%==========================================================
% 
%==========================================================
function IMAGEROI = ImRoi_DrawROI(IMAGEROI,IMAGEANLZ,axhand,clr,pickable)

if isempty(axhand)
    axhand = IMAGEANLZ.GetAxisHandle;
end

delete(IMAGEROI.linehandles)
delete(IMAGEROI.contextmenu)
%zlocarr = cell2mat(IMAGEROI.zlocarr);              % different number types...
for n = 1:length(IMAGEROI.zlocarr)
    zlocarr(n) = IMAGEROI.zlocarr{n};
end
for n = 1:length(IMAGEROI.xlocarr)
    if isprop(IMAGEROI,'drawroiorientarray')
        if length(IMAGEROI.drawroiorientarray) == 0
            tempdrawroiorientarray = IMAGEROI.drawroiorient;
        else
            tempdrawroiorientarray = IMAGEROI.drawroiorientarray{n};
        end
    else
        tempdrawroiorientarray = IMAGEROI.drawroiorient;
    end
    if zlocarr(n) == IMAGEANLZ.SLICE && strcmp(tempdrawroiorientarray,IMAGEANLZ.ORIENT)
        xloc = IMAGEROI.xlocarr{n};                               
        yloc = IMAGEROI.ylocarr{n};
        IMAGEROI.linehandles(n) = line(xloc,yloc,'parent',axhand,'color',clr);
        if pickable == 1
            IMAGEROI.linehandles(n).PickableParts = 'visible';
        else
            IMAGEROI.linehandles(n).PickableParts = 'none';
        end
        IMAGEROI.contextmenu(n) = uicontextmenu;
        IMAGEROI.contextmenu(n).Tag = IMAGEANLZ.tab;
        IMAGEROI.linehandles(n).UIContextMenu = IMAGEROI.contextmenu(n);
        uimenu(IMAGEROI.contextmenu(n),'Label',IMAGEROI.roiname,'Enable','off');
        Data.ROI = IMAGEROI;
        Data.currentregion = n;
        uimenu(IMAGEROI.contextmenu(n),'Label','Show Creation','Callback',@ShowROICreate,'Separator','on','Tag',num2str(IMAGEANLZ.axnum),'UserData',Data);
     end
end
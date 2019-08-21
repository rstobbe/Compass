%============================================
% Drawn Line Across Image...
%============================================
function LineCollect

global IMDIM
global IMINFO
global MOVEFUNCTION
global LINE
global LINEMARKHAND
global LINEMARKHAND2
global IMT
global SLCTIE
global CURFIG

test = get(gcf,'SelectionType');

if strcmp(test,'normal')
    [x,y] = PointsCollect;
    LINE(1).x = x;
    LINE(1).y = y;
    for r = 1:2    
        if isempty(IMT{r})
        else
            if ishandle(LINEMARKHAND(r,1)); delete(LINEMARKHAND(r,1)); end
            if ishandle(LINEMARKHAND(r,2)); delete(LINEMARKHAND(r,2)); end
            if ishandle(LINEMARKHAND(r,3)); delete(LINEMARKHAND(r,3)); end
            if ishandle(LINEMARKHAND(r,4)); delete(LINEMARKHAND(r,4)); end
            if ishandle(LINEMARKHAND2(r,1)); delete(LINEMARKHAND2(r,1)); end
            if ishandle(LINEMARKHAND2(r,2)); delete(LINEMARKHAND2(r,2)); end
            if ishandle(LINEMARKHAND2(r,3)); delete(LINEMARKHAND2(r,3)); end
            if ishandle(LINEMARKHAND2(r,4)); delete(LINEMARKHAND2(r,4)); end
        end
    end
    if SLCTIE == 1
        if CURFIG == 1
            IMDIM(2).slice = IMDIM(1).slice;
        elseif CURFIG == 2
            IMDIM(1).slice = IMDIM(2).slice;
        end
        %Plot_XY_Slice(1);
        %Plot_XY_Slice(2);
        Plot_XY_Slices;
        set(findobj('tag','slice_no1'),'string',num2str(IMDIM(1).slice));
        set(findobj('tag','slice_no2'),'string',num2str(IMDIM(1).slice));
    else
        Plot_XY_Slice(CURFIG);
        set(findobj('tag',['slice_no',num2str(CURFIG)]),'string',num2str(IMDIM(CURFIG).slice));
    end
    Plot_Line_Marker(x,y);
    Draw_All_ROIs;
    MOVEFUNCTION = 'LineFunc';
    Status('error','');
elseif strcmp(test,'alt')   
    if not(strcmp(MOVEFUNCTION,'LineFunc'))
        Status('error','Left-click to start line drawing');
        return
    end
    Status('error','');
    [x,y] = PointsCollect;
    LINE(2).x = x;
    LINE(2).y = y;
    Plot_Line_Marker2(x,y);
    MOVEFUNCTION = '';
    distpix = sqrt(((LINE(2).x - LINE(1).x)).^2 + ((LINE(2).y - LINE(1).y)).^2)
    distreal = sqrt(((LINE(2).x - LINE(1).x)*IMINFO(CURFIG).pixdim(2)).^2 + ((LINE(2).y - LINE(1).y)*IMINFO(CURFIG).pixdim(1)).^2)
    
end
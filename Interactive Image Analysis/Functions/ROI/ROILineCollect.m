%============================================
% Free hand drawn ROI
%============================================
function ROILineCollect

global IMDIM           
global MOVEFUNCTION
global XLOC                         
global YLOC
global LOCNUM
global XLOCARR
global YLOCARR
global ZLOCARR
global LOCCNT
global LINEHAND
global AX1
global AX2
global CURFIG

xlocarr = XLOCARR;
ylocarr = YLOCARR;
zlocarr = ZLOCARR;

test = get(gcf,'SelectionType');

if strcmp(test,'normal')
    if strcmp(MOVEFUNCTION,'buildroi');
        Status2('warn','Right click to finish the ROI',2);
        return;
    else
        XLOC = zeros(1,1000);               
        YLOC = zeros(1,1000);
        MOVEFUNCTION = 'buildroi';
        LOCCNT = 1;
        switch CURFIG
            case 1; axes = AX1;
            case 2; axes = AX2;
        end
        LINEHAND(CURFIG) = line([0 0],[0 0],'parent',axes,'color','r');
    end
elseif strcmp(test,'alt')   
    if isempty(MOVEFUNCTION)
        Status2('warn','Left click to start ROI',2);
        return
    end
    LOCNUM = LOCNUM + 1;    
    theta = atan((XLOC(2:LOCCNT-1)-XLOC(1:LOCCNT-2))./(YLOC(2:LOCCNT-1)-YLOC(1:LOCCNT-2)));
    theta((YLOC(2:LOCCNT-1)-YLOC(1:LOCCNT-2))<0) = theta((YLOC(2:LOCCNT-1)-YLOC(1:LOCCNT-2))<0)+pi;
    
    xlocarr(LOCNUM) = {[XLOC(1:LOCCNT-2)-0.5*cos(theta) flip(XLOC(1:LOCCNT-2)+0.5*cos(theta))]};           
    ylocarr(LOCNUM) = {[YLOC(1:LOCCNT-2)+0.5*sin(theta) flip(YLOC(1:LOCCNT-2)-0.5*sin(theta))]};               
    zlocarr(LOCNUM) = IMDIM(CURFIG).slice;        
    XLOC = zeros(1,1000);
    YLOC = zeros(1,1000);
    LOCCNT = 1;
    MOVEFUNCTION = '';
    Plot_XY_Slice(CURFIG);
    Draw_Current_ROI(xlocarr,ylocarr,zlocarr);
    valid = Compute_Current_ROI(xlocarr,ylocarr,zlocarr);
    if valid == 0
        Status('error','Region does not contain a voxel');
        Plot_XY_Slice(1);
        Plot_XY_Slice(2);
        Draw_All_ROIs;
    else   
        Status('error','');
        XLOCARR = xlocarr;
        YLOCARR = ylocarr;
        ZLOCARR = zlocarr;
    end
end
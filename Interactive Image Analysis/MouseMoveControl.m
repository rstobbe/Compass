%============================================
% What to do when mouse moved
%============================================
function MouseMoveControl(currentax,tab,axnum)

global IMAGEANLZ
global FIGOBJS
global TOTALGBL

%--------------------------------------------
% Update the panel value
%--------------------------------------------
pt = currentax.CurrentPoint;
x = pt(1,1);
y = pt(1,2);
if strcmp(IMAGEANLZ.(tab)(axnum).presentation,'Standard')
    CurrentPointUpdate(tab,axnum,x,y);
elseif strcmp(IMAGEANLZ.(tab)(axnum).presentation,'Ortho')
    CurrentPointUpdateOrtho(tab,axnum,x,y);
end

switch IMAGEANLZ.(tab)(axnum).movefunction 
    case 'UpdateOrthoSlices'
        DynamicOrthoReslice(tab,axnum,x,y)
    case 'DrawROI'
        DrawROI(tab,axnum,x,y);
    case 'DrawLine'
        DrawLine(tab,axnum,x,y);    
    
    %===============================================
    % Build ROI
    %===============================================        
    case 'buildsphere'
        if IMAGEANLZ.(tab)(axnum).ROITIE == 1
            start = 1;    
            stop = length(FIGOBJS.(tab).ImAxes);
        else
            start = axnum;
            stop = axnum;
        end
        centre = IMAGEANLZ.(tab)(axnum).ROIMAKE.centre;
        rad = sqrt((x-centre(1))^2 + (y-centre(2))^2);
        if (centre(1)-rad) >= SCALE.xmin && (centre(1)+rad) <= SCALE.xmax && (centre(2)+rad) >= SCALE.ymin && (centre(2)+rad) <= SCALE.ymax && ...
               (centre(3)-rad) >= 1 && (centre(3)+rad) <= TOTALGBL{2,FIGOBJS.(tab).ImAxes(axnum).UserData.totgblnum}.IMDISP.IMDIM.z2
            for axnum = start:stop
                circlen = 5*rad;
                if circlen < 20
                    circlen = 20;
                end
                theta = linspace(0,2*pi,circlen);
                for n = 1:length(theta)
                    XLOC(n) = centre(1)+rad*cos(theta(n));
                    YLOC(n) = centre(2)+rad*sin(theta(n));
                end
                if not(isempty(FIGOBJS.(tab).ImAxes(axnum).UserData))
                     if isfield(IMAGEANLZ.(tab)(axnum).ROIMAKE,'circle')
                        if ishghandle(IMAGEANLZ.(tab)(axnum).ROIMAKE.circle)
                            delete(IMAGEANLZ.(tab)(axnum).ROIMAKE.circle);
                        end
                    end
                    IMAGEANLZ.(tab)(axnum).ROIMAKE.circle = line(XLOC,YLOC,'parent',FIGOBJS.(tab).ImAxes(axnum),'color','r');
                    IMAGEANLZ.(tab)(axnum).ROIMAKE.circle.PickableParts = 'none';
                end
            end
        else
            set(gcf,'pointer','arrow');         
            for axnum = start:stop
                IMAGEANLZ.(tab)(axnum).MOVEFUNCTION = '';
                IMAGEANLZ.(tab)(axnum).XLOC = zeros(1,1000);
                IMAGEANLZ.(tab)(axnum).YLOC = zeros(1,1000);
                IMAGEANLZ.(tab)(axnum).LOCCNT = 1;
                if not(isempty(FIGOBJS.(tab).ImAxes(axnum).UserData))
                    ImagingPlot(tab,axnum,FIGOBJS.(tab).ImAxes(axnum).UserData.totgblnum);
                    if IMAGEANLZ.(tab)(axnum).SAVEDROISFLAG ~= 0
                        Draw_Saved_ROIs(tab,axnum);
                    end
                    if not(isempty(IMAGEANLZ.(tab)(axnum).XLOCARR{1}))
                        Draw_Current_ROI(tab,axnum,IMAGEANLZ.(tab)(axnum).XLOCARR,IMAGEANLZ.(tab)(axnum).YLOCARR,IMAGEANLZ.(tab)(axnum).ZLOCARR);
                    end
                end
            end
            FIGOBJS.Compass.WindowKeyPressFcn = @RWSUI_KeyPressControl;
            FIGOBJS.Compass.WindowKeyReleaseFcn = @RWSUI_KeyReleaseControl;        
            FIGOBJS.Compass.WindowScrollWheelFcn = @ScrollWheelControl;
            FIGOBJS.Compass.WindowButtonMotionFcn = @RWSUI_MouseMoveControl;
            Status2('info','Left click to select centre',3);
        end
      
end




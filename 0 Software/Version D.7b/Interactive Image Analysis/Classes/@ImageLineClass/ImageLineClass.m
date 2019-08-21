%================================================================
%  
%================================================================

classdef ImageLineClass < handle

    properties (SetAccess = private)                                                                             
        datapoint;
        state;
        linehandle;
        contextmenu;
        pointer,status,info;
        length, angle;
        baseorient;
        draworient;
    end
    
%==================================================================
% Init
%==================================================================       
    methods
        % ImageLineClass
        function IMAGELINE = ImageLineClass(IMAGEANLZ)
            IMAGELINE.baseorient = IMAGEANLZ.GetBaseOrient([]);
            IMAGELINE.draworient = IMAGEANLZ.ORIENT;
            IMAGELINE.datapoint = struct();                      
            IMAGELINE.state = 'Start';
            IMAGELINE.linehandle = gobjects(0); 
            IMAGELINE.contextmenu = gobjects(0); 
            IMAGELINE.pointer = 'crosshair';
            IMAGELINE.status = 'Line Tool Active';
            IMAGELINE.info = 'Left click to start';
            IMAGELINE.length = [];
            IMAGELINE.angle = [];
        end
        % Initialize
        function Initialize(IMAGELINE)
            IMAGELINE.state = 'Start';
            if not(isempty(IMAGELINE.linehandle))
                delete(IMAGELINE.linehandle);
            end
            IMAGELINE.linehandle = gobjects(0);
            IMAGELINE.contextmenu = gobjects(0);
            IMAGELINE.datapoint = struct(); 
            IMAGELINE.status = 'Line Tool Active';
            IMAGELINE.info = 'Left click to draw';
            IMAGELINE.length = [];
            IMAGELINE.angle = [];
        end
        
%==================================================================
% Creation Info
%==================================================================          
        % GetPointer
        function pointer = GetPointer(IMAGELINE)
            pointer = IMAGELINE.pointer;
        end
        % GetStatus
        function status = GetStatus(IMAGELINE)
            status = IMAGELINE.status;
        end
        % GetInfo
        function info = GetInfo(IMAGELINE)
            info = IMAGELINE.info;
        end

%==================================================================
% Update
%==================================================================          
        % SetDrawOrientation
        function SetDrawOrientation(IMAGELINE,drawroiorient)
            IMAGELINE.drawroiorient = drawroiorient;
        end

%==================================================================
% Build Line
%==================================================================          
        % BuildLine
        function OUT = BuildLine(IMAGELINE,datapoint,event)
            if event.Button == 1 
                IMAGELINE.Initialize;
                IMAGELINE.datapoint = datapoint;
                OUT.info = 'Right click to finish';
                OUT.buttonfunc = 'draw';
                IMAGELINE.state = 'Drawing';
            elseif event.Button == 2
                OUT.buttonfunc = 'return';
            elseif event.Button == 3 && strcmp(IMAGELINE.state,'Start')
                OUT.buttonfunc = 'return';
            elseif event.Button == 3 && strcmp(IMAGELINE.state,'Drawing')
                if not(isempty(IMAGELINE.linehandle))
                    delete(IMAGELINE.linehandle);
                end
                OUT.info = IMAGELINE.info;
                OUT.buttonfunc = 'updatefinish';
            end   
        end
  
%==================================================================
% Draw Line
%==================================================================          
        % RecordLineInfo
        function RecordLineInfo(IMAGELINE,datapoint) 
            IMAGELINE.datapoint(2) = datapoint;
            xloc = [IMAGELINE.datapoint(1).xloc IMAGELINE.datapoint(2).xloc];
            yloc = [IMAGELINE.datapoint(1).yloc IMAGELINE.datapoint(2).yloc];
            IMAGELINE.length = sqrt((xloc(2)-xloc(1))^2 + (yloc(2)-yloc(1))^2);
            IMAGELINE.angle = 180*asin(abs(yloc(2)-yloc(1))/IMAGELINE.length)/pi;
            if xloc(2) > xloc(1)
                if yloc(2) > yloc(1)
                    IMAGELINE.angle = -IMAGELINE.angle;
                end
            else
                if yloc(1) > yloc(2)
                    IMAGELINE.angle = -IMAGELINE.angle;
                end
            end            
        end
        % DrawLine
        function DrawLine(IMAGELINE,axhand,clr) 
            xpt = [IMAGELINE.datapoint(1).xpt IMAGELINE.datapoint(2).xpt];
            ypt = [IMAGELINE.datapoint(1).ypt IMAGELINE.datapoint(2).ypt];
            if not(isempty(IMAGELINE.linehandle))
                delete(IMAGELINE.linehandle);
            end
            IMAGELINE.linehandle = line(xpt,ypt,'Parent',axhand,'Color',clr,'Interruptible','off');
            IMAGELINE.linehandle.PickableParts = 'none';           
%             IMAGELINE.contextmenu = uicontextmenu;
%             %IMAGELINE.contextmenu.Tag = IMAGEANLZ.tab;
%             IMAGELINE.linehandle.UIContextMenu = IMAGELINE.contextmenu;
%             uimenu(IMAGELINE.contextmenu,'Label','asdf');
        end
        % DrawError
        function DrawError(IMAGELINE)
            if not(isempty(IMAGELINE.linehandle))
                delete(IMAGELINE.linehandle);
            end
            IMAGELINE.Initialize;
        end
        % DeleteGraphicObjects
        function DeleteGraphicObjects(IMAGELINE)
            delete(IMAGELINE.linehandles);
        end
        
%==================================================================
% Load/Delete ROIs
%==================================================================        

    end

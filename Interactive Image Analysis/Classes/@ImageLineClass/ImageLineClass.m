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
        lengthIP, lengthTot, anglePol, angleAzi;
        baseorient;
        draworient;
    end
    
%==================================================================
% Init
%==================================================================       
    methods
        % ImageLineClass
        function IMAGELINE = ImageLineClass(IMAGEANLZ)
            %IMAGELINE.baseorient = IMAGEANLZ.GetBaseOrient([]);
            %IMAGELINE.draworient = IMAGEANLZ.ORIENT;
            IMAGELINE.baseorient = '';
            IMAGELINE.draworient = '';
            IMAGELINE.datapoint = struct();                      
            IMAGELINE.state = 'Start';
            IMAGELINE.linehandle = gobjects(0); 
            IMAGELINE.contextmenu = gobjects(0); 
            IMAGELINE.pointer = 'crosshair';
            IMAGELINE.status = 'Line Tool Active';
            IMAGELINE.info = 'Left click to start';
            IMAGELINE.lengthIP = [];
            IMAGELINE.anglePol = [];
            IMAGELINE.lengthTot = [];
            IMAGELINE.angleAzi = [];
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
            IMAGELINE.lengthIP = [];
            IMAGELINE.anglePol = [];
            IMAGELINE.lengthTot = [];
            IMAGELINE.angleAzi = [];
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
            if event.Button == 1 && strcmp(IMAGELINE.state,'Start') 
                IMAGELINE.Initialize;
                IMAGELINE.datapoint = datapoint;
                OUT.info = 'Right click to finish';
                OUT.buttonfunc = 'draw';
                IMAGELINE.state = 'Drawing';
            elseif event.Button == 1 && strcmp(IMAGELINE.state,'Drawing') 
                OUT.info = '';
                OUT.buttonfunc = 'endtool';
            elseif event.Button == 2
                OUT.buttonfunc = 'return';
            elseif event.Button == 3 && strcmp(IMAGELINE.state,'Start')
                OUT.info = '';
                OUT.buttonfunc = 'endtool';
            elseif event.Button == 3 && strcmp(IMAGELINE.state,'Drawing')
                if not(isempty(IMAGELINE.linehandle))
                    delete(IMAGELINE.linehandle);
                end
                OUT.info = IMAGELINE.info;
                OUT.buttonfunc = 'updatefinish';
                IMAGELINE.state = 'Start';
            end   
        end

%==================================================================
% AssignDataPoint
%==================================================================          
        % AssignDataPoint
        function AssignDataPoint(IMAGELINE,datapoint)
            IMAGELINE.datapoint = datapoint;  
        end        
        
%==================================================================
% Draw Line
%==================================================================          
        % RecordLineInfo
        function RecordLineInfo(IMAGELINE,datapoint) 
            IMAGELINE.datapoint(2) = datapoint;
            xloc = [IMAGELINE.datapoint(1).xloc IMAGELINE.datapoint(2).xloc];
            yloc = [IMAGELINE.datapoint(1).yloc IMAGELINE.datapoint(2).yloc];
            zloc = [IMAGELINE.datapoint(1).zloc IMAGELINE.datapoint(2).zloc];
            IMAGELINE.lengthIP = sqrt((xloc(2)-xloc(1))^2 + (yloc(2)-yloc(1))^2);
            lengthHzP = sqrt((xloc(2)-xloc(1))^2 + (zloc(2)-zloc(1))^2);
            IMAGELINE.lengthTot = sqrt((xloc(2)-xloc(1))^2 + (yloc(2)-yloc(1))^2 + (zloc(2)-zloc(1))^2);
            IMAGELINE.anglePol = 180*asin(abs(yloc(2)-yloc(1))/IMAGELINE.lengthIP)/pi;
            IMAGELINE.angleAzi = 180*asin(abs(zloc(2)-zloc(1))/lengthHzP)/pi;
            if xloc(2) > xloc(1)
                if yloc(2) > yloc(1)
                    IMAGELINE.anglePol = -IMAGELINE.anglePol;
                end
            else
                if yloc(1) > yloc(2)
                    IMAGELINE.anglePol = -IMAGELINE.anglePol;
                end
            end
            if zloc(2) > zloc(1)
                if xloc(1) > xloc(2)
                    IMAGELINE.angleAzi = -IMAGELINE.angleAzi;
                end
            else
                if xloc(2) > xloc(1)
                    IMAGELINE.angleAzi = -IMAGELINE.angleAzi;
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
            delete(IMAGELINE.linehandle);
        end
        
%==================================================================
% Other
%==================================================================        
        % CopyLineInfo
        function CopyLineInfo(IMAGELINE,CURRENTLINE)
            IMAGELINE.baseorient = CURRENTLINE.baseorient;
            IMAGELINE.draworient = CURRENTLINE.draworient;
            IMAGELINE.datapoint = CURRENTLINE.datapoint;                      
            IMAGELINE.lengthIP = CURRENTLINE.lengthIP;
            IMAGELINE.anglePol = CURRENTLINE.anglePol;
            IMAGELINE.lengthTot = CURRENTLINE.lengthTot;
            IMAGELINE.angleAzi = CURRENTLINE.angleAzi;
        end
        % TestLineInSlice
        function bool = TestLineInSlice(IMAGELINE,Slice)
            bool = 0;
            if Slice >= IMAGELINE.datapoint(1).zpt && Slice <= IMAGELINE.datapoint(2).zpt
                bool = 1;
            elseif Slice <= IMAGELINE.datapoint(1).zpt && Slice >= IMAGELINE.datapoint(2).zpt
                bool = 1;
            end
        end   
        % TestSavedLine
        function bool = TestSavedLine(IMAGELINE)
            bool = 1;
            if isempty(IMAGELINE.lengthIP)
                bool = 0;
            end
        end 
    end
end

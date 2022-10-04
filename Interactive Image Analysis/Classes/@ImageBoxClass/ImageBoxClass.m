%================================================================
%  
%================================================================

classdef ImageBoxClass < handle

    properties (SetAccess = private)                                                                             
        datapoint;
        state;
        boxhandle;
        contextmenu;
        pointer,status,info;
        length, height, insetH, insetV;
        baseorient;
        draworient;
        imagesz;
    end
    
%==================================================================
% Init
%==================================================================       
    methods
        % ImageBoxClass
        function IMAGEBOX = ImageBoxClass(IMAGEANLZ,sz)
            %IMAGEBOX.baseorient = IMAGEANLZ.GetBaseOrient([]);
            %IMAGEBOX.draworient = IMAGEANLZ.ORIENT;
            IMAGEBOX.baseorient = '';
            IMAGEBOX.draworient = '';
            IMAGEBOX.datapoint = struct();                      
            IMAGEBOX.state = 'Start';
            IMAGEBOX.boxhandle = gobjects(0); 
            IMAGEBOX.contextmenu = gobjects(0); 
            IMAGEBOX.pointer = 'crosshair';
            IMAGEBOX.status = 'Box Tool Active';
            IMAGEBOX.info = 'Left click to start';
            IMAGEBOX.length = [];
            IMAGEBOX.insetH = [];
            IMAGEBOX.height = [];
            IMAGEBOX.insetV = [];
            IMAGEBOX.imagesz = sz;
        end
        % Initialize
        function Initialize(IMAGEBOX)
            IMAGEBOX.state = 'Start';
            if not(isempty(IMAGEBOX.boxhandle))
                delete(IMAGEBOX.boxhandle);
            end
            IMAGEBOX.boxhandle = gobjects(0);
            IMAGEBOX.contextmenu = gobjects(0);
            IMAGEBOX.datapoint = struct(); 
            IMAGEBOX.status = 'Box Tool Active';
            IMAGEBOX.info = 'Left click to draw';
            IMAGEBOX.length = [];
            IMAGEBOX.insetH = [];
            IMAGEBOX.height = [];
            IMAGEBOX.insetV = [];
        end
        
%==================================================================
% Creation Info
%==================================================================          
        % GetPointer
        function pointer = GetPointer(IMAGEBOX)
            pointer = IMAGEBOX.pointer;
        end
        % GetStatus
        function status = GetStatus(IMAGEBOX)
            status = IMAGEBOX.status;
        end
        % GetInfo
        function info = GetInfo(IMAGEBOX)
            info = IMAGEBOX.info;
        end

%==================================================================
% Update
%==================================================================          
        % SetDrawOrientation
        function SetDrawOrientation(IMAGEBOX,drawroiorient)
            IMAGEBOX.drawroiorient = drawroiorient;
        end

%==================================================================
% Build Box
%==================================================================          
        % BuildBox
        function OUT = BuildBox(IMAGEBOX,datapoint,event)
            if event.Button == 1 && strcmp(IMAGEBOX.state,'Start') 
                IMAGEBOX.Initialize;
                IMAGEBOX.datapoint = datapoint;
                OUT.info = 'Right click to finish';
                OUT.buttonfunc = 'draw';
                IMAGEBOX.state = 'Drawing';
            elseif event.Button == 1 && strcmp(IMAGEBOX.state,'Drawing') 
                IMAGEBOX.Initialize;
                IMAGEBOX.datapoint = datapoint;
                OUT.info = 'Right click to finish';
                OUT.buttonfunc = 'draw';
                IMAGEBOX.state = 'Drawing';
            elseif event.Button == 2
                OUT.buttonfunc = 'return';
            elseif event.Button == 3 && strcmp(IMAGEBOX.state,'Start')
                OUT.info = '';
                OUT.buttonfunc = 'endtool';
            elseif event.Button == 3 && strcmp(IMAGEBOX.state,'Drawing')
                if not(isempty(IMAGEBOX.boxhandle))
                    delete(IMAGEBOX.boxhandle);
                end
                OUT.info = IMAGEBOX.info;
                OUT.buttonfunc = 'updatefinish';
                IMAGEBOX.state = 'Start';
            end   
        end

%==================================================================
% AssignDataPoint
%==================================================================          
        % AssignDataPoint
        function AssignDataPoint(IMAGEBOX,datapoint)
            IMAGEBOX.datapoint = datapoint;  
        end        
        
%==================================================================
% Draw Box
%==================================================================          
        % RecordBoxInfo
        function RecordBoxInfo(IMAGEBOX,datapoint) 
            IMAGEBOX.datapoint(2) = datapoint;
            IMAGEBOX.length = abs(IMAGEBOX.datapoint(2).xloc - IMAGEBOX.datapoint(1).xloc);
            IMAGEBOX.height = abs(IMAGEBOX.datapoint(2).yloc - IMAGEBOX.datapoint(1).yloc);  
            IMAGEBOX.insetH(1) = round(IMAGEBOX.datapoint(1).xpt - 1);
            IMAGEBOX.insetH(2) = round(IMAGEBOX.imagesz(2) - IMAGEBOX.datapoint(2).xpt);
            IMAGEBOX.insetV(1) = round(IMAGEBOX.datapoint(1).ypt - 1);
            IMAGEBOX.insetV(2) = round(IMAGEBOX.imagesz(1) - IMAGEBOX.datapoint(2).ypt);
        end
        % DrawBox
        function DrawBox(IMAGEBOX,axhand,clr) 
            xpt = [IMAGEBOX.datapoint(1).xpt IMAGEBOX.datapoint(1).xpt IMAGEBOX.datapoint(2).xpt IMAGEBOX.datapoint(2).xpt IMAGEBOX.datapoint(1).xpt];
            ypt = [IMAGEBOX.datapoint(1).ypt IMAGEBOX.datapoint(2).ypt IMAGEBOX.datapoint(2).ypt IMAGEBOX.datapoint(1).ypt IMAGEBOX.datapoint(1).ypt];
            if not(isempty(IMAGEBOX.boxhandle))
                delete(IMAGEBOX.boxhandle);
            end
            IMAGEBOX.boxhandle = line(xpt,ypt,'Parent',axhand,'Color',clr,'Interruptible','off');
            IMAGEBOX.boxhandle.PickableParts = 'none';           
        end
        % DrawError
        function DrawError(IMAGEBOX)
            if not(isempty(IMAGEBOX.boxhandle))
                delete(IMAGEBOX.boxhandle);
            end
            IMAGEBOX.Initialize;
        end
        % DeleteGraphicObjects
        function DeleteGraphicObjects(IMAGEBOX)
            delete(IMAGEBOX.boxhandle);
        end
        
%==================================================================
% Other
%==================================================================        
        % CopyBoxInfo
        function CopyBoxInfo(IMAGEBOX,CURRENTBOX)
            IMAGEBOX.baseorient = CURRENTBOX.baseorient;
            IMAGEBOX.draworient = CURRENTBOX.draworient;
            IMAGEBOX.datapoint = CURRENTBOX.datapoint;                      
            IMAGEBOX.length = CURRENTBOX.length;
            IMAGEBOX.insetH = CURRENTBOX.insetH;
            IMAGEBOX.height = CURRENTBOX.height;
            IMAGEBOX.insetV = CURRENTBOX.insetV;
        end
        % TestBoxInSlice
        function bool = TestBoxInSlice(IMAGEBOX,Slice)
            bool = 0;
            if Slice >= IMAGEBOX.datapoint(1).zpt && Slice <= IMAGEBOX.datapoint(2).zpt
                bool = 1;
            elseif Slice <= IMAGEBOX.datapoint(1).zpt && Slice >= IMAGEBOX.datapoint(2).zpt
                bool = 1;
            end
        end        
    end
end

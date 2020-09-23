%================================================================
%  
%================================================================

classdef RoiFreeHandClass < handle

    properties (SetAccess = private)
        xloc,yloc,zloc;
        linecnt;
        linehandle;
        state;
        panelobs;
        roicreatesel;
        pointer,status,info;
    end
    
    methods
        function DAT = RoiFreeHandClass
            DAT.state = 'Start';  
            DAT.xloc = []; DAT.yloc = []; DAT.zloc = [];
            DAT.panelobs = gobjects(0);
            DAT.roicreatesel = 1;
            DAT.linecnt = 0;
            DAT.linehandle = gobjects(0); 
            DAT.pointer = 'crosshair';
            DAT.status = 'FreeHand Drawing Tool Active';
            DAT.info = 'Left click to draw';
        end
        function Setup(DAT,IMAGEANLZ)
            DAT.status = 'FreeHand Drawing Tool Active';
            DAT.info = 'Left click to draw';
        end
        function Initialize(DAT)
            DAT.state = 'Start';
            DAT.linecnt = 0;
            if not(isempty(DAT.linehandle))
                delete(DAT.linehandle);
            end
            DAT.linehandle = gobjects(0);
            DAT.xloc = []; DAT.yloc = []; DAT.zloc = [];
            DAT.status = 'FreeHand Drawing Tool Active';
            DAT.info = 'Left click to draw';
        end
        function ResetPanel(DAT) 
        end
        function Reset(DAT)
            DAT.Initialize;
            DAT.ResetPanel;
        end
        function Copy(DAT,DAT2) 
        end
        function bool = TestActive(DAT)
            bool = 1;
            if strcmp(DAT.state,'Start')
                bool = 0;
            end
        end
        function SetValue(DAT,Value)
            % dummy (used elsewhere)
        end
        function OUT = BuildROI(DAT,datapoint,event,ImageSlice) 
            if event.Button == 1 && strcmp(DAT.state,'Start') 
                DAT.linecnt = 1;
                DAT.xloc(DAT.linecnt) = datapoint(1);
                DAT.yloc(DAT.linecnt) = datapoint(2);
                DAT.zloc = datapoint(3);
                OUT.info = 'Right click to finish';
                OUT.buttonfunc = 'draw';
                DAT.state = 'Drawing';
            elseif event.Button == 1 && strcmp(DAT.state,'Drawing')
                OUT.buttonfunc = 'return';
            elseif event.Button == 2
                OUT.buttonfunc = 'return';
            elseif event.Button == 3 && strcmp(DAT.state,'Start')
                OUT.buttonfunc = 'return';
            elseif event.Button == 3 && strcmp(DAT.state,'Drawing')
                if not(isempty(DAT.linehandle))
                    delete(DAT.linehandle);
                end
                OUT.xloc{1} = [DAT.xloc DAT.xloc(1)]; OUT.yloc{1} = [DAT.yloc DAT.yloc(1)]; OUT.zloc{1} = DAT.zloc;
                DAT.Initialize;
                OUT.info = DAT.info;
                OUT.buttonfunc = 'updatefinish';
            end   
        end
        function DrawLine(DAT,datapoint,axhand,clr) 
            DAT.linecnt = DAT.linecnt+1;
            DAT.xloc(DAT.linecnt) = datapoint(1);
            DAT.yloc(DAT.linecnt) = datapoint(2);
            if not(isempty(DAT.linehandle))
                delete(DAT.linehandle);
            end
            DAT.linehandle = line(DAT.xloc,DAT.yloc,'Parent',axhand,'Color',clr,'Interruptible','off');
            DAT.linehandle.PickableParts = 'none';
        end
        function DrawError(DAT) 
            if not(isempty(DAT.linehandle))
                delete(DAT.linehandle);
            end
            DAT.Initialize;
        end   
    end
end
        
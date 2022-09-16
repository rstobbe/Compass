%================================================================
%  
%================================================================

classdef RoiRectClass < handle

    properties (SetAccess = private)
        rad1,rad2,tubelen,centre1,centre2,extend; 
        userad1,userad2,usecen1,usecen2;
        xloc1,yloc1,zloc1;
        xloc2,yloc2,zloc2;
        state;
        panelobs;
        roicreatesel;
        pointer,status,info;
    end 
    methods
        function DAT = RoiRectClass
            DAT.rad1 = 10; DAT.rad2 = 10;
            DAT.userad1 = 1; DAT.userad2 = 1; 
            DAT.tubelen = 0; DAT.extend = 0;
            DAT.centre1 = [0 0 0]; DAT.centre2 = [0 0 0];
            DAT.usecen1 = 0; DAT.usecen2 = 0;
            DAT.state = 'Start';  
            DAT.xloc1 = []; DAT.yloc1 = []; DAT.zloc1 = [];
            DAT.xloc2 = []; DAT.yloc1 = []; DAT.zloc1 = [];
            DAT.panelobs = gobjects(0);
            DAT.roicreatesel = 6;
            DAT.pointer = 'crosshair';
            DAT.status = 'Rectangle Drawing Tool Active';
            DAT.info = 'Left click to start';
        end
        function Setup(DAT,IMAGEANLZ)
            DAT.pointer = 'crosshair';            
            DAT.status = 'Rectangle Drawing Tool Active';
            DAT.info = 'Left click to start';
        end
        function Initialize(DAT)
            DAT.state = 'Start';
            DAT.xloc1 = []; DAT.yloc1 = []; DAT.zloc1 = [];
            DAT.xloc2 = []; DAT.yloc2 = []; DAT.zloc2 = [];
            DAT.status = 'Tube Drawing Tool Active';
            DAT.info = 'Left click to start';
        end
        function Copy(DAT,DAT2)
            DAT.centre1 = DAT2.centre1;
            DAT.centre2 = DAT2.centre2;
            DAT.rad1 = DAT2.rad1;
            DAT.rad2 = DAT2.rad2;
            DAT.extend = DAT2.extend;
            DAT.tubelen = DAT2.tubelen;
        end
        function ResetPanel(DAT) 
            drawnow;
        end
        function Reset(DAT)
            DAT.Initialize;
            DAT.ResetPanel;
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
            if event.Button == 1
                if strcmp(DAT.state,'Start')
                    DAT.state = 'Point2';
                    DAT.xloc1(1) = datapoint(1); 
                    DAT.yloc1(1) = datapoint(2); 
                    DAT.zloc1(1) = datapoint(3); 
                    OUT.buttonfunc = 'updateregion';
                    OUT.info = 'Click second point';
                elseif strcmp(DAT.state,'Point2')
                    DAT.state = 'Point3';
                    DAT.xloc1(2) = datapoint(1); 
                    DAT.yloc1(2) = datapoint(2); 
                    DAT.zloc1(2) = datapoint(3); 
                    OUT.buttonfunc = 'updateregion';
                    OUT.info = 'Click third pointt';
                elseif strcmp(DAT.state,'Point3') || strcmp(DAT.state,'Point3b')
                    DAT.state = 'Point3b';
                    DAT.xloc1(3) = datapoint(1); 
                    DAT.yloc1(3) = datapoint(2); 
                    DAT.zloc1(3) = datapoint(3); 
                    OUT.buttonfunc = 'updateregion';
                    OUT.info = 'Right click to finish';
                end 
                OUT.xloc{1} = DAT.xloc1; OUT.yloc{1} = DAT.yloc1; OUT.zloc{1} = DAT.zloc1;
                OUT.clr = [0.9 0.6 0.6];
            elseif event.Button == 3
                if strcmp(DAT.state,'Start') || strcmp(DAT.state,'Point2') || strcmp(DAT.state,'Point3')
                    OUT.buttonfunc = 'return';
                    return
                end
                DAT.xloc1(4) = DAT.xloc1(1) + DAT.xloc1(3) - DAT.xloc1(2); 
                DAT.yloc1(4) = DAT.yloc1(1) + DAT.yloc1(3) - DAT.yloc1(2); 
                DAT.zloc1(4) = DAT.zloc1(1);
                DAT.xloc1(5) = DAT.xloc1(1); 
                DAT.yloc1(5) = DAT.yloc1(1); 
                DAT.zloc1(5) = DAT.zloc1(1); 
                OUT.clr = [0.8 0.3 0.3];
                OUT.xloc{1} = DAT.xloc1; OUT.yloc{1} = DAT.yloc1; OUT.zloc{1} = DAT.zloc1;
                DAT.xloc1 = []; DAT.yloc1 = []; DAT.zloc1 = [];
                DAT.xloc2 = []; DAT.yloc2 = []; DAT.zloc2 = [];
                OUT.buttonfunc = 'updatefinish';
                OUT.info = 'Left click to start';
                DAT.state = 'Start';
            end
        end
    end
end    
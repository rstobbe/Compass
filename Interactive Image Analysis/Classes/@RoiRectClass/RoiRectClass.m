%================================================================
%  
%================================================================

classdef RoiRectClass < handle

    properties (SetAccess = private)
        wid; 
        xloc,yloc,zloc;
        state;
        panelobs;
        roicreatesel;
        pointer,status,info;
    end 
    methods
        function DAT = RoiRectClass
            DAT.wid = 4; 
            DAT.state = 'Start';  
            DAT.xloc = []; DAT.yloc = []; DAT.zloc = [];
            DAT.panelobs = gobjects(0);
            DAT.roicreatesel = 6;
            DAT.pointer = 'crosshair';
            DAT.status = 'Rectangle Drawing Tool Active';
            DAT.info = 'Left click to start';
        end
        function Setup(DAT,IMAGEANLZ)
            top = 69;
            horz = 180;
            DAT.panelobs = uicontrol('Parent',IMAGEANLZ.FIGOBJS.ROITab,'Style','text','BackgroundColor',IMAGEANLZ.FIGOBJS.Colours.BGcolour,'Tag',num2str(IMAGEANLZ.axnum),'ForegroundColor',[0.8 0.8 0.8],'String','Width (pixels)','HorizontalAlignment','right','Fontsize',7,'Position',[horz+200 top-15 80 15],'Enable','inactive','ButtonDownFcn',@ResetFocus);
            DAT.panelobs(2) = uicontrol('Parent',IMAGEANLZ.FIGOBJS.ROITab,'Style','edit','BackgroundColor',IMAGEANLZ.FIGOBJS.Colours.BGcolour,'Tag',num2str(IMAGEANLZ.axnum),'ForegroundColor',[0.8 0.8 0.8],'String',num2str(DAT.wid),'HorizontalAlignment','left','Fontsize',6,'Position',[horz+290 top-13 30 15],'CallBack',@DAT.SetWid);    
            DAT.pointer = 'crosshair';            
            DAT.status = 'Rectangle Drawing Tool Active';
            DAT.info = 'Left click to start';
        end
        function Initialize(DAT)
            DAT.state = 'Start';
            DAT.xloc = []; DAT.yloc = []; DAT.zloc = [];
            DAT.status = 'Tube Drawing Tool Active';
            DAT.info = 'Left click to start';
        end
        function Copy(DAT,DAT2)
            DAT.wid = DAT2.wid;
        end
        function DAT = SetWid(DAT,src,event)
            DAT.wid = str2double(src.String);
            ResetFocus(src,event);
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
                    DAT.xloc(1) = datapoint(1); 
                    DAT.yloc(1) = datapoint(2); 
                    DAT.zloc(1) = datapoint(3); 
                    OUT.buttonfunc = 'startline';
                    OUT.info = 'Rigth click second point';
                    OUT.datapoint = datapoint;
                    OUT.xloc{1} = DAT.xloc; OUT.yloc{1} = DAT.yloc; OUT.zloc{1} = DAT.zloc;
                elseif strcmp(DAT.state,'Point2')
                    DAT.state = 'Point2';
                    DAT.xloc(1) = datapoint(1); 
                    DAT.yloc(1) = datapoint(2); 
                    DAT.zloc(1) = datapoint(3); 
                    OUT.buttonfunc = 'restartline';
                    OUT.info = 'Rigth click second point';
                    OUT.datapoint = datapoint;
                    OUT.xloc{1} = DAT.xloc; OUT.yloc{1} = DAT.yloc; OUT.zloc{1} = DAT.zloc;
                end 
            elseif event.Button == 3
                if strcmp(DAT.state,'Start')
                    OUT.buttonfunc = 'return';
                    return
                end     
                DAT.xloc(2) = datapoint(1);
                DAT.yloc(2) = datapoint(2); 
                Len = sqrt((DAT.xloc(2)-DAT.xloc(1)).^2 + (DAT.yloc(2)-DAT.yloc(1)).^2);
                if DAT.xloc(2) > DAT.xloc(1)
                    angle = asin((DAT.yloc(1)-DAT.yloc(2))/Len);
                else
                	angle = asin((DAT.yloc(2)-DAT.yloc(1))/Len);
                end
                Ayloc(1) = DAT.yloc(1) - cos(angle)*DAT.wid/2;
                Ayloc(2) = DAT.yloc(1) + cos(angle)*DAT.wid/2;
                Axloc(1) = DAT.xloc(1) - sin(angle)*DAT.wid/2;
                Axloc(2) = DAT.xloc(1) + sin(angle)*DAT.wid/2;
                Ayloc(3) = DAT.yloc(2) + cos(angle)*DAT.wid/2;
                Ayloc(4) = DAT.yloc(2) - cos(angle)*DAT.wid/2;
                Axloc(3) = DAT.xloc(2) + sin(angle)*DAT.wid/2;
                Axloc(4) = DAT.xloc(2) - sin(angle)*DAT.wid/2;
                Ayloc(5) = Ayloc(1);
                Axloc(5) = Axloc(1);
                Azloc(1:5) = DAT.zloc;
                OUT.clr = [0.8 0.3 0.3];
                OUT.xloc{1} = Axloc; OUT.yloc{1} = Ayloc; OUT.zloc{1} = Azloc;
                DAT.xloc = []; DAT.yloc = []; DAT.zloc = [];
                OUT.buttonfunc = 'updatefinish';
                OUT.info = 'Left click to start';
                DAT.state = 'Start';
            end
        end
    end
end    
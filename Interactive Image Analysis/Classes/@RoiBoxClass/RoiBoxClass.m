%================================================================
%  
%================================================================

classdef RoiBoxClass < handle

    properties (SetAccess = private)
        wid; 
        xloc,yloc,zloc;
        Axloc,Ayloc,Azloc;
        state;
        panelobs;
        roicreatesel;
        pointer,status,info;
    end 
    methods
        function DAT = RoiBoxClass
            DAT.wid = 4; 
            DAT.state = 'Start';  
            DAT.xloc = []; DAT.yloc = []; DAT.zloc = [];
            DAT.Axloc = []; DAT.Ayloc = []; DAT.Azloc = [];
            DAT.panelobs = gobjects(0);
            DAT.roicreatesel = 7;
            DAT.pointer = 'crosshair';
            DAT.status = 'Box Drawing Tool Active';
            DAT.info = 'Left click to start';
        end
        function Setup(DAT,IMAGEANLZ)
            top = 69;
            horz = 180;
            DAT.panelobs = uicontrol('Parent',IMAGEANLZ.FIGOBJS.ROITab,'Style','text','BackgroundColor',IMAGEANLZ.FIGOBJS.Colours.BGcolour,'Tag',num2str(IMAGEANLZ.axnum),'ForegroundColor',[0.8 0.8 0.8],'String','Depth (pixels)','HorizontalAlignment','right','Fontsize',7,'Position',[horz+180 top-30 80 15],'Enable','inactive','ButtonDownFcn',@ResetFocus);
            DAT.panelobs(2) = uicontrol('Parent',IMAGEANLZ.FIGOBJS.ROITab,'Style','edit','BackgroundColor',IMAGEANLZ.FIGOBJS.Colours.BGcolour,'Tag',num2str(IMAGEANLZ.axnum),'ForegroundColor',[0.8 0.8 0.8],'String',num2str(DAT.wid),'HorizontalAlignment','left','Fontsize',6,'Position',[horz+270 top-28 30 15],'CallBack',@DAT.SetWid);    
            DAT.panelobs(3) = uicontrol('Parent',IMAGEANLZ.FIGOBJS.ROITab,'Style','text','BackgroundColor',IMAGEANLZ.FIGOBJS.Colours.BGcolour,'Tag',num2str(IMAGEANLZ.axnum),'ForegroundColor',[0.8 0.8 0.8],'String','Width (pixels)','HorizontalAlignment','right','Fontsize',7,'Position',[horz+300 top-30 80 15],'Enable','inactive','ButtonDownFcn',@ResetFocus);
            DAT.panelobs(4) = uicontrol('Parent',IMAGEANLZ.FIGOBJS.ROITab,'Style','edit','BackgroundColor',IMAGEANLZ.FIGOBJS.Colours.BGcolour,'Tag',num2str(IMAGEANLZ.axnum),'ForegroundColor',[0.8 0.8 0.8],'String','','HorizontalAlignment','left','Fontsize',6,'Position',[horz+390 top-28 30 15],'Enable','inactive','ButtonDownFcn',@ResetFocus); 
            DAT.panelobs(5) = uicontrol('Parent',IMAGEANLZ.FIGOBJS.ROITab,'Style','text','BackgroundColor',IMAGEANLZ.FIGOBJS.Colours.BGcolour,'Tag',num2str(IMAGEANLZ.axnum),'ForegroundColor',[0.8 0.8 0.8],'String','Length (pixels)','HorizontalAlignment','right','Fontsize',7,'Position',[horz+420 top-30 80 15],'Enable','inactive','ButtonDownFcn',@ResetFocus);
            DAT.panelobs(6) = uicontrol('Parent',IMAGEANLZ.FIGOBJS.ROITab,'Style','edit','BackgroundColor',IMAGEANLZ.FIGOBJS.Colours.BGcolour,'Tag',num2str(IMAGEANLZ.axnum),'ForegroundColor',[0.8 0.8 0.8],'String','','HorizontalAlignment','left','Fontsize',6,'Position',[horz+510 top-28 30 15],'Enable','inactive','ButtonDownFcn',@ResetFocus); 
            DAT.pointer = 'crosshair';            
            DAT.status = 'Box Drawing Tool Active';
            DAT.info = 'Left click to start';
            DAT.roicreatesel = 7;
        end
        function Initialize(DAT)
            DAT.state = 'Start';
            DAT.xloc = []; DAT.yloc = []; DAT.zloc = [];
            DAT.Axloc = []; DAT.Ayloc = []; DAT.Azloc = [];
            DAT.status = 'Box Drawing Tool Active';
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
                elseif strcmp(DAT.state,'Start2')
                    DAT.state = 'Point22';
                    DAT.xloc(1) = datapoint(1); 
                    DAT.yloc(1) = datapoint(2); 
                    DAT.zloc(1) = datapoint(3); 
                    OUT.buttonfunc = 'startline';
                    OUT.info = 'Rigth click second point';
                    OUT.datapoint = datapoint;
                    OUT.xloc{1} = DAT.xloc; OUT.yloc{1} = DAT.yloc; OUT.zloc{1} = DAT.zloc;
                elseif strcmp(DAT.state,'Point22')
                    DAT.state = 'Point22';
                    DAT.xloc(1) = datapoint(1); 
                    DAT.yloc(1) = datapoint(2); 
                    DAT.zloc(1) = datapoint(3); 
                    OUT.buttonfunc = 'restartline';
                    OUT.info = 'Rigth click second point';
                    OUT.datapoint = datapoint;
                    OUT.xloc{1} = DAT.xloc; OUT.yloc{1} = DAT.yloc; OUT.zloc{1} = DAT.zloc;
                end 
            elseif event.Button == 3
                if strcmp(DAT.state,'Point2')
                    DAT.xloc(2) = datapoint(1);
                    DAT.yloc(2) = datapoint(2); 
                    Len = sqrt((DAT.xloc(2)-DAT.xloc(1)).^2 + (DAT.yloc(2)-DAT.yloc(1)).^2);
                    if DAT.xloc(2) > DAT.xloc(1)
                        angle = asin((DAT.yloc(1)-DAT.yloc(2))/Len);
                    else
                        angle = asin((DAT.yloc(2)-DAT.yloc(1))/Len);
                    end
                    DAT.Ayloc(1) = DAT.yloc(1) - cos(angle)*DAT.wid/2;
                    DAT.Ayloc(2) = DAT.yloc(1) + cos(angle)*DAT.wid/2;
                    DAT.Axloc(1) = DAT.xloc(1) - sin(angle)*DAT.wid/2;
                    DAT.Axloc(2) = DAT.xloc(1) + sin(angle)*DAT.wid/2;
                    DAT.Ayloc(3) = DAT.yloc(2) + cos(angle)*DAT.wid/2;
                    DAT.Ayloc(4) = DAT.yloc(2) - cos(angle)*DAT.wid/2;
                    DAT.Axloc(3) = DAT.xloc(2) + sin(angle)*DAT.wid/2;
                    DAT.Axloc(4) = DAT.xloc(2) - sin(angle)*DAT.wid/2;
                    DAT.Ayloc(5) = DAT.Ayloc(1);
                    DAT.Axloc(5) = DAT.Axloc(1);
                    DAT.Azloc = DAT.zloc;
                    DAT.panelobs(4).String = num2str(round(Len));
                    OUT.xloc{1} = DAT.Axloc; OUT.yloc{1} = DAT.Ayloc; OUT.zloc{1} = DAT.Azloc;
                    DAT.xloc = []; DAT.yloc = []; DAT.zloc = [];
                    OUT.buttonfunc = 'updateregion';
                    OUT.info = 'Left click to start (second side)';
                    DAT.state = 'Start2';
                    OUT.clr = [0.9 0.6 0.6];
                elseif strcmp(DAT.state,'Point22')
                    DAT.xloc(2) = datapoint(1);
                    DAT.yloc(2) = datapoint(2); 
                    Len = sqrt((DAT.xloc(2)-DAT.xloc(1)).^2 + (DAT.yloc(2)-DAT.yloc(1)).^2);
                    if DAT.xloc(2) > DAT.xloc(1)
                        angle = asin((DAT.yloc(1)-DAT.yloc(2))/Len);
                    else
                        angle = asin((DAT.yloc(2)-DAT.yloc(1))/Len);
                    end
                    tAyloc(1) = DAT.yloc(1) - cos(angle)*DAT.wid/2;
                    tAyloc(2) = DAT.yloc(1) + cos(angle)*DAT.wid/2;
                    tAxloc(1) = DAT.xloc(1) - sin(angle)*DAT.wid/2;
                    tAxloc(2) = DAT.xloc(1) + sin(angle)*DAT.wid/2;
                    tAyloc(3) = DAT.yloc(2) + cos(angle)*DAT.wid/2;
                    tAyloc(4) = DAT.yloc(2) - cos(angle)*DAT.wid/2;
                    tAxloc(3) = DAT.xloc(2) + sin(angle)*DAT.wid/2;
                    tAxloc(4) = DAT.xloc(2) - sin(angle)*DAT.wid/2;
                    tAyloc(5) = tAyloc(1);
                    tAxloc(5) = tAxloc(1);
                    DAT.panelobs(4).String = num2str(round(Len));
                    DAT.panelobs(6).String = num2str(round(abs(DAT.zloc - DAT.Azloc)));
                    if DAT.zloc > DAT.Azloc(1)
                        SliceArray = DAT.Azloc(1):DAT.zloc;
                    else
                        SliceArray = DAT.Azloc(1):-1:DAT.zloc;
                    end
                    for m = 1:5
                        fAxloc(m,:) = linspace(DAT.Axloc(m),tAxloc(m),length(SliceArray));
                        fAyloc(m,:) = linspace(DAT.Ayloc(m),tAyloc(m),length(SliceArray));
                    end
                    for n = 1:length(SliceArray)
                        fAzloc = SliceArray(n);
                        OUT.xloc{n} = fAxloc(:,n); OUT.yloc{n} = fAyloc(:,n); OUT.zloc{n} = fAzloc;
                    end
                    DAT.xloc = []; DAT.yloc = []; DAT.zloc = [];
                    OUT.buttonfunc = 'updatefinish';
                    OUT.info = 'Left click to start';
                    DAT.state = 'Start';
                    OUT.clr = [0.9 0.6 0.6];
                end
            end
        end
    end
end    
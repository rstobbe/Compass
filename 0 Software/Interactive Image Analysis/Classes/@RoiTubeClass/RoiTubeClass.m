%================================================================
%  
%================================================================

classdef RoiTubeClass < handle

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
        function DAT = RoiTubeClass
            DAT.rad1 = 10; DAT.rad2 = 10;
            DAT.userad1 = 1; DAT.userad2 = 1; 
            DAT.tubelen = 0; DAT.extend = 0;
            DAT.centre1 = [0 0 0]; DAT.centre2 = [0 0 0];
            DAT.usecen1 = 0; DAT.usecen2 = 0;
            DAT.state = 'Start';  
            DAT.xloc1 = []; DAT.yloc1 = []; DAT.zloc1 = [];
            DAT.xloc2 = []; DAT.yloc1 = []; DAT.zloc1 = [];
            DAT.panelobs = gobjects(0);
            DAT.roicreatesel = 5;
            DAT.pointer = 'crosshair';
            DAT.status = 'Tube Drawing Tool Active';
            DAT.info = 'Left click to start';
        end
        function Setup(DAT,IMAGEANLZ)
            top = 59;
            horz = 10;
            DAT.panelobs = uicontrol('Parent',IMAGEANLZ.FIGOBJS.ROITab,'Style','text','BackgroundColor',IMAGEANLZ.FIGOBJS.Colours.BGcolour,'Tag',num2str(IMAGEANLZ.axnum),'ForegroundColor',[0.8 0.8 0.8],'String','Circle1 Radius','HorizontalAlignment','right','Fontsize',7,'FontWeight','Bold','Position',[horz+200 top-15 80 15],'Enable','inactive','ButtonDownFcn',@ResetFocus);
            DAT.panelobs(2) = uicontrol('Parent',IMAGEANLZ.FIGOBJS.ROITab,'Style','edit','BackgroundColor',IMAGEANLZ.FIGOBJS.Colours.BGcolour,'Tag',num2str(IMAGEANLZ.axnum),'ForegroundColor',[0.8 0.8 0.8],'String',num2str(DAT.rad1),'HorizontalAlignment','left','Fontsize',6,'FontWeight','Bold','Position',[horz+290 top-13 30 15],'CallBack',@DAT.SetRad1);    
            DAT.panelobs(3) = uicontrol('Parent',IMAGEANLZ.FIGOBJS.ROITab,'Style','checkbox','BackgroundColor',IMAGEANLZ.FIGOBJS.Colours.BGcolour,'Tag',num2str(IMAGEANLZ.axnum),'ForegroundColor',[0.8 0.8 0.8],'Value',DAT.userad1,'HorizontalAlignment','left','Fontsize',6,'FontWeight','Bold','Position',[horz+325 top-13 30 15],'Enable','off','CallBack',@DAT.SetUseRad1); 
            DAT.panelobs(4) = uicontrol('Parent',IMAGEANLZ.FIGOBJS.ROITab,'Style','text','BackgroundColor',IMAGEANLZ.FIGOBJS.Colours.BGcolour,'Tag',num2str(IMAGEANLZ.axnum),'ForegroundColor',[0.8 0.8 0.8],'String','Circle2 Radius','HorizontalAlignment','right','Fontsize',7,'FontWeight','Bold','Position',[horz+200 top-32 80 15],'Enable','inactive','ButtonDownFcn',@ResetFocus);
            DAT.panelobs(5) = uicontrol('Parent',IMAGEANLZ.FIGOBJS.ROITab,'Style','edit','BackgroundColor',IMAGEANLZ.FIGOBJS.Colours.BGcolour,'Tag',num2str(IMAGEANLZ.axnum),'ForegroundColor',[0.8 0.8 0.8],'String',num2str(DAT.rad2),'HorizontalAlignment','left','Fontsize',6,'FontWeight','Bold','Position',[horz+290 top-30 30 15],'CallBack',@DAT.SetRad2);    
            DAT.panelobs(6) = uicontrol('Parent',IMAGEANLZ.FIGOBJS.ROITab,'Style','checkbox','BackgroundColor',IMAGEANLZ.FIGOBJS.Colours.BGcolour,'Tag',num2str(IMAGEANLZ.axnum),'ForegroundColor',[0.8 0.8 0.8],'Value',DAT.userad2,'HorizontalAlignment','left','Fontsize',6,'FontWeight','Bold','Position',[horz+325 top-30 30 15],'Enable','off','CallBack',@DAT.SetUseRad2); 
            DAT.panelobs(7) = uicontrol('Parent',IMAGEANLZ.FIGOBJS.ROITab,'Style','text','BackgroundColor',IMAGEANLZ.FIGOBJS.Colours.BGcolour,'Tag',num2str(IMAGEANLZ.axnum),'ForegroundColor',[0.8 0.8 0.8],'String','Circle1 Centre','HorizontalAlignment','right','Fontsize',7,'FontWeight','Bold','Position',[horz+340 top-15 80 15],'Enable','inactive','ButtonDownFcn',@ResetFocus);
            DAT.panelobs(8) = uicontrol('Parent',IMAGEANLZ.FIGOBJS.ROITab,'Style','edit','BackgroundColor',IMAGEANLZ.FIGOBJS.Colours.BGcolour,'Tag',num2str(IMAGEANLZ.axnum),'ForegroundColor',[0.8 0.8 0.8],'String',num2str(round(DAT.centre1(1)*10)/10),'HorizontalAlignment','left','Fontsize',6,'FontWeight','Bold','Position',[horz+430 top-13 30 15],'CallBack',@DAT.SetCen1);    
            DAT.panelobs(9) = uicontrol('Parent',IMAGEANLZ.FIGOBJS.ROITab,'Style','edit','BackgroundColor',IMAGEANLZ.FIGOBJS.Colours.BGcolour,'Tag',num2str(IMAGEANLZ.axnum),'ForegroundColor',[0.8 0.8 0.8],'String',num2str(round(DAT.centre1(2)*10)/10),'HorizontalAlignment','left','Fontsize',6,'FontWeight','Bold','Position',[horz+460 top-13 30 15],'CallBack',@DAT.SetCen1); 
            DAT.panelobs(10) = uicontrol('Parent',IMAGEANLZ.FIGOBJS.ROITab,'Style','edit','BackgroundColor',IMAGEANLZ.FIGOBJS.Colours.BGcolour,'Tag',num2str(IMAGEANLZ.axnum),'ForegroundColor',[0.8 0.8 0.8],'String',num2str(round(DAT.centre1(3))),'HorizontalAlignment','left','Fontsize',6,'FontWeight','Bold','Position',[horz+490 top-13 30 15],'CallBack',@DAT.SetCen1); 
            DAT.panelobs(11) = uicontrol('Parent',IMAGEANLZ.FIGOBJS.ROITab,'Style','checkbox','BackgroundColor',IMAGEANLZ.FIGOBJS.Colours.BGcolour,'Tag',num2str(IMAGEANLZ.axnum),'ForegroundColor',[0.8 0.8 0.8],'Value',DAT.usecen1,'HorizontalAlignment','left','Fontsize',6,'FontWeight','Bold','Position',[horz+525 top-13 30 15],'CallBack',@DAT.SetUseCen1); 
            DAT.panelobs(12) = uicontrol('Parent',IMAGEANLZ.FIGOBJS.ROITab,'Style','text','BackgroundColor',IMAGEANLZ.FIGOBJS.Colours.BGcolour,'Tag',num2str(IMAGEANLZ.axnum),'ForegroundColor',[0.8 0.8 0.8],'String','Circle2 Centre','HorizontalAlignment','right','Fontsize',7,'FontWeight','Bold','Position',[horz+340 top-32 80 15],'Enable','inactive','ButtonDownFcn',@ResetFocus);
            DAT.panelobs(13) = uicontrol('Parent',IMAGEANLZ.FIGOBJS.ROITab,'Style','edit','BackgroundColor',IMAGEANLZ.FIGOBJS.Colours.BGcolour,'Tag',num2str(IMAGEANLZ.axnum),'ForegroundColor',[0.8 0.8 0.8],'String',num2str(round(DAT.centre2(1)*10)/10),'HorizontalAlignment','left','Fontsize',6,'FontWeight','Bold','Position',[horz+430 top-30 30 15],'CallBack',@DAT.SetCen2);    
            DAT.panelobs(14) = uicontrol('Parent',IMAGEANLZ.FIGOBJS.ROITab,'Style','edit','BackgroundColor',IMAGEANLZ.FIGOBJS.Colours.BGcolour,'Tag',num2str(IMAGEANLZ.axnum),'ForegroundColor',[0.8 0.8 0.8],'String',num2str(round(DAT.centre2(2)*10)/10),'HorizontalAlignment','left','Fontsize',6,'FontWeight','Bold','Position',[horz+460 top-30 30 15],'CallBack',@DAT.SetCen2); 
            DAT.panelobs(15) = uicontrol('Parent',IMAGEANLZ.FIGOBJS.ROITab,'Style','edit','BackgroundColor',IMAGEANLZ.FIGOBJS.Colours.BGcolour,'Tag',num2str(IMAGEANLZ.axnum),'ForegroundColor',[0.8 0.8 0.8],'String',num2str(round(DAT.centre2(3))),'HorizontalAlignment','left','Fontsize',6,'FontWeight','Bold','Position',[horz+490 top-30 30 15],'CallBack',@DAT.SetCen2); 
            DAT.panelobs(16) = uicontrol('Parent',IMAGEANLZ.FIGOBJS.ROITab,'Style','checkbox','BackgroundColor',IMAGEANLZ.FIGOBJS.Colours.BGcolour,'Tag',num2str(IMAGEANLZ.axnum),'ForegroundColor',[0.8 0.8 0.8],'Value',DAT.usecen2,'HorizontalAlignment','left','Fontsize',6,'FontWeight','Bold','Position',[horz+525 top-30 30 15],'CallBack',@DAT.SetUseCen2); 
            DAT.panelobs(17) = uicontrol('Parent',IMAGEANLZ.FIGOBJS.ROITab,'Style','text','BackgroundColor',IMAGEANLZ.FIGOBJS.Colours.BGcolour,'Tag',num2str(IMAGEANLZ.axnum),'ForegroundColor',[0.8 0.8 0.8],'String','Tube Length','HorizontalAlignment','right','Fontsize',7,'FontWeight','Bold','Position',[horz+200 top-49 80 15],'Enable','inactive','ButtonDownFcn',@ResetFocus);
            DAT.panelobs(18) = uicontrol('Parent',IMAGEANLZ.FIGOBJS.ROITab,'Style','edit','BackgroundColor',IMAGEANLZ.FIGOBJS.Colours.BGcolour,'Tag',num2str(IMAGEANLZ.axnum),'ForegroundColor',[0.8 0.8 0.8],'String',num2str(DAT.tubelen),'HorizontalAlignment','left','Fontsize',6,'FontWeight','Bold','Position',[horz+290 top-47 30 15],'Enable','inactive','CallBack',@DAT.SetTubeLen);         
            DAT.panelobs(19) = uicontrol('Parent',IMAGEANLZ.FIGOBJS.ROITab,'Style','text','BackgroundColor',IMAGEANLZ.FIGOBJS.Colours.BGcolour,'Tag',num2str(IMAGEANLZ.axnum),'ForegroundColor',[0.8 0.8 0.8],'String','Extend','HorizontalAlignment','right','Fontsize',7,'FontWeight','Bold','Position',[horz+340 top-49 80 15],'Enable','inactive','ButtonDownFcn',@ResetFocus);
            DAT.panelobs(20) = uicontrol('Parent',IMAGEANLZ.FIGOBJS.ROITab,'Style','edit','BackgroundColor',IMAGEANLZ.FIGOBJS.Colours.BGcolour,'Tag',num2str(IMAGEANLZ.axnum),'ForegroundColor',[0.8 0.8 0.8],'String',num2str(DAT.extend),'HorizontalAlignment','left','Fontsize',6,'FontWeight','Bold','Position',[horz+430 top-47 30 15],'CallBack',@DAT.SetExtend);    
            DAT.panelobs(21) = uicontrol('Parent',IMAGEANLZ.FIGOBJS.ROITab,'Style','pushbutton','BackgroundColor',IMAGEANLZ.FIGOBJS.Colours.BGcolour,'Tag',num2str(IMAGEANLZ.axnum),'ForegroundColor',[0.8 0.8 0.8],'String','','Position',[horz+600 top-15 15 15],'CallBack',@DAT.NudgeUp);   
            DAT.panelobs(22) = uicontrol('Parent',IMAGEANLZ.FIGOBJS.ROITab,'Style','pushbutton','BackgroundColor',IMAGEANLZ.FIGOBJS.Colours.BGcolour,'Tag',num2str(IMAGEANLZ.axnum),'ForegroundColor',[0.8 0.8 0.8],'String','','Position',[horz+600 top-45 15 15],'CallBack',@DAT.NudgeDown); 
            DAT.panelobs(23) = uicontrol('Parent',IMAGEANLZ.FIGOBJS.ROITab,'Style','pushbutton','BackgroundColor',IMAGEANLZ.FIGOBJS.Colours.BGcolour,'Tag',num2str(IMAGEANLZ.axnum),'ForegroundColor',[0.8 0.8 0.8],'String','','Position',[horz+615 top-30 15 15],'CallBack',@DAT.NudgeRight);   
            DAT.panelobs(24) = uicontrol('Parent',IMAGEANLZ.FIGOBJS.ROITab,'Style','pushbutton','BackgroundColor',IMAGEANLZ.FIGOBJS.Colours.BGcolour,'Tag',num2str(IMAGEANLZ.axnum),'ForegroundColor',[0.8 0.8 0.8],'String','','Position',[horz+585 top-30 15 15],'CallBack',@DAT.NudgeLeft);
            DAT.status = 'Tube Drawing Tool Active';
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
            DAT.panelobs(8).Enable = 'on';
            DAT.panelobs(9).Enable = 'on';
            DAT.panelobs(10).Enable = 'on';
            DAT.panelobs(13).Enable = 'on';
            DAT.panelobs(14).Enable = 'on';
            DAT.panelobs(15).Enable = 'on';
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
        function DAT = SetRad1(DAT,src,event)
            DAT.rad1 = str2double(src.String);
            ResetFocus(src,event);
        end
        function DAT = SetRad2(DAT,src,event)
            DAT.rad2 = str2double(src.String);
            ResetFocus(src,event);
        end
        function DAT = SetUseRad1(DAT,src,event)
            DAT.userad1 = src.Value;
            ResetFocus(src,event);
        end
        function DAT = SetUseRad2(DAT,src,event)
            DAT.userad2 = src.Value;
            ResetFocus(src,event);
        end
        function DAT = SetCen1(DAT,src,event)
            if strcmp(DAT.state,'Circle2Edit')
                return
            end   
            tab = src.Parent.Parent.Parent.Tag;
            axnum = str2double(src.Tag);
            DAT.centre1(1) = str2double(DAT.panelobs(8).String);
            DAT.centre1(2) = str2double(DAT.panelobs(9).String);
            DAT.centre1(3) = round(str2double(DAT.panelobs(10).String));
            if strcmp(DAT.state,'Circle1Edit')
                [DAT.xloc1,DAT.yloc1,DAT.zloc1] = DrawCircle(DAT,DAT.centre1,DAT.rad1);
                OUT.clr = [0.9 0.6 0.6];
                OUT.xloc{1} = DAT.xloc1; OUT.yloc{1} = DAT.yloc1; OUT.zloc{1} = DAT.zloc1;
                UpdateTempRegion(OUT,tab,axnum) 
                ResetFocus(src,event);
            end
        end
        function DAT = SetCen2(DAT,src,event)
            if strcmp(DAT.state,'Circle1Edit')
                return
            end   
            tab = src.Parent.Parent.Parent.Tag;
            axnum = str2double(src.Tag);
            DAT.centre2(1) = str2double(DAT.panelobs(13).String);
            DAT.centre2(2) = str2double(DAT.panelobs(14).String);
            DAT.centre2(3) = round(str2double(DAT.panelobs(15).String));
            if strcmp(DAT.state,'Circle2Edit')
                [DAT.xloc2,DAT.yloc2,DAT.zloc2] = DrawCircle(DAT,DAT.centre2,DAT.rad2);
                OUT.clr = [0.9 0.6 0.6];
                OUT.xloc{1} = DAT.xloc2; OUT.yloc{1} = DAT.yloc2; OUT.zloc{1} = DAT.zloc2;
                UpdateTempRegion(OUT,tab,axnum) 
                ResetFocus(src,event);
            end
        end    
        function DAT = NudgeUp(DAT,src,event)
            if isempty(DAT.xloc1)
                return
            end   
            tab = src.Parent.Parent.Parent.Tag;
            axnum = str2double(src.Tag);
            if strcmp(DAT.state,'Circle1Edit')                
                DAT.centre1(2) = DAT.centre1(2)-0.2;
                DAT.panelobs(9).String = num2str(round(DAT.centre1(2)*10)/10);
                [DAT.xloc1,DAT.yloc1,DAT.zloc1] = DrawCircle(DAT,DAT.centre1,DAT.rad1);
                OUT.xloc{1} = DAT.xloc1; OUT.yloc{1} = DAT.yloc1; OUT.zloc{1} = DAT.zloc1;
            elseif strcmp(DAT.state,'Circle2Edit')  
                DAT.centre2(2) = DAT.centre2(2)-0.2;
                DAT.panelobs(14).String = num2str(round(DAT.centre2(2)*10)/10);
                [DAT.xloc2,DAT.yloc2,DAT.zloc2] = DrawCircle(DAT,DAT.centre2,DAT.rad2);
                OUT.xloc{1} = DAT.xloc2; OUT.yloc{1} = DAT.yloc2; OUT.zloc{1} = DAT.zloc2;
            end   
            OUT.clr = [0.9 0.6 0.6];
            UpdateTempRegion(OUT,tab,axnum) 
            ResetFocus(src,event);
        end 
        function DAT = NudgeDown(DAT,src,event)
            if isempty(DAT.xloc1)
                return
            end   
            tab = src.Parent.Parent.Parent.Tag;
            axnum = str2double(src.Tag);
            if strcmp(DAT.state,'Circle1Edit')                
                DAT.centre1(2) = DAT.centre1(2)+0.2;
                DAT.panelobs(9).String = num2str(round(DAT.centre1(2)*10)/10);
                [DAT.xloc1,DAT.yloc1,DAT.zloc1] = DrawCircle(DAT,DAT.centre1,DAT.rad1);
                OUT.xloc{1} = DAT.xloc1; OUT.yloc{1} = DAT.yloc1; OUT.zloc{1} = DAT.zloc1;
            elseif strcmp(DAT.state,'Circle2Edit')  
                DAT.centre2(2) = DAT.centre2(2)+0.2;
                DAT.panelobs(14).String = num2str(round(DAT.centre2(2)*10)/10);
                [DAT.xloc2,DAT.yloc2,DAT.zloc2] = DrawCircle(DAT,DAT.centre2,DAT.rad2);
                OUT.xloc{1} = DAT.xloc2; OUT.yloc{1} = DAT.yloc2; OUT.zloc{1} = DAT.zloc2;
            end   
            OUT.clr = [0.9 0.6 0.6];
            UpdateTempRegion(OUT,tab,axnum) 
            ResetFocus(src,event);
        end
        function DAT = NudgeRight(DAT,src,event)
            if isempty(DAT.xloc1)
                return
            end   
            tab = src.Parent.Parent.Parent.Tag;
            axnum = str2double(src.Tag);
            if strcmp(DAT.state,'Circle1Edit')                
                DAT.centre1(1) = DAT.centre1(1)+0.2;
                DAT.panelobs(8).String = num2str(round(DAT.centre1(1)*10)/10);
                [DAT.xloc1,DAT.yloc1,DAT.zloc1] = DrawCircle(DAT,DAT.centre1,DAT.rad1);
                OUT.xloc{1} = DAT.xloc1; OUT.yloc{1} = DAT.yloc1; OUT.zloc{1} = DAT.zloc1;
            elseif strcmp(DAT.state,'Circle2Edit')  
                DAT.centre2(1) = DAT.centre2(1)+0.2;
                DAT.panelobs(13).String = num2str(round(DAT.centre2(1)*10)/10);
                [DAT.xloc2,DAT.yloc2,DAT.zloc2] = DrawCircle(DAT,DAT.centre2,DAT.rad2);
                OUT.xloc{1} = DAT.xloc2; OUT.yloc{1} = DAT.yloc2; OUT.zloc{1} = DAT.zloc2;
            end   
            OUT.clr = [0.9 0.6 0.6];
            UpdateTempRegion(OUT,tab,axnum) 
            ResetFocus(src,event);
        end 
        function DAT = NudgeLeft(DAT,src,event)
            if isempty(DAT.xloc1)
                return
            end   
            tab = src.Parent.Parent.Parent.Tag;
            axnum = str2double(src.Tag);
            if strcmp(DAT.state,'Circle1Edit')                
                DAT.centre1(1) = DAT.centre1(1)-0.2;
                DAT.panelobs(8).String = num2str(round(DAT.centre1(1)*10)/10);
                [DAT.xloc1,DAT.yloc1,DAT.zloc1] = DrawCircle(DAT,DAT.centre1,DAT.rad1);
                OUT.xloc{1} = DAT.xloc1; OUT.yloc{1} = DAT.yloc1; OUT.zloc{1} = DAT.zloc1;
            elseif strcmp(DAT.state,'Circle2Edit')  
                DAT.centre2(1) = DAT.centre2(1)-0.2;
                DAT.panelobs(13).String = num2str(round(DAT.centre2(1)*10)/10);
                [DAT.xloc2,DAT.yloc2,DAT.zloc2] = DrawCircle(DAT,DAT.centre2,DAT.rad2);
                OUT.xloc{1} = DAT.xloc2; OUT.yloc{1} = DAT.yloc2; OUT.zloc{1} = DAT.zloc2;
            end   
            OUT.clr = [0.9 0.6 0.6];
            UpdateTempRegion(OUT,tab,axnum) 
            ResetFocus(src,event);
        end        
        function DAT = SetUseCen1(DAT,src,event)
            DAT.usecen1 = src.Value;
            ResetFocus(src,event);
        end
        function DAT = SetUseCen2(DAT,src,event)
            DAT.usecen2 = src.Value;
            ResetFocus(src,event);
        end
        function DAT = SetTubeLen(DAT,src,event)
            DAT.tubelen = str2double(src.String);
            ResetFocus(src,event);
        end
        function DAT = SetExtend(DAT,src,event)
            DAT.extend = str2double(src.String);
            ResetFocus(src,event);
        end           
        function OUT = BuildROI(DAT,datapoint,event,ImageSlice) 
            if strcmp(DAT.state,'Start') || strcmp(DAT.state,'Circle1Edit') 
                if event.Button == 1
                    if DAT.userad1 == 1 
                        if DAT.usecen1 == 1
                            [DAT.xloc1,DAT.yloc1,DAT.zloc1] = DrawCircle(DAT,DAT.centre1,DAT.rad1);
                        else
                            DAT.centre1 = datapoint(1:3);
                            DAT.panelobs(8).String = num2str(round(DAT.centre1(1)*10)/10);
                            DAT.panelobs(9).String = num2str(round(DAT.centre1(2)*10)/10);
                            DAT.panelobs(10).String = num2str(round(DAT.centre1(3)));
                            [DAT.xloc1,DAT.yloc1,DAT.zloc1] = DrawCircle(DAT,DAT.centre1,DAT.rad1);
                        end
                    else
                        error    % see sphere class to finish
                    end
                    DAT.state = 'Circle1Edit';
                    OUT.clr = [0.9 0.6 0.6];
                    DAT.panelobs(8).Enable = 'on';
                    DAT.panelobs(9).Enable = 'on';
                    DAT.panelobs(10).Enable = 'on';
                    DAT.panelobs(13).Enable = 'off';
                    DAT.panelobs(14).Enable = 'off';
                    DAT.panelobs(15).Enable = 'off';
                    OUT.xloc{1} = DAT.xloc1; OUT.yloc{1} = DAT.yloc1; OUT.zloc{1} = DAT.zloc1;
                    OUT.buttonfunc = 'updateregion';
                    OUT.info = 'Right click to accept circle';
                elseif event.Button == 3
                    if isempty(DAT.xloc1)
                        OUT.buttonfunc = 'return';
                        return
                    end
                    OUT.clr = [0.8 0.3 0.3];
                    DAT.panelobs(8).Enable = 'off';
                    DAT.panelobs(9).Enable = 'off';
                    DAT.panelobs(10).Enable = 'off';
                    DAT.panelobs(13).Enable = 'on';
                    DAT.panelobs(14).Enable = 'on';
                    DAT.panelobs(15).Enable = 'on';
                    OUT.xloc{1} = DAT.xloc1; OUT.yloc{1} = DAT.yloc1; OUT.zloc{1} = DAT.zloc1;
                    DAT.state = 'Circle2Edit';
                    OUT.buttonfunc = 'updateregion';
                    OUT.info = 'Left click second circle';
                end
            elseif strcmp(DAT.state,'Circle2Edit') 
                if event.Button == 1
                    if DAT.userad2 == 1 
                        if DAT.usecen2 == 1
                            [DAT.xloc2,DAT.yloc2,DAT.zloc2] = DrawCircle(DAT,DAT.centre2,DAT.rad2);
                        else
                            DAT.centre2 = datapoint(1:3);
                            DAT.panelobs(13).String = num2str(round(DAT.centre2(1)));
                            DAT.panelobs(14).String = num2str(round(DAT.centre2(2)));
                            DAT.panelobs(15).String = num2str(round(DAT.centre2(3)));
                            [DAT.xloc2,DAT.yloc2,DAT.zloc2] = DrawCircle(DAT,DAT.centre2,DAT.rad2);
                        end
                    end
                    DAT.state = 'Circle2Edit';
                    OUT.clr = [0.9 0.6 0.6];
                    OUT.xloc{1} = DAT.xloc2; OUT.yloc{1} = DAT.yloc2; OUT.zloc{1} = DAT.zloc2;
                    OUT.buttonfunc = 'updateregion';
                    OUT.info = 'Right click to accept circle';
                elseif event.Button == 3
                    if isempty(DAT.xloc2)
                        OUT.buttonfunc = 'return';
                        return
                    end
                    DAT.panelobs(8).Enable = 'on';
                    DAT.panelobs(9).Enable = 'on';
                    DAT.panelobs(10).Enable = 'on';
                    DAT.state = 'Start';
                    [OUT.xloc,OUT.yloc,OUT.zloc] = CompleteROI(DAT);
                    DAT.xloc1 = []; DAT.yloc1 = []; DAT.zloc1 = [];
                    DAT.xloc2 = []; DAT.yloc2 = []; DAT.zloc2 = [];
                    OUT.buttonfunc = 'updatefinish';
                    OUT.info = 'Left click to start';
                end 
            end
        end
        function [xloc,yloc,zloc] = DrawCircle(DAT,centre,rad)
                circlen = 5*rad;
                if circlen < 20
                    circlen = 20;
                end
                theta = linspace(0,2*pi,circlen);
                xloc = centre(1)+rad*cos(theta);
                yloc = centre(2)+rad*sin(theta);
                zloc = centre(3);
        end        
        function [xloc,yloc,zloc] = CompleteROI(DAT)
            DAT.tubelen = DAT.zloc2 - DAT.zloc1 + 1;
            if DAT.zloc2 > DAT.zloc1
                slices = (DAT.zloc1-DAT.extend:DAT.zloc2+DAT.extend);
            else
                slices = (DAT.zloc1+DAT.extend:DAT.zloc2-DAT.extend);
            end
            txloc1 = DAT.xloc1;
            tyloc1 = DAT.yloc1;
            txloc2 = DAT.xloc2;
            tyloc2 = DAT.yloc2;
            if isempty(slices)
                DAT.tubelen = DAT.zloc1 - DAT.zloc2;
                slices = (DAT.zloc2-DAT.extend:DAT.zloc1+DAT.extend);
                txloc1 = DAT.xloc2;
                tyloc1 = DAT.yloc2;
                txloc2 = DAT.xloc1;
                tyloc2 = DAT.yloc1;
            end
            DAT.panelobs(18).String = num2str(DAT.tubelen);
            for m = 1:length(slices)
                xloc{m} = txloc1+(m-1-DAT.extend)*(txloc2-txloc1)/DAT.tubelen;
                yloc{m} = tyloc1+(m-1-DAT.extend)*(tyloc2-tyloc1)/DAT.tubelen;
                zloc{m} = slices(m); 
            end
        end
    end
end
        
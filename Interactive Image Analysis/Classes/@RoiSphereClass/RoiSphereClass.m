%================================================================
%  
%================================================================

classdef RoiSphereClass < handle

    properties (SetAccess = private)
        rad,centre;
        userad,usecentre;
        xloc,yloc,zloc;
        state;
        panelobs;
        roicreatesel;
        pointer,status,info;
    end
    
    methods
        function DAT = RoiSphereClass
            DAT.rad = 10;
            DAT.userad = 1; DAT.usecentre = 0;
            DAT.centre = [0 0 0];
            DAT.xloc = []; DAT.yloc = []; DAT.zloc = [];
            DAT.state = 'Start';
            DAT.panelobs = gobjects(0);
            DAT.roicreatesel = 3;
            DAT.pointer = 'cross';
            DAT.status = 'Sphere Drawing Tool Active';
            DAT.info = 'Left click to start';
        end
        function Setup(DAT,IMAGEANLZ)
            horz0 = 0.35;
            top = 47;
            horz = 10;
            DAT.panelobs = uicontrol('Parent',IMAGEANLZ.FIGOBJS.ROITab,'Style','text','BackgroundColor',IMAGEANLZ.FIGOBJS.Colours.BGcolour,'Tag',num2str(IMAGEANLZ.axnum),'ForegroundColor',[0.8 0.8 0.8],'String','Sphere Radius','HorizontalAlignment','right','Fontsize',7,'Units','normalized','Position',[horz0+0.05 0.39 0.08 0.14],'Enable','inactive','ButtonDownFcn',@ResetFocus);
            DAT.panelobs(2) = uicontrol('Parent',IMAGEANLZ.FIGOBJS.ROITab,'Style','edit','BackgroundColor',IMAGEANLZ.FIGOBJS.Colours.BGcolour,'Tag',num2str(IMAGEANLZ.axnum),'ForegroundColor',[0.8 0.8 0.8],'String',num2str(DAT.rad),'HorizontalAlignment','left','Fontsize',6,'Units','normalized','Position',[horz0+0.14 0.4 0.04 0.14],'CallBack',@DAT.SetRad);    
            DAT.panelobs(3) = uicontrol('Parent',IMAGEANLZ.FIGOBJS.ROITab,'Style','checkbox','BackgroundColor',IMAGEANLZ.FIGOBJS.Colours.BGcolour,'Tag',num2str(IMAGEANLZ.axnum),'ForegroundColor',[0.8 0.8 0.8],'Value',DAT.userad,'HorizontalAlignment','left','Fontsize',6,'Units','normalized','Position',[horz0+0.19 0.4 0.04 0.14],'Enable','off','CallBack',@DAT.SetUseRad); 
            DAT.panelobs(4) = uicontrol('Parent',IMAGEANLZ.FIGOBJS.ROITab,'Style','text','BackgroundColor',IMAGEANLZ.FIGOBJS.Colours.BGcolour,'Tag',num2str(IMAGEANLZ.axnum),'ForegroundColor',[0.8 0.8 0.8],'String','Sphere Centre','HorizontalAlignment','right','Fontsize',7,'Units','normalized','Position',[horz0+0.24 0.39 0.07 0.14],'Enable','inactive','ButtonDownFcn',@ResetFocus);
            DAT.panelobs(5) = uicontrol('Parent',IMAGEANLZ.FIGOBJS.ROITab,'Style','edit','BackgroundColor',IMAGEANLZ.FIGOBJS.Colours.BGcolour,'Tag',num2str(IMAGEANLZ.axnum),'ForegroundColor',[0.8 0.8 0.8],'String',num2str(round(DAT.centre(1)*10)/10),'HorizontalAlignment','left','Fontsize',6,'Units','normalized','Position',[horz0+0.32 0.4 0.04 0.14],'CallBack',@DAT.SetCentre);    
            DAT.panelobs(6) = uicontrol('Parent',IMAGEANLZ.FIGOBJS.ROITab,'Style','edit','BackgroundColor',IMAGEANLZ.FIGOBJS.Colours.BGcolour,'Tag',num2str(IMAGEANLZ.axnum),'ForegroundColor',[0.8 0.8 0.8],'String',num2str(round(DAT.centre(2)*10)/10),'HorizontalAlignment','left','Fontsize',6,'Units','normalized','Position',[horz0+0.36 0.4 0.04 0.14],'CallBack',@DAT.SetCentre); 
            DAT.panelobs(7) = uicontrol('Parent',IMAGEANLZ.FIGOBJS.ROITab,'Style','edit','BackgroundColor',IMAGEANLZ.FIGOBJS.Colours.BGcolour,'Tag',num2str(IMAGEANLZ.axnum),'ForegroundColor',[0.8 0.8 0.8],'String',num2str(round(DAT.centre(3))),'HorizontalAlignment','left','Fontsize',6,'Units','normalized','Position',[horz0+0.40 0.4 0.04 0.14],'CallBack',@DAT.SetCentre); 
            DAT.panelobs(8) = uicontrol('Parent',IMAGEANLZ.FIGOBJS.ROITab,'Style','checkbox','BackgroundColor',IMAGEANLZ.FIGOBJS.Colours.BGcolour,'Tag',num2str(IMAGEANLZ.axnum),'ForegroundColor',[0.8 0.8 0.8],'Value',DAT.usecentre,'HorizontalAlignment','left','Fontsize',6,'Units','normalized','Position',[horz0+0.45 0.4 0.04 0.14],'CallBack',@DAT.SetUseCentre); 
            DAT.panelobs(15) = uicontrol('Parent',IMAGEANLZ.FIGOBJS.ROITab,'Style','text','BackgroundColor',IMAGEANLZ.FIGOBJS.Colours.BGcolour,'Tag',num2str(IMAGEANLZ.axnum),'ForegroundColor',[0.8 0.8 0.8],'String','Value','HorizontalAlignment','right','Fontsize',7,'Units','normalized','Position',[horz0+0.05 0.19 0.08 0.14],'Enable','inactive','ButtonDownFcn',@ResetFocus);
            DAT.panelobs(16) = uicontrol('Parent',IMAGEANLZ.FIGOBJS.ROITab,'Style','text','BackgroundColor',IMAGEANLZ.FIGOBJS.Colours.BGcolour,'Tag',num2str(IMAGEANLZ.axnum),'ForegroundColor',[0.8 0.8 0.8],'String',[],'HorizontalAlignment','left','Fontsize',6,'Units','normalized','Position',[horz0+0.14 0.2 0.04 0.14],'Enable','inactive','ButtonDownFcn',@ResetFocus);    

            top = 59;
            DAT.panelobs(9) = uicontrol('Parent',IMAGEANLZ.FIGOBJS.ROITab,'Style','pushbutton','BackgroundColor',IMAGEANLZ.FIGOBJS.Colours.BGcolour,'Tag',num2str(IMAGEANLZ.axnum),'ForegroundColor',[0.8 0.8 0.8],'String','','Units','normalized','Position',[horz0+0.54 0.58 0.018 0.14],'CallBack',@DAT.NudgeUp);   
            DAT.panelobs(10) = uicontrol('Parent',IMAGEANLZ.FIGOBJS.ROITab,'Style','pushbutton','BackgroundColor',IMAGEANLZ.FIGOBJS.Colours.BGcolour,'Tag',num2str(IMAGEANLZ.axnum),'ForegroundColor',[0.8 0.8 0.8],'String','','Units','normalized','Position',[horz0+0.54 0.22 0.018 0.14],'CallBack',@DAT.NudgeDown); 
            DAT.panelobs(11) = uicontrol('Parent',IMAGEANLZ.FIGOBJS.ROITab,'Style','pushbutton','BackgroundColor',IMAGEANLZ.FIGOBJS.Colours.BGcolour,'Tag',num2str(IMAGEANLZ.axnum),'ForegroundColor',[0.8 0.8 0.8],'String','','Units','normalized','Position',[horz0+0.56 0.4 0.018 0.14],'CallBack',@DAT.NudgeRight);   
            DAT.panelobs(12) = uicontrol('Parent',IMAGEANLZ.FIGOBJS.ROITab,'Style','pushbutton','BackgroundColor',IMAGEANLZ.FIGOBJS.Colours.BGcolour,'Tag',num2str(IMAGEANLZ.axnum),'ForegroundColor',[0.8 0.8 0.8],'String','','Units','normalized','Position',[horz0+0.52 0.4 0.018 0.14],'CallBack',@DAT.NudgeLeft);
            DAT.panelobs(13) = uicontrol('Parent',IMAGEANLZ.FIGOBJS.ROITab,'Style','pushbutton','BackgroundColor',IMAGEANLZ.FIGOBJS.Colours.BGcolour,'Tag',num2str(IMAGEANLZ.axnum),'ForegroundColor',[0.8 0.8 0.8],'String','','Units','normalized','Position',[horz0+0.59 0.58 0.018 0.14],'CallBack',@DAT.NudgeIn);   
            DAT.panelobs(14) = uicontrol('Parent',IMAGEANLZ.FIGOBJS.ROITab,'Style','pushbutton','BackgroundColor',IMAGEANLZ.FIGOBJS.Colours.BGcolour,'Tag',num2str(IMAGEANLZ.axnum),'ForegroundColor',[0.8 0.8 0.8],'String','','Units','normalized','Position',[horz0+0.59 0.22 0.018 0.14],'CallBack',@DAT.NudgeOut);
            DAT.status = 'Sphere Drawing Tool Active';
            DAT.info = 'Left click to start';
        end
        function Initialize(DAT)
            DAT.state = 'Start';
            DAT.xloc = []; DAT.yloc = []; DAT.zloc = [];
            DAT.status = 'Sphere Drawing Tool Active';
            DAT.info = 'Left click to start';
        end
        function Copy(DAT,DAT2)
            DAT.centre = DAT2.centre;
            DAT.rad = DAT2.rad;
        end
        function ResetPanel(DAT)
            DAT.panelobs(16).String = '';
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
            DAT.panelobs(16).String = num2str(Value);
        end
        function SetRad(DAT,src,event)
            tab = src.Parent.Parent.Parent.Tag;
            axnum = str2double(src.Tag);
            DAT.rad = str2double(src.String);
            if strcmp(DAT.state,'SphereEdit')
                [DAT.xloc,DAT.yloc,DAT.zloc,err] = CompleteROI(DAT);
                if err == 1
                    OUT.buttonfunc = 'updatestatus';
                    OUT.info = 'Sphere out of bounds';
                    return
                end
                OUT.xloc = DAT.xloc; OUT.yloc = DAT.yloc; OUT.zloc = DAT.zloc;
                OUT.clr = [0.9 0.6 0.6];
                UpdateTempRegion(OUT,tab,axnum) 
            end
            ResetFocus(src,event);
        end
        function SetUseRad(DAT,src,event)
            DAT.userad = src.Value;
            ResetFocus(src,event);
        end
        function SetCentre(DAT,src,event)
            tab = src.Parent.Parent.Parent.Tag;
            axnum = str2double(src.Tag);
            DAT.centre(1) = str2double(DAT.panelobs(5).String);
            DAT.centre(2) = str2double(DAT.panelobs(6).String);
            DAT.centre(3) = round(str2double(DAT.panelobs(7).String));
            if strcmp(DAT.state,'SphereEdit')
                [DAT.xloc,DAT.yloc,DAT.zloc,err] = CompleteROI(DAT);
                if err == 1
                    OUT.buttonfunc = 'updatestatus';
                    OUT.info = 'Sphere out of bounds';
                    return
                end
                OUT.xloc = DAT.xloc; OUT.yloc = DAT.yloc; OUT.zloc = DAT.zloc;
                OUT.clr = [0.9 0.6 0.6];
                UpdateTempRegion(OUT,tab,axnum) 
            end
            ResetFocus(src,event);
        end
        function SetUseCentre(DAT,src,event)
            DAT.usecentre = src.Value;
            ResetFocus(src,event);
        end
        function OUT = NudgeUp(DAT,src,event)
            if isempty(DAT.xloc)
                return
            end   
            tab = src.Parent.Parent.Parent.Tag;
            axnum = str2double(src.Tag);
            if strcmp(DAT.state,'SphereEdit')                
                DAT.centre(2) = DAT.centre(2)-0.5;
                DAT.panelobs(6).String = num2str(round(DAT.centre(2)*10)/10);
                [DAT.xloc,DAT.yloc,DAT.zloc,err] = CompleteROI(DAT);
                if err == 1
                    OUT.buttonfunc = 'updatestatus';
                    OUT.info = 'Sphere out of bounds';
                    return
                end
                OUT.xloc = DAT.xloc; OUT.yloc = DAT.yloc; OUT.zloc = DAT.zloc;
                OUT.clr = [0.9 0.6 0.6];
                UpdateTempRegion(OUT,tab,axnum) 
            end
            ResetFocus(src,event);
        end  
        function OUT = NudgeDown(DAT,src,event)
            if isempty(DAT.xloc)
                return
            end   
            tab = src.Parent.Parent.Parent.Tag;
            axnum = str2double(src.Tag);
            if strcmp(DAT.state,'SphereEdit')                
                DAT.centre(2) = DAT.centre(2)+0.5;
                DAT.panelobs(6).String = num2str(round(DAT.centre(2)*10)/10);
                [DAT.xloc,DAT.yloc,DAT.zloc,err] = CompleteROI(DAT);
                if err == 1
                    OUT.buttonfunc = 'updatestatus';
                    OUT.info = 'Sphere out of bounds';
                    return
                end
                OUT.xloc = DAT.xloc; OUT.yloc = DAT.yloc; OUT.zloc = DAT.zloc;
                OUT.clr = [0.9 0.6 0.6];
                UpdateTempRegion(OUT,tab,axnum) 
            end
            ResetFocus(src,event);
        end 
        function OUT = NudgeLeft(DAT,src,event)
            if isempty(DAT.xloc)
                return
            end   
            tab = src.Parent.Parent.Parent.Tag;
            axnum = str2double(src.Tag);
            if strcmp(DAT.state,'SphereEdit')                
                DAT.centre(1) = DAT.centre(1)-0.5;
                DAT.panelobs(5).String = num2str(round(DAT.centre(1)*10)/10);
                [DAT.xloc,DAT.yloc,DAT.zloc,err] = CompleteROI(DAT);
                if err == 1
                    OUT.buttonfunc = 'updatestatus';
                    OUT.info = 'Sphere out of bounds';
                    return
                end
                OUT.xloc = DAT.xloc; OUT.yloc = DAT.yloc; OUT.zloc = DAT.zloc;
                OUT.clr = [0.9 0.6 0.6];
                UpdateTempRegion(OUT,tab,axnum) 
            end
            ResetFocus(src,event);
        end  
        function OUT = NudgeRight(DAT,src,event)
            if isempty(DAT.xloc)
                return
            end   
            tab = src.Parent.Parent.Parent.Tag;
            axnum = str2double(src.Tag);
            if strcmp(DAT.state,'SphereEdit')                
                DAT.centre(1) = DAT.centre(1)+0.5;
                DAT.panelobs(5).String = num2str(round(DAT.centre(1)*10)/10);
                [DAT.xloc,DAT.yloc,DAT.zloc,err] = CompleteROI(DAT);
                if err == 1
                    OUT.buttonfunc = 'updatestatus';
                    OUT.info = 'Sphere out of bounds';
                    return
                end
                OUT.xloc = DAT.xloc; OUT.yloc = DAT.yloc; OUT.zloc = DAT.zloc;
                OUT.clr = [0.9 0.6 0.6];
                UpdateTempRegion(OUT,tab,axnum) 
            end
            ResetFocus(src,event);
        end 
        function OUT = NudgeIn(DAT,src,event)
            if isempty(DAT.xloc)
                return
            end   
            tab = src.Parent.Parent.Parent.Tag;
            axnum = str2double(src.Tag);
            if strcmp(DAT.state,'SphereEdit')                
                DAT.centre(3) = DAT.centre(3)+1;
                DAT.panelobs(7).String = num2str(round(DAT.centre(3)));
                [DAT.xloc,DAT.yloc,DAT.zloc,err] = CompleteROI(DAT);
                if err == 1
                    OUT.buttonfunc = 'updatestatus';
                    OUT.info = 'Sphere out of bounds';
                    return
                end
                OUT.xloc = DAT.xloc; OUT.yloc = DAT.yloc; OUT.zloc = DAT.zloc;
                OUT.clr = [0.9 0.6 0.6];
                UpdateTempRegion(OUT,tab,axnum) 
            end
            ResetFocus(src,event);
        end 
        function OUT = NudgeOut(DAT,src,event)
            if isempty(DAT.xloc)
                return
            end   
            tab = src.Parent.Parent.Parent.Tag;
            axnum = str2double(src.Tag);
            if strcmp(DAT.state,'SphereEdit')                
                DAT.centre(3) = DAT.centre(3)-1;
                DAT.panelobs(7).String = num2str(round(DAT.centre(3)));
                [DAT.xloc,DAT.yloc,DAT.zloc,err] = CompleteROI(DAT);
                if err == 1
                    OUT.buttonfunc = 'updatestatus';
                    OUT.info = 'Sphere out of bounds';
                    return
                end
                OUT.xloc = DAT.xloc; OUT.yloc = DAT.yloc; OUT.zloc = DAT.zloc;
                OUT.clr = [0.9 0.6 0.6];
                UpdateTempRegion(OUT,tab,axnum) 
            end
            ResetFocus(src,event);
        end         
        function OUT = BuildROI(DAT,datapoint,event,ImageSlice) 
            if event.Button == 1
                if DAT.userad == 1 
                    if DAT.usecentre == 0
                        DAT.centre = datapoint(1:3);
                        DAT.panelobs(5).String = num2str(round(DAT.centre(1)*10)/10);
                        DAT.panelobs(6).String = num2str(round(DAT.centre(2)*10)/10);
                        DAT.panelobs(7).String = num2str(round(DAT.centre(3)));
                    end
                    [DAT.xloc,DAT.yloc,DAT.zloc,err] = CompleteROI(DAT);
                    if err == 1
                        OUT.buttonfunc = 'updatestatus';
                        OUT.info = 'Sphere out of bounds';
                        return
                    end
                    OUT.xloc = DAT.xloc; OUT.yloc = DAT.yloc; OUT.zloc = DAT.zloc;
                    OUT.clr = [0.9 0.6 0.6];
                    OUT.buttonfunc = 'updateregion';
                    DAT.info = 'Right click to accept circle';
                    OUT.info = DAT.info;
                    DAT.state = 'SphereEdit';
                else
                    error
                end
            else
                if strcmp(DAT.state,'SphereEdit')
                    OUT.xloc = DAT.xloc; OUT.yloc = DAT.yloc; OUT.zloc = DAT.zloc;
                    OUT.buttonfunc = 'updatefinish';
                    DAT.info = 'Left click to start new';
                    OUT.info = DAT.info;
                    DAT.state = 'Start';
                else
                    OUT.buttonfunc = 'return';
                end
            end
        end         
        function [xloc,yloc,zloc,err] = CompleteROI(DAT)
            err = 0;
            slices = (DAT.centre(3)-floor(DAT.rad):1:DAT.centre(3)+floor(DAT.rad));
            if min(slices) < 1
                err = 1;
            end
            for m = 1:length(slices)
                phi = asin((slices(m)-DAT.centre(3))/DAT.rad);
                iprad = cos(phi)*DAT.rad;
                circlen = 5*iprad;
                if circlen < 20
                    circlen = 20;
                end
                theta = linspace(0,2*pi,circlen);
                xloc{m} = size(theta);
                yloc{m} = size(theta);
                for n = 1:length(theta)
                    xloc{m}(n) = DAT.centre(1)+iprad*cos(theta(n));
                    yloc{m}(n) = DAT.centre(2)+iprad*sin(theta(n));
                end
                zloc{m} = slices(m); 
            end
        end
    end
end
        
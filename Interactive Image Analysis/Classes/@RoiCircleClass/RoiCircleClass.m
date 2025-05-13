%================================================================
%  
%================================================================

classdef RoiCircleClass < handle

    properties (SetAccess = private)
        circleval;
        rad,centre;
        userad,usecentre;
        xloc,yloc, zloc; % location components for GUI placement
        state;
        panelobs;
        roicreatesel; % what does this mean? 
        pointer,status,info;
    end
    
    methods
        function DAT = RoiCircleClass % constructor, initializes values 
            DAT.circleval = 0;
            DAT.rad = 10;
            DAT.userad = 1; DAT.usecentre = 0;
            DAT.centre = [0 0];
            DAT.xloc = []; DAT.yloc = []; DAT.zloc = [];
            DAT.state = 'Start';
            DAT.panelobs = gobjects(0);
            DAT.roicreatesel = 4; % what does this mean
            DAT.pointer = 'cross';
            DAT.status = 'Circle Drawing Tool Active';
            DAT.info = 'Left click to start';
        end
        function DAT = SetCircleVal(DAT,circleval) % setter function
            DAT.circleval = circleval;
        end

        function Setup(DAT,IMAGEANLZ) % creat GUI
            horz0 = 0.35;
            top = 47;
            horz = 10;
            DAT.panelobs = uicontrol('Parent',IMAGEANLZ.FIGOBJS.ROITab,'Style','text','BackgroundColor',IMAGEANLZ.FIGOBJS.Colours.BGcolour,'Tag',num2str(IMAGEANLZ.axnum),'ForegroundColor',[0.8 0.8 0.8],'String','Circle Radius','HorizontalAlignment','right','Fontsize',7,'Units','normalized','Position',[horz0+0.05 0.39 0.08 0.14],'Enable','inactive','ButtonDownFcn',@ResetFocus);
            DAT.panelobs(2) = uicontrol('Parent',IMAGEANLZ.FIGOBJS.ROITab,'Style','edit','BackgroundColor',IMAGEANLZ.FIGOBJS.Colours.BGcolour,'Tag',num2str(IMAGEANLZ.axnum),'ForegroundColor',[0.8 0.8 0.8],'String',num2str(DAT.rad),'HorizontalAlignment','left','Fontsize',6,'Units','normalized','Position',[horz0+0.14 0.4 0.04 0.14],'CallBack',@DAT.SetRad);    
            DAT.panelobs(3) = uicontrol('Parent',IMAGEANLZ.FIGOBJS.ROITab,'Style','checkbox','BackgroundColor',IMAGEANLZ.FIGOBJS.Colours.BGcolour,'Tag',num2str(IMAGEANLZ.axnum),'ForegroundColor',[0.8 0.8 0.8],'Value',DAT.userad,'HorizontalAlignment','left','Fontsize',6,'Units','normalized','Position',[horz0+0.19 0.4 0.04 0.14],'Enable','off','CallBack',@DAT.SetUseRad); 
            DAT.panelobs(4) = uicontrol('Parent',IMAGEANLZ.FIGOBJS.ROITab,'Style','text','BackgroundColor',IMAGEANLZ.FIGOBJS.Colours.BGcolour,'Tag',num2str(IMAGEANLZ.axnum),'ForegroundColor',[0.8 0.8 0.8],'String','Circle Centre','HorizontalAlignment','right','Fontsize',7,'Units','normalized','Position',[horz0+0.24 0.39 0.07 0.14],'Enable','inactive','ButtonDownFcn',@ResetFocus);
            DAT.panelobs(5) = uicontrol('Parent',IMAGEANLZ.FIGOBJS.ROITab,'Style','edit','BackgroundColor',IMAGEANLZ.FIGOBJS.Colours.BGcolour,'Tag',num2str(IMAGEANLZ.axnum),'ForegroundColor',[0.8 0.8 0.8],'String',num2str(round(DAT.centre(1)*10)/10),'HorizontalAlignment','left','Fontsize',6,'Units','normalized','Position',[horz0+0.32 0.4 0.04 0.14],'CallBack',@DAT.SetCentre);    
            DAT.panelobs(6) = uicontrol('Parent',IMAGEANLZ.FIGOBJS.ROITab,'Style','edit','BackgroundColor',IMAGEANLZ.FIGOBJS.Colours.BGcolour,'Tag',num2str(IMAGEANLZ.axnum),'ForegroundColor',[0.8 0.8 0.8],'String',num2str(round(DAT.centre(2)*10)/10),'HorizontalAlignment','left','Fontsize',6,'Units','normalized','Position',[horz0+0.36 0.4 0.04 0.14],'CallBack',@DAT.SetCentre); 
            DAT.panelobs(8) = uicontrol('Parent',IMAGEANLZ.FIGOBJS.ROITab,'Style','checkbox','BackgroundColor',IMAGEANLZ.FIGOBJS.Colours.BGcolour,'Tag',num2str(IMAGEANLZ.axnum),'ForegroundColor',[0.8 0.8 0.8],'Value',DAT.usecentre,'HorizontalAlignment','left','Fontsize',6,'Units','normalized','Position',[horz0+0.45 0.4 0.04 0.14],'CallBack',@DAT.SetUseCentre); 
            DAT.panelobs(15) = uicontrol('Parent',IMAGEANLZ.FIGOBJS.ROITab,'Style','text','BackgroundColor',IMAGEANLZ.FIGOBJS.Colours.BGcolour,'Tag',num2str(IMAGEANLZ.axnum),'ForegroundColor',[0.8 0.8 0.8],'String','Value','HorizontalAlignment','right','Fontsize',7,'Units','normalized','Position',[horz0+0.05 0.19 0.08 0.14],'Enable','inactive','ButtonDownFcn',@ResetFocus);
            DAT.panelobs(16) = uicontrol('Parent',IMAGEANLZ.FIGOBJS.ROITab,'Style','text','BackgroundColor',IMAGEANLZ.FIGOBJS.Colours.BGcolour,'Tag',num2str(IMAGEANLZ.axnum),'ForegroundColor',[0.8 0.8 0.8],'String',[],'HorizontalAlignment','left','Fontsize',6,'Units','normalized','Position',[horz0+0.14 0.2 0.04 0.14],'Enable','inactive','ButtonDownFcn',@ResetFocus);    

            top = 59;
            DAT.panelobs(9) = uicontrol('Parent',IMAGEANLZ.FIGOBJS.ROITab,'Style','pushbutton','BackgroundColor',IMAGEANLZ.FIGOBJS.Colours.BGcolour,'Tag',num2str(IMAGEANLZ.axnum),'ForegroundColor',[0.8 0.8 0.8],'String','','Units','normalized','Position',[horz0+0.54 0.58 0.018 0.14],'CallBack',@DAT.NudgeUp);   
            DAT.panelobs(10) = uicontrol('Parent',IMAGEANLZ.FIGOBJS.ROITab,'Style','pushbutton','BackgroundColor',IMAGEANLZ.FIGOBJS.Colours.BGcolour,'Tag',num2str(IMAGEANLZ.axnum),'ForegroundColor',[0.8 0.8 0.8],'String','','Units','normalized','Position',[horz0+0.54 0.22 0.018 0.14],'CallBack',@DAT.NudgeDown); 
            DAT.panelobs(11) = uicontrol('Parent',IMAGEANLZ.FIGOBJS.ROITab,'Style','pushbutton','BackgroundColor',IMAGEANLZ.FIGOBJS.Colours.BGcolour,'Tag',num2str(IMAGEANLZ.axnum),'ForegroundColor',[0.8 0.8 0.8],'String','','Units','normalized','Position',[horz0+0.56 0.4 0.018 0.14],'CallBack',@DAT.NudgeRight);   
            DAT.panelobs(12) = uicontrol('Parent',IMAGEANLZ.FIGOBJS.ROITab,'Style','pushbutton','BackgroundColor',IMAGEANLZ.FIGOBJS.Colours.BGcolour,'Tag',num2str(IMAGEANLZ.axnum),'ForegroundColor',[0.8 0.8 0.8],'String','','Units','normalized','Position',[horz0+0.52 0.4 0.018 0.14],'CallBack',@DAT.NudgeLeft);
            DAT.status = 'Circle Drawing Tool Active';
            DAT.info = 'Left click to start';
        end

        function Initialize(DAT)
            DAT.state = 'Start';
            DAT.xloc = []; DAT.yloc = []; DAT.zloc = [];
            DAT.status = 'Circle Drawing Tool Active';
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
            if strcmp(DAT.state,'CircleEdit')
                [DAT.xloc,DAT.yloc,DAT.zloc,err] = CompleteROI(DAT);
                if err == 1
                    OUT.buttonfunc = 'updatestatus';
                    OUT.info = 'Circle out of bounds';
                    return
                end
                OUT.xloc = {DAT.xloc}; OUT.yloc = {DAT.yloc}; OUT.zloc = {DAT.zloc}; 
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
            % update DAT.centre from GUI fields 
            DAT.centre(1) = str2double(DAT.panelobs(5).String);
            DAT.centre(2) = str2double(DAT.panelobs(6).String);

            if numel(DAT.centre) < 3
                DAT.centre(3) = 80; % default z plane
            end

            if strcmp(DAT.state,'CircleEdit')
                [DAT.xloc,DAT.yloc,DAT.zloc, err] = CompleteROI(DAT);
                if err == 1
                    OUT.buttonfunc = 'updatestatus';
                    OUT.info = 'Circle out of bounds';
                    return
                end
                OUT.xloc = {DAT.xloc}; OUT.yloc = {DAT.yloc}; OUT.zloc = {DAT.zloc}; 
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
            if strcmp(DAT.state,'CircleEdit')  
                % nudge the center upward (in the Y direction)
                DAT.centre(2) = DAT.centre(2)-0.5;
                % update the GUi display for the Y position
                DAT.panelobs(6).String = num2str(round(DAT.centre(2)*10)/10);
                % recalculate the circle region
                [DAT.xloc,DAT.yloc,DAT.zloc,err] = CompleteROI(DAT);
                if err == 1
                    OUT.buttonfunc = 'updatestatus';
                    OUT.info = 'Circle out of bounds';
                    return
                end
                % package coordinates for rendering 
                OUT.xloc = {DAT.xloc}; OUT.yloc = {DAT.yloc}; OUT.zloc = {DAT.zloc}; 
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
            if strcmp(DAT.state,'CircleEdit')                
                DAT.centre(2) = DAT.centre(2)+0.5;
                DAT.panelobs(6).String = num2str(round(DAT.centre(2)*10)/10);
                [DAT.xloc,DAT.yloc,DAT.zloc,err] = CompleteROI(DAT);
                if err == 1
                    OUT.buttonfunc = 'updatestatus';
                    OUT.info = 'Circle out of bounds';
                    return
                end
                OUT.xloc = {DAT.xloc}; OUT.yloc = {DAT.yloc}; OUT.zloc = {DAT.zloc}; 
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
            if strcmp(DAT.state,'CircleEdit')                
                DAT.centre(1) = DAT.centre(1)-0.5;
                DAT.panelobs(5).String = num2str(round(DAT.centre(1)*10)/10);
                [DAT.xloc,DAT.yloc,DAT.zloc,err] = CompleteROI(DAT);
                if err == 1
                    OUT.buttonfunc = 'updatestatus';
                    OUT.info = 'Circle out of bounds';
                    return
                end
                OUT.xloc = {DAT.xloc}; OUT.yloc = {DAT.yloc}; OUT.zloc = {DAT.zloc};
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
            if strcmp(DAT.state,'CircleEdit')                
                DAT.centre(1) = DAT.centre(1)+0.5;
                DAT.panelobs(5).String = num2str(round(DAT.centre(1)*10)/10);
                [DAT.xloc,DAT.yloc,DAT.zloc,err] = CompleteROI(DAT);
                if err == 1
                    OUT.buttonfunc = 'updatestatus';
                    OUT.info = 'Circle out of bounds';
                    return
                end
                OUT.xloc = {DAT.xloc}; OUT.yloc = {DAT.yloc}; OUT.zloc = {DAT.zloc};                 
                OUT.clr = [0.9 0.6 0.6];
                UpdateTempRegion(OUT,tab,axnum) 
            end
            ResetFocus(src,event);
        end 
       

        function OUT = BuildROI(DAT,datapoint,event,ImageSlice) 
            if event.Button == 1
                if DAT.userad == 1 
                    if DAT.usecentre == 0
                        % set the circle center to the click location
                        if numel(datapoint) < 3
                            datapoint(3) = 1; % default z if not given
                        end 
                        DAT.centre = datapoint(1:3);
                        DAT.panelobs(5).String = num2str(round(DAT.centre(1)*10)/10);
                        DAT.panelobs(6).String = num2str(round(DAT.centre(2)*10)/10);
                    end
                    [DAT.xloc,DAT.yloc,DAT.zloc,err] = CompleteROI(DAT);
                    if err == 1
                        OUT.buttonfunc = 'updatestatus';
                        OUT.info = 'Circle out of bounds';
                        return
                    end

                    % package ROI info
                    OUT.xloc = {DAT.xloc}; OUT.yloc = {DAT.yloc}; OUT.zloc = {DAT.zloc}; 
                    OUT.clr = [0.9 0.6 0.6];
                    OUT.buttonfunc = 'updateregion';
                    DAT.info = 'Right click to accept circle';
                    OUT.info = DAT.info;
                    DAT.state = 'CircleEdit';
                else
                    error
                end
            else
                if strcmp(DAT.state,'CircleEdit')
                    OUT.xloc = {DAT.xloc}; OUT.yloc = {DAT.yloc}; OUT.zloc = {DAT.zloc}; 
                    OUT.buttonfunc = 'updatefinish';
                    DAT.info = 'Left click to start new';
                    OUT.info = DAT.info;
                    DAT.state = 'Start';
                else
                    OUT.buttonfunc = 'return';
                end
            end
        end

        function [xloc, yloc, zloc,err] = CompleteROI(DAT)
            err = 0; 

            % check if the circle would be out of bounds 
            if DAT.rad <= 0
                err = 1; 
                xloc = []; yloc = []; zloc = [];
                return
            end

            % generate theta values
            circlen = max(20, round(5*DAT.rad));
            theta = linspace(0, 2*pi, circlen);

            % compute x and y positions
            xloc = gather(DAT.centre(1) + DAT.rad * cos(theta));
            yloc = gather(DAT.centre(2) + DAT.rad * sin(theta));

            % since it's a 2D circle in one plane, z is constant in the xy
            % plane

            % zloc = ones(size(theta))* DAT.centre(3); 
            zloc = gather(DAT.centre(3)); 

        end

    end  
end
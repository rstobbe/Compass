%================================================================
%  
%================================================================

classdef RoiSeedClass < handle

    properties (SetAccess = private)
        seed;
        seeddir;
        xloc,yloc,zloc;
        state;
        panelobs;
        roicreatesel;
        pointer,status,info;
        maxval;
    end
    
    methods
        function DAT = RoiSeedClass
            DAT.seed = 0;
            DAT.seeddir = 1; 
            DAT.xloc = []; DAT.yloc = []; DAT.zloc = [];
            DAT.maxval = 0;
            DAT.state = 'Start'; 
            DAT.panelobs = gobjects(0);
            DAT.roicreatesel = 2;
            DAT.pointer = 'crosshair';
            DAT.status = 'Seed Drawing Tool Active';
            DAT.info = 'Left click';
        end
        function DAT = Setup(DAT,IMAGEANLZ)
            horz = 0.38;
            if isempty(IMAGEANLZ.FullContrast)
                DAT.maxval = 100;
            else
                DAT.maxval = round(IMAGEANLZ.FullContrast,2,'significant');
            end
            DAT.seed = round(DAT.maxval/2,2,'significant');
            DAT.panelobs = uicontrol('Parent',IMAGEANLZ.FIGOBJS.ROITab,'Style','text','Tag',num2str(IMAGEANLZ.axnum),'BackgroundColor',IMAGEANLZ.FIGOBJS.Colours.BGcolour,'ForegroundColor',[0.8 0.8 0.8],'String','Seed Value','HorizontalAlignment','right','Fontsize',7,'Units','normalized','Position',[horz+0.05 0.39 0.07 0.14],'Enable','inactive','ButtonDownFcn',@ResetFocus);
            DAT.panelobs(2) = uicontrol('Parent',IMAGEANLZ.FIGOBJS.ROITab,'Style','slider','Tag',num2str(IMAGEANLZ.axnum),'BackgroundColor',[0.8 0.8 0.8],'ForegroundColor',IMAGEANLZ.FIGOBJS.Colours.BGcolour,'Units','normalized','Position',[horz+0.13 0.4 0.25 0.14],'Value',DAT.seed,'SliderStep',[0.01 0.1],'Max',DAT.maxval,'CallBack',@DAT.SetSeedSlider);    
            DAT.panelobs(3) = uicontrol('Parent',IMAGEANLZ.FIGOBJS.ROITab,'Style','edit','Tag',num2str(IMAGEANLZ.axnum),'BackgroundColor',IMAGEANLZ.FIGOBJS.Colours.BGcolour,'ForegroundColor',[0.8 0.8 0.8],'String',num2str(DAT.seed),'HorizontalAlignment','left','Fontsize',6,'FontWeight','Bold','Enable','on','Units','normalized','Position',[horz+0.39 0.4 0.04 0.14],'CallBack',@DAT.SetSeedEdit,'KeyPressFcn',@DAT.IndSeedEdit);    
            DAT.panelobs(4) = uicontrol('Parent',IMAGEANLZ.FIGOBJS.ROITab,'Style','popupmenu','Tag',num2str(IMAGEANLZ.axnum),'BackgroundColor',IMAGEANLZ.FIGOBJS.Colours.BGcolour,'ForegroundColor',[0.8 0.8 0.8],'String',{'Above','Below'},'Fontsize',6,'Enable','on','Units','normalized','Position',[horz+0.44 0.4 0.07 0.14],'CallBack',@DAT.SetSeedDir,'Enable','on'); 
            DAT.status = 'Seed Drawing Tool Active';
            DAT.info = 'Left click';
        end
        function DAT = RedrawSetup(DAT)
            DAT.state = 'Start';
            DAT.seed = 0.5;
            DAT.xloc = []; DAT.yloc = []; DAT.zloc = [];
            DAT.status = 'Seeding Redraw Tool Active';
            DAT.info = 'Left click';
        end
        function Initialize(DAT)
            DAT.state = 'Start';
            DAT.xloc = []; DAT.yloc = []; DAT.zloc = [];
            DAT.status = 'Seed Drawing Tool Active';
            DAT.info = 'Left click';
        end
        function Copy(DAT,DAT2)
            DAT.seed = DAT2.seed;
            DAT.seeddir = DAT2.seeddir;
        end
        function ResetPanel(DAT) 
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
        function OUT = BuildROI(DAT,datapoint,event,ImageSlice)
            if DAT.seeddir == 1
                [DAT.xloc,DAT.yloc,DAT.zloc,err] = SeedRoi(DAT,datapoint,ImageSlice);  
            else
                [DAT.xloc,DAT.yloc,DAT.zloc,err] = SeedRoiN(DAT,datapoint,ImageSlice);  
            end
            if err == 0
                OUT.buttonfunc = 'updatefinish';
                OUT.info = 'Left click';
                OUT.xloc{1} = [DAT.xloc DAT.xloc(1)]; OUT.yloc{1} = [DAT.yloc DAT.yloc(1)]; OUT.zloc{1} = DAT.zloc;
            else
                OUT.buttonfunc = 'return';
                OUT.info = 'Left click';
            end 
        end
        function DAT = SetSeedSlider(DAT,src,event)
            DAT.seed = src.Value;
            DAT.panelobs(3).String = num2str(round(DAT.seed,2,'significant'));
            ResetFocus(src,event);
        end
        function DAT = SetSeedEdit(DAT,src,event)
            DAT.seed = round(str2double(src.String),3,'significant');
            if DAT.seed > DAT.maxval
                DAT.seed = DAT.maxval;
            end
            DAT.panelobs(3).String = num2str(DAT.seed);
            DAT.panelobs(2).Value = DAT.seed;
            ResetFocus(src,event);
            DAT.panelobs(3).ForegroundColor = [1 1 1];
        end
        function DAT = SetSeedDir(DAT,src,event) 
            DAT.seeddir = src.Value;
            ResetFocus(src,event);
        end
        function DAT = IndSeedEdit(DAT,src,event) 
            DAT.panelobs(3).ForegroundColor = [0.8 0.5 0.3];
        end
    end
end
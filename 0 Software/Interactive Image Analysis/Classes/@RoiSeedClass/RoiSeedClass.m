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
            DAT.info = 'Left click to start';
        end
        function DAT = Setup(DAT,IMAGEANLZ)
            horz = 0.28;
            if isempty(IMAGEANLZ.MAXCONTRAST)
                DAT.maxval = 100;
            else
                DAT.maxval = floor(IMAGEANLZ.MAXCONTRAST);
            end
            DAT.seed = DAT.maxval/2;
            DAT.panelobs = uicontrol('Parent',IMAGEANLZ.FIGOBJS.ROITab,'Style','text','Tag',num2str(IMAGEANLZ.axnum),'BackgroundColor',IMAGEANLZ.FIGOBJS.Colours.BGcolour,'ForegroundColor',[0.8 0.8 0.8],'String','Seed Value','HorizontalAlignment','right','Fontsize',7,'Units','normalized','Position',[horz+0.05 0.39 0.07 0.14],'Enable','inactive','ButtonDownFcn',@ResetFocus);
            DAT.panelobs(2) = uicontrol('Parent',IMAGEANLZ.FIGOBJS.ROITab,'Style','slider','Tag',num2str(IMAGEANLZ.axnum),'BackgroundColor',[0.8 0.8 0.8],'ForegroundColor',IMAGEANLZ.FIGOBJS.Colours.BGcolour,'Units','normalized','Position',[horz+0.13 0.4 0.25 0.14],'Value',DAT.seed,'SliderStep',[0.01*DAT.maxval 0.1*DAT.maxval],'Max',DAT.maxval,'CallBack',@DAT.SetSeedSlider);    
            DAT.panelobs(3) = uicontrol('Parent',IMAGEANLZ.FIGOBJS.ROITab,'Style','edit','Tag',num2str(IMAGEANLZ.axnum),'BackgroundColor',IMAGEANLZ.FIGOBJS.Colours.BGcolour,'ForegroundColor',[0.8 0.8 0.8],'String',num2str(DAT.seed),'HorizontalAlignment','left','Fontsize',6,'FontWeight','Bold','Enable','on','Units','normalized','Position',[horz+0.39 0.4 0.04 0.14],'CallBack',@DAT.SetSeedEdit);    
            DAT.panelobs(4) = uicontrol('Parent',IMAGEANLZ.FIGOBJS.ROITab,'Style','popupmenu','Tag',num2str(IMAGEANLZ.axnum),'BackgroundColor',IMAGEANLZ.FIGOBJS.Colours.BGcolour,'ForegroundColor',[0.8 0.8 0.8],'String',{'Above','Below'},'Fontsize',6,'Enable','on','Units','normalized','Position',[horz+0.44 0.4 0.07 0.14],'CallBack',@DAT.SetSeedDir,'Enable','on'); 
            DAT.status = 'Seed Drawing Tool Active';
            DAT.info = 'Left click to start';
        end
        function Initialize(DAT)
            DAT.state = 'Start';
            DAT.xloc = []; DAT.yloc = []; DAT.zloc = [];
            DAT.status = 'Seed Drawing Tool Active';
            DAT.info = 'Left click to start';
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
                OUT.info = 'Left click to start';
                OUT.xloc{1} = [DAT.xloc DAT.xloc(1)]; OUT.yloc{1} = [DAT.yloc DAT.yloc(1)]; OUT.zloc{1} = DAT.zloc;
            else
                OUT.buttonfunc = 'return';
                OUT.info = 'Left click to start';
            end 
        end
        function DAT = SetSeedSlider(DAT,src,event)
            DAT.seed = src.Value;
            if DAT.seed >= 10
                DAT.panelobs(3).String = num2str(floor(DAT.seed*10)/10);
            else 
                DAT.panelobs(3).String = num2str(floor(DAT.seed*100)/100);
            end
            ResetFocus(src,event);
        end
        function DAT = SetSeedEdit(DAT,src,event)
            DAT.seed = floor(str2double(src.String)*1000)/1000;
            if DAT.seed > DAT.maxval
                DAT.seed = DAT.maxval;
            end
            DAT.panelobs(3).String = num2str(DAT.seed);
            DAT.panelobs(2).Value = DAT.seed;
            ResetFocus(src,event);
        end
        function DAT = SetSeedDir(DAT,src,event) 
            DAT.seeddir = src.Value;
        end
    end
end
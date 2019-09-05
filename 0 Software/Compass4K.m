function Compass4K(doCuda,doPaths)

%================================================================
% Initialize
%================================================================
disp('Starting');
%clear global
clear global COMPASSINFO
clear global DEFFILEGBL
clear global FIGOBJS
clear global IMAGEANLZ
clear global RWSUIGBL
clear global SCRPTGBL
clear global SCRPTIPTGBL
clear global SCRPTPATHS
clear global TOTALGBL

test = findobj;
if length(test) > 1
    delete(test)
end
if nargin==0
    doCuda = 1;
    doPaths = 1;
end
InitFcn4K(doCuda,doPaths);

%------------------------------------------------
% Figure Properties
%------------------------------------------------
global FIGOBJS
BGcolour = [0.149 0.149 0.241];
BGcolour2 = [0.1 0.1 0.1];
FIGOBJS.Colours.BGcolour = BGcolour;
Compass = figure;
Compass.Name = ['COMPASS (',169,' R.W.Stobbe 2019)'];
Compass.NumberTitle = 'off';
Compass.Position = [140 75 2308 1300];
Compass.MenuBar = 'none';
Compass.DockControls = 'off';
Compass.Resize = 'on';
Compass.Renderer = 'opengl';
Compass.WindowKeyPressFcn = @RWSUI_KeyPressControl;
Compass.WindowKeyReleaseFcn = @RWSUI_KeyReleaseControl;
Compass.GraphicsSmoothing = 'off';
Compass.WindowScrollWheelFcn = @ScrollWheelControl;
Compass.WindowButtonMotionFcn = @RWSUI_MouseMoveControl;
Compass.HitTest = 'off';
Compass.Visible = 'off';
FIGOBJS.Compass = Compass;

%------------------------------------------------
% Menu Properties
%------------------------------------------------
%Menu = uimenu(Compass,'Label','Run');
%RunMenu = uimenu(Menu,'Label','Select Composite Script',

%------------------------------------------------
% Tab Properties
%------------------------------------------------
tabgp = uitabgroup(Compass,'Position',[0 0 1 1]);
IM = uitab(tabgp,'Title','Imaging','Tag','IM');
IM2 = uitab(tabgp,'Title','Imaging2','Tag','IM2');
IM3 = uitab(tabgp,'Title','Imaging3','Tag','IM3');
IM4 = uitab(tabgp,'Title','Imaging4','Tag','IM4');
ACC = uitab(tabgp,'Title','Script1','Tag','ACC');
ACC2 = uitab(tabgp,'Title','Script2','Tag','ACC2');
ACC3 = uitab(tabgp,'Title','Script3','Tag','ACC3');
ACC4 = uitab(tabgp,'Title','Script4','Tag','ACC4');
IM.BackgroundColor = BGcolour;
IM2.BackgroundColor = BGcolour;
IM3.BackgroundColor = BGcolour;
IM4.BackgroundColor = BGcolour;
ACC.BackgroundColor = BGcolour;
ACC2.BackgroundColor = BGcolour;
ACC3.BackgroundColor = BGcolour;
ACC4.BackgroundColor = BGcolour;

FIGOBJS.TABGP = tabgp;
FIGOBJS.IM.Tab = IM;
FIGOBJS.IM2.Tab = IM2;
FIGOBJS.IM3.Tab = IM3;
FIGOBJS.IM4.Tab = IM4;
FIGOBJS.ACC.Tab = ACC;
FIGOBJS.ACC2.Tab = ACC2;
FIGOBJS.ACC3.Tab = ACC3;
FIGOBJS.ACC4.Tab = ACC4;

%================================================================
% Status (all Tabs)
%================================================================
tablabs = {'IM','IM2','IM3','IM4','ACC','ACC2','ACC3','ACC4'};
tabs = {IM,IM2,IM3,IM4,ACC,ACC2,ACC3,ACC4};
for n = 1:length(tablabs)
    blank = uicontrol('Parent',tabs{n},'Style','text');
    blank.Units = 'normalized';
    blank.Position = [0.805 0.01 0.19 0.049];
    blank.Enable = 'inactive';
    blank.ButtonDownFcn = @ResetFocus;
    for m = 1:3
        FIGOBJS.Status(n,4-m) = uicontrol('Parent',tabs{n},'Style','edit');
        FIGOBJS.Status(n,4-m).Units = 'normalized';
        FIGOBJS.Status(n,4-m).Position = [0.805 0.013+(m-1)*0.015 0.19 0.0125]; 
        FIGOBJS.Status(n,4-m).FontSize = 7;
        FIGOBJS.Status(n,4-m).Enable = 'inactive'; 
        FIGOBJS.Status(n,4-m).Visible = 'off';
        FIGOBJS.Status(n,4-m).ButtonDownFcn = @ResetFocus;
    end
end

%================================================================
% List Box
%================================================================
tablabs = {'IM','IM2','IM3','IM4'};
tabs = {IM,IM2,IM3,IM4};
for n = 1:length(tablabs)
    FIGOBJS.(tablabs{n}).GblListTabGroup = uitabgroup(tabs{n},'Position',[0.805 0.069 0.190 0.260]);
    FIGOBJS.(tablabs{n}).GblListTab = uitab(FIGOBJS.(tablabs{n}).GblListTabGroup,'Title','Loaded');    
    FIGOBJS.(tablabs{n}).GblList = uicontrol('Parent',FIGOBJS.(tablabs{n}).GblListTab,'Style','listbox');
    FIGOBJS.(tablabs{n}).GblList.Units = 'normalized';
    FIGOBJS.(tablabs{n}).GblList.Position = [0 0 1 1]; 
    FIGOBJS.(tablabs{n}).GblList.FontSize = 8;
    FIGOBJS.(tablabs{n}).GblList.Callback = @HandleIM_TOTALGBL;
    FIGOBJS.(tablabs{n}).GblList.ButtonDownFcn = @OptionsIM_TOTALGBL;
    FIGOBJS.(tablabs{n}).GblList.Value = [];
    FIGOBJS.(tablabs{n}).GblList.BackgroundColor = BGcolour;
    FIGOBJS.(tablabs{n}).GblList.ForegroundColor = [0.8 0.8 0.8];
    FIGOBJS.(tablabs{n}).GblList.Max = 2;                   % allow multiple selection 
    FIGOBJS.(tablabs{n}).GblList.Min = 0;
end
tablabs = {'ACC','ACC2','ACC3','ACC4'};
tabs = {ACC,ACC2,ACC3,ACC4};
for n = 1:length(tablabs)
    FIGOBJS.(tablabs{n}).GblListTabGroup = uitabgroup(tabs{n},'Position',[0.805 0.073 0.190 0.256]);
    FIGOBJS.(tablabs{n}).GblListTab = uitab(FIGOBJS.(tablabs{n}).GblListTabGroup,'Title','Loaded');    
    FIGOBJS.(tablabs{n}).GblList = uicontrol('Parent',FIGOBJS.(tablabs{n}).GblListTab,'Style','listbox');
    FIGOBJS.(tablabs{n}).GblList.Units = 'normalized';
    FIGOBJS.(tablabs{n}).GblList.Position = [0 0 1 1]; 
    FIGOBJS.(tablabs{n}).GblList.FontSize = 8;
    FIGOBJS.(tablabs{n}).GblList.Callback = @HandleACC_TOTALGBL;
    FIGOBJS.(tablabs{n}).GblList.ButtonDownFcn = @OptionsACC_TOTALGBL;
    FIGOBJS.(tablabs{n}).GblList.Value = [];
    FIGOBJS.(tablabs{n}).GblList.BackgroundColor = BGcolour;
    FIGOBJS.(tablabs{n}).GblList.ForegroundColor = [0.8 0.8 0.8];
    FIGOBJS.(tablabs{n}).GblList.Max = 2;                   % allow multiple selection 
    FIGOBJS.(tablabs{n}).GblList.Min = 0;
end

%================================================================
% Imaging Tab
%================================================================
FIGOBJS.IM.TabGroup = uitabgroup(IM,'Position',[0.005 0.01 0.795 0.98],'SelectionChangedFcn',@ImageTabChange);
for n = 1:10
    FIGOBJS.IM.ImTab(n) = uitab(FIGOBJS.IM.TabGroup,'Title',['Image',num2str(n)],'Tag',['ImTab',num2str(n)]);
    FIGOBJS.IM.ImPan(n) = uipanel('Parent',FIGOBJS.IM.ImTab(n));
    FIGOBJS.IM.ImPan(n).BackgroundColor = BGcolour2;
    %FIGOBJS.IM.ImPan.Position = [0.005 0.01 0.795 0.98];
    FIGOBJS.IM.ImPan(n).Position = [0 0 1 1];
    FIGOBJS.IM.ImPan(n).HitTest = 'off';
    FIGOBJS.IM.ImageName(n) = uicontrol('Parent',FIGOBJS.IM.ImPan(n),'Style','text','BackgroundColor',BGcolour2,'ForegroundColor',[1,1,0.5],'String','','HorizontalAlignment','left','Fontsize',8,'Units','normalized','Position',[0.01 0.98 0.12 0.015],'Enable','inactive','ButtonDownFcn',@ResetFocus);
    FIGOBJS.IM.VALUElab(n) = uicontrol('Parent',FIGOBJS.IM.ImPan(n),'Style','text','BackgroundColor',BGcolour2,'ForegroundColor',[0.8 0.8 0.8],'String','Value','HorizontalAlignment','left','Fontsize',8,'Units','normalized','Position',[0.01 0.96 0.08 0.01],'Enable','inactive','ButtonDownFcn',@ResetFocus,'Visible','Off');
    FIGOBJS.IM.Xlab(n) = uicontrol('Parent',FIGOBJS.IM.ImPan(n),'Style','text','BackgroundColor',BGcolour2,'ForegroundColor',[0.8 0.8 0.8],'String','X (mm)','HorizontalAlignment','left','Fontsize',8,'Units','normalized','Position',[0.01 0.945 0.05 0.01],'Enable','inactive','ButtonDownFcn',@ResetFocus,'Visible','Off');
    FIGOBJS.IM.Ylab(n) = uicontrol('Parent',FIGOBJS.IM.ImPan(n),'Style','text','BackgroundColor',BGcolour2,'ForegroundColor',[0.8 0.8 0.8],'String','Y (mm)','HorizontalAlignment','left','Fontsize',8,'Units','normalized','Position',[0.01 0.93 0.05 0.01],'Enable','inactive','ButtonDownFcn',@ResetFocus,'Visible','Off');
    FIGOBJS.IM.SLICElab(n) = uicontrol('Parent',FIGOBJS.IM.ImPan(n),'Style','text','BackgroundColor',BGcolour2,'ForegroundColor',[0.8 0.8 0.8],'String','Slice','HorizontalAlignment','left','Fontsize',8,'Units','normalized','Position',[0.01 0.915 0.05 0.01],'Enable','inactive','ButtonDownFcn',@ResetFocus,'Visible','Off');
    FIGOBJS.IM.DIM4lab(n) = uicontrol('Parent',FIGOBJS.IM.ImPan(n),'Style','text','BackgroundColor',BGcolour2,'ForegroundColor',[0.8 0.8 0.8],'String','Dim4','HorizontalAlignment','left','Fontsize',8,'Units','normalized','Position',[0.01 0.9 0.05 0.01],'Enable','inactive','ButtonDownFcn',@ResetFocus,'Visible','Off');
    FIGOBJS.IM.DIM5lab(n) = uicontrol('Parent',FIGOBJS.IM.ImPan(n),'Style','text','BackgroundColor',BGcolour2,'ForegroundColor',[0.8 0.8 0.8],'String','Dim5','HorizontalAlignment','left','Fontsize',8,'Units','normalized','Position',[0.01 0.885 0.05 0.01],'Enable','inactive','ButtonDownFcn',@ResetFocus,'Visible','Off');
    FIGOBJS.IM.DIM6lab(n) = uicontrol('Parent',FIGOBJS.IM.ImPan(n),'Style','text','BackgroundColor',BGcolour2,'ForegroundColor',[0.8 0.8 0.8],'String','Dim6','HorizontalAlignment','left','Fontsize',8,'Units','normalized','Position',[0.01 0.87 0.05 0.01],'Enable','inactive','ButtonDownFcn',@ResetFocus,'Visible','Off');
    FIGOBJS.IM.CURVAL(n) = uicontrol('Parent',FIGOBJS.IM.ImPan(n),'Style','text','BackgroundColor',BGcolour2,'ForegroundColor',[1,1,0.5],'String','','HorizontalAlignment','left','Fontsize',8,'Units','normalized','Position',[0.06 0.96 0.03 0.01],'Enable','inactive','ButtonDownFcn',@ResetFocus);
    FIGOBJS.IM.X(n) = uicontrol('Parent',FIGOBJS.IM.ImPan(n),'Style','text','BackgroundColor',BGcolour2,'ForegroundColor',[1,1,0.5],'String','','HorizontalAlignment','left','Fontsize',8,'Units','normalized','Position',[0.06 0.945 0.03 0.01],'Enable','inactive','ButtonDownFcn',@ResetFocus);
    FIGOBJS.IM.Y(n) = uicontrol('Parent',FIGOBJS.IM.ImPan(n),'Style','text','BackgroundColor',BGcolour2,'ForegroundColor',[1,1,0.5],'String','','HorizontalAlignment','left','Fontsize',8,'Units','normalized','Position',[0.06 0.93 0.03 0.01],'Enable','inactive','ButtonDownFcn',@ResetFocus);
    FIGOBJS.IM.SLICE(n) = uicontrol('Parent',FIGOBJS.IM.ImPan(n),'Style','text','BackgroundColor',BGcolour2,'ForegroundColor',[1,1,0.5],'String','','HorizontalAlignment','left','Fontsize',8,'Units','normalized','Position',[0.06 0.915 0.03 0.01],'Enable','inactive','ButtonDownFcn',@ResetFocus);
    FIGOBJS.IM.DIM4(n) = uicontrol('Parent',FIGOBJS.IM.ImPan(n),'Style','text','BackgroundColor',BGcolour2,'ForegroundColor',[1,1,0.5],'String','','HorizontalAlignment','left','Fontsize',8,'Units','normalized','Position',[0.06 0.9 0.03 0.01],'Enable','inactive','ButtonDownFcn',@ResetFocus);
    FIGOBJS.IM.DIM5(n) = uicontrol('Parent',FIGOBJS.IM.ImPan(n),'Style','text','BackgroundColor',BGcolour2,'ForegroundColor',[1,1,0.5],'String','','HorizontalAlignment','left','Fontsize',8,'Units','normalized','Position',[0.06 0.885 0.03 0.01],'Enable','inactive','ButtonDownFcn',@ResetFocus);
    FIGOBJS.IM.DIM6(n) = uicontrol('Parent',FIGOBJS.IM.ImPan(n),'Style','text','BackgroundColor',BGcolour2,'ForegroundColor',[1,1,0.5],'String','','HorizontalAlignment','left','Fontsize',8,'Units','normalized','Position',[0.06 0.87 0.03 0.01],'Enable','inactive','ButtonDownFcn',@ResetFocus);
    FIGOBJS.IM.ImAxes(n) = axes('Parent',FIGOBJS.IM.ImPan(n));
    FIGOBJS.IM.ImAxes(n).Tag = num2str(n);
    FIGOBJS.IM.ImAxes(n).NextPlot = 'replacechildren';
    FIGOBJS.IM.ImAxes(n).Position = [0.085 0 0.915 1];
    FIGOBJS.IM.ImAxes(n).ButtonDownFcn = @ButtonPressControl;
    FIGOBJS.IM.ImAxes(n).PickableParts = 'all';
    FIGOBJS.IM.ImAxes(n).Visible = 'off';
    FIGOBJS.IM.ImAxes(n).Interruptible = 'off';
    FIGOBJS.IM.ImAxes(n).Color = BGcolour;
end
FIGOBJS.IM.AspectRatio = 1.4;
FIGOBJS.IM.CurrentImage = 0;

%================================================================
% Imaging2 Tab
%================================================================
FIGOBJS.IM2.ImPan(1) = uipanel('Parent',IM2);
FIGOBJS.IM2.ImPan(1).BackgroundColor = BGcolour2;
FIGOBJS.IM2.ImPan(1).Position = [0.005 0.12 0.395 0.87];
FIGOBJS.IM2.ImPan(2) = uipanel('Parent',IM2);
FIGOBJS.IM2.ImPan(2).BackgroundColor = BGcolour2;
FIGOBJS.IM2.ImPan(2).Position = [0.405 0.12 0.395 0.87];

for n = 1:2
    FIGOBJS.IM2.ImageName(n) = uicontrol('Parent',FIGOBJS.IM2.ImPan(n),'Style','text','BackgroundColor',BGcolour2,'ForegroundColor',[1,1,0.5],'String','','HorizontalAlignment','left','Fontsize',8,'Units','normalized','Position',[0.01 0.98 0.4 0.015],'Enable','inactive','ButtonDownFcn',@ResetFocus);
end
for n = 1:2
    FIGOBJS.IM2.VALUElab(n) = uicontrol('Parent',FIGOBJS.IM2.ImPan(n),'Style','text','BackgroundColor',BGcolour2,'ForegroundColor',[0.8 0.8 0.8],'String','Value','HorizontalAlignment','left','Fontsize',8,'Units','normalized','Position',[0.15 0.02 0.05 0.015],'Enable','inactive','ButtonDownFcn',@ResetFocus,'Visible','Off');
    FIGOBJS.IM2.Xlab(n) = uicontrol('Parent',FIGOBJS.IM2.ImPan(n),'Style','text','BackgroundColor',BGcolour2,'ForegroundColor',[0.8 0.8 0.8],'String','X (mm)','HorizontalAlignment','left','Fontsize',8,'Units','normalized','Position',[0.225 0.02 0.05 0.015],'Enable','inactive','ButtonDownFcn',@ResetFocus,'Visible','Off');
    FIGOBJS.IM2.Ylab(n) = uicontrol('Parent',FIGOBJS.IM2.ImPan(n),'Style','text','BackgroundColor',BGcolour2,'ForegroundColor',[0.8 0.8 0.8],'String','Y (mm)','HorizontalAlignment','left','Fontsize',8,'Units','normalized','Position',[0.3 0.02 0.05 0.015],'Enable','inactive','ButtonDownFcn',@ResetFocus,'Visible','Off');
    FIGOBJS.IM2.Zlab(n) = uicontrol('Parent',FIGOBJS.IM2.ImPan(n),'Style','text','BackgroundColor',BGcolour2,'ForegroundColor',[0.8 0.8 0.8],'String','Z (mm)','HorizontalAlignment','left','Fontsize',8,'Units','normalized','Position',[0.375 0.02 0.05 0.015],'Enable','inactive','ButtonDownFcn',@ResetFocus,'Visible','Off');
    FIGOBJS.IM2.XPixlab(n) = uicontrol('Parent',FIGOBJS.IM2.ImPan(n),'Style','text','BackgroundColor',BGcolour2,'ForegroundColor',[0.8 0.8 0.8],'String','X (pix)','HorizontalAlignment','left','Fontsize',8,'Units','normalized','Position',[0.45 0.02 0.05 0.015],'Enable','inactive','ButtonDownFcn',@ResetFocus,'Visible','Off');
    FIGOBJS.IM2.YPixlab(n) = uicontrol('Parent',FIGOBJS.IM2.ImPan(n),'Style','text','BackgroundColor',BGcolour2,'ForegroundColor',[0.8 0.8 0.8],'String','Y (pix)','HorizontalAlignment','left','Fontsize',8,'Units','normalized','Position',[0.525 0.02 0.05 0.015],'Enable','inactive','ButtonDownFcn',@ResetFocus,'Visible','Off');
    FIGOBJS.IM2.ZPixlab(n) = uicontrol('Parent',FIGOBJS.IM2.ImPan(n),'Style','text','BackgroundColor',BGcolour2,'ForegroundColor',[0.8 0.8 0.8],'String','Z (pix)','HorizontalAlignment','left','Fontsize',8,'Units','normalized','Position',[0.6 0.02 0.05 0.015],'Enable','inactive','ButtonDownFcn',@ResetFocus,'Visible','Off');
    FIGOBJS.IM2.DIM4lab(n) = uicontrol('Parent',FIGOBJS.IM2.ImPan(n),'Style','text','BackgroundColor',BGcolour2,'ForegroundColor',[0.8 0.8 0.8],'String','Dim4','HorizontalAlignment','left','Fontsize',8,'Units','normalized','Position',[0.675 0.02 0.05 0.015],'Enable','inactive','ButtonDownFcn',@ResetFocus,'Visible','Off');
    FIGOBJS.IM2.DIM5lab(n) = uicontrol('Parent',FIGOBJS.IM2.ImPan(n),'Style','text','BackgroundColor',BGcolour2,'ForegroundColor',[0.8 0.8 0.8],'String','Dim5','HorizontalAlignment','left','Fontsize',8,'Units','normalized','Position',[0.75 0.02 0.05 0.015],'Enable','inactive','ButtonDownFcn',@ResetFocus,'Visible','Off');
    FIGOBJS.IM2.DIM6lab(n) = uicontrol('Parent',FIGOBJS.IM2.ImPan(n),'Style','text','BackgroundColor',BGcolour2,'ForegroundColor',[0.8 0.8 0.8],'String','Dim6','HorizontalAlignment','left','Fontsize',8,'Units','normalized','Position',[0.825 0.02 0.05 0.015],'Enable','inactive','ButtonDownFcn',@ResetFocus,'Visible','Off');
    FIGOBJS.IM2.POINTERlab(n) = uicontrol('Parent',FIGOBJS.IM2.ImPan(n),'Style','text','BackgroundColor',BGcolour2,'ForegroundColor',[0.8 0.8 0.8],'String','Pointer','HorizontalAlignment','left','Fontsize',8,'Units','normalized','Position',[0.05 0.005 0.05 0.015],'Enable','inactive','ButtonDownFcn',@ResetFocus,'Visible','Off');
    FIGOBJS.IM2.CURVAL(n) = uicontrol('Parent',FIGOBJS.IM2.ImPan(n),'Style','text','BackgroundColor',BGcolour2,'ForegroundColor',[1,1,0.5],'String','','HorizontalAlignment','left','Fontsize',8,'Units','normalized','Position',[0.155 0.005 0.05 0.015],'Enable','inactive','ButtonDownFcn',@ResetFocus);
    FIGOBJS.IM2.X(n) = uicontrol('Parent',FIGOBJS.IM2.ImPan(n),'Style','text','BackgroundColor',BGcolour2,'ForegroundColor',[1,1,0.5],'String','','HorizontalAlignment','left','Fontsize',8,'Units','normalized','Position',[0.230 0.005 0.05 0.015],'Enable','inactive','ButtonDownFcn',@ResetFocus);
    FIGOBJS.IM2.Y(n) = uicontrol('Parent',FIGOBJS.IM2.ImPan(n),'Style','text','BackgroundColor',BGcolour2,'ForegroundColor',[1,1,0.5],'String','','HorizontalAlignment','left','Fontsize',8,'Units','normalized','Position',[0.306 0.005 0.05 0.015],'Enable','inactive','ButtonDownFcn',@ResetFocus);
    FIGOBJS.IM2.Z(n) = uicontrol('Parent',FIGOBJS.IM2.ImPan(n),'Style','text','BackgroundColor',BGcolour2,'ForegroundColor',[1,1,0.5],'String','','HorizontalAlignment','left','Fontsize',8,'Units','normalized','Position',[0.380 0.005 0.05 0.015],'Enable','inactive','ButtonDownFcn',@ResetFocus);
    FIGOBJS.IM2.XPix(n) = uicontrol('Parent',FIGOBJS.IM2.ImPan(n),'Style','text','BackgroundColor',BGcolour2,'ForegroundColor',[1,1,0.5],'String','','HorizontalAlignment','left','Fontsize',8,'Units','normalized','Position',[0.455 0.005 0.05 0.015],'Enable','inactive','ButtonDownFcn',@ResetFocus);
    FIGOBJS.IM2.YPix(n) = uicontrol('Parent',FIGOBJS.IM2.ImPan(n),'Style','text','BackgroundColor',BGcolour2,'ForegroundColor',[1,1,0.5],'String','','HorizontalAlignment','left','Fontsize',8,'Units','normalized','Position',[0.530 0.005 0.05 0.015],'Enable','inactive','ButtonDownFcn',@ResetFocus);
    FIGOBJS.IM2.ZPix(n) = uicontrol('Parent',FIGOBJS.IM2.ImPan(n),'Style','text','BackgroundColor',BGcolour2,'ForegroundColor',[1,1,0.5],'String','','HorizontalAlignment','left','Fontsize',8,'Units','normalized','Position',[0.605 0.005 0.05 0.015],'Enable','inactive','ButtonDownFcn',@ResetFocus);
    FIGOBJS.IM2.DIM4(n) = uicontrol('Parent',FIGOBJS.IM2.ImPan(n),'Style','text','BackgroundColor',BGcolour2,'ForegroundColor',[1,1,0.5],'String','','HorizontalAlignment','left','Fontsize',8,'Units','normalized','Position',[0.680 0.005 0.05 0.015],'Enable','inactive','ButtonDownFcn',@ResetFocus);
    FIGOBJS.IM2.DIM5(n) = uicontrol('Parent',FIGOBJS.IM2.ImPan(n),'Style','text','BackgroundColor',BGcolour2,'ForegroundColor',[1,1,0.5],'String','','HorizontalAlignment','left','Fontsize',8,'Units','normalized','Position',[0.755 0.005 0.05 0.015],'Enable','inactive','ButtonDownFcn',@ResetFocus);
    FIGOBJS.IM2.DIM6(n) = uicontrol('Parent',FIGOBJS.IM2.ImPan(n),'Style','text','BackgroundColor',BGcolour2,'ForegroundColor',[1,1,0.5],'String','','HorizontalAlignment','left','Fontsize',8,'Units','normalized','Position',[0.830 0.005 0.05 0.015],'Enable','inactive','ButtonDownFcn',@ResetFocus);
end
for n = 1:2
    FIGOBJS.IM2.ImAxes(n) = axes('Parent',FIGOBJS.IM2.ImPan(n));
    FIGOBJS.IM2.ImAxes(n).Tag = num2str(n);
    FIGOBJS.IM2.ImAxes(n).NextPlot = 'replacechildren';
    FIGOBJS.IM2.ImAxes(n).Position = [0 0.05 1 0.95];
    FIGOBJS.IM2.ImAxes(n).ButtonDownFcn = @ButtonPressControl;
    FIGOBJS.IM2.ImAxes(n).PickableParts = 'all';
    FIGOBJS.IM2.ImAxes(n).Visible = 'off';
    FIGOBJS.IM2.ImAxes(n).Interruptible = 'off';
    FIGOBJS.IM2.ImAxes(n).Color = BGcolour;
end
FIGOBJS.IM2.AspectRatio = 0.83;    

tg1 = uitabgroup(IM2,'Position',[0.005 0.01 0.395 0.1]);
tg2 = uitabgroup(IM2,'Position',[0.405 0.01 0.395 0.1]);
FIGOBJS.IM2.ContrastTab(1) = uitab(tg1,'Title','Contrast','BackgroundColor',BGcolour,'ButtonDownFcn',@ResetFocus);
FIGOBJS.IM2.ContrastTab(2) = uitab(tg2,'Title','Contrast','BackgroundColor',BGcolour,'ButtonDownFcn',@ResetFocus);
for n = 1:2
    uicontrol('Parent',FIGOBJS.IM2.ContrastTab(n),'Style','text','tag',num2str(n),'BackgroundColor',BGcolour,'ForegroundColor',[0.8 0.8 0.8],'String','Max','HorizontalAlignment','right','Fontsize',7,'Units','normalized','Position',[0 0.59 0.07 0.14],'Enable','inactive','ButtonDownFcn',@ResetFocus);
    FIGOBJS.IM2.ContrastMax(n) = uicontrol('Parent',FIGOBJS.IM2.ContrastTab(n),'Style','slider','tag',num2str(n),'BackgroundColor',[0.8 0.8 0.8],'ForegroundColor',BGcolour,'Units','normalized','Position',[0.08 0.6 0.25 0.14],'Value',1,'CallBack',@ContrastMax,'SliderStep',[0.02 0.1]);
    addlistener(FIGOBJS.IM2.ContrastMax(n),'Value','PostSet',@ContrastMax2);
    FIGOBJS.IM2.CMaxVal(n) = uicontrol('Parent',FIGOBJS.IM2.ContrastTab(n),'Style','edit','tag',num2str(n),'BackgroundColor',BGcolour,'ForegroundColor',[0.8 0.8 0.8],'String','','HorizontalAlignment','left','Fontsize',7,'Units','normalized','Position',[0.34 0.6 0.05 0.14],'CallBack',@ContrastMaxval);
    uicontrol('Parent',FIGOBJS.IM2.ContrastTab(n),'Style','text','tag',num2str(n),'BackgroundColor',BGcolour,'ForegroundColor',[0.8 0.8 0.8],'String','Min','HorizontalAlignment','right','Fontsize',7,'Units','normalized','Position',[0 0.39 0.07 0.14],'Enable','inactive','ButtonDownFcn',@ResetFocus);
    FIGOBJS.IM2.ContrastMin(n) = uicontrol('Parent',FIGOBJS.IM2.ContrastTab(n),'Style','slider','tag',num2str(n),'BackgroundColor',[0.8 0.8 0.8],'ForegroundColor',BGcolour,'Units','normalized','Position',[0.08 0.4 0.25 0.14],'Value',0,'CallBack',@ContrastMin,'SliderStep',[0.02 0.1]);
    addlistener(FIGOBJS.IM2.ContrastMin(n),'Value','PostSet',@ContrastMin2);
    FIGOBJS.IM2.CMinVal(n) = uicontrol('Parent',FIGOBJS.IM2.ContrastTab(n),'Style','edit','tag',num2str(n),'BackgroundColor',BGcolour,'ForegroundColor',[0.8 0.8 0.8],'String','','HorizontalAlignment','left','Fontsize',7,'Units','normalized','Position',[0.34 0.4 0.05 0.14],'CallBack',@ContrastMinval);
    uicontrol('Parent',FIGOBJS.IM2.ContrastTab(n),'Style','text','tag',num2str(n),'BackgroundColor',BGcolour,'ForegroundColor',[0.8 0.8 0.8],'String','Type','HorizontalAlignment','right','Fontsize',7,'Units','normalized','Position',[0.41 0.49 0.04 0.14],'Enable','inactive','ButtonDownFcn',@ResetFocus);
    FIGOBJS.IM2.ImType(n) = uicontrol('Parent',FIGOBJS.IM2.ContrastTab(n),'Style','popupmenu','tag',num2str(n),'BackgroundColor',[0.8 0.8 0.8],'ForegroundColor',BGcolour,'String',{'abs','real','imag','phase','map'},'HorizontalAlignment','right','Fontsize',6,'Units','normalized','Position',[0.46 0.5 0.07 0.15],'CallBack',@ChangeImType);
    uicontrol('Parent',FIGOBJS.IM2.ContrastTab(n),'Style','text','tag',num2str(n),'BackgroundColor',BGcolour,'ForegroundColor',[0.8 0.8 0.8],'String','Colour','HorizontalAlignment','right','Fontsize',7,'Units','normalized','Position',[0.55 0.49 0.04 0.14],'Enable','inactive','ButtonDownFcn',@ResetFocus);
    FIGOBJS.IM2.ImColour(n) = uicontrol('Parent',FIGOBJS.IM2.ContrastTab(n),'Style','popupmenu','tag',num2str(n),'BackgroundColor',[0.8 0.8 0.8],'ForegroundColor',BGcolour,'String',{'off','on'},'HorizontalAlignment','right','Fontsize',6,'Units','normalized','Position',[0.60 0.5 0.07 0.15],'CallBack',@ChangeColour);
    uicontrol('Parent',FIGOBJS.IM2.ContrastTab(n),'Style','text','BackgroundColor',BGcolour,'ForegroundColor',[0.8 0.8 0.8],'String','Hold Contrast','HorizontalAlignment','left','Fontsize',7,'Units','normalized','Position',[0.70 0.61 0.07 0.15],'Enable','inactive','ButtonDownFcn',@ResetFocus);
    FIGOBJS.IM2.HoldContrast2(n) = uicontrol('Parent',FIGOBJS.IM2.ContrastTab(n),'Style','checkbox','tag',num2str(n),'BackgroundColor',BGcolour,'ForegroundColor',[0.8 0.8 0.8],'Fontsize',6,'Units','normalized','Position',[0.725 0.5 0.07 0.15],'CallBack',@HoldContrastChange); 
end
FIGOBJS.IM2.PointerTab(1) = uitab(tg1,'Title','General','BackgroundColor',BGcolour,'ButtonDownFcn',@ResetFocus);
FIGOBJS.IM2.PointerTab(2) = uitab(tg2,'Title','General','BackgroundColor',BGcolour,'ButtonDownFcn',@ResetFocus);
for n = 1:2
    uicontrol('Parent',FIGOBJS.IM2.PointerTab(n),'Style','text','BackgroundColor',BGcolour,'ForegroundColor',[0.8 0.8 0.8],'String','All','HorizontalAlignment','left','Fontsize',7,'Units','normalized','Position',[0.09 0.62 0.06 0.14],'Enable','inactive','ButtonDownFcn',@ResetFocus);
    uicontrol('Parent',FIGOBJS.IM2.PointerTab(n),'Style','text','BackgroundColor',BGcolour,'ForegroundColor',[0.8 0.8 0.8],'String','Slice','HorizontalAlignment','left','Fontsize',7,'Units','normalized','Position',[0.15 0.62 0.06 0.14],'Enable','inactive','ButtonDownFcn',@ResetFocus);
    uicontrol('Parent',FIGOBJS.IM2.PointerTab(n),'Style','text','BackgroundColor',BGcolour,'ForegroundColor',[0.8 0.8 0.8],'String','Zoom','HorizontalAlignment','left','Fontsize',7,'Units','normalized','Position',[0.21 0.62 0.06 0.14],'Enable','inactive','ButtonDownFcn',@ResetFocus);
    uicontrol('Parent',FIGOBJS.IM2.PointerTab(n),'Style','text','BackgroundColor',BGcolour,'ForegroundColor',[0.8 0.8 0.8],'String','Dims','HorizontalAlignment','left','Fontsize',7,'Units','normalized','Position',[0.27 0.62 0.06 0.14],'Enable','inactive','ButtonDownFcn',@ResetFocus);
    uicontrol('Parent',FIGOBJS.IM2.PointerTab(n),'Style','text','BackgroundColor',BGcolour,'ForegroundColor',[0.8 0.8 0.8],'String','ROIs','HorizontalAlignment','left','Fontsize',7,'Units','normalized','Position',[0.33 0.62 0.06 0.14],'Enable','inactive','ButtonDownFcn',@ResetFocus);
    uicontrol('Parent',FIGOBJS.IM2.PointerTab(n),'Style','text','BackgroundColor',BGcolour,'ForegroundColor',[0.8 0.8 0.8],'String','DatVals','HorizontalAlignment','left','Fontsize',7,'Units','normalized','Position',[0.39 0.62 0.06 0.14],'Enable','inactive','ButtonDownFcn',@ResetFocus);
    uicontrol('Parent',FIGOBJS.IM2.PointerTab(n),'Style','text','BackgroundColor',BGcolour,'ForegroundColor',[0.8 0.8 0.8],'String','Cursor','HorizontalAlignment','left','Fontsize',7,'Units','normalized','Position',[0.45 0.62 0.06 0.14],'Enable','inactive','ButtonDownFcn',@ResetFocus);
    uicontrol('Parent',FIGOBJS.IM2.PointerTab(n),'Style','text','BackgroundColor',BGcolour,'ForegroundColor',[0.8 0.8 0.8],'String','Tie','HorizontalAlignment','right','Fontsize',7,'Units','normalized','Position',[0 0.49 0.06 0.14],'Enable','inactive','ButtonDownFcn',@ResetFocus);
    FIGOBJS.IM2.TieAll(n) = uicontrol('Parent',FIGOBJS.IM2.PointerTab(n),'Style','checkbox','tag',num2str(n),'BackgroundColor',BGcolour,'ForegroundColor',[0.8 0.8 0.8],'Fontsize',6,'Units','normalized','Position',[0.09 0.5 0.05 0.14],'CallBack',@TieAllChange);
    FIGOBJS.IM2.TieSlice(n) = uicontrol('Parent',FIGOBJS.IM2.PointerTab(n),'Style','checkbox','tag',num2str(n),'BackgroundColor',BGcolour,'ForegroundColor',[0.8 0.8 0.8],'Fontsize',6,'Units','normalized','Position',[0.15 0.5 0.05 0.14],'CallBack',@TieSliceChange);   
    FIGOBJS.IM2.TieZoom(n) = uicontrol('Parent',FIGOBJS.IM2.PointerTab(n),'Style','checkbox','tag',num2str(n),'BackgroundColor',BGcolour,'ForegroundColor',[0.8 0.8 0.8],'Fontsize',6,'Units','normalized','Position',[0.21 0.5 0.05 0.14],'CallBack',@TieZoomChange);  
    FIGOBJS.IM2.TieDims(n) = uicontrol('Parent',FIGOBJS.IM2.PointerTab(n),'Style','checkbox','tag',num2str(n),'BackgroundColor',BGcolour,'ForegroundColor',[0.8 0.8 0.8],'Fontsize',6,'Units','normalized','Position',[0.27 0.5 0.05 0.14],'CallBack',@TieDimsChange); 
    FIGOBJS.IM2.TieROIs(n) = uicontrol('Parent',FIGOBJS.IM2.PointerTab(n),'Style','checkbox','tag',num2str(n),'BackgroundColor',BGcolour,'ForegroundColor',[0.8 0.8 0.8],'Fontsize',6,'Units','normalized','Position',[0.33 0.5 0.05 0.14],'CallBack',@TieROIsChange);  
    FIGOBJS.IM2.TieDatVals(n) = uicontrol('Parent',FIGOBJS.IM2.PointerTab(n),'Style','checkbox','tag',num2str(n),'BackgroundColor',BGcolour,'ForegroundColor',[0.8 0.8 0.8],'Fontsize',6,'Units','normalized','Position',[0.39 0.5 0.05 0.14],'CallBack',@TieDatValsChange); 
    FIGOBJS.IM2.TieCursor(n) = uicontrol('Parent',FIGOBJS.IM2.PointerTab(n),'Style','checkbox','tag',num2str(n),'BackgroundColor',BGcolour,'ForegroundColor',[0.8 0.8 0.8],'Fontsize',6,'Units','normalized','Position',[0.45 0.5 0.05 0.14],'CallBack',@TieCursorChange);    
end
FIGOBJS.IM2.DimsTab(1) = uitab(tg1,'Title','Dimensions','BackgroundColor',BGcolour,'ButtonDownFcn',@ResetFocus);
FIGOBJS.IM2.DimsTab(2) = uitab(tg2,'Title','Dimensions','BackgroundColor',BGcolour,'ButtonDownFcn',@ResetFocus);
for n = 1:2
    uicontrol('Parent',FIGOBJS.IM2.DimsTab(n),'Style','text','tag',num2str(n),'BackgroundColor',BGcolour,'ForegroundColor',[0.8 0.8 0.8],'String','4th Dim','HorizontalAlignment','right','Fontsize',7,'Units','normalized','Position',[0 0.59 0.07 0.14],'Enable','inactive','ButtonDownFcn',@ResetFocus);
    FIGOBJS.IM2.Dim4(n) = uicontrol('Parent',FIGOBJS.IM2.DimsTab(n),'Style','slider','tag',num2str(n),'BackgroundColor',[0.8 0.8 0.8],'ForegroundColor',BGcolour,'Units','normalized','Position',[0.08 0.6 0.25 0.14],'Value',0,'CallBack',@Dim4ChangeControl,'SliderStep',[1 1],'Enable','off');
    uicontrol('Parent',FIGOBJS.IM2.DimsTab(n),'Style','text','tag',num2str(n),'BackgroundColor',BGcolour,'ForegroundColor',[0.8 0.8 0.8],'String','5th Dim','HorizontalAlignment','right','Fontsize',7,'Units','normalized','Position',[0 0.39 0.07 0.14],'Enable','inactive','ButtonDownFcn',@ResetFocus);
    FIGOBJS.IM2.Dim5(n) = uicontrol('Parent',FIGOBJS.IM2.DimsTab(n),'Style','slider','tag',num2str(n),'BackgroundColor',[0.8 0.8 0.8],'ForegroundColor',BGcolour,'Units','normalized','Position',[0.08 0.4 0.25 0.14],'Value',0,'CallBack',@Dim5ChangeControl,'SliderStep',[1 1],'Enable','off');
    uicontrol('Parent',FIGOBJS.IM2.DimsTab(n),'Style','text','tag',num2str(n),'BackgroundColor',BGcolour,'ForegroundColor',[0.8 0.8 0.8],'String','6th Dim','HorizontalAlignment','right','Fontsize',7,'Units','normalized','Position',[0 0.19 0.07 0.14],'Enable','inactive','ButtonDownFcn',@ResetFocus);
    FIGOBJS.IM2.Dim6(n) = uicontrol('Parent',FIGOBJS.IM2.DimsTab(n),'Style','slider','tag',num2str(n),'BackgroundColor',[0.8 0.8 0.8],'ForegroundColor',BGcolour,'Units','normalized','Position',[0.08 0.2 0.25 0.14],'Value',0,'CallBack',@Dim6ChangeControl,'SliderStep',[1 1],'Enable','off');
    uicontrol('Parent',FIGOBJS.IM2.DimsTab(n),'Style','text','tag',num2str(n),'BackgroundColor',BGcolour,'ForegroundColor',[0.8 0.8 0.8],'String','Orient','HorizontalAlignment','right','Fontsize',7,'Units','normalized','Position',[0.38 0.39 0.04 0.14],'Enable','inactive','ButtonDownFcn',@ResetFocus);
    FIGOBJS.IM2.Orient(n) = uicontrol('Parent',FIGOBJS.IM2.DimsTab(n),'Style','popupmenu','tag',num2str(n),'BackgroundColor',[0.8 0.8 0.8],'ForegroundColor',BGcolour,'String',{'Axial','Sagittal','Coronal'},'HorizontalAlignment','right','Fontsize',6,'Units','normalized','Position',[0.43 0.4 0.07 0.15],'CallBack',@ChangeOrientation);
end
FIGOBJS.IM2.ROITab(1) = uitab(tg1,'Title','ROI Creation','BackgroundColor',BGcolour,'ButtonDownFcn',@ResetFocus);
FIGOBJS.IM2.ROITab(2) = uitab(tg2,'Title','ROI Creation','BackgroundColor',BGcolour,'ButtonDownFcn',@ResetFocus);
for n = 1:2
    uicontrol('Parent',FIGOBJS.IM2.ROITab(n),'Style','text','tag',num2str(n),'BackgroundColor',BGcolour,'ForegroundColor',[0.8 0.8 0.8],'String','ROI Creation','HorizontalAlignment','right','Fontsize',7,'Units','normalized','Position',[0.015 0.59 0.07 0.14],'Enable','inactive','ButtonDownFcn',@ResetFocus);
    FIGOBJS.IM2.ROICreateSel(n) = uicontrol('Parent',FIGOBJS.IM2.ROITab(n),'Style','popupmenu','tag',num2str(n),'BackgroundColor',[0.8 0.8 0.8],'ForegroundColor',BGcolour,'String',{'FreeHand','Seed','Sphere','Circle','Tube'},'HorizontalAlignment','left','Fontsize',6,'Units','normalized','Position',[0.02 0.4 0.07 0.15],'CallBack',@ChangeROICreate);  
    FIGOBJS.IM2.NewROIbutton(n) = uicontrol('Parent',FIGOBJS.IM2.ROITab(n),'Style','pushbutton','tag',num2str(n),'BackgroundColor',[0.8 0.8 0.8],'ForegroundColor',BGcolour,'String','New','HorizontalAlignment','left','Fontsize',7,'Units','normalized','Position',[0.1 0.59 0.06 0.16],'CallBack',@ButtonNewROI);    
    FIGOBJS.IM2.SaveROIbutton(n) = uicontrol('Parent',FIGOBJS.IM2.ROITab(n),'Style','pushbutton','tag',num2str(n),'BackgroundColor',[0.8 0.8 0.8],'ForegroundColor',BGcolour,'String','Save','HorizontalAlignment','left','Fontsize',7,'Units','normalized','Position',[0.1 0.4 0.06 0.16],'CallBack',@ButtonSaveROI);   
    FIGOBJS.IM2.DiscardROIbutton(n) = uicontrol('Parent',FIGOBJS.IM2.ROITab(n),'Style','pushbutton','tag',num2str(n),'BackgroundColor',[0.8 0.8 0.8],'ForegroundColor',BGcolour,'String','Discard','HorizontalAlignment','left','Fontsize',7,'Units','normalized','Position',[0.1 0.21 0.06 0.16],'CallBack',@ButtonDiscardROI);   
    FIGOBJS.IM2.SaveROIbutton(n) = uicontrol('Parent',FIGOBJS.IM2.ROITab(n),'Style','pushbutton','tag',num2str(n),'BackgroundColor',[0.8 0.8 0.8],'ForegroundColor',BGcolour,'String','Drop Last','HorizontalAlignment','left','Fontsize',7,'Units','normalized','Position',[0.17 0.59 0.06 0.16],'CallBack',@ButtonDeleteLast);   
    FIGOBJS.IM2.RedrawROIbutton(n) = uicontrol('Parent',FIGOBJS.IM2.ROITab(n),'Style','pushbutton','tag',num2str(n),'BackgroundColor',[0.8 0.8 0.8],'ForegroundColor',BGcolour,'String','Redraw','HorizontalAlignment','left','Fontsize',7,'Units','normalized','Position',[0.17 0.21 0.06 0.16],'CallBack',@ButtonRedraw);   
    FIGOBJS.IM2.EraseROIbutton(n) = uicontrol('Parent',FIGOBJS.IM2.ROITab(n),'Style','pushbutton','tag',num2str(n),'BackgroundColor',[0.8 0.8 0.8],'ForegroundColor',BGcolour,'String','Erase','HorizontalAlignment','left','Fontsize',7,'Units','normalized','Position',[0.17 0.4 0.06 0.16],'CallBack',@ButtonEraseROI);     
    uicontrol('Parent',FIGOBJS.IM2.ROITab(n),'Style','text','BackgroundColor',BGcolour,'ForegroundColor',[0.8 0.8 0.8],'String','ShadeROI','HorizontalAlignment','right','Fontsize',7,'Units','normalized','Position',[0.23 0.59 0.06 0.14],'Enable','inactive','ButtonDownFcn',@ResetFocus);
    FIGOBJS.IM2.ShadeROI(n) = uicontrol('Parent',FIGOBJS.IM2.ROITab(n),'Style','checkbox','tag',num2str(n),'BackgroundColor',BGcolour,'ForegroundColor',[0.8 0.8 0.8],'Fontsize',6,'Units','normalized','Position',[0.295 0.6 0.07 0.14],'CallBack',@ShadeROIChange);
    FIGOBJS.IM2.ShadeROIValue(n) = uicontrol('Parent',FIGOBJS.IM2.ROITab(n),'Style','slider','Tag',num2str(n),'BackgroundColor',[0.8 0.8 0.8],'ForegroundColor',BGcolour,'Units','normalized','Position',[0.24 0.4 0.07 0.14],'Value',1,'SliderStep',[0.5 0.5],'Min',1,'Max',3,'CallBack',@ShadeROISlideChange);    
    uicontrol('Parent',FIGOBJS.IM2.ROITab(n),'Style','text','BackgroundColor',BGcolour,'ForegroundColor',[0.8 0.8 0.8],'String','LinesROI','HorizontalAlignment','right','Fontsize',7,'Units','normalized','Position',[0.23 0.19 0.06 0.14],'Enable','inactive','ButtonDownFcn',@ResetFocus);
    FIGOBJS.IM2.LinesROI(n) = uicontrol('Parent',FIGOBJS.IM2.ROITab(n),'Style','checkbox','tag',num2str(n),'BackgroundColor',BGcolour,'ForegroundColor',[0.8 0.8 0.8],'Fontsize',6,'Units','normalized','Position',[0.295 0.2 0.07 0.14],'CallBack',@LinesROIChange);
end
FIGOBJS.IM2.ROIOptTab(1) = uitab(tg1,'Title','ROI Options','BackgroundColor',BGcolour,'ButtonDownFcn',@ResetFocus);
FIGOBJS.IM2.ROIOptTab(2) = uitab(tg2,'Title','ROI Options','BackgroundColor',BGcolour,'ButtonDownFcn',@ResetFocus);
for n = 1:2
    uicontrol('Parent',FIGOBJS.IM2.ROIOptTab(n),'Style','text','BackgroundColor',BGcolour,'ForegroundColor',[0.8 0.8 0.8],'String','AutoUpdateROI','HorizontalAlignment','right','Fontsize',7,'Units','normalized','Position',[0.02 0.59 0.08 0.14],'Enable','inactive','ButtonDownFcn',@ResetFocus);
    FIGOBJS.IM2.AutoUpdateROI(n) = uicontrol('Parent',FIGOBJS.IM2.ROIOptTab(n),'Style','checkbox','tag',num2str(n),'BackgroundColor',BGcolour,'ForegroundColor',[0.8 0.8 0.8],'Fontsize',6,'Units','normalized','Position',[0.11 0.6 0.07 0.14],'CallBack',@AutoUpdateChange);
    uicontrol('Parent',FIGOBJS.IM2.ROIOptTab(n),'Style','text','BackgroundColor',BGcolour,'ForegroundColor',[0.8 0.8 0.8],'String','ComplexAverage','HorizontalAlignment','right','Fontsize',7,'Units','normalized','Position',[0.02 0.39 0.08 0.14],'Enable','inactive','ButtonDownFcn',@ResetFocus);
    FIGOBJS.IM2.ComplexAverage(n) = uicontrol('Parent',FIGOBJS.IM2.ROIOptTab(n),'Style','checkbox','tag',num2str(n),'BackgroundColor',BGcolour,'ForegroundColor',[0.8 0.8 0.8],'Fontsize',6,'Units','normalized','Position',[0.11 0.4 0.07 0.14],'CallBack',@ComplexAverageROIChange);
end

%================================================================
% Imaging3 Tab
%================================================================
FIGOBJS.IM3.ImPan(1) = uipanel('Parent',IM3);
FIGOBJS.IM3.ImPan(1).BackgroundColor = BGcolour2;
FIGOBJS.IM3.ImPan(1).Position = [0.405 0.12 0.395 0.87];
FIGOBJS.IM3.ImPan(2) = uipanel('Parent',IM3);
FIGOBJS.IM3.ImPan(2).BackgroundColor = [0.1 0.1 0.1];
FIGOBJS.IM3.ImPan(2).Position = [0.005 0.505 0.395 0.485];
FIGOBJS.IM3.ImPan(3) = uipanel('Parent',IM3);
FIGOBJS.IM3.ImPan(3).BackgroundColor = [0.1 0.1 0.1];
FIGOBJS.IM3.ImPan(3).Position = [0.005 0.01 0.395 0.485];

for n = 1:1
    FIGOBJS.IM3.ImageName(n) = uicontrol('Parent',FIGOBJS.IM3.ImPan(n),'Style','text','BackgroundColor',BGcolour2,'ForegroundColor',[1,1,0.5],'String','','HorizontalAlignment','left','Fontsize',8,'Units','normalized','Position',[0.01 0.98 0.4 0.015],'Enable','inactive','ButtonDownFcn',@ResetFocus);
end
for n = 1:1
    FIGOBJS.IM3.VALUElab(n) = uicontrol('Parent',FIGOBJS.IM3.ImPan(n),'Style','text','BackgroundColor',BGcolour2,'ForegroundColor',[0.8 0.8 0.8],'String','Value','HorizontalAlignment','left','Fontsize',8,'Units','normalized','Position',[0.15 0.02 0.05 0.015],'Enable','inactive','ButtonDownFcn',@ResetFocus,'Visible','Off');
    FIGOBJS.IM3.Xlab(n) = uicontrol('Parent',FIGOBJS.IM3.ImPan(n),'Style','text','BackgroundColor',BGcolour2,'ForegroundColor',[0.8 0.8 0.8],'String','X (mm)','HorizontalAlignment','left','Fontsize',8,'Units','normalized','Position',[0.225 0.02 0.05 0.015],'Enable','inactive','ButtonDownFcn',@ResetFocus,'Visible','Off');
    FIGOBJS.IM3.Ylab(n) = uicontrol('Parent',FIGOBJS.IM3.ImPan(n),'Style','text','BackgroundColor',BGcolour2,'ForegroundColor',[0.8 0.8 0.8],'String','Y (mm)','HorizontalAlignment','left','Fontsize',8,'Units','normalized','Position',[0.3 0.02 0.05 0.015],'Enable','inactive','ButtonDownFcn',@ResetFocus,'Visible','Off');
    FIGOBJS.IM3.Zlab(n) = uicontrol('Parent',FIGOBJS.IM3.ImPan(n),'Style','text','BackgroundColor',BGcolour2,'ForegroundColor',[0.8 0.8 0.8],'String','Z (mm)','HorizontalAlignment','left','Fontsize',8,'Units','normalized','Position',[0.375 0.02 0.05 0.015],'Enable','inactive','ButtonDownFcn',@ResetFocus,'Visible','Off');
    FIGOBJS.IM3.XPixlab(n) = uicontrol('Parent',FIGOBJS.IM3.ImPan(n),'Style','text','BackgroundColor',BGcolour2,'ForegroundColor',[0.8 0.8 0.8],'String','X (pix)','HorizontalAlignment','left','Fontsize',8,'Units','normalized','Position',[0.45 0.02 0.05 0.015],'Enable','inactive','ButtonDownFcn',@ResetFocus,'Visible','Off');
    FIGOBJS.IM3.YPixlab(n) = uicontrol('Parent',FIGOBJS.IM3.ImPan(n),'Style','text','BackgroundColor',BGcolour2,'ForegroundColor',[0.8 0.8 0.8],'String','Y (pix)','HorizontalAlignment','left','Fontsize',8,'Units','normalized','Position',[0.525 0.02 0.05 0.015],'Enable','inactive','ButtonDownFcn',@ResetFocus,'Visible','Off');
    FIGOBJS.IM3.ZPixlab(n) = uicontrol('Parent',FIGOBJS.IM3.ImPan(n),'Style','text','BackgroundColor',BGcolour2,'ForegroundColor',[0.8 0.8 0.8],'String','Z (pix)','HorizontalAlignment','left','Fontsize',8,'Units','normalized','Position',[0.6 0.02 0.05 0.015],'Enable','inactive','ButtonDownFcn',@ResetFocus,'Visible','Off');
    FIGOBJS.IM3.DIM4lab(n) = uicontrol('Parent',FIGOBJS.IM3.ImPan(n),'Style','text','BackgroundColor',BGcolour2,'ForegroundColor',[0.8 0.8 0.8],'String','Dim4','HorizontalAlignment','left','Fontsize',8,'Units','normalized','Position',[0.675 0.02 0.05 0.015],'Enable','inactive','ButtonDownFcn',@ResetFocus,'Visible','Off');
    FIGOBJS.IM3.DIM5lab(n) = uicontrol('Parent',FIGOBJS.IM3.ImPan(n),'Style','text','BackgroundColor',BGcolour2,'ForegroundColor',[0.8 0.8 0.8],'String','Dim5','HorizontalAlignment','left','Fontsize',8,'Units','normalized','Position',[0.75 0.02 0.05 0.015],'Enable','inactive','ButtonDownFcn',@ResetFocus,'Visible','Off');
    FIGOBJS.IM3.DIM6lab(n) = uicontrol('Parent',FIGOBJS.IM3.ImPan(n),'Style','text','BackgroundColor',BGcolour2,'ForegroundColor',[0.8 0.8 0.8],'String','Dim6','HorizontalAlignment','left','Fontsize',8,'Units','normalized','Position',[0.825 0.02 0.05 0.015],'Enable','inactive','ButtonDownFcn',@ResetFocus,'Visible','Off');
    FIGOBJS.IM3.POINTERlab(n) = uicontrol('Parent',FIGOBJS.IM3.ImPan(n),'Style','text','BackgroundColor',BGcolour2,'ForegroundColor',[0.8 0.8 0.8],'String','Pointer','HorizontalAlignment','left','Fontsize',8,'Units','normalized','Position',[0.05 0.005 0.05 0.015],'Enable','inactive','ButtonDownFcn',@ResetFocus,'Visible','Off');
    FIGOBJS.IM3.CURVAL(n) = uicontrol('Parent',FIGOBJS.IM3.ImPan(n),'Style','text','BackgroundColor',BGcolour2,'ForegroundColor',[1,1,0.5],'String','','HorizontalAlignment','left','Fontsize',8,'Units','normalized','Position',[0.155 0.005 0.05 0.015],'Enable','inactive','ButtonDownFcn',@ResetFocus);
    FIGOBJS.IM3.X(n) = uicontrol('Parent',FIGOBJS.IM3.ImPan(n),'Style','text','BackgroundColor',BGcolour2,'ForegroundColor',[1,1,0.5],'String','','HorizontalAlignment','left','Fontsize',8,'Units','normalized','Position',[0.230 0.005 0.05 0.015],'Enable','inactive','ButtonDownFcn',@ResetFocus);
    FIGOBJS.IM3.Y(n) = uicontrol('Parent',FIGOBJS.IM3.ImPan(n),'Style','text','BackgroundColor',BGcolour2,'ForegroundColor',[1,1,0.5],'String','','HorizontalAlignment','left','Fontsize',8,'Units','normalized','Position',[0.306 0.005 0.05 0.015],'Enable','inactive','ButtonDownFcn',@ResetFocus);
    FIGOBJS.IM3.Z(n) = uicontrol('Parent',FIGOBJS.IM3.ImPan(n),'Style','text','BackgroundColor',BGcolour2,'ForegroundColor',[1,1,0.5],'String','','HorizontalAlignment','left','Fontsize',8,'Units','normalized','Position',[0.380 0.005 0.05 0.015],'Enable','inactive','ButtonDownFcn',@ResetFocus);
    FIGOBJS.IM3.XPix(n) = uicontrol('Parent',FIGOBJS.IM3.ImPan(n),'Style','text','BackgroundColor',BGcolour2,'ForegroundColor',[1,1,0.5],'String','','HorizontalAlignment','left','Fontsize',8,'Units','normalized','Position',[0.455 0.005 0.05 0.015],'Enable','inactive','ButtonDownFcn',@ResetFocus);
    FIGOBJS.IM3.YPix(n) = uicontrol('Parent',FIGOBJS.IM3.ImPan(n),'Style','text','BackgroundColor',BGcolour2,'ForegroundColor',[1,1,0.5],'String','','HorizontalAlignment','left','Fontsize',8,'Units','normalized','Position',[0.530 0.005 0.05 0.015],'Enable','inactive','ButtonDownFcn',@ResetFocus);
    FIGOBJS.IM3.ZPix(n) = uicontrol('Parent',FIGOBJS.IM3.ImPan(n),'Style','text','BackgroundColor',BGcolour2,'ForegroundColor',[1,1,0.5],'String','','HorizontalAlignment','left','Fontsize',8,'Units','normalized','Position',[0.605 0.005 0.05 0.015],'Enable','inactive','ButtonDownFcn',@ResetFocus);
    FIGOBJS.IM3.DIM4(n) = uicontrol('Parent',FIGOBJS.IM3.ImPan(n),'Style','text','BackgroundColor',BGcolour2,'ForegroundColor',[1,1,0.5],'String','','HorizontalAlignment','left','Fontsize',8,'Units','normalized','Position',[0.680 0.005 0.05 0.015],'Enable','inactive','ButtonDownFcn',@ResetFocus);
    FIGOBJS.IM3.DIM5(n) = uicontrol('Parent',FIGOBJS.IM3.ImPan(n),'Style','text','BackgroundColor',BGcolour2,'ForegroundColor',[1,1,0.5],'String','','HorizontalAlignment','left','Fontsize',8,'Units','normalized','Position',[0.755 0.005 0.05 0.015],'Enable','inactive','ButtonDownFcn',@ResetFocus);
    FIGOBJS.IM3.DIM6(n) = uicontrol('Parent',FIGOBJS.IM3.ImPan(n),'Style','text','BackgroundColor',BGcolour2,'ForegroundColor',[1,1,0.5],'String','','HorizontalAlignment','left','Fontsize',8,'Units','normalized','Position',[0.830 0.005 0.05 0.015],'Enable','inactive','ButtonDownFcn',@ResetFocus);
end   
for n = 1:1
    FIGOBJS.IM3.ImAxes(n) = axes('Parent',FIGOBJS.IM3.ImPan(n));
    FIGOBJS.IM3.ImAxes(n).Tag = num2str(n);
    FIGOBJS.IM3.ImAxes(n).NextPlot = 'replacechildren';
    FIGOBJS.IM3.ImAxes(n).Position = [0 0.05 1 0.95];
    FIGOBJS.IM3.ImAxes(n).ButtonDownFcn = @ButtonPressControl;
    FIGOBJS.IM3.ImAxes(n).PickableParts = 'all';
    FIGOBJS.IM3.ImAxes(n).Visible = 'off';
    FIGOBJS.IM3.ImAxes(n).Interruptible = 'off';
    FIGOBJS.IM3.ImAxes(n).Color = BGcolour;
    FIGOBJS.IM3.AspectRatio(n) = 0.83; 
end   
for n = 2:3
    FIGOBJS.IM3.ImAxes(n) = axes('Parent',FIGOBJS.IM3.ImPan(n));
    FIGOBJS.IM3.ImAxes(n).Tag = num2str(n);
    FIGOBJS.IM3.ImAxes(n).NextPlot = 'replacechildren';
    FIGOBJS.IM3.ImAxes(n).Position = [0 0 1 1];
    FIGOBJS.IM3.ImAxes(n).ButtonDownFcn = @ButtonPressControl;
    FIGOBJS.IM3.ImAxes(n).PickableParts = 'all';
    FIGOBJS.IM3.ImAxes(n).Visible = 'off';
    FIGOBJS.IM3.ImAxes(n).Interruptible = 'off';
    FIGOBJS.IM3.ImAxes(n).Color = BGcolour;
    FIGOBJS.IM3.AspectRatio(n) = 1.45;
end

tg1 = uitabgroup(IM3,'Position',[0.405 0.01 0.395 0.1]);
FIGOBJS.IM3.ContrastTab(1) = uitab(tg1,'Title','Contrast','BackgroundColor',BGcolour,'ButtonDownFcn',@ResetFocus);
for n = 1
    uicontrol('Parent',FIGOBJS.IM3.ContrastTab(n),'Style','text','tag',num2str(n),'BackgroundColor',BGcolour,'ForegroundColor',[0.8 0.8 0.8],'String','Max','HorizontalAlignment','right','Fontsize',7,'Units','normalized','Position',[0 0.59 0.07 0.14],'Enable','inactive','ButtonDownFcn',@ResetFocus);
    FIGOBJS.IM3.ContrastMax(n) = uicontrol('Parent',FIGOBJS.IM3.ContrastTab(n),'Style','slider','tag',num2str(n),'BackgroundColor',[0.8 0.8 0.8],'ForegroundColor',BGcolour,'Units','normalized','Position',[0.08 0.6 0.25 0.14],'Value',1,'CallBack',@ContrastMax,'SliderStep',[0.02 0.1]);
    addlistener(FIGOBJS.IM3.ContrastMax(n),'Value','PostSet',@ContrastMax2);
    FIGOBJS.IM3.CMaxVal(n) = uicontrol('Parent',FIGOBJS.IM3.ContrastTab(n),'Style','edit','tag',num2str(n),'BackgroundColor',BGcolour,'ForegroundColor',[0.8 0.8 0.8],'String','','HorizontalAlignment','left','Fontsize',7,'Units','normalized','Position',[0.34 0.6 0.05 0.14],'CallBack',@ContrastMaxval);
    uicontrol('Parent',FIGOBJS.IM3.ContrastTab(n),'Style','text','tag',num2str(n),'BackgroundColor',BGcolour,'ForegroundColor',[0.8 0.8 0.8],'String','Min','HorizontalAlignment','right','Fontsize',7,'Units','normalized','Position',[0 0.39 0.07 0.14],'Enable','inactive','ButtonDownFcn',@ResetFocus);
    FIGOBJS.IM3.ContrastMin(n) = uicontrol('Parent',FIGOBJS.IM3.ContrastTab(n),'Style','slider','tag',num2str(n),'BackgroundColor',[0.8 0.8 0.8],'ForegroundColor',BGcolour,'Units','normalized','Position',[0.08 0.4 0.25 0.14],'Value',0,'CallBack',@ContrastMin,'SliderStep',[0.02 0.1]);
    addlistener(FIGOBJS.IM3.ContrastMin(n),'Value','PostSet',@ContrastMin2);
    FIGOBJS.IM3.CMinVal(n) = uicontrol('Parent',FIGOBJS.IM3.ContrastTab(n),'Style','edit','tag',num2str(n),'BackgroundColor',BGcolour,'ForegroundColor',[0.8 0.8 0.8],'String','','HorizontalAlignment','left','Fontsize',7,'Units','normalized','Position',[0.34 0.4 0.05 0.14],'CallBack',@ContrastMinval);
    uicontrol('Parent',FIGOBJS.IM3.ContrastTab(n),'Style','text','tag',num2str(n),'BackgroundColor',BGcolour,'ForegroundColor',[0.8 0.8 0.8],'String','Type','HorizontalAlignment','right','Fontsize',7,'Units','normalized','Position',[0.41 0.49 0.04 0.14],'Enable','inactive','ButtonDownFcn',@ResetFocus);
    FIGOBJS.IM3.ImType(n) = uicontrol('Parent',FIGOBJS.IM3.ContrastTab(n),'Style','popupmenu','tag',num2str(n),'BackgroundColor',[0.8 0.8 0.8],'ForegroundColor',BGcolour,'String',{'abs','real','imag','phase','map'},'HorizontalAlignment','right','Fontsize',6,'Units','normalized','Position',[0.46 0.5 0.07 0.15],'CallBack',@ChangeImType);
    uicontrol('Parent',FIGOBJS.IM3.ContrastTab(n),'Style','text','tag',num2str(n),'BackgroundColor',BGcolour,'ForegroundColor',[0.8 0.8 0.8],'String','Colour','HorizontalAlignment','right','Fontsize',7,'Units','normalized','Position',[0.55 0.49 0.04 0.14],'Enable','inactive','ButtonDownFcn',@ResetFocus);
    FIGOBJS.IM3.ImColour(n) = uicontrol('Parent',FIGOBJS.IM3.ContrastTab(n),'Style','popupmenu','tag',num2str(n),'BackgroundColor',[0.8 0.8 0.8],'ForegroundColor',BGcolour,'String',{'off','on'},'HorizontalAlignment','right','Fontsize',6,'Units','normalized','Position',[0.60 0.5 0.07 0.15],'CallBack',@ChangeColour);
    uicontrol('Parent',FIGOBJS.IM3.ContrastTab(n),'Style','text','BackgroundColor',BGcolour,'ForegroundColor',[0.8 0.8 0.8],'String','Hold Contrast','HorizontalAlignment','left','Fontsize',7,'Units','normalized','Position',[0.70 0.61 0.07 0.15],'Enable','inactive','ButtonDownFcn',@ResetFocus);
    FIGOBJS.IM3.HoldContrast2(n) = uicontrol('Parent',FIGOBJS.IM3.ContrastTab(n),'Style','checkbox','tag',num2str(n),'BackgroundColor',BGcolour,'ForegroundColor',[0.8 0.8 0.8],'Fontsize',6,'Units','normalized','Position',[0.725 0.5 0.07 0.15],'CallBack',@HoldContrastChange); 
end
FIGOBJS.IM3.PointerTab(1) = uitab(tg1,'Title','General','BackgroundColor',BGcolour,'ButtonDownFcn',@ResetFocus);
for n = 1
    uicontrol('Parent',FIGOBJS.IM3.PointerTab(n),'Style','text','tag',num2str(n),'BackgroundColor',BGcolour,'ForegroundColor',[0.8 0.8 0.8],'String','Orientation','HorizontalAlignment','right','Fontsize',7,'Units','normalized','Position',[0 0.59 0.07 0.14],'Enable','inactive','ButtonDownFcn',@ResetFocus);
    FIGOBJS.IM3.Orientation(n) = uicontrol('Parent',FIGOBJS.IM3.PointerTab(n),'Style','popupmenu','tag',num2str(n),'BackgroundColor',[0.8 0.8 0.8],'ForegroundColor',BGcolour,'String',{'Axial','Sagittal','Coronal'},'HorizontalAlignment','right','Fontsize',6,'Units','normalized','Position',[0.08 0.6 0.07 0.15],'CallBack',@ChangeOrientationOrtho);    
    uicontrol('Parent',FIGOBJS.IM3.PointerTab(n),'Style','text','BackgroundColor',BGcolour,'ForegroundColor',[0.8 0.8 0.8],'String','OrthoLine','HorizontalAlignment','right','Fontsize',7,'Units','normalized','Position',[0 0.39 0.07 0.14],'Enable','inactive','ButtonDownFcn',@ResetFocus);
    FIGOBJS.IM3.ShowOrtho(n) = uicontrol('Parent',FIGOBJS.IM3.PointerTab(n),'Style','checkbox','tag',num2str(n),'BackgroundColor',BGcolour,'ForegroundColor',[0.8 0.8 0.8],'Fontsize',6,'Units','normalized','Position',[0.08 0.4 0.07 0.15],'CallBack',@ShowOrthoLineChange);    
end
FIGOBJS.IM3.DimsTab(1) = uitab(tg1,'Title','Dimensions','BackgroundColor',BGcolour,'ButtonDownFcn',@ResetFocus);
for n = 1
    uicontrol('Parent',FIGOBJS.IM3.DimsTab(n),'Style','text','tag',num2str(n),'BackgroundColor',BGcolour,'ForegroundColor',[0.8 0.8 0.8],'String','4th Dim','HorizontalAlignment','right','Fontsize',7,'Units','normalized','Position',[0 0.59 0.07 0.14],'Enable','inactive','ButtonDownFcn',@ResetFocus);
    FIGOBJS.IM3.Dim4(n) = uicontrol('Parent',FIGOBJS.IM3.DimsTab(n),'Style','slider','tag',num2str(n),'BackgroundColor',[0.8 0.8 0.8],'ForegroundColor',BGcolour,'Units','normalized','Position',[0.08 0.6 0.25 0.14],'Value',0,'CallBack',@Dim4ChangeControl,'SliderStep',[1 1],'Enable','off');
    uicontrol('Parent',FIGOBJS.IM3.DimsTab(n),'Style','text','tag',num2str(n),'BackgroundColor',BGcolour,'ForegroundColor',[0.8 0.8 0.8],'String','5th Dim','HorizontalAlignment','right','Fontsize',7,'Units','normalized','Position',[0 0.39 0.07 0.14],'Enable','inactive','ButtonDownFcn',@ResetFocus);
    FIGOBJS.IM3.Dim5(n) = uicontrol('Parent',FIGOBJS.IM3.DimsTab(n),'Style','slider','tag',num2str(n),'BackgroundColor',[0.8 0.8 0.8],'ForegroundColor',BGcolour,'Units','normalized','Position',[0.08 0.4 0.25 0.14],'Value',0,'CallBack',@Dim5ChangeControl,'SliderStep',[1 1],'Enable','off');
    uicontrol('Parent',FIGOBJS.IM3.DimsTab(n),'Style','text','tag',num2str(n),'BackgroundColor',BGcolour,'ForegroundColor',[0.8 0.8 0.8],'String','6th Dim','HorizontalAlignment','right','Fontsize',7,'Units','normalized','Position',[0 0.19 0.07 0.14],'Enable','inactive','ButtonDownFcn',@ResetFocus);
    FIGOBJS.IM3.Dim6(n) = uicontrol('Parent',FIGOBJS.IM3.DimsTab(n),'Style','slider','tag',num2str(n),'BackgroundColor',[0.8 0.8 0.8],'ForegroundColor',BGcolour,'Units','normalized','Position',[0.08 0.2 0.25 0.14],'Value',0,'CallBack',@Dim6ChangeControl,'SliderStep',[1 1],'Enable','off');
    uicontrol('Parent',FIGOBJS.IM3.DimsTab(n),'Style','text','tag',num2str(n),'BackgroundColor',BGcolour,'ForegroundColor',[0.8 0.8 0.8],'String','Orient','HorizontalAlignment','right','Fontsize',7,'Units','normalized','Position',[0.38 0.39 0.04 0.14],'Enable','inactive','ButtonDownFcn',@ResetFocus);
    FIGOBJS.IM3.Orient(n) = uicontrol('Parent',FIGOBJS.IM3.DimsTab(n),'Style','popupmenu','tag',num2str(n),'BackgroundColor',[0.8 0.8 0.8],'ForegroundColor',BGcolour,'String',{'Axial','Sagittal','Coronal'},'HorizontalAlignment','right','Fontsize',6,'Units','normalized','Position',[0.43 0.4 0.07 0.15],'CallBack',@ChangeOrientation);
end
FIGOBJS.IM3.ROITab(1) = uitab(tg1,'Title','ROI Creation','BackgroundColor',BGcolour,'ButtonDownFcn',@ResetFocus);
for n = 1
    uicontrol('Parent',FIGOBJS.IM3.ROITab(n),'Style','text','tag',num2str(n),'BackgroundColor',BGcolour,'ForegroundColor',[0.8 0.8 0.8],'String','ROI Creation','HorizontalAlignment','right','Fontsize',7,'Units','normalized','Position',[0.015 0.59 0.07 0.14],'Enable','inactive','ButtonDownFcn',@ResetFocus);
    %FIGOBJS.IM3.ROICreateSel(n) = uicontrol('Parent',FIGOBJS.IM3.ROITab(n),'Style','popupmenu','tag',num2str(n),'BackgroundColor',[0.8 0.8 0.8],'ForegroundColor',BGcolour,'String',{'FreeHand','Seed','Sphere'},'HorizontalAlignment','left','Fontsize',6,'Units','normalized','Position',[0.02 0.4 0.07 0.15],'CallBack',@ChangeROICreate);   
    FIGOBJS.IM3.ROICreateSel(n) = uicontrol('Parent',FIGOBJS.IM3.ROITab(n),'Style','popupmenu','tag',num2str(n),'BackgroundColor',[0.8 0.8 0.8],'ForegroundColor',BGcolour,'String',{'FreeHand','Seed','Sphere','Circle','Tube'},'HorizontalAlignment','left','Fontsize',6,'Units','normalized','Position',[0.02 0.4 0.07 0.15],'CallBack',@ChangeROICreate);    
    FIGOBJS.IM3.NewROIbutton(n) = uicontrol('Parent',FIGOBJS.IM3.ROITab(n),'Style','pushbutton','tag',num2str(n),'BackgroundColor',[0.8 0.8 0.8],'ForegroundColor',BGcolour,'String','New','HorizontalAlignment','left','Fontsize',7,'Units','normalized','Position',[0.1 0.59 0.06 0.16],'CallBack',@ButtonNewROI);    
    FIGOBJS.IM3.SaveROIbutton(n) = uicontrol('Parent',FIGOBJS.IM3.ROITab(n),'Style','pushbutton','tag',num2str(n),'BackgroundColor',[0.8 0.8 0.8],'ForegroundColor',BGcolour,'String','Save','HorizontalAlignment','left','Fontsize',7,'Units','normalized','Position',[0.1 0.4 0.06 0.16],'CallBack',@ButtonSaveROI);   
    FIGOBJS.IM3.DiscardROIbutton(n) = uicontrol('Parent',FIGOBJS.IM3.ROITab(n),'Style','pushbutton','tag',num2str(n),'BackgroundColor',[0.8 0.8 0.8],'ForegroundColor',BGcolour,'String','Discard','HorizontalAlignment','left','Fontsize',7,'Units','normalized','Position',[0.1 0.21 0.06 0.16],'CallBack',@ButtonDiscardROI);   
    FIGOBJS.IM3.SaveROIbutton(n) = uicontrol('Parent',FIGOBJS.IM3.ROITab(n),'Style','pushbutton','tag',num2str(n),'BackgroundColor',[0.8 0.8 0.8],'ForegroundColor',BGcolour,'String','Drop Last','HorizontalAlignment','left','Fontsize',7,'Units','normalized','Position',[0.17 0.59 0.06 0.16],'CallBack',@ButtonDeleteLast);   
    FIGOBJS.IM3.RedrawROIbutton(n) = uicontrol('Parent',FIGOBJS.IM3.ROITab(n),'Style','pushbutton','tag',num2str(n),'BackgroundColor',[0.8 0.8 0.8],'ForegroundColor',BGcolour,'String','Redraw','HorizontalAlignment','left','Fontsize',7,'Units','normalized','Position',[0.17 0.21 0.06 0.16],'CallBack',@ButtonRedraw);   
    FIGOBJS.IM3.EraseROIbutton(n) = uicontrol('Parent',FIGOBJS.IM2.ROITab(n),'Style','pushbutton','tag',num2str(n),'BackgroundColor',[0.8 0.8 0.8],'ForegroundColor',BGcolour,'String','Erase','HorizontalAlignment','left','Fontsize',7,'Units','normalized','Position',[0.17 0.4 0.06 0.16],'CallBack',@ButtonEraseROI);   
end
FIGOBJS.IM3.ROIOptTab(1) = uitab(tg1,'Title','ROI Options','BackgroundColor',BGcolour,'ButtonDownFcn',@ResetFocus);
for n = 1
    uicontrol('Parent',FIGOBJS.IM3.ROIOptTab(n),'Style','text','BackgroundColor',BGcolour,'ForegroundColor',[0.8 0.8 0.8],'String','ShadeROI','HorizontalAlignment','right','Fontsize',7,'Units','normalized','Position',[0.02 0.59 0.08 0.14],'Enable','inactive','ButtonDownFcn',@ResetFocus);
    FIGOBJS.IM3.ShadeROI(n) = uicontrol('Parent',FIGOBJS.IM3.ROIOptTab(n),'Style','checkbox','tag',num2str(n),'BackgroundColor',BGcolour,'ForegroundColor',[0.8 0.8 0.8],'Fontsize',6,'Units','normalized','Position',[0.11 0.6 0.07 0.14],'CallBack',@ShadeROIChange);
    uicontrol('Parent',FIGOBJS.IM3.ROIOptTab(n),'Style','text','BackgroundColor',BGcolour,'ForegroundColor',[0.8 0.8 0.8],'String','AutoUpdateROI','HorizontalAlignment','right','Fontsize',7,'Units','normalized','Position',[0.02 0.39 0.08 0.14],'Enable','inactive','ButtonDownFcn',@ResetFocus);
    FIGOBJS.IM3.AutoUpdateROI(n) = uicontrol('Parent',FIGOBJS.IM3.ROIOptTab(n),'Style','checkbox','tag',num2str(n),'BackgroundColor',BGcolour,'ForegroundColor',[0.8 0.8 0.8],'Fontsize',6,'Units','normalized','Position',[0.11 0.4 0.07 0.14],'CallBack',@AutoUpdateChange);
    uicontrol('Parent',FIGOBJS.IM3.ROIOptTab(n),'Style','text','BackgroundColor',BGcolour,'ForegroundColor',[0.8 0.8 0.8],'String','ComplexAverage','HorizontalAlignment','right','Fontsize',7,'Units','normalized','Position',[0.02 0.19 0.08 0.14],'Enable','inactive','ButtonDownFcn',@ResetFocus);
    FIGOBJS.IM3.ComplexAverage(n) = uicontrol('Parent',FIGOBJS.IM3.ROIOptTab(n),'Style','checkbox','tag',num2str(n),'BackgroundColor',BGcolour,'ForegroundColor',[0.8 0.8 0.8],'Fontsize',6,'Units','normalized','Position',[0.11 0.2 0.07 0.14],'CallBack',@ComplexAverageROIChange);
end
FIGOBJS.IM3.LineTab(1) = uitab(tg1,'Title','Line Data','BackgroundColor',BGcolour,'ButtonDownFcn',@ResetFocus);
FIGOBJS.IM3.ActivateLineTool(n) = uicontrol('Parent',FIGOBJS.IM3.LineTab(n),'Style','pushbutton','tag',num2str(n),'BackgroundColor',[0.8 0.8 0.8],'ForegroundColor',BGcolour,'String','Activate','HorizontalAlignment','left','Fontsize',7,'Units','normalized','Position',[0.05 0.59 0.06 0.16],'CallBack',@ButtonActivateLineTool);    
FIGOBJS.IM3.DeActivateLineTool(n) = uicontrol('Parent',FIGOBJS.IM3.LineTab(n),'Style','pushbutton','tag',num2str(n),'BackgroundColor',[0.8 0.8 0.8],'ForegroundColor',BGcolour,'String','DeActivate','HorizontalAlignment','left','Fontsize',7,'Units','normalized','Position',[0.05 0.4 0.06 0.16],'CallBack',@ButtonDeActivateLineTool);  
uicontrol('Parent',FIGOBJS.IM3.LineTab(1),'Style','text','BackgroundColor',BGcolour,'ForegroundColor',[0.8 0.8 0.8],'String','LengthTot (mm)','HorizontalAlignment','left','Fontsize',7,'Units','normalized','Position',[0.21 0.79 0.08 0.14],'Enable','inactive','ButtonDownFcn',@ResetFocus);
uicontrol('Parent',FIGOBJS.IM3.LineTab(1),'Style','text','BackgroundColor',BGcolour,'ForegroundColor',[0.8 0.8 0.8],'String','LengthIP (mm)','HorizontalAlignment','left','Fontsize',7,'Units','normalized','Position',[0.30 0.79 0.08 0.14],'Enable','inactive','ButtonDownFcn',@ResetFocus);
uicontrol('Parent',FIGOBJS.IM3.LineTab(1),'Style','text','BackgroundColor',BGcolour,'ForegroundColor',[0.8 0.8 0.8],'String','AnglePol (deg)','HorizontalAlignment','left','Fontsize',7,'Units','normalized','Position',[0.39 0.79 0.08 0.14],'Enable','inactive','ButtonDownFcn',@ResetFocus);
uicontrol('Parent',FIGOBJS.IM3.LineTab(1),'Style','text','BackgroundColor',BGcolour,'ForegroundColor',[0.8 0.8 0.8],'String','AngleAzi (deg)','HorizontalAlignment','left','Fontsize',7,'Units','normalized','Position',[0.48 0.79 0.08 0.14],'Enable','inactive','ButtonDownFcn',@ResetFocus);
uicontrol('Parent',FIGOBJS.IM3.LineTab(n),'Style','text','BackgroundColor',BGcolour,'ForegroundColor',[0.8 0.8 0.8],'String','Current Line','HorizontalAlignment','right','Fontsize',7,'Units','normalized','Position',[0.12 0.59 0.08 0.14],'Enable','inactive','ButtonDownFcn',@ResetFocus);
FIGOBJS.IM3.CURRENTLINE(1,1) = uicontrol('Parent',FIGOBJS.IM3.LineTab(1),'Style','text','BackgroundColor',BGcolour,'ForegroundColor',[0.8 0.8 0.8],'String','cdata','HorizontalAlignment','left','Fontsize',7,'Units','normalized','Position',[0.23 0.59 0.08 0.14],'Enable','inactive','ButtonDownFcn',@ResetFocus);
FIGOBJS.IM3.CURRENTLINE(1,2) = uicontrol('Parent',FIGOBJS.IM3.LineTab(1),'Style','text','BackgroundColor',BGcolour,'ForegroundColor',[0.8 0.8 0.8],'String','cdata','HorizontalAlignment','left','Fontsize',7,'Units','normalized','Position',[0.32 0.59 0.08 0.14],'Enable','inactive','ButtonDownFcn',@ResetFocus);
FIGOBJS.IM3.CURRENTLINE(1,3) = uicontrol('Parent',FIGOBJS.IM3.LineTab(1),'Style','text','BackgroundColor',BGcolour,'ForegroundColor',[0.8 0.8 0.8],'String','cdata','HorizontalAlignment','left','Fontsize',7,'Units','normalized','Position',[0.41 0.59 0.08 0.14],'Enable','inactive','ButtonDownFcn',@ResetFocus);
FIGOBJS.IM3.CURRENTLINE(1,4) = uicontrol('Parent',FIGOBJS.IM3.LineTab(1),'Style','text','BackgroundColor',BGcolour,'ForegroundColor',[0.8 0.8 0.8],'String','cdata','HorizontalAlignment','left','Fontsize',7,'Units','normalized','Position',[0.50 0.59 0.08 0.14],'Enable','inactive','ButtonDownFcn',@ResetFocus);
for m = 1:3
    FIGOBJS.IM3.LINELAB(1,m) = uicontrol('Parent',FIGOBJS.IM3.LineTab(n),'Style','text','BackgroundColor',BGcolour,'ForegroundColor',[0.8 0.8 0.8],'String',['Line ',num2str(m)],'HorizontalAlignment','right','Fontsize',7,'Units','normalized','Position',[0.12 0.59-(m*0.15) 0.08 0.14],'ButtonDownFcn',@LineButtonControl,'UserData',[n,m]);
    FIGOBJS.IM3.SAVEDLINES(1,m,1) = uicontrol('Parent',FIGOBJS.IM3.LineTab(1),'Style','text','BackgroundColor',BGcolour,'ForegroundColor',[0.8 0.8 0.8],'String','cdata','HorizontalAlignment','left','Fontsize',7,'Units','normalized','Position',[0.23 0.59-(m*0.15) 0.08 0.14],'Enable','inactive','ButtonDownFcn',@ResetFocus);
    FIGOBJS.IM3.SAVEDLINES(1,m,2) = uicontrol('Parent',FIGOBJS.IM3.LineTab(1),'Style','text','BackgroundColor',BGcolour,'ForegroundColor',[0.8 0.8 0.8],'String','cdata','HorizontalAlignment','left','Fontsize',7,'Units','normalized','Position',[0.32 0.59-(m*0.15) 0.08 0.14],'Enable','inactive','ButtonDownFcn',@ResetFocus);
    FIGOBJS.IM3.SAVEDLINES(1,m,3) = uicontrol('Parent',FIGOBJS.IM3.LineTab(1),'Style','text','BackgroundColor',BGcolour,'ForegroundColor',[0.8 0.8 0.8],'String','cdata','HorizontalAlignment','left','Fontsize',7,'Units','normalized','Position',[0.41 0.59-(m*0.15) 0.08 0.14],'Enable','inactive','ButtonDownFcn',@ResetFocus);
    FIGOBJS.IM3.SAVEDLINES(1,m,4) = uicontrol('Parent',FIGOBJS.IM3.LineTab(1),'Style','text','BackgroundColor',BGcolour,'ForegroundColor',[0.8 0.8 0.8],'String','cdata','HorizontalAlignment','left','Fontsize',7,'Units','normalized','Position',[0.50 0.59-(m*0.15) 0.08 0.14],'Enable','inactive','ButtonDownFcn',@ResetFocus);
    FIGOBJS.IM3.DeleteLine(1,m) = uicontrol('Parent',FIGOBJS.IM3.LineTab(n),'Style','pushbutton','tag',num2str(n),'BackgroundColor',[0.8 0.8 0.8],'ForegroundColor',BGcolour,'String','Drop Last','HorizontalAlignment','left','Fontsize',7,'Units','normalized','Position',[0.58 0.59-(m*0.15) 0.06 0.16],'CallBack',@ButtonDeleteLine,'UserData',[n,m]); 
end

%================================================================
% Imaging4 Tab
%================================================================
FIGOBJS.IM4.ImPan(1) = uipanel('Parent',IM4);
FIGOBJS.IM4.ImPan(1).BackgroundColor = [0.1 0.1 0.1];
FIGOBJS.IM4.ImPan(1).Position = [0.005 0.505 0.395 0.485];
FIGOBJS.IM4.ImPan(2) = uipanel('Parent',IM4);
FIGOBJS.IM4.ImPan(2).BackgroundColor = [0.1 0.1 0.1];
FIGOBJS.IM4.ImPan(2).Position = [0.405 0.505 0.395 0.485];
FIGOBJS.IM4.ImPan(3) = uipanel('Parent',IM4);
FIGOBJS.IM4.ImPan(3).BackgroundColor = [0.1 0.1 0.1];
FIGOBJS.IM4.ImPan(3).Position = [0.005 0.01 0.395 0.485];
FIGOBJS.IM4.ImPan(4) = uipanel('Parent',IM4);
FIGOBJS.IM4.ImPan(4).BackgroundColor = [0.1 0.1 0.1];
FIGOBJS.IM4.ImPan(4).Position = [0.405 0.01 0.395 0.485];

for n = 1:4
    FIGOBJS.IM4.ImAxes(n) = axes('Parent',FIGOBJS.IM4.ImPan(n));
    FIGOBJS.IM4.ImAxes(n).Tag = num2str(n);
    FIGOBJS.IM4.ImAxes(n).NextPlot = 'replacechildren';
    FIGOBJS.IM4.ImAxes(n).Position = [0 0 1 1];
    FIGOBJS.IM4.ImAxes(n).ButtonDownFcn = @ButtonPressControl;
    FIGOBJS.IM4.ImAxes(n).PickableParts = 'all';
    FIGOBJS.IM4.ImAxes(n).Visible = 'off';
    FIGOBJS.IM4.ImAxes(n).Interruptible = 'off';
    FIGOBJS.IM4.ImAxes(n).Color = BGcolour;
end
FIGOBJS.IM4.AspectRatio = 1.55;

%================================================================
% Side Panel
%================================================================
tablabs = {'IM','IM2','IM3','IM4'};
tabs = {IM,IM2,IM3,IM4};

N = [10 2 1 4]; 
top = 570;
for p = 1:length(tabs)
    FIGOBJS.(tablabs{p}).UberTabGroup = uitabgroup(tabs{p},'Position',[0.805 0.34 0.190 0.65]);             
    %FIGOBJS.(tablabs{p}).UberTabGroup.SelectionChangedFcn = @UberTabChangeControl;
    if p == 1
        FIGOBJS.(tablabs{p}).TopScriptTab = uitab(FIGOBJS.(tablabs{p}).UberTabGroup,'Title','Script');
        FIGOBJS.(tablabs{p}).TopScriptTab.ButtonDownFcn = @ResetFocus;           
        FIGOBJS.(tablabs{p}).ScriptTabGroup = uitabgroup(FIGOBJS.(tablabs{p}).TopScriptTab,'Position',[0 0 1 1]);            
        %FIGOBJS.(tablabs{p}).ScriptTabGroup.SelectionChangedFcn = @ScriptTabChangeControl;
    end
    if p~=2 && p~=3
        FIGOBJS.(tablabs{p}).TopGeneralTab = uitab(FIGOBJS.(tablabs{p}).UberTabGroup,'Title','General');
        FIGOBJS.(tablabs{p}).TopGeneralTab.ButtonDownFcn = @ResetFocus;        
        FIGOBJS.(tablabs{p}).GeneralTabGroup = uitabgroup(FIGOBJS.(tablabs{p}).TopGeneralTab,'Position',[0 0 1 1]);             
        FIGOBJS.(tablabs{p}).GeneralTabGroup.SelectionChangedFcn = @GeneralTabChangeControl;   
    end
    FIGOBJS.(tablabs{p}).TopAnlzTab = uitab(FIGOBJS.(tablabs{p}).UberTabGroup,'Title','Analysis');
    FIGOBJS.(tablabs{p}).TopAnlzTab.ButtonDownFcn = @ResetFocus;
    FIGOBJS.(tablabs{p}).AnlzTabGroup = uitabgroup(FIGOBJS.(tablabs{p}).TopAnlzTab,'Position',[0 0 1 1]);            
    FIGOBJS.(tablabs{p}).AnlzTabGroup.SelectionChangedFcn = @AnlzTabChangeControl;    
    if p ~= 1
        FIGOBJS.(tablabs{p}).TopScriptTab = uitab(FIGOBJS.(tablabs{p}).UberTabGroup,'Title','Script');
        FIGOBJS.(tablabs{p}).TopScriptTab.ButtonDownFcn = @ResetFocus;           
        FIGOBJS.(tablabs{p}).ScriptTabGroup = uitabgroup(FIGOBJS.(tablabs{p}).TopScriptTab,'Position',[0 0 1 1]);            
        %FIGOBJS.(tablabs{p}).ScriptTabGroup.SelectionChangedFcn = @ScriptTabChangeControl;
    end
    FIGOBJS.(tablabs{p}).PanelLengths = [30 30 30 30];           
    FIGOBJS.(tablabs{p}).TopInfoTab = uitab(FIGOBJS.(tablabs{p}).UberTabGroup,'Title','Info');
    FIGOBJS.(tablabs{p}).TopInfoTab.ButtonDownFcn = @ResetFocus;
    FIGOBJS.(tablabs{p}).InfoTabGroup = uitabgroup(FIGOBJS.(tablabs{p}).TopInfoTab,'Position',[0 0 1 1]);            
    FIGOBJS.(tablabs{p}).InfoTabGroup.SelectionChangedFcn = @InfoTabChangeControl;     
    
    for n = 1:N(p)       
        % General
        if p~=2 && p~=3
            FIGOBJS.(tablabs{p}).GeneralTab(n) = uitab(FIGOBJS.(tablabs{p}).GeneralTabGroup,'Title',['Gen',num2str(n)]);
            FIGOBJS.(tablabs{p}).GeneralTab(n).BackgroundColor = BGcolour;
            FIGOBJS.(tablabs{p}).GeneralTab(n).ButtonDownFcn = @ResetFocus;
            uicontrol('Parent',FIGOBJS.(tablabs{p}).GeneralTab(n),'Style','text','tag',num2str(n),'BackgroundColor',BGcolour,'ForegroundColor',[0.8 0.8 0.8],'String','Max','HorizontalAlignment','right','Fontsize',7,'Units','normalized','Position',[0 0.944 0.12 0.025],'Enable','inactive','ButtonDownFcn',@ResetFocus);
            FIGOBJS.(tablabs{p}).ContrastMax(n) = uicontrol('Parent',FIGOBJS.(tablabs{p}).GeneralTab(n),'Style','slider','tag',num2str(n),'BackgroundColor',[0.8 0.8 0.8],'ForegroundColor',BGcolour,'Units','normalized','Position',[0.14 0.950 0.65 0.022],'Value',1,'CallBack',@ContrastMax,'SliderStep',[0.02 0.1]);
            addlistener(FIGOBJS.(tablabs{p}).ContrastMax(n),'Value','PostSet',@ContrastMax2);
            FIGOBJS.(tablabs{p}).CMaxVal(n) = uicontrol('Parent',FIGOBJS.(tablabs{p}).GeneralTab(n),'Style','edit','tag',num2str(n),'BackgroundColor',BGcolour,'ForegroundColor',[0.8 0.8 0.8],'String','','HorizontalAlignment','left','Fontsize',6,'Units','normalized','Position',[0.81 0.950 0.10 0.022],'CallBack',@ContrastMaxval);
            uicontrol('Parent',FIGOBJS.(tablabs{p}).GeneralTab(n),'Style','text','tag',num2str(n),'BackgroundColor',BGcolour,'ForegroundColor',[0.8 0.8 0.8],'String','Min','HorizontalAlignment','right','Fontsize',7,'Units','normalized','Position',[0 0.914 0.12 0.025],'Enable','inactive','ButtonDownFcn',@ResetFocus);
            FIGOBJS.(tablabs{p}).ContrastMin(n) = uicontrol('Parent',FIGOBJS.(tablabs{p}).GeneralTab(n),'Style','slider','tag',num2str(n),'BackgroundColor',[0.8 0.8 0.8],'ForegroundColor',BGcolour,'Units','normalized','Position',[0.14 0.920 0.65 0.022],'Value',0,'CallBack',@ContrastMin,'SliderStep',[0.02 0.1]);
            addlistener(FIGOBJS.(tablabs{p}).ContrastMin(n),'Value','PostSet',@ContrastMin2);
            FIGOBJS.(tablabs{p}).CMinVal(n) = uicontrol('Parent',FIGOBJS.(tablabs{p}).GeneralTab(n),'Style','edit','tag',num2str(n),'BackgroundColor',BGcolour,'ForegroundColor',[0.8 0.8 0.8],'String','','HorizontalAlignment','left','Fontsize',6,'Units','normalized','Position',[0.81 0.920 0.10 0.022],'CallBack',@ContrastMinval);      
            uicontrol('Parent',FIGOBJS.(tablabs{p}).GeneralTab(n),'Style','text','tag',num2str(n),'BackgroundColor',BGcolour,'ForegroundColor',[0.8 0.8 0.8],'String','Type','HorizontalAlignment','right','Fontsize',7,'Units','normalized','Position',[0 0.874 0.12 0.025],'Enable','inactive','ButtonDownFcn',@ResetFocus);
            FIGOBJS.(tablabs{p}).ImType(n) = uicontrol('Parent',FIGOBJS.(tablabs{p}).GeneralTab(n),'Style','popupmenu','tag',num2str(n),'BackgroundColor',[0.8 0.8 0.8],'ForegroundColor',BGcolour,'String',{'abs','real','imag','phase','map'},'HorizontalAlignment','right','Fontsize',6,'Units','normalized','Position',[0.14 0.88 0.13 0.022],'CallBack',@ChangeImType);
            uicontrol('Parent',FIGOBJS.(tablabs{p}).GeneralTab(n),'Style','text','tag',num2str(n),'BackgroundColor',BGcolour,'ForegroundColor',[0.8 0.8 0.8],'String','Colour','HorizontalAlignment','right','Fontsize',7,'Units','normalized','Position',[0.28 0.874 0.12 0.025],'Enable','inactive','ButtonDownFcn',@ResetFocus);
            FIGOBJS.(tablabs{p}).ImColour(n) = uicontrol('Parent',FIGOBJS.(tablabs{p}).GeneralTab(n),'Style','popupmenu','tag',num2str(n),'BackgroundColor',[0.8 0.8 0.8],'ForegroundColor',BGcolour,'String',{'off','on'},'HorizontalAlignment','right','Fontsize',6,'Units','normalized','Position',[0.42 0.88 0.13 0.022],'CallBack',@ChangeColour);
            uicontrol('Parent',FIGOBJS.(tablabs{p}).GeneralTab(n),'Style','text','tag',num2str(n),'BackgroundColor',BGcolour,'ForegroundColor',[0.8 0.8 0.8],'String','Hold Contrast','HorizontalAlignment','right','Fontsize',7,'Units','normalized','Position',[0.56 0.874 0.2 0.025],'Enable','inactive','ButtonDownFcn',@ResetFocus);
            FIGOBJS.(tablabs{p}).HoldContrast(n) = uicontrol('Parent',FIGOBJS.(tablabs{p}).GeneralTab(n),'Style','checkbox','tag',num2str(n),'BackgroundColor',BGcolour,'ForegroundColor',[0.8 0.8 0.8],'Fontsize',6,'Units','normalized','Position',[0.78 0.88 0.12 0.022],'CallBack',@HoldContrastChange);     
            uicontrol('Parent',FIGOBJS.(tablabs{p}).GeneralTab(n),'Style','text','tag',num2str(n),'BackgroundColor',BGcolour,'ForegroundColor',[0.8 0.8 0.8],'String','4th Dim','HorizontalAlignment','right','Fontsize',7,'Units','normalized','Position',[0 0.834 0.12 0.025],'Enable','inactive','ButtonDownFcn',@ResetFocus);
            FIGOBJS.(tablabs{p}).Dim4(n) = uicontrol('Parent',FIGOBJS.(tablabs{p}).GeneralTab(n),'Style','slider','tag',num2str(n),'BackgroundColor',[0.8 0.8 0.8],'ForegroundColor',BGcolour,'Units','normalized','Position',[0.14 0.84 0.65 0.022],'Value',0,'CallBack',@Dim4ChangeControl,'SliderStep',[1 1],'Enable','off');
            FIGOBJS.(tablabs{p}).Dim4Val(n) = uicontrol('Parent',FIGOBJS.(tablabs{p}).GeneralTab(n),'Style','edit','tag',num2str(n),'BackgroundColor',BGcolour,'ForegroundColor',[0.8 0.8 0.8],'String','','HorizontalAlignment','left','Fontsize',6,'Units','normalized','Position',[0.81 0.84 0.10 0.022],'CallBack',@Dim4val);
            uicontrol('Parent',FIGOBJS.(tablabs{p}).GeneralTab(n),'Style','text','tag',num2str(n),'BackgroundColor',BGcolour,'ForegroundColor',[0.8 0.8 0.8],'String','5th Dim','HorizontalAlignment','right','Fontsize',7,'Units','normalized','Position',[0 0.804 0.12 0.025],'Enable','inactive','ButtonDownFcn',@ResetFocus);
            FIGOBJS.(tablabs{p}).Dim5(n) = uicontrol('Parent',FIGOBJS.(tablabs{p}).GeneralTab(n),'Style','slider','tag',num2str(n),'BackgroundColor',[0.8 0.8 0.8],'ForegroundColor',BGcolour,'Units','normalized','Position',[0.14 0.81 0.65 0.022],'Value',0,'CallBack',@Dim5ChangeControl,'SliderStep',[1 1],'Enable','off');
            FIGOBJS.(tablabs{p}).Dim5Val(n) = uicontrol('Parent',FIGOBJS.(tablabs{p}).GeneralTab(n),'Style','edit','tag',num2str(n),'BackgroundColor',BGcolour,'ForegroundColor',[0.8 0.8 0.8],'String','','HorizontalAlignment','left','Fontsize',6,'Units','normalized','Position',[0.81 0.81 0.10 0.022],'CallBack',@Dim5val);
            uicontrol('Parent',FIGOBJS.(tablabs{p}).GeneralTab(n),'Style','text','tag',num2str(n),'BackgroundColor',BGcolour,'ForegroundColor',[0.8 0.8 0.8],'String','6th Dim','HorizontalAlignment','right','Fontsize',7,'Units','normalized','Position',[0 0.774 0.12 0.025],'Enable','inactive','ButtonDownFcn',@ResetFocus);
            FIGOBJS.(tablabs{p}).Dim6(n) = uicontrol('Parent',FIGOBJS.(tablabs{p}).GeneralTab(n),'Style','slider','tag',num2str(n),'BackgroundColor',[0.8 0.8 0.8],'ForegroundColor',BGcolour,'Units','normalized','Position',[0.14 0.78 0.65 0.022],'Value',0,'CallBack',@Dim6ChangeControl,'SliderStep',[1 1],'Enable','off');
            FIGOBJS.(tablabs{p}).Dim6Val(n) = uicontrol('Parent',FIGOBJS.(tablabs{p}).GeneralTab(n),'Style','edit','tag',num2str(n),'BackgroundColor',BGcolour,'ForegroundColor',[0.8 0.8 0.8],'String','','HorizontalAlignment','left','Fontsize',6,'Units','normalized','Position',[0.81 0.78 0.10 0.022],'CallBack',@Dim6val);
            uicontrol('Parent',FIGOBJS.(tablabs{p}).GeneralTab(n),'Style','text','tag',num2str(n),'BackgroundColor',BGcolour,'ForegroundColor',[0.8 0.8 0.8],'String','Orient','HorizontalAlignment','right','Fontsize',7,'Units','normalized','Position',[0 0.734 0.12 0.025],'Enable','inactive','ButtonDownFcn',@ResetFocus);
            FIGOBJS.(tablabs{p}).Orientation(n) = uicontrol('Parent',FIGOBJS.(tablabs{p}).GeneralTab(n),'Style','popupmenu','tag',num2str(n),'BackgroundColor',[0.8 0.8 0.8],'ForegroundColor',BGcolour,'String',{'Axial','Sagittal','Coronal'},'HorizontalAlignment','right','Fontsize',6,'Units','normalized','Position',[0.14 0.74 0.13 0.022],'CallBack',@ChangeOrientation);
        end
   
        % Anlz
        FIGOBJS.(tablabs{p}).AnlzTab(n) = uitab(FIGOBJS.(tablabs{p}).AnlzTabGroup,'Title',['Anlz',num2str(n)]);
        FIGOBJS.(tablabs{p}).AnlzTab(n).BackgroundColor = BGcolour;
        FIGOBJS.(tablabs{p}).AnlzTab(n).ButtonDownFcn = @ResetFocus;
        uicontrol('Parent',FIGOBJS.(tablabs{p}).AnlzTab(n),'Style','text','BackgroundColor',BGcolour,'ForegroundColor',[0.8 0.8 0.8],'String','Name','HorizontalAlignment','center','Fontsize',8,'Units','normalized','Position',[0.2 0.96 0.3 0.0225],'Enable','inactive','ButtonDownFcn',@ResetFocus);
        uicontrol('Parent',FIGOBJS.(tablabs{p}).AnlzTab(n),'Style','text','BackgroundColor',BGcolour,'ForegroundColor',[0.8 0.8 0.8],'String','Mean','HorizontalAlignment','center','Fontsize',8,'Units','normalized','Position',[0.5 0.96 0.15 0.0225],'Enable','inactive','ButtonDownFcn',@ResetFocus);
        uicontrol('Parent',FIGOBJS.(tablabs{p}).AnlzTab(n),'Style','text','BackgroundColor',BGcolour,'ForegroundColor',[0.8 0.8 0.8],'String','Sdv','HorizontalAlignment','center','Fontsize',8,'Units','normalized','Position',[0.65 0.96 0.15 0.0225],'Enable','inactive','ButtonDownFcn',@ResetFocus);
        uicontrol('Parent',FIGOBJS.(tablabs{p}).AnlzTab(n),'Style','text','BackgroundColor',BGcolour,'ForegroundColor',[0.8 0.8 0.8],'String','Vol (cm3)','HorizontalAlignment','center','Fontsize',8,'Units','normalized','Position',[0.8 0.96 0.15 0.0225],'Enable','inactive','ButtonDownFcn',@ResetFocus);
        uicontrol('Parent',FIGOBJS.(tablabs{p}).AnlzTab(n),'Style','text','BackgroundColor',BGcolour,'ForegroundColor',[0.8 0.8 0.8],'String','Current','HorizontalAlignment','right','Fontsize',8,'Units','normalized','Position',[0 0.93 0.125 0.0225],'Enable','inactive','ButtonDownFcn',@ResetFocus);
        FIGOBJS.(tablabs{p}).CURRENT(n,2) = uicontrol('Parent',FIGOBJS.(tablabs{p}).AnlzTab(n),'Style','text','BackgroundColor',BGcolour,'ForegroundColor',[0.8 0.8 0.8],'String','','HorizontalAlignment','left','Fontsize',8,'Units','normalized','Position',[0.53 0.93 0.3 0.0225],'Enable','inactive','ButtonDownFcn',@ResetFocus);
        FIGOBJS.(tablabs{p}).CURRENT(n,3) = uicontrol('Parent',FIGOBJS.(tablabs{p}).AnlzTab(n),'Style','text','BackgroundColor',BGcolour,'ForegroundColor',[0.8 0.8 0.8],'String','','HorizontalAlignment','left','Fontsize',8,'Units','normalized','Position',[0.7 0.93 0.15 0.0225],'Enable','inactive','ButtonDownFcn',@ResetFocus);
        FIGOBJS.(tablabs{p}).CURRENT(n,1) = uicontrol('Parent',FIGOBJS.(tablabs{p}).AnlzTab(n),'Style','text','BackgroundColor',BGcolour,'ForegroundColor',[0.8 0.8 0.8],'String','','HorizontalAlignment','left','Fontsize',8,'Units','normalized','Position',[0.85 0.93 0.15 0.0225],'Enable','inactive','ButtonDownFcn',@ResetFocus);
        for m = 1:35
            FIGOBJS.(tablabs{p}).ROILAB(n,m) = uicontrol('Parent',FIGOBJS.(tablabs{p}).AnlzTab(n),'Style','text','BackgroundColor',BGcolour,'ForegroundColor',[0.8 0.8 0.8],'String',['ROI',num2str(m)],'HorizontalAlignment','right','Fontsize',8,'Units','normalized','Position',[0 0.93-m*0.0225 0.125 0.0225],'ButtonDownFcn',@ROIButtonControl,'UserData',[n,m]);
            FIGOBJS.(tablabs{p}).ROINAME(n,m) = uicontrol('Parent',FIGOBJS.(tablabs{p}).AnlzTab(n),'Style','text','BackgroundColor',BGcolour,'ForegroundColor',[0.8 0.8 0.8],'String','','HorizontalAlignment','left','Fontsize',8,'Units','normalized','Position',[0.18 0.93-m*0.0225 0.4 0.0225],'Enable','inactive','ButtonDownFcn',@ResetFocus);
            FIGOBJS.(tablabs{p}).OUTPUT(n,m,2) = uicontrol('Parent',FIGOBJS.(tablabs{p}).AnlzTab(n),'Style','text','BackgroundColor',BGcolour,'ForegroundColor',[0.8 0.8 0.8],'String','','HorizontalAlignment','left','Fontsize',8,'Units','normalized','Position',[0.53 0.93-m*0.0225 0.15 0.0225],'Enable','inactive','ButtonDownFcn',@ResetFocus);
            FIGOBJS.(tablabs{p}).OUTPUT(n,m,3) = uicontrol('Parent',FIGOBJS.(tablabs{p}).AnlzTab(n),'Style','text','BackgroundColor',BGcolour,'ForegroundColor',[0.8 0.8 0.8],'String','','HorizontalAlignment','left','Fontsize',8,'Units','normalized','Position',[0.7 0.93-m*0.0225 0.15 0.0225],'Enable','inactive','ButtonDownFcn',@ResetFocus);
            FIGOBJS.(tablabs{p}).OUTPUT(n,m,1) = uicontrol('Parent',FIGOBJS.(tablabs{p}).AnlzTab(n),'Style','text','BackgroundColor',BGcolour,'ForegroundColor',[0.8 0.8 0.8],'String','','HorizontalAlignment','left','Fontsize',8,'Units','normalized','Position',[0.85 0.93-m*0.0225 0.15 0.0225],'Enable','inactive','ButtonDownFcn',@ResetFocus);
        end
        
        % Info
        FIGOBJS.(tablabs{p}).InfoTab(n) = uitab(FIGOBJS.(tablabs{p}).InfoTabGroup,'Title',['Info',num2str(n)]);
        FIGOBJS.(tablabs{p}).InfoTab(n).BackgroundColor = BGcolour;
        FIGOBJS.(tablabs{p}).InfoTab(n).ButtonDownFcn = @ResetFocus;
        FIGOBJS.(tablabs{p}).Info(n) = uicontrol('Parent',FIGOBJS.(tablabs{p}).InfoTab(n),'Style','edit');
        FIGOBJS.(tablabs{p}).Info(n).Units = 'normalized';
        FIGOBJS.(tablabs{p}).Info(n).Position = [0 0 1 1]; 
        FIGOBJS.(tablabs{p}).Info(n).Max = 2; 
        FIGOBJS.(tablabs{p}).Info(n).HorizontalAlignment = 'left';
        FIGOBJS.(tablabs{p}).Info(n).Enable = 'inactive'; 
        FIGOBJS.(tablabs{p}).Info(n).FontSize = 7;
        FIGOBJS.(tablabs{p}).Info(n).BackgroundColor = BGcolour;
        FIGOBJS.(tablabs{p}).Info(n).ForegroundColor = [0.8 0.8 0.8];
        FIGOBJS.(tablabs{p}).Info(n).HitTest = 'off';         
    end

    % Info (Loaded)
    FIGOBJS.(tablabs{p}).InfoTabL = uitab(FIGOBJS.(tablabs{p}).InfoTabGroup,'Title','InfoL');
    FIGOBJS.(tablabs{p}).InfoTabL.BackgroundColor = BGcolour;
    FIGOBJS.(tablabs{p}).InfoTabL.ButtonDownFcn = @ResetFocus;
    FIGOBJS.(tablabs{p}).InfoL = uicontrol('Parent',FIGOBJS.(tablabs{p}).InfoTabL,'Style','edit');
    FIGOBJS.(tablabs{p}).InfoL.Units = 'normalized';
    FIGOBJS.(tablabs{p}).InfoL.Position = [0 0 1 1]; 
    FIGOBJS.(tablabs{p}).InfoL.Max = 2; 
    FIGOBJS.(tablabs{p}).InfoL.HorizontalAlignment = 'left';
    FIGOBJS.(tablabs{p}).InfoL.Enable = 'inactive'; 
    FIGOBJS.(tablabs{p}).InfoL.FontSize = 7;
    FIGOBJS.(tablabs{p}).InfoL.BackgroundColor = BGcolour;
    FIGOBJS.(tablabs{p}).InfoL.ForegroundColor = [0.8 0.8 0.8];
    FIGOBJS.(tablabs{p}).InfoL.HitTest = 'off';         
    
    % Script
    for m = 1:4        
        FIGOBJS.(tablabs{p}).Pan(m) = uitab(FIGOBJS.(tablabs{p}).ScriptTabGroup,'Title',['Script',num2str(m)]);
        FIGOBJS.(tablabs{p}).Pan(m).BackgroundColor = BGcolour;
        FIGOBJS.(tablabs{p}).Pan(m).ButtonDownFcn = @ResetFocus;       
        for n = 1:40
            FIGOBJS.(tablabs{p}).Select(m,n) = uicontrol('Parent',FIGOBJS.(tablabs{p}).Pan(m),'Style','pushbutton');
            FIGOBJS.(tablabs{p}).Select(m,n).Units = 'normalized';
            FIGOBJS.(tablabs{p}).Select(m,n).Position = [0.03 0.98-n*0.0225 0.11 0.020];
            FIGOBJS.(tablabs{p}).Select(m,n).String = 'Select';
            FIGOBJS.(tablabs{p}).Select(m,n).Visible = 'off';
            FIGOBJS.(tablabs{p}).Label(m,n) = uicontrol('Parent',FIGOBJS.(tablabs{p}).Pan(m),'Style','text');
            FIGOBJS.(tablabs{p}).Label(m,n).Units = 'normalized';
            FIGOBJS.(tablabs{p}).Label(m,n).Position = [0.16 0.978-n*0.0225 0.26 0.020];
            FIGOBJS.(tablabs{p}).Label(m,n).String = 'pasdvjapoijasdgsdg';
            FIGOBJS.(tablabs{p}).Label(m,n).HorizontalAlignment = 'left';
            FIGOBJS.(tablabs{p}).Label(m,n).BackgroundColor = [1 1 1];
            FIGOBJS.(tablabs{p}).Label(m,n).Visible = 'off';
            FIGOBJS.(tablabs{p}).Entry(m,n) = uicontrol('Parent',FIGOBJS.(tablabs{p}).Pan(m),'Style','text');
            FIGOBJS.(tablabs{p}).Entry(m,n).Units = 'normalized';
            FIGOBJS.(tablabs{p}).Entry(m,n).Position = [0.43 0.978-n*0.0225 0.57 0.020];
            FIGOBJS.(tablabs{p}).Entry(m,n).String = 'asdvapoisdvpoqqrgwegasd';
            FIGOBJS.(tablabs{p}).Entry(m,n).HorizontalAlignment = 'left';
            FIGOBJS.(tablabs{p}).Entry(m,n).BackgroundColor = [1 1 1];
            FIGOBJS.(tablabs{p}).Entry(m,n).Visible = 'off';
        end        
    end
end

%================================================================
% Access Tab
%================================================================
acctabs = [ACC,ACC2,ACC3,ACC4];
acclabs = {'ACC','ACC2','ACC3','ACC4'};
for p = 1:4

    FIGOBJS.(acclabs{p}).InfoTabGroup = uitabgroup(acctabs(p),'Position',[0.805 0.34 0.190 0.48]);
    FIGOBJS.(acclabs{p}).InfoTabGroup.SelectionChangedFcn = @InfoTabChangeControl;
    FIGOBJS.(acclabs{p}).InfoTab = uitab(FIGOBJS.(acclabs{p}).InfoTabGroup,'Title','Info');
    FIGOBJS.(acclabs{p}).InfoTab.ButtonDownFcn = @ResetFocus;  
    FIGOBJS.(acclabs{p}).Info = uicontrol('Parent',FIGOBJS.(acclabs{p}).InfoTab,'Style','edit');
    FIGOBJS.(acclabs{p}).Info.Units = 'normalized';
    FIGOBJS.(acclabs{p}).Info.Position = [0 0 1 1]; 
    FIGOBJS.(acclabs{p}).Info.Max = 2; 
    FIGOBJS.(acclabs{p}).Info.HorizontalAlignment = 'left';
    FIGOBJS.(acclabs{p}).Info.Enable = 'inactive'; 
    FIGOBJS.(acclabs{p}).Info.FontSize = 6;
    FIGOBJS.(acclabs{p}).Info.BackgroundColor = BGcolour;
    FIGOBJS.(acclabs{p}).Info.ForegroundColor = [0.8 0.8 0.8];
    FIGOBJS.(acclabs{p}).Info.HitTest = 'off';    
    
    for n = 1:5
        FIGOBJS.(acclabs{p}).Pan(n) = uipanel('Parent',acctabs(p));
        FIGOBJS.(acclabs{p}).Pan(n).BackgroundColor = BGcolour;
        FIGOBJS.(acclabs{p}).Pan(n).ButtonDownFcn = @AddScriptSelectClick;
        FIGOBJS.(acclabs{p}).Pan(n).UserData.PanNum = n;
        FIGOBJS.(acclabs{p}).Pan(n).UserData.Tab = acclabs{p};
    end
    FIGOBJS.(acclabs{p}).Pan(1).Position = [0.005 0.01 0.195 0.98];
    FIGOBJS.(acclabs{p}).Pan(2).Position = [0.205 0.01 0.195 0.98];
    FIGOBJS.(acclabs{p}).Pan(3).Position = [0.405 0.01 0.195 0.98];
    FIGOBJS.(acclabs{p}).Pan(4).Position = [0.605 0.01 0.195 0.98];
    FIGOBJS.(acclabs{p}).Pan(5).Position = [0.805 0.83 0.190 0.16];

    %------------------------------------------------
    % Select Buttons
    %------------------------------------------------
    for m = 1:4
        for n = 1:60
            FIGOBJS.(acclabs{p}).Select(m,n) = uicontrol('Parent',FIGOBJS.(acclabs{p}).Pan(m),'Style','pushbutton');
            FIGOBJS.(acclabs{p}).Select(m,n).Units = 'normalized';
            FIGOBJS.(acclabs{p}).Select(m,n).Position = [0.03 0.99-n*0.015 0.11 0.0125];
            FIGOBJS.(acclabs{p}).Select(m,n).String = 'Select';
            FIGOBJS.(acclabs{p}).Select(m,n).Visible = 'off';
        end
    end
    for n = 1:7
        FIGOBJS.(acclabs{p}).Select(5,n) = uicontrol('Parent',FIGOBJS.(acclabs{p}).Pan(5),'Style','pushbutton');
        FIGOBJS.(acclabs{p}).Select(5,n).Units = 'normalized';
        FIGOBJS.(acclabs{p}).Select(5,n).Position = [0.03 0.94-n*0.09 0.11 0.078];
        FIGOBJS.(acclabs{p}).Select(5,n).String = 'Select';
        FIGOBJS.(acclabs{p}).Select(5,n).Visible = 'off';
    end

    %------------------------------------------------
    % Label Strings
    %------------------------------------------------
    for m = 1:4
        for n = 1:60
            FIGOBJS.(acclabs{p}).Label(m,n) = uicontrol('Parent',FIGOBJS.(acclabs{p}).Pan(m),'Style','text');
            FIGOBJS.(acclabs{p}).Label(m,n).Units = 'normalized';
            FIGOBJS.(acclabs{p}).Label(m,n).Position = [0.16 0.988-n*0.015 0.26 0.0125];
            FIGOBJS.(acclabs{p}).Label(m,n).HorizontalAlignment = 'left';
            FIGOBJS.(acclabs{p}).Label(m,n).BackgroundColor = [1 1 1];
            FIGOBJS.(acclabs{p}).Label(m,n).Visible = 'off';
        end
    end
    for n = 1:7
        FIGOBJS.(acclabs{p}).Label(5,n) = uicontrol('Parent',FIGOBJS.(acclabs{p}).Pan(5),'Style','text');
        FIGOBJS.(acclabs{p}).Label(5,n).Units = 'normalized';
        FIGOBJS.(acclabs{p}).Label(5,n).Position = [0.16 0.93-n*0.09 0.26 0.078];
        FIGOBJS.(acclabs{p}).Label(5,n).HorizontalAlignment = 'left';
        FIGOBJS.(acclabs{p}).Label(5,n).BackgroundColor = [1 1 1];
        FIGOBJS.(acclabs{p}).Label(5,n).Visible = 'off';
    end

    %------------------------------------------------
    % Entry Strings
    %------------------------------------------------
    for m = 1:4
        for n = 1:60
            FIGOBJS.(acclabs{p}).Entry(m,n) = uicontrol('Parent',FIGOBJS.(acclabs{p}).Pan(m),'Style','text');
            FIGOBJS.(acclabs{p}).Entry(m,n).Units = 'normalized';
            FIGOBJS.(acclabs{p}).Entry(m,n).Position = [0.43 0.988-n*0.015 0.57 0.0125];
            FIGOBJS.(acclabs{p}).Entry(m,n).String = '';
            FIGOBJS.(acclabs{p}).Entry(m,n).HorizontalAlignment = 'left';
            FIGOBJS.(acclabs{p}).Entry(m,n).BackgroundColor = [1 1 1];
        end
    end
    for n = 1:7
        FIGOBJS.(acclabs{p}).Entry(5,n) = uicontrol('Parent',FIGOBJS.(acclabs{p}).Pan(5),'Style','text');
        FIGOBJS.(acclabs{p}).Entry(5,n).Units = 'normalized';
        FIGOBJS.(acclabs{p}).Entry(5,n).Position = [0.43 0.93-n*0.09 0.57 0.078];
        FIGOBJS.(acclabs{p}).Entry(5,n).String = '';
        FIGOBJS.(acclabs{p}).Entry(5,n).HorizontalAlignment = 'left';
        FIGOBJS.(acclabs{p}).Entry(5,n).BackgroundColor = [1 1 1];
        FIGOBJS.(acclabs{p}).Entry(5,n).Visible = 'off';
    end
    FIGOBJS.(acclabs{p}).PanelLengths = [60 60 60 60 7];
end

%================================================================
% Options
%================================================================
load('mycolormap3','mycmap');
FIGOBJS.Options.ColorMap = mycmap;
cmap = linspace(0,1,256);
FIGOBJS.Options.GrayMap = [cmap.' cmap.' cmap.'];
FIGOBJS.Compass.Colormap = FIGOBJS.Options.GrayMap;

%================================================================
% Script Setup
%================================================================
Tabs = {'ACC','ACC2','ACC3','ACC4'};
for tab = 1:length(Tabs)
    for n = 1:5
        AddScriptSelect(Tabs{tab},n);
    end
end
Tabs = {'IM','IM2','IM3','IM4'};
for tab = 1:length(Tabs)
    for n = 1:4
        AddScriptSelect(Tabs{tab},n);
    end
end

%================================================================
% Class Setup
%================================================================
global IMAGEANLZ
for n = 1:10
    IMAGEANLZ.('IM')(n) = ImageAnlzClass(FIGOBJS,'IM',n);
end
IMAGEANLZ.('IM2')(1) = ImageAnlzClass(FIGOBJS,'IM2',1); 
IMAGEANLZ.('IM2')(2) = ImageAnlzClass(FIGOBJS,'IM2',2);
IMAGEANLZ.('IM3')(1) = ImageAnlzClass(FIGOBJS,'IM3',1); 
IMAGEANLZ.('IM3')(2) = ImageAnlzClass(FIGOBJS,'IM3',2);
IMAGEANLZ.('IM3')(3) = ImageAnlzClass(FIGOBJS,'IM3',3);
IMAGEANLZ.('IM4')(1) = ImageAnlzClass(FIGOBJS,'IM4',1);  
IMAGEANLZ.('IM4')(2) = ImageAnlzClass(FIGOBJS,'IM4',2); 
IMAGEANLZ.('IM4')(3) = ImageAnlzClass(FIGOBJS,'IM4',3);  
IMAGEANLZ.('IM4')(4) = ImageAnlzClass(FIGOBJS,'IM4',4);

%================================================================
% Done
%================================================================
FIGOBJS.Compass.Visible = 'on';
disp('Finished');

%================================================================
%  
%================================================================

classdef FigObjsClass < handle

    properties (SetAccess = public)
        ImageName;
        POINTERlab;
        CURVAL;
        VALUElab;
        Xlab;
        Ylab;
        Zlab;
        XPixlab;
        YPixlab;
        ZPixlab;
        SLICElab;
        DIM4lab;
        DIM5lab;
        DIM6lab;
        DIM4;
        DIM5;
        DIM6;
        Dim4;
        Dim5;
        Dim6;
        X;
        Y;
        Z;
        XPix;
        YPix;
        ZPix;
        SLICE;
        TieAll;
        TieSlice;
        TieZoom;
        TieDims;
        TieROIs;
        TieDatVals;
        TieCursor;
        HoldContrast;
        TieContrast;
        Options;    
        ImColour;
        ImType;
        ImContMeth;
        ContrastMax;    
        ContrastMin;    
        CMaxVal; 
        CMinVal;
        MaxCMaxVal; 
        MinCMinVal; 
        Compass;
        ImAxes;
        OUTPUT;
        ROINAME;
        ROILAB;
        LINELAB;
        BOXLAB;
        CURRENT;
        CURRENTLINE;
        SAVEDLINES;
        CURRENTBOX;
        SAVEDBOXS;
        DeleteLine;
        DeleteBox;
        PlotLine;
        ActivateLineTool;
        ActivateBoxTool;
        ROICreateSel;
        ROITab;
        Colours;
        ImPan;
        UberTabGroup;
        TopAnlzTab;
        AnlzTab;
        AnlzTabGroup;
        Info;
        TopInfoTab;
        InfoTab;
        InfoTabL;
        InfoTabGroup;
        TopGeneralTab;
        GeneralTab;
        GeneralTabGroup;
        TABGP;
        IM,IM2,IM3,IM4,ACC1,ACC2,ACC3,ACC4;
        AspectRatio;
        Orientation;
        ShowOrtho;
        ShadeROI; ShadeROIValue;
        LinesROI;
        GblList;
        AutoUpdateROI;
        DrawROIonAll;
        ComplexAverage;
        NewROIbutton;
        AndROIbutton;        
        EraseROIbutton;
        RedrawROIbutton;
        OverlayColour;
        OverlayTransparency;
        OverlayValue;
        OverlayMax;
        OverlayMin;
        OverlayName;
    end
    
%==================================================================
% Init
%==================================================================        
    methods 
        % Setup
        function IMOBJS = Setup(IMOBJS,FIGOBJS,tab,axnum)
            IMOBJS = FigObjs_Setup(IMOBJS,FIGOBJS,tab,axnum);
        end 
        % Initialize
        function Initialize(IMOBJS)
            FigObjs_Initialize(IMOBJS);
        end

%==================================================================
% Panel Functions
%==================================================================  
        % Move2Tab
        function Move2Tab(IMOBJS,tab)
            IMOBJS.TABGP.SelectedTab = IMOBJS.(tab).Tab;
        end
        function IMOBJS = SetFocus(IMOBJS)                                  % when ready in mouse move control
            IMOBJS.Compass.CurrentAxes = IMOBJS.ImAxes;                
            IMOBJS.Compass.CurrentObject = IMOBJS.ImAxes;
        end
        function CurrentObject = GetFocus(IMOBJS)                                               
            CurrentObject = IMOBJS.Compass.CurrentObject;
        end
        
%==================================================================
% Mouse Functions
%==================================================================  
        function SetROIBuildFunctions(IMOBJS)
            IMOBJS.Compass.WindowKeyPressFcn = @DummyKeyPressControl;
            IMOBJS.Compass.WindowKeyReleaseFcn = @DummyKeyPressControl;
            IMOBJS.Compass.WindowScrollWheelFcn = @ScrollWheelControl;
            IMOBJS.Compass.WindowButtonMotionFcn = @RWSUI_MouseMoveControl2;
        end
        function ReturnPanelFunctions(IMOBJS)
            IMOBJS.Compass.WindowKeyPressFcn = @RWSUI_KeyPressControl;
            IMOBJS.Compass.WindowKeyReleaseFcn = @RWSUI_KeyReleaseControl;        
            IMOBJS.Compass.WindowScrollWheelFcn = @ScrollWheelControl;
            IMOBJS.Compass.WindowButtonMotionFcn = @RWSUI_MouseMoveControl;
        end

%==================================================================
% Overlay
%==================================================================          
        function SetOverlayValue(IMOBJS,overlaynum,val)       
            IMOBJS.OverlayValue(overlaynum).String = val;
        end
        function ClearOverlayValue(IMOBJS,overlaynum)       
            IMOBJS.OverlayValue(overlaynum).String = '';
        end
        function SetOverlayName(IMOBJS,name,overlaynum)       
            IMOBJS.OverlayName(overlaynum).String = name;
        end
        function DeleteOverlayName(IMOBJS,overlaynum)       
            IMOBJS.OverlayName(overlaynum).String = '';
        end
        function SetOverlayTransparency(IMOBJS,val,overlaynum)       
            IMOBJS.OverlayTransparency(overlaynum).Value = val;
        end
        function SetOverlayMax(IMOBJS,val,overlaynum)       
            IMOBJS.OverlayMax(overlaynum).String = num2str(val);
        end
        function SetOverlayMin(IMOBJS,val,overlaynum)       
            IMOBJS.OverlayMin(overlaynum).String = num2str(val);
        end
        function SetOverlayColour(IMOBJS,overlaynum)       
            IMOBJS.OverlayColour(overlaynum).Value = 2;
        end
        
%==================================================================
% Enable Contrast
%==================================================================          
        function EnableContrast(IMOBJS)
            IMOBJS.ImColour.Enable = 'on';
            IMOBJS.ImType.Enable = 'on';
            IMOBJS.ContrastMax.Enable = 'on';
            IMOBJS.ContrastMin.Enable = 'on';
            IMOBJS.CMaxVal.Enable = 'on';
            IMOBJS.CMinVal.Enable = 'on';
            IMOBJS.MaxCMaxVal.Enable = 'on';
            IMOBJS.MinCMinVal.Enable = 'on';
        end
        function DisplayOverlayContrast(IMOBJS,Contrast,overlaynum)
            IMOBJS.OverlayMax(overlaynum).String = num2str(Contrast(2),4);
            IMOBJS.OverlayMin(overlaynum).String = num2str(Contrast(1),4);
        end
            
%==================================================================
% ROI
%==================================================================  
        function MakeCurrentVisible(IMOBJS)
            for p = 1:3
                set(IMOBJS.CURRENT(p),'visible','on','string','0','foregroundcolor','r');
            end
        end
        function MakeCurrentInvisible(IMOBJS)        
            for p = 1:3
                set(IMOBJS.CURRENT(p),'visible','off');
            end
        end
    end
end
        
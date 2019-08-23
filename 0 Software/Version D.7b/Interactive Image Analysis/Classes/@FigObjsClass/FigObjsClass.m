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
        Options;    
        ImColour;
        ImType;
        ImContMeth;
        ContrastMax;    
        ContrastMin;    
        CMaxVal; 
        CMinVal; 
        Compass;
        ImAxes;
        OUTPUT;
        ROINAME;
        ROILAB;
        LINELAB;
        CURRENT;
        CURRENTLINE;
        SAVEDLINES;
        DeleteLine;
        ActivateLineTool;
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
        InfoTabGroup;
        TopGeneralTab;
        GeneralTab;
        GeneralTabGroup;
        TABGP;
        IM,IM2,IM3,IM4,ACC1,ACC2,ACC3,ACC4;
        AspectRatio;
        Orientation;
        ShowOrtho;
        ShadeROI;
        GblList;
        AutoUpdateROI;
        DrawROIonAll;
        ComplexAverage;
        NewROIbutton;
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
        
%=========================================================
% 
%=========================================================

function IMOBJS = FigObjs_Initialize(IMOBJS)

IMOBJS.ImAxes.UserData = [];
if not(isempty(IMOBJS.ImAxes.Children))
    GrxArr = IMOBJS.ImAxes.Children;
    for n = 1:length(GrxArr)
        delete(GrxArr(n));
    end
end
IMOBJS.ImAxes.Visible = 'off';
drawnow;

sz = size(IMOBJS.OUTPUT);
for n = 1:sz(1)
    for p = 1:3
        IMOBJS.OUTPUT(n,p).Visible = 'off';
    end
    IMOBJS.ROINAME(n).Visible = 'off';
    IMOBJS.ROILAB(n).ForegroundColor = [0.8 0.8 0.8];
end
for p = 1:3
    IMOBJS.CURRENT(p).Visible = 'off';
end
for p = 1:2
    IMOBJS.CURRENTLINE(p).Visible = 'off';
end
sz = size(IMOBJS.SAVEDLINES);
for n = 1:sz(1)
    for p = 1:2
        IMOBJS.SAVEDLINES(n,p).Visible = 'off';
    end
end

IMOBJS.ImageName.Visible = 'Off';
IMOBJS.POINTERlab.Visible = 'Off';
IMOBJS.CURVAL.Visible = 'Off';
IMOBJS.VALUElab.Visible = 'Off';
IMOBJS.Xlab.Visible = 'Off';
IMOBJS.Ylab.Visible = 'Off';
IMOBJS.Zlab.Visible = 'Off';
IMOBJS.XPixlab.Visible = 'Off';
IMOBJS.YPixlab.Visible = 'Off';
IMOBJS.ZPixlab.Visible = 'Off';
IMOBJS.SLICElab.Visible = 'Off';
IMOBJS.DIM4lab.Visible = 'Off';
IMOBJS.DIM5lab.Visible = 'Off';
IMOBJS.DIM6lab.Visible = 'Off';
IMOBJS.DIM4.Visible = 'Off';
IMOBJS.DIM5.Visible = 'Off';
IMOBJS.DIM6.Visible = 'Off';
IMOBJS.X.Visible = 'Off';
IMOBJS.Y.Visible = 'Off';
IMOBJS.Z.Visible = 'Off';
IMOBJS.XPix.Visible = 'Off';
IMOBJS.YPix.Visible = 'Off';
IMOBJS.ZPix.Visible = 'Off';
IMOBJS.SLICE.Visible = 'Off';

IMOBJS.TieAll.Value = 0;
IMOBJS.TieSlice.Value = 0;
IMOBJS.TieZoom.Value = 0;
IMOBJS.TieDims.Value = 0;
IMOBJS.TieROIs.Value = 0;
IMOBJS.TieDatVals.Value = 0;
IMOBJS.TieCursor.Value = 0;
IMOBJS.TieAll.Enable = 'on';
IMOBJS.TieSlice.Enable = 'on';
IMOBJS.TieZoom.Enable = 'on';
IMOBJS.TieDims.Enable = 'on';
IMOBJS.TieROIs.Enable = 'on';
IMOBJS.TieDatVals.Enable = 'on';
IMOBJS.TieCursor.Enable = 'on';

IMOBJS.HoldContrast.Value = 0;
IMOBJS.ShadeROI.Value = 0;
IMOBJS.NewROIbutton.BackgroundColor = [0.8 0.8 0.8];

colormap(IMOBJS.ImAxes,IMOBJS.Options.GrayMap);    
IMOBJS.ImColour.Value = 1;
IMOBJS.ImType.Value = 1;
IMOBJS.ImContMeth.Value = 1;

IMOBJS.ContrastMax.Value = 1;    
IMOBJS.ContrastMin.Value = 0;    
IMOBJS.CMaxVal.String = '1';  
IMOBJS.CMinVal.String = '0';  

IMOBJS.Dim4.Max = 1;
IMOBJS.Dim4.Value = 1;
IMOBJS.Dim4.Enable = 'off';
IMOBJS.Dim5.Max = 1;
IMOBJS.Dim5.Value = 1;
IMOBJS.Dim5.Enable = 'off';
IMOBJS.Dim6.Max = 1;
IMOBJS.Dim6.Value = 1;
IMOBJS.Dim6.Enable = 'off';

IMOBJS.Orientation.Value = 1;
IMOBJS.Orientation.Enable = 'on';
IMOBJS.ShowOrtho.Value = 0;
IMOBJS.ShowOrtho.Enable = 'on';

IMOBJS.GblList.Value = [];

IMOBJS.Compass.WindowKeyPressFcn = @RWSUI_KeyPressControl;
IMOBJS.Compass.WindowKeyReleaseFcn = @RWSUI_KeyReleaseControl;        
IMOBJS.Compass.WindowScrollWheelFcn = @ScrollWheelControl;
IMOBJS.Compass.WindowButtonMotionFcn = @RWSUI_MouseMoveControl;
IMOBJS.Compass.KeyPressFcn = '';
IMOBJS.Compass.KeyReleaseFcn = '';

Status2('done','',1);
Status2('done','',2);
Status2('done','',3);



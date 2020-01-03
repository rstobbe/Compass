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
for p = 1:4
    IMOBJS.CURRENTLINE(p).Visible = 'off';
end
sz = size(IMOBJS.SAVEDLINES);
for n = 1:sz(1)
    for p = 1:4
        IMOBJS.SAVEDLINES(n,p).Visible = 'off';
        IMOBJS.LINELAB(n).ForegroundColor = [0.8 0.8 0.8];
    end
    IMOBJS.DeleteLine(n).Visible = 'off';
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

IMOBJS.TieAll.Value = 1;
IMOBJS.TieSlice.Value = 1;
IMOBJS.TieZoom.Value = 1;
IMOBJS.TieDims.Value = 1;
IMOBJS.TieROIs.Value = 1;
IMOBJS.TieDatVals.Value = 1;
IMOBJS.TieCursor.Value = 0;
IMOBJS.TieAll.Enable = 'on';
IMOBJS.TieSlice.Enable = 'on';
IMOBJS.TieZoom.Enable = 'on';
IMOBJS.TieDims.Enable = 'on';
IMOBJS.TieROIs.Enable = 'on';
IMOBJS.TieDatVals.Enable = 'on';
IMOBJS.TieCursor.Enable = 'on';

IMOBJS.HoldContrast.Value = 0;
IMOBJS.HoldContrast.Enable = 'inactive';
IMOBJS.ShadeROI.Value = 0;
IMOBJS.LinesROI.Value = 1;
IMOBJS.ShadeROIValue.Value = 0.12;
IMOBJS.NewROIbutton.BackgroundColor = [0.8 0.8 0.8];
IMOBJS.NewROIbutton.ForegroundColor = [0.149 0.149 0.241];
IMOBJS.ActivateLineTool.BackgroundColor = [0.8 0.8 0.8];
IMOBJS.ActivateLineTool.ForegroundColor = [0.149 0.149 0.241];
IMOBJS.EraseROIbutton.BackgroundColor = [0.8 0.8 0.8];
IMOBJS.EraseROIbutton.ForegroundColor = [0.149 0.149 0.241];
IMOBJS.RedrawROIbutton.BackgroundColor = [0.8 0.8 0.8];
IMOBJS.RedrawROIbutton.ForegroundColor = [0.149 0.149 0.241];

colormap(IMOBJS.ImAxes,IMOBJS.Options.GrayMap);    
IMOBJS.ImColour.Value = 1;
IMOBJS.ImColour.Enable = 'inactive';
IMOBJS.ImType.Value = 1;
IMOBJS.ImType.Enable = 'inactive';
IMOBJS.ImContMeth.Value = 1;

IMOBJS.ContrastMax.Value = 1; 
IMOBJS.ContrastMax.Enable = 'inactive';
IMOBJS.ContrastMin.Value = 0;  
IMOBJS.ContrastMin.Enable = 'inactive';
IMOBJS.CMaxVal.String = '1';
IMOBJS.CMaxVal.ForegroundColor = [0.8 0.8 0.8];
IMOBJS.CMaxVal.Enable = 'inactive';
IMOBJS.CMinVal.String = '0'; 
IMOBJS.CMinVal.ForegroundColor = [0.8 0.8 0.8];
IMOBJS.CMinVal.Enable = 'inactive';
IMOBJS.MaxCMaxVal.String = '1';
IMOBJS.MaxCMaxVal.ForegroundColor = [0.8 0.8 0.8];
IMOBJS.MaxCMaxVal.Enable = 'inactive';
IMOBJS.MinCMinVal.String = '0';  
IMOBJS.MinCMinVal.ForegroundColor = [0.8 0.8 0.8];
IMOBJS.MinCMinVal.Enable = 'inactive';

for n = 1:4
    IMOBJS.OverlayTransparency(n).Value = 0.5; 
    IMOBJS.OverlayColour(n).Value = 2;
    IMOBJS.OverlayValue(n).String = '';
    IMOBJS.OverlayMax(n).String = '1';
    IMOBJS.OverlayMax(n).Enable = 'on';
    IMOBJS.OverlayMin(n).String = '0';
    IMOBJS.OverlayMin(n).Enable = 'on';
    IMOBJS.OverlayName(n).String = '';
end

IMOBJS.Dim4.Max = 1;
IMOBJS.Dim4.Value = 1;
IMOBJS.Dim4.Enable = 'inactive';
IMOBJS.Dim5.Max = 1;
IMOBJS.Dim5.Value = 1;
IMOBJS.Dim5.Enable = 'inactive';
IMOBJS.Dim6.Max = 1;
IMOBJS.Dim6.Value = 1;
IMOBJS.Dim6.Enable = 'inactive';

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



%=========================================================
% 
%=========================================================

function IMOBJS = FigObjs_Setup(IMOBJS,FIGOBJS,tab,axnum)

IMOBJS.(tab) = FIGOBJS.(tab);
if isfield(FIGOBJS,'TABGP')
    IMOBJS.TABGP = FIGOBJS.TABGP;
end
if isfield(FIGOBJS.(tab),'ImageName')
    if axnum <= length(FIGOBJS.(tab).ImageName)
        IMOBJS.ImageName = FIGOBJS.(tab).ImageName(axnum);
    end
end
if isfield(FIGOBJS.(tab),'POINTERlab')
    if axnum <= length(FIGOBJS.(tab).POINTERlab)
        IMOBJS.POINTERlab = FIGOBJS.(tab).POINTERlab(axnum);
    end
end
if isfield(FIGOBJS.(tab),'CURVAL')
    if axnum <= length(FIGOBJS.(tab).CURVAL)
        IMOBJS.CURVAL = FIGOBJS.(tab).CURVAL(axnum);
    end
end
if isfield(FIGOBJS.(tab),'VALUElab')
    if axnum <= length(FIGOBJS.(tab).VALUElab)
        IMOBJS.VALUElab = FIGOBJS.(tab).VALUElab(axnum);
    end
end
if isfield(FIGOBJS.(tab),'Xlab')
    if axnum <= length(FIGOBJS.(tab).Xlab)
        IMOBJS.Xlab = FIGOBJS.(tab).Xlab(axnum);
    end
end
if isfield(FIGOBJS.(tab),'Ylab')
    if axnum <= length(FIGOBJS.(tab).Ylab)
        IMOBJS.Ylab = FIGOBJS.(tab).Ylab(axnum);
    end
end
if isfield(FIGOBJS.(tab),'Zlab')
    if axnum <= length(FIGOBJS.(tab).Zlab)
        IMOBJS.Zlab = FIGOBJS.(tab).Zlab(axnum);
    end
end
if isfield(FIGOBJS.(tab),'XPixlab')
    if axnum <= length(FIGOBJS.(tab).XPixlab)
        IMOBJS.XPixlab = FIGOBJS.(tab).XPixlab(axnum);
    end
end
if isfield(FIGOBJS.(tab),'YPixlab')
    if axnum <= length(FIGOBJS.(tab).YPixlab)
        IMOBJS.YPixlab = FIGOBJS.(tab).YPixlab(axnum);
    end
end
if isfield(FIGOBJS.(tab),'ZPixlab')
    if axnum <= length(FIGOBJS.(tab).ZPixlab)
        IMOBJS.ZPixlab = FIGOBJS.(tab).ZPixlab(axnum);
    end
end
if isfield(FIGOBJS.(tab),'SLICElab')
    if axnum <= length(FIGOBJS.(tab).SLICElab)
        IMOBJS.SLICElab = FIGOBJS.(tab).SLICElab(axnum);
    end
end
if isfield(FIGOBJS.(tab),'DIM4lab')
    if axnum <= length(FIGOBJS.(tab).DIM4lab)
        IMOBJS.DIM4lab = FIGOBJS.(tab).DIM4lab(axnum);
    end
end
if isfield(FIGOBJS.(tab),'DIM5lab')
    if axnum <= length(FIGOBJS.(tab).DIM5lab)
        IMOBJS.DIM5lab = FIGOBJS.(tab).DIM5lab(axnum);
    end
end
if isfield(FIGOBJS.(tab),'DIM6lab')
    if axnum <= length(FIGOBJS.(tab).DIM6lab)
        IMOBJS.DIM6lab = FIGOBJS.(tab).DIM6lab(axnum);
    end
end
if isfield(FIGOBJS.(tab),'DIM4')
    if axnum <= length(FIGOBJS.(tab).DIM4)
        IMOBJS.DIM4 = FIGOBJS.(tab).DIM4(axnum);
    end
end
if isfield(FIGOBJS.(tab),'DIM5')
    if axnum <= length(FIGOBJS.(tab).DIM5)
        IMOBJS.DIM5 = FIGOBJS.(tab).DIM5(axnum);
    end
end
if isfield(FIGOBJS.(tab),'DIM6')
    if axnum <= length(FIGOBJS.(tab).DIM6)
        IMOBJS.DIM6 = FIGOBJS.(tab).DIM6(axnum);
    end
end
if isfield(FIGOBJS.(tab),'X')
    if axnum <= length(FIGOBJS.(tab).X)
        IMOBJS.X = FIGOBJS.(tab).X(axnum);
    end
end
if isfield(FIGOBJS.(tab),'Y')
    if axnum <= length(FIGOBJS.(tab).Y)
        IMOBJS.Y = FIGOBJS.(tab).Y(axnum);
    end
end
if isfield(FIGOBJS.(tab),'Z')
    if axnum <= length(FIGOBJS.(tab).Z)
        IMOBJS.Z = FIGOBJS.(tab).Z(axnum);
    end
end
if isfield(FIGOBJS.(tab),'XPix')
    if axnum <= length(FIGOBJS.(tab).XPix)
        IMOBJS.XPix = FIGOBJS.(tab).XPix(axnum);
    end
end
if isfield(FIGOBJS.(tab),'YPix')
    if axnum <= length(FIGOBJS.(tab).YPix)
        IMOBJS.YPix = FIGOBJS.(tab).YPix(axnum);
    end
end
if isfield(FIGOBJS.(tab),'ZPix')
    if axnum <= length(FIGOBJS.(tab).ZPix)
        IMOBJS.ZPix = FIGOBJS.(tab).ZPix(axnum);
    end
end
if isfield(FIGOBJS.(tab),'SLICE')
    IMOBJS.SLICE = FIGOBJS.(tab).SLICE(axnum);
end
if isfield(FIGOBJS.(tab),'TieAll')
    if axnum <= length(FIGOBJS.(tab).TieAll)
        IMOBJS.TieAll = FIGOBJS.(tab).TieAll(axnum);
    end
end
if isfield(FIGOBJS.(tab),'TieSlice')
    if axnum <= length(FIGOBJS.(tab).TieSlice)
        IMOBJS.TieSlice = FIGOBJS.(tab).TieSlice(axnum);
    end
end
if isfield(FIGOBJS.(tab),'TieZoom')
    if axnum <= length(FIGOBJS.(tab).TieZoom)
        IMOBJS.TieZoom = FIGOBJS.(tab).TieZoom(axnum);
    end
end
if isfield(FIGOBJS.(tab),'TieROIs')
    if axnum <= length(FIGOBJS.(tab).TieROIs)
        IMOBJS.TieROIs = FIGOBJS.(tab).TieROIs(axnum);
    end
end
if isfield(FIGOBJS.(tab),'TieDims')
    if axnum <= length(FIGOBJS.(tab).TieDims)
        IMOBJS.TieDims = FIGOBJS.(tab).TieDims(axnum);
    end
end
if isfield(FIGOBJS.(tab),'TieDatVals')
    if axnum <= length(FIGOBJS.(tab).TieDatVals)
        IMOBJS.TieDatVals = FIGOBJS.(tab).TieDatVals(axnum);
    end
end
if isfield(FIGOBJS.(tab),'HoldContrast') 
    if axnum <= length(FIGOBJS.(tab).HoldContrast)
        IMOBJS.HoldContrast = FIGOBJS.(tab).HoldContrast(axnum);
    end
end
if isfield(FIGOBJS.(tab),'ImColour') 
    if axnum <= length(FIGOBJS.(tab).ImColour)
        IMOBJS.ImColour = FIGOBJS.(tab).ImColour(axnum);
    end
end
if isfield(FIGOBJS.(tab),'ImType') 
    if axnum <= length(FIGOBJS.(tab).ImType)
        IMOBJS.ImType = FIGOBJS.(tab).ImType(axnum);
    end
end
if isfield(FIGOBJS.(tab),'ImContMeth')
    if axnum <= length(FIGOBJS.(tab).ImContMeth)
        IMOBJS.ImContMeth = FIGOBJS.(tab).ImContMeth(axnum);
    end
end
if isfield(FIGOBJS.(tab),'ContrastMax')
    if axnum <= length(FIGOBJS.(tab).ContrastMax)
        IMOBJS.ContrastMax = FIGOBJS.(tab).ContrastMax(axnum);
    end
end
if isfield(FIGOBJS.(tab),'ContrastMin')
    if axnum <= length(FIGOBJS.(tab).ContrastMin)
        IMOBJS.ContrastMin = FIGOBJS.(tab).ContrastMin(axnum); 
    end
end
if isfield(FIGOBJS.(tab),'CMaxVal')
    if axnum <= length(FIGOBJS.(tab).CMaxVal)
        IMOBJS.CMaxVal = FIGOBJS.(tab).CMaxVal(axnum);
    end
end
if isfield(FIGOBJS.(tab),'CMinVal')
    if axnum <= length(FIGOBJS.(tab).CMinVal)
        IMOBJS.CMinVal = FIGOBJS.(tab).CMinVal(axnum);
    end
end
if isfield(FIGOBJS.(tab),'MaxCMaxVal')
    if axnum <= length(FIGOBJS.(tab).MaxCMaxVal)
        IMOBJS.MaxCMaxVal = FIGOBJS.(tab).MaxCMaxVal(axnum);
    end
end
if isfield(FIGOBJS.(tab),'MinCMinVal')
    if axnum <= length(FIGOBJS.(tab).MinCMinVal)
        IMOBJS.MinCMinVal = FIGOBJS.(tab).MinCMinVal(axnum);
    end
end
if isfield(FIGOBJS.(tab),'Dim4')
    if axnum <= length(FIGOBJS.(tab).Dim4)
        IMOBJS.Dim4 = FIGOBJS.(tab).Dim4(axnum);
    end
end
if isfield(FIGOBJS.(tab),'Dim5')
    if axnum <= length(FIGOBJS.(tab).Dim5)
        IMOBJS.Dim5 = FIGOBJS.(tab).Dim5(axnum);
    end
end
if isfield(FIGOBJS.(tab),'Dim6')
    if axnum <= length(FIGOBJS.(tab).Dim6)
        IMOBJS.Dim6 = FIGOBJS.(tab).Dim6(axnum);
    end
end
if isfield(FIGOBJS.(tab),'ImAxes')
    IMOBJS.ImAxes = FIGOBJS.(tab).ImAxes(axnum);
end
if isfield(FIGOBJS.(tab),'OUTPUT')
    if axnum <= length(FIGOBJS.(tab).OUTPUT(:,1,1))
        IMOBJS.OUTPUT = squeeze(FIGOBJS.(tab).OUTPUT(axnum,:,:));
    end
end
if isfield(FIGOBJS.(tab),'ROINAME')
    if axnum <= length(FIGOBJS.(tab).ROINAME(:,1))
        IMOBJS.ROINAME = FIGOBJS.(tab).ROINAME(axnum,:);
    end
end
if isfield(FIGOBJS.(tab),'ROILAB')
    if axnum <= length(FIGOBJS.(tab).ROILAB(:,1))
        IMOBJS.ROILAB = FIGOBJS.(tab).ROILAB(axnum,:);
    end
end
if isfield(FIGOBJS.(tab),'LINELAB')
    if axnum <= length(FIGOBJS.(tab).LINELAB(:,1))
        IMOBJS.LINELAB = FIGOBJS.(tab).LINELAB(axnum,:);
    end
end
if isfield(FIGOBJS.(tab),'BOXLAB')
    if axnum <= length(FIGOBJS.(tab).BOXLAB(:,1))
        IMOBJS.BOXLAB = FIGOBJS.(tab).BOXLAB(axnum,:);
    end
end
if isfield(FIGOBJS.(tab),'ActivateLineTool')
    if axnum <= length(FIGOBJS.(tab).ActivateLineTool)
        IMOBJS.ActivateLineTool = FIGOBJS.(tab).ActivateLineTool(axnum);
    end
end
if isfield(FIGOBJS.(tab),'ActivateBoxTool')
    if axnum <= length(FIGOBJS.(tab).ActivateBoxTool)
        IMOBJS.ActivateBoxTool = FIGOBJS.(tab).ActivateBoxTool(axnum);
    end
end
if isfield(FIGOBJS.(tab),'CURRENT')
    if axnum <= length(FIGOBJS.(tab).CURRENT(:,1))
        IMOBJS.CURRENT = FIGOBJS.(tab).CURRENT(axnum,:);
    end
end  
 if isfield(FIGOBJS.(tab),'CURRENTLINE')
    if axnum <= length(FIGOBJS.(tab).CURRENTLINE(:,1))
        IMOBJS.CURRENTLINE = FIGOBJS.(tab).CURRENTLINE(axnum,:);
    end
end 
if isfield(FIGOBJS.(tab),'CURRENTBOX')
    if axnum <= length(FIGOBJS.(tab).CURRENTBOX(:,1))
        IMOBJS.CURRENTBOX = FIGOBJS.(tab).CURRENTBOX(axnum,:);
    end
end 
if isfield(FIGOBJS.(tab),'SAVEDLINES')
    if axnum <= length(FIGOBJS.(tab).SAVEDLINES(:,1,1))
        IMOBJS.SAVEDLINES = squeeze(FIGOBJS.(tab).SAVEDLINES(axnum,:,:));
    end
end
if isfield(FIGOBJS.(tab),'SAVEDBOXS')
    if axnum <= length(FIGOBJS.(tab).SAVEDBOXS(:,1,1))
        IMOBJS.SAVEDBOXS = squeeze(FIGOBJS.(tab).SAVEDBOXS(axnum,:,:));
    end
end
if isfield(FIGOBJS.(tab),'DeleteLine')
    if axnum <= length(FIGOBJS.(tab).DeleteLine(:,1))
        IMOBJS.DeleteLine = FIGOBJS.(tab).DeleteLine(axnum,:);
    end
end 
if isfield(FIGOBJS.(tab),'DeleteBox')
    if axnum <= length(FIGOBJS.(tab).DeleteBox(:,1))
        IMOBJS.DeleteBox = FIGOBJS.(tab).DeleteBox(axnum,:);
    end
end 
if isfield(FIGOBJS.(tab),'PlotLine')
    if axnum <= length(FIGOBJS.(tab).PlotLine(:,1))
        IMOBJS.PlotLine = FIGOBJS.(tab).PlotLine(axnum,:);
    end
end  
if isfield(FIGOBJS.(tab),'ROICreateSel')
    if axnum <= length(FIGOBJS.(tab).ROICreateSel)
        IMOBJS.ROICreateSel = FIGOBJS.(tab).ROICreateSel(axnum);
    end
end  
if isfield(FIGOBJS.(tab),'ROITab')
    if axnum <= length(FIGOBJS.(tab).ROITab)
        IMOBJS.ROITab = FIGOBJS.(tab).ROITab(axnum);
    end
end  
if isfield(FIGOBJS,'Colours')
    IMOBJS.Colours = FIGOBJS.Colours;
end  
if isfield(FIGOBJS.(tab),'ImPan')
    IMOBJS.ImPan = FIGOBJS.(tab).ImPan(axnum);
end  
if isfield(FIGOBJS,'Options')
    IMOBJS.Options = FIGOBJS.Options;
end
if isfield(FIGOBJS.(tab),'TopAnlzTab')
    IMOBJS.TopAnlzTab = FIGOBJS.(tab).TopAnlzTab;
end
if isfield(FIGOBJS.(tab),'TopInfoTab')
    IMOBJS.TopInfoTab = FIGOBJS.(tab).TopInfoTab;
end
if isfield(FIGOBJS.(tab),'TopGeneralTab')
    IMOBJS.TopGeneralTab = FIGOBJS.(tab).TopGeneralTab;
end
if isfield(FIGOBJS.(tab),'UberTabGroup')
    IMOBJS.UberTabGroup = FIGOBJS.(tab).UberTabGroup;
end
if isfield(FIGOBJS.(tab),'AnlzTabGroup')
    IMOBJS.AnlzTabGroup = FIGOBJS.(tab).AnlzTabGroup;
end
if isfield(FIGOBJS.(tab),'InfoTabGroup')
    IMOBJS.InfoTabGroup = FIGOBJS.(tab).InfoTabGroup;
end
if isfield(FIGOBJS.(tab),'GeneralTabGroup')
    IMOBJS.GeneralTabGroup = FIGOBJS.(tab).GeneralTabGroup;
end
if isfield(FIGOBJS.(tab),'AnlzTab')
    if axnum <= length(FIGOBJS.(tab).AnlzTab)
        IMOBJS.AnlzTab = FIGOBJS.(tab).AnlzTab(axnum);
    end
end
if isfield(FIGOBJS.(tab),'InfoTab')
    if axnum <= length(FIGOBJS.(tab).InfoTab)
        IMOBJS.InfoTab = FIGOBJS.(tab).InfoTab(axnum);
    end
end
if isfield(FIGOBJS.(tab),'InfoTabL')
    if axnum <= length(FIGOBJS.(tab).InfoTabL)
        IMOBJS.InfoTabL = FIGOBJS.(tab).InfoTabL(axnum);
    end
end
if isfield(FIGOBJS.(tab),'GeneralTab')
    if axnum <= length(FIGOBJS.(tab).GeneralTab)
        IMOBJS.GeneralTab = FIGOBJS.(tab).GeneralTab(axnum);
    end
end
if isfield(FIGOBJS.(tab),'AspectRatio')
    if axnum <= length(FIGOBJS.(tab).AspectRatio)
        IMOBJS.AspectRatio = FIGOBJS.(tab).AspectRatio(axnum);
    end
end
if isfield(FIGOBJS.(tab),'TieCursor')
    if axnum <= length(FIGOBJS.(tab).TieCursor)
        IMOBJS.TieCursor = FIGOBJS.(tab).TieCursor(axnum);
    end
end
if isfield(FIGOBJS.(tab),'OverlayColour')
    if axnum <= length(FIGOBJS.(tab).OverlayColour(:,1))
        IMOBJS.OverlayColour = FIGOBJS.(tab).OverlayColour(axnum,:);
    end
end
if isfield(FIGOBJS.(tab),'OverlayTransparency')
    if axnum <= length(FIGOBJS.(tab).OverlayTransparency(:,1))
        IMOBJS.OverlayTransparency = FIGOBJS.(tab).OverlayTransparency(axnum,:);
    end
end
if isfield(FIGOBJS.(tab),'OverlayValue')
    if axnum <= length(FIGOBJS.(tab).OverlayValue(:,1))
        IMOBJS.OverlayValue = FIGOBJS.(tab).OverlayValue(axnum,:);
    end
end
if isfield(FIGOBJS.(tab),'OverlayMax')
    if axnum <= length(FIGOBJS.(tab).OverlayMax(:,1))
        IMOBJS.OverlayMax = FIGOBJS.(tab).OverlayMax(axnum,:);
    end
end
if isfield(FIGOBJS.(tab),'OverlayMin')
    if axnum <= length(FIGOBJS.(tab).OverlayMin(:,1))
        IMOBJS.OverlayMin = FIGOBJS.(tab).OverlayMin(axnum,:);
    end
end
if isfield(FIGOBJS.(tab),'OverlayName')
    if axnum <= length(FIGOBJS.(tab).OverlayName(:,1))
        IMOBJS.OverlayName = FIGOBJS.(tab).OverlayName(axnum,:);
    end
end
if isfield(FIGOBJS.(tab),'HoldContrast')
    if axnum <= length(FIGOBJS.(tab).HoldContrast)
        IMOBJS.HoldContrast = FIGOBJS.(tab).HoldContrast(axnum);
    end
end
if isfield(FIGOBJS.(tab),'ImContMeth')
    if axnum <= length(FIGOBJS.(tab).ImContMeth)
        IMOBJS.ImContMeth = FIGOBJS.(tab).ImContMeth(axnum);
    end
end
if isfield(FIGOBJS.(tab),'Orientation')
    if axnum <= length(FIGOBJS.(tab).Orientation)
        IMOBJS.Orientation = FIGOBJS.(tab).Orientation(axnum);
    end
end
if isfield(FIGOBJS.(tab),'ShowOrtho')
    if axnum <= length(FIGOBJS.(tab).ShowOrtho)
        IMOBJS.ShowOrtho = FIGOBJS.(tab).ShowOrtho(axnum);
    end
end
if isfield(FIGOBJS.(tab),'ShadeROI')
    if axnum <= length(FIGOBJS.(tab).ShadeROI)
        IMOBJS.ShadeROI = FIGOBJS.(tab).ShadeROI(axnum);
    end
end
if isfield(FIGOBJS.(tab),'ShadeROIValue')
    if axnum <= length(FIGOBJS.(tab).ShadeROIValue)
        IMOBJS.ShadeROIValue = FIGOBJS.(tab).ShadeROIValue(axnum);
    end
end
if isfield(FIGOBJS.(tab),'LinesROI')
    if axnum <= length(FIGOBJS.(tab).LinesROI)
        IMOBJS.LinesROI = FIGOBJS.(tab).LinesROI(axnum);
    end
end
if isfield(FIGOBJS.(tab),'AutoUpdateROI')
    if axnum <= length(FIGOBJS.(tab).AutoUpdateROI)
        IMOBJS.AutoUpdateROI = FIGOBJS.(tab).AutoUpdateROI(axnum);
    end
end
if isfield(FIGOBJS.(tab),'DrawROIonAll')
    if axnum <= length(FIGOBJS.(tab).DrawROIonAll)
        IMOBJS.DrawROIonAll = FIGOBJS.(tab).DrawROIonAll(axnum);
    end
end
if isfield(FIGOBJS.(tab),'ComplexAverage')
    if axnum <= length(FIGOBJS.(tab).ComplexAverage)
        IMOBJS.ComplexAverage = FIGOBJS.(tab).ComplexAverage(axnum);
    end
end
if isfield(FIGOBJS.(tab),'NewROIbutton')
    if axnum <= length(FIGOBJS.(tab).NewROIbutton)
        IMOBJS.NewROIbutton = FIGOBJS.(tab).NewROIbutton(axnum);
    end
end
if isfield(FIGOBJS.(tab),'EraseROIbutton')
    if axnum <= length(FIGOBJS.(tab).EraseROIbutton)
        IMOBJS.EraseROIbutton = FIGOBJS.(tab).EraseROIbutton(axnum);
    end
end
if isfield(FIGOBJS.(tab),'AndROIbutton')
    if axnum <= length(FIGOBJS.(tab).AndROIbutton)
        IMOBJS.AndROIbutton = FIGOBJS.(tab).AndROIbutton(axnum);
    end
end
if isfield(FIGOBJS.(tab),'RedrawROIbutton')
    if axnum <= length(FIGOBJS.(tab).RedrawROIbutton)
        IMOBJS.RedrawROIbutton = FIGOBJS.(tab).RedrawROIbutton(axnum);
    end
end
if isfield(FIGOBJS.(tab),'GblList')
    IMOBJS.GblList = FIGOBJS.(tab).GblList;
end
if isfield(FIGOBJS.(tab),'Info')
    if axnum <= length(FIGOBJS.(tab).Info)
        IMOBJS.Info = FIGOBJS.(tab).Info(axnum);
    end
end

IMOBJS.Compass = FIGOBJS.Compass;
% IMOBJS.Compass.WindowKeyPressFcn = @RWSUI_KeyPressControl;
% IMOBJS.Compass.WindowKeyReleaseFcn = @RWSUI_KeyReleaseControl;        
% IMOBJS.Compass.WindowScrollWheelFcn = @ScrollWheelControl;
% IMOBJS.Compass.WindowButtonMotionFcn = @RWSUI_MouseMoveControl;
% IMOBJS.Compass.KeyPressFcn = '';
% IMOBJS.Compass.KeyReleaseFcn = '';





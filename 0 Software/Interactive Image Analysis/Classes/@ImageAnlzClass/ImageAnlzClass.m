%================================================================
%  
%================================================================

classdef ImageAnlzClass < handle

    properties (SetAccess = public)                                         % for now...
        %-- general
        tab,axnum,axeslen;
        totgblnum,axisactive;
        highlight;
        pointer;
        presentation;
        %-- current images
        imvol,imslice;
        %-- loading
        IMPATH;
        IMFILETYPE;
        ROIPATH;
        %-- mouse functions
        buttonfunction;
        movefunction;
        curmat,tinymove;
        %-- contrast
        IMTYPE;
        RELCONTRAST;                               
        MAXCONTRAST;
        MaxImVal;
        MinImVal;
        %-- orient
        ORIENT;
        %-- navigate
        SLICE,DIM4,DIM5,DIM6;
        %-- zoom
        SCALE; 
        %-- drawing
        mark; 
        ortholine;
        showortholine;
        %-- rois
        GETROIS;                                                       
        ROISOFINTEREST;                        
        SAVEDROISFLAG;
        COLORORDER;
        roipanelobs;
        activeroi;
        shaderoi; shaderoivalue; shaderoiintensities;
        linesroi;
        autoupdateroi;
        drawroionall;
        temproiclr;
        complexaverageroi;
        roievent;
        %-- line
        GETLINE;
        LineToolActive;
        %-- tieing
        ALLTIE;
        DATVALTIE;
        CURSORTIE;
        SLCTIE;
        DIMSTIE;
        ZOOMTIE;
        ROITIE;
        %-- holding
        SLCHOLD;               % - delete
        DIMSHOLD;
        ZOOMHOLD;
        contrasthold;
    end
    properties (SetAccess = private)                    % subclasses
        FIGOBJS;
        TEMPROI;
        CURRENTROI;
        SAVEDROIS;
        ROIFREEHAND;                 
        ROISEED;
        ROISPHERE;        
        ROICIRCLE;    
        ROITUBE;
        CURRENTLINE;
        SAVEDLINES;
        GlobalSavedLinesInd;
        SavedLinesInd;
        LineClrOrder;
        STATUS;
    end

%==================================================================
% Init
%==================================================================    
    methods 
        % ImageAnlzClass
        function IMAGEANLZ = ImageAnlzClass(FIGOBJS,tab,axnum)
            IMAGEANLZ = ImAnlz_Initialize(IMAGEANLZ,tab,axnum);
            if strcmp(tab,'Script')
                return
            end
            IMAGEANLZ.FIGOBJS = FigObjsClass;
            IMAGEANLZ.FIGOBJS.Setup(FIGOBJS,tab,axnum);
            IMAGEANLZ.FIGOBJS.Initialize;
            ImAnlz_DefaultSetup(IMAGEANLZ);   
        end
        % Initialize
        function Initialize(IMAGEANLZ,tab,axnum)
            ImAnlz_Initialize(IMAGEANLZ,tab,axnum);
            IMAGEANLZ.FIGOBJS.Initialize;
            ImAnlz_DefaultSetup(IMAGEANLZ);           
        end

%==================================================================
% Image Export
%==================================================================        
        function Copy4Export(IMAGEANLZ,IMAGEANLZ2)
            IMAGEANLZ.totgblnum = IMAGEANLZ2.totgblnum;
            IMAGEANLZ.IMPATH = IMAGEANLZ2.IMPATH;
            IMAGEANLZ.IMTYPE = IMAGEANLZ2.IMTYPE;
            IMAGEANLZ.RELCONTRAST = IMAGEANLZ2.RELCONTRAST;                             
            IMAGEANLZ.MAXCONTRAST = IMAGEANLZ2.MAXCONTRAST;
            IMAGEANLZ.ORIENT = IMAGEANLZ2.ORIENT;
            IMAGEANLZ.SLICE = IMAGEANLZ2.SLICE;
            IMAGEANLZ.DIM4 = IMAGEANLZ2.DIM4;
            IMAGEANLZ.DIM5 = IMAGEANLZ2.DIM5;
            IMAGEANLZ.DIM6 = IMAGEANLZ2.DIM6;
            IMAGEANLZ.SCALE = IMAGEANLZ2.SCALE;
        end

%==================================================================
% Panel Functions
%==================================================================
        % Move2Tab
        function Move2Tab(IMAGEANLZ)
            IMAGEANLZ.FIGOBJS.Move2Tab(IMAGEANLZ.tab);
        end
        % SetFocus
        function SetFocus(IMAGEANLZ)
            IMAGEANLZ.FIGOBJS.SetFocus;
            IMAGEANLZ.STATUS.UpdateStatus;
        end        
        % GetAxisHandle
        function axishandle = GetAxisHandle(IMAGEANLZ)
            axishandle = IMAGEANLZ.FIGOBJS.ImAxes;
        end
        % TestAxisActive
        function bool = TestAxisActive(IMAGEANLZ)
            bool = IMAGEANLZ.axisactive;
        end
        % SetAxisActive
        function SetAxisActive(IMAGEANLZ)
            IMAGEANLZ.axisactive = 1;
        end        
        % AssignData
        function AssignData(IMAGEANLZ,totgblnum)
            IMAGEANLZ.totgblnum = totgblnum;
        end             
        % Highlight
        function Highlight(IMAGEANLZ)
            IMAGEANLZ.highlight = 1;
            IMAGEANLZ.FIGOBJS.ImPan.HighlightColor = 'r';
            if not(isempty(IMAGEANLZ.FIGOBJS.AnlzTab))
                IMAGEANLZ.FIGOBJS.InfoTabGroup.SelectedTab = IMAGEANLZ.FIGOBJS.InfoTab;
                IMAGEANLZ.FIGOBJS.AnlzTabGroup.SelectedTab = IMAGEANLZ.FIGOBJS.AnlzTab;
                if isprop(IMAGEANLZ.FIGOBJS,'GeneralTabGroup')
                    IMAGEANLZ.FIGOBJS.GeneralTabGroup.SelectedTab = IMAGEANLZ.FIGOBJS.GeneralTab; 
                end
            end
        end
        % TabChange
        function TabChange(IMAGEANLZ)
            if not(isempty(IMAGEANLZ.FIGOBJS.AnlzTab))
                IMAGEANLZ.FIGOBJS.InfoTabGroup.SelectedTab = IMAGEANLZ.FIGOBJS.InfoTab;
                IMAGEANLZ.FIGOBJS.AnlzTabGroup.SelectedTab = IMAGEANLZ.FIGOBJS.AnlzTab;
                if isprop(IMAGEANLZ.FIGOBJS,'GeneralTabGroup')
                    IMAGEANLZ.FIGOBJS.GeneralTabGroup.SelectedTab = IMAGEANLZ.FIGOBJS.GeneralTab; 
                end
            end
        end
        % UnHighlight
        function UnHighlight(IMAGEANLZ)
            IMAGEANLZ.highlight = 0;
            IMAGEANLZ.FIGOBJS.ImPan.HighlightColor = 'w';
        end
        % TestMouseInImage
        function bool = TestMouseInImage(IMAGEANLZ,mouseloc)
            bool = ImAnlz_TestMouseInImage(IMAGEANLZ,mouseloc);
        end
        % TurnOnDisplay
        function TurnOnDisplay(IMAGEANLZ)
            IMAGEANLZ.FIGOBJS.ImageName.Visible = 'On';
            IMAGEANLZ.FIGOBJS.POINTERlab.Visible = 'On';
            IMAGEANLZ.FIGOBJS.CURVAL.Visible = 'On';
            IMAGEANLZ.FIGOBJS.VALUElab.Visible = 'On';
            IMAGEANLZ.FIGOBJS.Xlab.Visible = 'On';
            IMAGEANLZ.FIGOBJS.Ylab.Visible = 'On';
            IMAGEANLZ.FIGOBJS.Zlab.Visible = 'On';
            IMAGEANLZ.FIGOBJS.XPixlab.Visible = 'On';
            IMAGEANLZ.FIGOBJS.YPixlab.Visible = 'On';
            IMAGEANLZ.FIGOBJS.ZPixlab.Visible = 'On';
            IMAGEANLZ.FIGOBJS.SLICElab.Visible = 'On';
            IMAGEANLZ.FIGOBJS.X.Visible = 'On';
            IMAGEANLZ.FIGOBJS.Y.Visible = 'On';
            IMAGEANLZ.FIGOBJS.Z.Visible = 'On';
            IMAGEANLZ.FIGOBJS.XPix.Visible = 'On';
            IMAGEANLZ.FIGOBJS.YPix.Visible = 'On';
            IMAGEANLZ.FIGOBJS.ZPix.Visible = 'On';
            IMAGEANLZ.FIGOBJS.SLICE.Visible = 'On';
            IMAGEANLZ.FIGOBJS.DIM4lab.Visible = 'On';
            IMAGEANLZ.FIGOBJS.DIM5lab.Visible = 'On';
            IMAGEANLZ.FIGOBJS.DIM6lab.Visible = 'On';
            IMAGEANLZ.FIGOBJS.DIM4.Visible = 'On';
            IMAGEANLZ.FIGOBJS.DIM5.Visible = 'On';
            IMAGEANLZ.FIGOBJS.DIM6.Visible = 'On';
        end
        % SetImageName
        function SetImageName(IMAGEANLZ)
            IMAGEANLZ.FIGOBJS.ImageName.String = GetImageName(IMAGEANLZ);
        end
        % HighlightROI
        function HighlightROI(IMAGEANLZ,roinum)
            IMAGEANLZ.FIGOBJS.ROILAB(roinum).ForegroundColor = [1,1,0.5];
        end
        % UnHighlightROI
        function UnHighlightROI(IMAGEANLZ,roinum)
            IMAGEANLZ.FIGOBJS.ROILAB(roinum).ForegroundColor = [0.8,0.8,0.8];
        end
        % HighlightLine
        function HighlightLine(IMAGEANLZ,linenum)
            IMAGEANLZ.FIGOBJS.LINELAB(linenum).ForegroundColor = [1,1,0.5];
        end
        % UnHighlightLine
        function UnHighlightLine(IMAGEANLZ,linenum)
            IMAGEANLZ.FIGOBJS.LINELAB(linenum).ForegroundColor = [0.8,0.8,0.8];
        end
        % GetFigureAspectRatio
        function aspectratio = GetFigureAspectRatio(IMAGEANLZ)
            aspectratio = IMAGEANLZ.FIGOBJS.AspectRatio;
        end  
        
%==================================================================
% Get Image Info
%==================================================================
        % TestForImage
        function err = TestForImage(~,totgblnum) 
            global TOTALGBL
            err.flag = 0; err.msg = '';
            if not(isfield(TOTALGBL{2,totgblnum},'Im'))
                err.flag = 1;
                err.msg = 'Selection does not contain an image';
            end
        end
        % GetImageName
        function ImName = GetImageName(IMAGEANLZ)
            global TOTALGBL
            ImName = TOTALGBL{1,IMAGEANLZ.totgblnum};
        end
        % GetImageInfo
        function ImInfo = GetImageInfo(IMAGEANLZ)
            global TOTALGBL
            ImInfo = TOTALGBL{2,IMAGEANLZ.totgblnum}.IMDISP.ImInfo;
        end
        % ShowImageInfo
        function ShowImageInfo(IMAGEANLZ)
            ImInfo = IMAGEANLZ.GetImageInfo;
            IMAGEANLZ.FIGOBJS.Info.String = ImInfo.info;
        end
        % GetBaseImageSize
        function imsize = GetBaseImageSize(IMAGEANLZ,totgblnum)
            global TOTALGBL
            if isempty(totgblnum)
                totgblnum = IMAGEANLZ.totgblnum;
            end
            if isempty(totgblnum)
                imsize = [];
                return
            end
            newimsize = size(TOTALGBL{2,totgblnum}.Im);
            imsize = ones(1,6);
            imsize(1:length(newimsize)) = newimsize;
        end
        % GetBasePixelDimensions
        function pixdim = GetBasePixelDimensions(IMAGEANLZ,totgblnum)
            global TOTALGBL
            if isempty(totgblnum)
                totgblnum = IMAGEANLZ.totgblnum;
            end
            pixdim = TOTALGBL{2,totgblnum}.IMDISP.ImInfo.pixdim;
        end
        % GetBaseOrient
        function baseorient = GetBaseOrient(IMAGEANLZ,totgblnum)
            global TOTALGBL
            if isempty(totgblnum)
                totgblnum = IMAGEANLZ.totgblnum;
            end
            if isempty(totgblnum)
                error;      % why is this test here
            end
            if not(isfield(TOTALGBL{2,totgblnum}.IMDISP.ImInfo,'baseorient'))
                error;      % fix loading                               
            else
                baseorient = TOTALGBL{2,totgblnum}.IMDISP.ImInfo.baseorient;
            end
        end
        % GetPixelDimensions
        function pixdim = GetPixelDimensions(IMAGEANLZ)
            basepixdim = IMAGEANLZ.GetBasePixelDimensions([]);
            if strcmp(IMAGEANLZ.ORIENT,'Axial')
                pixdim = basepixdim;
            elseif strcmp(IMAGEANLZ.ORIENT,'Sagittal')
                pixdim = basepixdim([3 1 2]);
            elseif strcmp(IMAGEANLZ.ORIENT,'Coronal')
                pixdim = basepixdim([3 2 1]);
            end
        end
        % GetImageSize
        function imsize = GetImageSize(IMAGEANLZ)
            baseimsize = IMAGEANLZ.GetBaseImageSize([]);
            if strcmp(IMAGEANLZ.ORIENT,'Axial')
                imsize = baseimsize;
            elseif strcmp(IMAGEANLZ.ORIENT,'Sagittal')
                imsize = baseimsize([3 1 2 4 5 6]);
            elseif strcmp(IMAGEANLZ.ORIENT,'Coronal')
                imsize = baseimsize([3 2 1 4 5 6]);
            end
        end
        % GetTOTALGBLsize
        function TOTALGBLlength = GetTOTALGBLsize(IMAGEANLZ)
            global TOTALGBL
            sz = size(TOTALGBL);
            TOTALGBLlength = sz(2);
        end
        % GetTOTALGBLselected
        function totgblnum = GetTOTALGBLselected(IMAGEANLZ)
            TOTALGBLsel = IMAGEANLZ.FIGOBJS.GblList.Value;
            for n = 1:length(TOTALGBLsel)
                totgblnum(n) = IMAGEANLZ.FIGOBJS.GblList.UserData(TOTALGBLsel(n)).totgblnum;
            end
        end
        
%==================================================================
% Orient (setup)
%==================================================================            
        % DisableOrient
        function DisableOrient(IMAGEANLZ)
            IMAGEANLZ.FIGOBJS.Orientation.Enable = 'off'; 
        end
        % EnableOrient
        function EnableOrient(IMAGEANLZ)
            IMAGEANLZ.FIGOBJS.Orientation.Enable = 'on'; 
        end
        % DisableShowOrtho
        function DisableShowOrtho(IMAGEANLZ)
            IMAGEANLZ.FIGOBJS.ShowOrtho.Enable = 'off'; 
        end
        % EnableShowOrtho
        function EnableShowOrtho(IMAGEANLZ)
            IMAGEANLZ.FIGOBJS.ShowOrtho.Enable = 'on'; 
        end
        % SetOrient
        function SetOrient(IMAGEANLZ,orient)
            IMAGEANLZ.ORIENT = orient;
        end  
        
%==================================================================
% Slice (number)
%==================================================================          
        % CopySlice
        function CopySlice(IMAGEANLZ,IMAGEANLZ2)
            IMAGEANLZ.SLICE = IMAGEANLZ2.SLICE;
            IMAGEANLZ.FIGOBJS.SLICE.String = num2str(IMAGEANLZ.SLICE);
        end  
        % ResetSlice
        function ResetSlice(IMAGEANLZ)
            IMAGEANLZ.SLICE = 1;
            IMAGEANLZ.FIGOBJS.SLICE.String = num2str(IMAGEANLZ.SLICE); 
        end
        % SetMiddleSlice
        function SetMiddleSlice(IMAGEANLZ)
            imsize = GetImageSize(IMAGEANLZ);
            IMAGEANLZ.SLICE = round(imsize(3)/2);
            IMAGEANLZ.FIGOBJS.SLICE.String = num2str(IMAGEANLZ.SLICE); 
        end
        % SetSlice
        function SetSlice(IMAGEANLZ,slice)
            IMAGEANLZ.SLICE = slice;
            IMAGEANLZ.FIGOBJS.SLICE.String = num2str(IMAGEANLZ.SLICE); 
        end

%==================================================================
% Dims (numbers)
%==================================================================          
        % CopyDims
        function CopyDims(IMAGEANLZ,IMAGEANLZ2)
            IMAGEANLZ.DIM4 = IMAGEANLZ2.DIM4;
            IMAGEANLZ.DIM5 = IMAGEANLZ2.DIM5;
            IMAGEANLZ.DIM6 = IMAGEANLZ2.DIM6;
            IMAGEANLZ.FIGOBJS.DIM4.String = num2str(IMAGEANLZ.DIM4);
            IMAGEANLZ.FIGOBJS.DIM5.String = num2str(IMAGEANLZ.DIM5);
            IMAGEANLZ.FIGOBJS.DIM6.String = num2str(IMAGEANLZ.DIM6);
            IMAGEANLZ.FIGOBJS.Dim4.Value = IMAGEANLZ.DIM4;
            IMAGEANLZ.FIGOBJS.Dim5.Value = IMAGEANLZ.DIM5;
            IMAGEANLZ.FIGOBJS.Dim6.Value = IMAGEANLZ.DIM6;
        end  
        % ResetDims
        function ResetDims(IMAGEANLZ)
            IMAGEANLZ.DIM4 = 1;
            IMAGEANLZ.DIM5 = 1;
            IMAGEANLZ.DIM6 = 1;
            IMAGEANLZ.FIGOBJS.DIM4.String = num2str(IMAGEANLZ.DIM4);
            IMAGEANLZ.FIGOBJS.DIM5.String = num2str(IMAGEANLZ.DIM5);
            IMAGEANLZ.FIGOBJS.DIM6.String = num2str(IMAGEANLZ.DIM6);
            IMAGEANLZ.FIGOBJS.Dim4.Value = IMAGEANLZ.DIM4;
            IMAGEANLZ.FIGOBJS.Dim5.Value = IMAGEANLZ.DIM5;
            IMAGEANLZ.FIGOBJS.Dim6.Value = IMAGEANLZ.DIM6;
        end         
        % TestEnableMultiDim
        function TestEnableMultiDim(IMAGEANLZ)
            imsize = IMAGEANLZ.GetBaseImageSize([]);
            if imsize(4) > 1
                IMAGEANLZ.FIGOBJS.Dim4.Enable = 'On';
            else
                IMAGEANLZ.FIGOBJS.Dim4.Enable = 'Off';
            end
            if imsize(5) > 1
                IMAGEANLZ.FIGOBJS.Dim5.Enable = 'On';
            else
                IMAGEANLZ.FIGOBJS.Dim5.Enable = 'Off';
            end
            if imsize(6) > 1
                IMAGEANLZ.FIGOBJS.Dim6.Enable = 'On';
            else
                IMAGEANLZ.FIGOBJS.Dim6.Enable = 'Off';
            end
        end  
        % SetDim4
        function SetDim4(IMAGEANLZ,dim4)
            IMAGEANLZ.DIM4 = dim4;
            IMAGEANLZ.FIGOBJS.DIM4.String = num2str(IMAGEANLZ.DIM4); 
        end
        % SetDim5
        function SetDim5(IMAGEANLZ,dim5)
            IMAGEANLZ.DIM5 = dim5;
            IMAGEANLZ.FIGOBJS.DIM5.String = num2str(IMAGEANLZ.DIM5); 
        end
        % SetDim6
        function SetDim6(IMAGEANLZ,dim6)
            IMAGEANLZ.DIM6 = dim6;
            IMAGEANLZ.FIGOBJS.DIM6.String = num2str(IMAGEANLZ.DIM6); 
        end
        
%==================================================================
% Contrast (setup)
%==================================================================          
        % GetContrastLimit
        function clim = GetContrastLimit(IMAGEANLZ)
            if isempty(IMAGEANLZ.MAXCONTRAST)
                clim = IMAGEANLZ.RELCONTRAST;                       % no image loaded
            else
                clim = IMAGEANLZ.RELCONTRAST*IMAGEANLZ.MAXCONTRAST;
            end
        end
        % ChangeMaxContrast
        function ChangeMaxContrast(IMAGEANLZ,cmax)
            %if cmax > 1
            %    cmax = 1;
            %end
            IMAGEANLZ.RELCONTRAST(2) = cmax;
            if(IMAGEANLZ.RELCONTRAST(2) <= IMAGEANLZ.RELCONTRAST(1))
                IMAGEANLZ.RELCONTRAST(2) = IMAGEANLZ.RELCONTRAST(1)+0.01;
            end
            IMAGEANLZ.FIGOBJS.ContrastMax.Value = cmax;
            IMAGEANLZ.FIGOBJS.CMaxVal.String = num2str(IMAGEANLZ.RELCONTRAST(2)*IMAGEANLZ.MAXCONTRAST,5);
            IMAGEANLZ.SetContrast;
        end
        % ChangeMinContrast
        function ChangeMinContrast(IMAGEANLZ,cmin)
            %if cmin < 0.01
            %    cmin = 0.01;
            %end
            IMAGEANLZ.RELCONTRAST(1) = cmin;
            if(IMAGEANLZ.RELCONTRAST(1) >= IMAGEANLZ.RELCONTRAST(2))
                IMAGEANLZ.RELCONTRAST(1) = IMAGEANLZ.RELCONTRAST(2)-0.01;
            end
            IMAGEANLZ.FIGOBJS.ContrastMin.Value = cmin;
            IMAGEANLZ.FIGOBJS.CMinVal.String = num2str(IMAGEANLZ.RELCONTRAST(1)*IMAGEANLZ.MAXCONTRAST,5);
            IMAGEANLZ.SetContrast;
        end
        % ChangeImType
        function ChangeImType(IMAGEANLZ,imtype)
            imtypecurrent = IMAGEANLZ.IMTYPE; 
            IMAGEANLZ.IMTYPE = imtype;
            IMAGEANLZ.imvol = IMAGEANLZ.GetCurrent3DImage;
            if IMAGEANLZ.contrasthold == 0
                ImAnlz_UpdateContrastTypeChange(IMAGEANLZ);
            else
                if not((strcmp(imtypecurrent,'real') && strcmp(IMAGEANLZ.IMTYPE,'imag')) || (strcmp(imtypecurrent,'imag') && strcmp(IMAGEANLZ.IMTYPE,'real')))
                    ImAnlz_UpdateContrastTypeChange(IMAGEANLZ); 
                end
            end
        end
        % InitializeContrast
        function InitializeContrast(IMAGEANLZ)
            ImAnlz_InitializeContrast(IMAGEANLZ);
        end
        % DefaultContrast
        function DefaultContrast(IMAGEANLZ)
            ImAnlz_DefaultContrast(IMAGEANLZ);
        end
        
%==================================================================
% Scaling (Zooming)
%==================================================================        
        % GetXAxisLimits        
        function xlim = GetXAxisLimits(IMAGEANLZ)
            xlim = [IMAGEANLZ.SCALE.xmin IMAGEANLZ.SCALE.xmax];
        end
        % GetYAxisLimits
        function ylim = GetYAxisLimits(IMAGEANLZ)
            ylim = [IMAGEANLZ.SCALE.ymin IMAGEANLZ.SCALE.ymax];
        end  
        % CopyScale
        function CopyScale(IMAGEANLZ,IMAGEANLZ2)
            IMAGEANLZ.SCALE = IMAGEANLZ2.SCALE;
            IMAGEANLZ.SetScale;
        end  
        % ResetScale
        function ResetScale(IMAGEANLZ)
            ImAnlz_ResetScale(IMAGEANLZ);
            IMAGEANLZ.SetScale;
        end 
        % RecordScaleFactors
        function RecordScaleFactors(IMAGEANLZ,SCALE)
            IMAGEANLZ.SCALE = SCALE;
        end  
 
%==================================================================
% ROI
%==================================================================
        % SetROITool       
        function SetROITool(IMAGEANLZ,activeroi)
            ImAnlz_SetROITool(IMAGEANLZ,activeroi);
        end
        % GetROITool       
        function ROITOOL = GetROITool(IMAGEANLZ)
            ROITOOL = IMAGEANLZ.(IMAGEANLZ.activeroi);
        end
        % TestROIToolActive
        function bool = TestROIToolActive(IMAGEANLZ)
            bool = IMAGEANLZ.(IMAGEANLZ.activeroi).TestActive;
        end         
        % RestartROITool
        function RestartROITool(IMAGEANLZ)
            IMAGEANLZ.(IMAGEANLZ.activeroi).Reset;
            Status(1).state = 'busy';
            Status(1).string = 'New ROI Active';       
            Status(2).state = 'busy';  
            Status(2).string = IMAGEANLZ.(IMAGEANLZ.activeroi).status;   
            Status(3).state = 'info';  
            Status(3).string = IMAGEANLZ.(IMAGEANLZ.activeroi).info;        
            IMAGEANLZ.STATUS.SetStatus(Status);
            IMAGEANLZ.STATUS.UpdateStatus;
        end
        % ClearROIPanel
        function ClearROIPanel(IMAGEANLZ)
            if not(isempty(IMAGEANLZ.roipanelobs))
                delete(IMAGEANLZ.roipanelobs);
            end
        end
        % BuildROI
        function OUT = BuildROI(IMAGEANLZ,x,y,event)
            val = IMAGEANLZ.imslice(round(y),round(x));
            z = IMAGEANLZ.SLICE;
            datapoint = [x,y,z,val];
            OUT = IMAGEANLZ.TEMPROI.BuildROI(datapoint,event,IMAGEANLZ.imslice);
        end
        % AutoUpdateROIChange
        function AutoUpdateROIChange(IMAGEANLZ,val)
            IMAGEANLZ.autoupdateroi = val;
            IMAGEANLZ.FIGOBJS.AutoUpdateROI.Value = val;
        end
        % DrawROIonAllChange
        function DrawROIonAllChange(IMAGEANLZ,val)
            IMAGEANLZ.drawroionall = val;
            IMAGEANLZ.FIGOBJS.DrawROIonAll.Value = val;
        end        
        % ComplexAverageROIChange
        function ComplexAverageROIChange(IMAGEANLZ,val)
            IMAGEANLZ.complexaverageroi = val;
            IMAGEANLZ.FIGOBJS.ComplexAverage.Value = val;
        end        
        % CreateTempROIMask
        function CreateTempROIMask(IMAGEANLZ)
            IMAGEANLZ.TEMPROI.CreateBaseROIMask;
        end 
        % ComputeTempROI
        function ComputeTempROI(IMAGEANLZ)
            IMAGEANLZ.TEMPROI.ComputeROI(IMAGEANLZ);
        end        
        % TestEmptyTempROI
        function bool = TestEmptyTempROI(IMAGEANLZ)
            bool = 0;
            if isempty(IMAGEANLZ.TEMPROI.xlocarr) 
                bool = 1;
            end
        end
        % DrawTempROI
        function DrawTempROI(IMAGEANLZ,axhand,clr)
            if isempty(IMAGEANLZ.TEMPROI)
                return
            end
            if isempty(IMAGEANLZ.TEMPROI.xlocarr) 
                return
            end
            if not(isempty(clr))
                IMAGEANLZ.temproiclr = clr;
            end
            if IMAGEANLZ.linesroi
                if strcmp(IMAGEANLZ.ORIENT,IMAGEANLZ.TEMPROI.drawroiorient)
                    IMAGEANLZ.TEMPROI.DrawROI(IMAGEANLZ,axhand,IMAGEANLZ.temproiclr,0);
                end
            end
            if IMAGEANLZ.shaderoi
                IMAGEANLZ.TEMPROI.ShadeROI(IMAGEANLZ,axhand,IMAGEANLZ.temproiclr,IMAGEANLZ.shaderoiintensities(IMAGEANLZ.shaderoivalue));
            end
        end
        % UpdateTempROI
        function UpdateTempROI(IMAGEANLZ,OUT)
            IMAGEANLZ.TEMPROI.ResetLocArr;
            IMAGEANLZ.TEMPROI.BuildLocArr(OUT.xloc,OUT.yloc,OUT.zloc);
        end
        % UpdateTempROIDrawOrient
        function UpdateTempROIDrawOrient(IMAGEANLZ,orient)
            IMAGEANLZ.TEMPROI.SetDrawOrientation(orient);
        end
        % UpdateTempROIValues
        function UpdateTempROIValues(IMAGEANLZ)
            IMAGEANLZ.CreateTempROIMask;
            IMAGEANLZ.ComputeTempROI;
            IMAGEANLZ.(IMAGEANLZ.activeroi).SetValue(IMAGEANLZ.TEMPROI.roimean);
        end 
        % ResetTempROI
        function ResetTempROI(IMAGEANLZ)
            IMAGEANLZ.TEMPROI.DeleteGraphicObjects;
            IMAGEANLZ.TEMPROI.ResetLocArr;
        end
        % NewROICreate
        function NewROICreate(IMAGEANLZ)
            ImAnlz_NewROICreate(IMAGEANLZ);
        end
        % NewROICreateOrtho
        function NewROICreateOrtho(IMAGEANLZ,ROITOOL)
            ImAnlz_NewROICreateOrtho(IMAGEANLZ,ROITOOL);
        end
        % NewROICopy
        function NewROICopy(IMAGEANLZ,CURRENTROI,TEMPROI)
            ImAnlz_NewROICopy(IMAGEANLZ,CURRENTROI,TEMPROI);
        end
        % NewROICopyOrtho
        function NewROICopyOrtho(IMAGEANLZ,CURRENTROI,TEMPROI)
            ImAnlz_NewROICopyOrtho(IMAGEANLZ,CURRENTROI,TEMPROI);
        end
        % SetMoveFunction
        function SetMoveFunction(IMAGEANLZ,movefunction)
            IMAGEANLZ.movefunction = movefunction;
        end
        % DiscardCurrentROI
        function DiscardCurrentROI(IMAGEANLZ)
            ImAnlz_DiscardCurrentROI(IMAGEANLZ);
        end
        % TestFinishedCurrentROI
        function bool = TestFinishedCurrentROI(IMAGEANLZ)
            bool = 1;
            if isempty(IMAGEANLZ.CURRENTROI.xlocarr) 
                bool = 0;
                return
            end
        end
        % Add2CurrentROI
        function Add2CurrentROI(IMAGEANLZ,TEMPROI)
            IMAGEANLZ.CURRENTROI.Concatenate(TEMPROI,IMAGEANLZ.roievent);
            if IMAGEANLZ.shaderoi || IMAGEANLZ.autoupdateroi
                IMAGEANLZ.CURRENTROI.AddROIMask;
            end
        end
        % TestUpdateCurrentROIValue
        function TestUpdateCurrentROIValue(IMAGEANLZ)
            if IMAGEANLZ.autoupdateroi
                IMAGEANLZ.ComputeCurrentROI;
                IMAGEANLZ.SetCurrentROIValue;
                IMAGEANLZ.FIGOBJS.UberTabGroup.SelectedTab = IMAGEANLZ.FIGOBJS.TopAnlzTab;
                IMAGEANLZ.FIGOBJS.AnlzTabGroup.SelectedTab = IMAGEANLZ.FIGOBJS.AnlzTab;
            end
        end 
        % CreateCurrentROIMask
        function CreateCurrentROIMask(IMAGEANLZ)
            IMAGEANLZ.CURRENTROI.CreateBaseROIMask;
        end  
        % ComputeCurrentROI
        function ComputeCurrentROI(IMAGEANLZ)
            IMAGEANLZ.CURRENTROI.ComputeROI(IMAGEANLZ);
        end        
        % SetCurrentROIValue
        function SetCurrentROIValue(IMAGEANLZ)
            ImAnlz_SetCurrentROIValue(IMAGEANLZ);
        end
        % DrawCurrentROI
        function DrawCurrentROI(IMAGEANLZ,axhand)
            if isempty(IMAGEANLZ.CURRENTROI) 
                return
            end
            if isempty(IMAGEANLZ.CURRENTROI.xlocarr) 
                return
            end
            if IMAGEANLZ.linesroi
                if strcmp(IMAGEANLZ.ORIENT,IMAGEANLZ.CURRENTROI.drawroiorient)
                    IMAGEANLZ.CURRENTROI.DrawROI(IMAGEANLZ,axhand,[1 0 0],0);
                end
            end
            if IMAGEANLZ.shaderoi
                IMAGEANLZ.CURRENTROI.ShadeROI(IMAGEANLZ,axhand,[1 0 0],IMAGEANLZ.shaderoiintensities(IMAGEANLZ.shaderoivalue));
            end
        end
        % CompleteCurrentROI
        function CompleteCurrentROI(IMAGEANLZ,roi,roiname)
            ImAnlz_CompleteCurrentROI(IMAGEANLZ,roi,roiname);
            IMAGEANLZ.SAVEDROISFLAG = 1;
        end
        % CreateEmptySavedROI
        function CreateEmptySavedROI(IMAGEANLZ,roinum)
            for n = length(IMAGEANLZ.SAVEDROIS)+1:roinum
                IMAGEANLZ.SAVEDROIS(n) = ImageRoiClass(IMAGEANLZ);
            end   
        end
        % CreateEmptySavedROIAtEnd
        function CreateEmptySavedROIAtEnd(IMAGEANLZ)
            IMAGEANLZ.SAVEDROIS(length(IMAGEANLZ.SAVEDROIS)+1) = ImageRoiClass(IMAGEANLZ);
        end
        % ComputeSavedROI
        function ComputeSavedROI(IMAGEANLZ,roinum)
            IMAGEANLZ.SAVEDROIS(roinum).ComputeROI(IMAGEANLZ);
        end
        % ComputeAllSavedROIs
        function ComputeAllSavedROIs(IMAGEANLZ)
            for n = 1:length(IMAGEANLZ.SAVEDROIS)
                IMAGEANLZ.SAVEDROIS(n).ComputeROI(IMAGEANLZ);
            end
        end        
        % SetSavedROIValues
        function SetSavedROIValues(IMAGEANLZ)
            ImAnlz_SetSavedROIValues(IMAGEANLZ);
        end
        % DrawSavedROIs
        function DrawSavedROIs(IMAGEANLZ,axhand)
            if isempty(IMAGEANLZ.SAVEDROIS)
                return
            end
            for n = 1:length(IMAGEANLZ.SAVEDROIS)
                if IMAGEANLZ.linesroi
                    if strcmp(IMAGEANLZ.ORIENT,IMAGEANLZ.SAVEDROIS(n).drawroiorient)
                        IMAGEANLZ.SAVEDROIS(n).DrawROI(IMAGEANLZ,axhand,IMAGEANLZ.COLORORDER{n},1);
                    end
                end
                if IMAGEANLZ.shaderoi
                    IMAGEANLZ.SAVEDROIS(n).ShadeROI(IMAGEANLZ,axhand,IMAGEANLZ.COLORORDER{n},IMAGEANLZ.shaderoiintensities(IMAGEANLZ.shaderoivalue));
                end
            end
        end
        % DrawSavedROIsNoPick
        function DrawSavedROIsNoPick(IMAGEANLZ,axhand)
            if isempty(IMAGEANLZ.SAVEDROIS)
                return
            end
            for n = 1:length(IMAGEANLZ.SAVEDROIS)
                if IMAGEANLZ.linesroi
                    if strcmp(IMAGEANLZ.ORIENT,IMAGEANLZ.SAVEDROIS(n).drawroiorient)
                        IMAGEANLZ.SAVEDROIS(n).DrawROI(IMAGEANLZ,axhand,IMAGEANLZ.COLORORDER{n},0);
                    end
                end
                if IMAGEANLZ.shaderoi
                    IMAGEANLZ.SAVEDROIS(n).ShadeROI(IMAGEANLZ,axhand,IMAGEANLZ.COLORORDER{n},IMAGEANLZ.shaderoiintensities(IMAGEANLZ.shaderoivalue));
                end
            end
        end
        % DrawSavedROIsOffset
        function DrawSavedROIsOffset(IMAGEANLZ,axhand,slice,xoff,yoff)
            IMAGEANLZ.SLICE = slice;
            for n = 1:length(IMAGEANLZ.SAVEDROIS)
                IMAGEANLZ.SAVEDROIS(n).DrawROIwOffset(IMAGEANLZ,axhand,IMAGEANLZ.COLORORDER{n},xoff,yoff);
            end
        end
        % DeleteLastRegion
        function DeleteLastRegion(IMAGEANLZ)
            IMAGEANLZ.CURRENTROI.DeleteLastRegion;
            if IMAGEANLZ.autoupdateroi || IMAGEANLZ.shaderoi             
                IMAGEANLZ.CURRENTROI.CreateBaseROIMask;
            end
            if IMAGEANLZ.shaderoi 
                IMAGEANLZ.CURRENTROI.ShadeROI(IMAGEANLZ,[],'r',IMAGEANLZ.shaderoiintensities(IMAGEANLZ.shaderoivalue));
            end
        end
        % DeleteROI
        function DeleteROI(IMAGEANLZ,roinum)
            tSAVEDROIS = IMAGEANLZ.SAVEDROIS;
            if roinum == 1
                if length(tSAVEDROIS) == 1
                    IMAGEANLZ.SAVEDROIS = ImageRoiClass.empty;
                    IMAGEANLZ.SAVEDROISFLAG = 0;
                else
                    IMAGEANLZ.SAVEDROIS = tSAVEDROIS(2:end);
                end
            elseif roinum == length(tSAVEDROIS)
                IMAGEANLZ.SAVEDROIS = tSAVEDROIS(1:end-1);
            else
                IMAGEANLZ.SAVEDROIS = [tSAVEDROIS(1:roinum-1),tSAVEDROIS(roinum+1:end)];
            end
            switch IMAGEANLZ.presentation
                case 'Standard'
                    ImAnlz_ClearSavedROIValues(IMAGEANLZ);
                    ImAnlz_SetSavedROIValues(IMAGEANLZ);
                case 'Ortho'
                    if IMAGEANLZ.axnum == 1
                        ImAnlz_ClearSavedROIValues(IMAGEANLZ);
                        ImAnlz_SetSavedROIValues(IMAGEANLZ);
                    end
            end
        end        
        % DeleteAllSavedROIs
        function DeleteAllSavedROIs(IMAGEANLZ)
            IMAGEANLZ.SAVEDROISFLAG = 0;
            IMAGEANLZ.SAVEDROIS = ImageRoiClass.empty;
            ImAnlz_ClearSavedROIValues(IMAGEANLZ);
        end
        % TestForSavedROI
        function bool = TestForSavedROI(IMAGEANLZ,roinum)
            if roinum > length(IMAGEANLZ.SAVEDROIS)
                bool = 0;
                return
            end
            bool = IMAGEANLZ.SAVEDROIS(roinum).TestForSavedROI;
        end
        % AddROI2Saved
        function AddROI2Saved(IMAGEANLZ,ROI,roinum)
            IMAGEANLZ.SAVEDROISFLAG = 1;
            test = length(IMAGEANLZ.SAVEDROIS);
            for n = test+1:roinum
                IMAGEANLZ.SAVEDROIS(n) = ImageRoiClass(IMAGEANLZ);
            end
            IMAGEANLZ.SAVEDROIS(roinum).CopyRoiInfo(ROI);
        end  
        % CopySavedRoi2Current
        function CopySavedRoi2Current(IMAGEANLZ,roinum)
            IMAGEANLZ.CURRENTROI = ImageRoiClass(IMAGEANLZ);
            IMAGEANLZ.CURRENTROI.CopyRoiInfo(IMAGEANLZ.SAVEDROIS(roinum))
        end  
        % CopySavedRois
        function CopySavedRois(IMAGEANLZ,IMAGEANLZ2)
            IMAGEANLZ.SAVEDROISFLAG = 1;
            for n = 1:length(IMAGEANLZ2.SAVEDROIS)  
                IMAGEANLZ.SAVEDROIS(n) = ImageRoiClass(IMAGEANLZ);
                IMAGEANLZ.SAVEDROIS(n).CopyRoiInfo(IMAGEANLZ2.SAVEDROIS(n));
            end
        end   
        % ShadeROIChange
        function ShadeROIChange(IMAGEANLZ,val)
%             if IMAGEANLZ.GETROIS == 1 && val == 1
%                 IMAGEANLZ.CURRENTROI.CreateBaseROIMask;           % should already be created
%             end
            IMAGEANLZ.shaderoi = val;
            IMAGEANLZ.FIGOBJS.ShadeROI.Value = val;
        end
        % ShadeROIChangeValue
        function ShadeROIChangeValue(IMAGEANLZ,val)
            IMAGEANLZ.shaderoivalue = val;
        end
        % LinesROIChange
        function LinesROIChange(IMAGEANLZ,val)
            IMAGEANLZ.linesroi = val;
            IMAGEANLZ.FIGOBJS.LinesROI.Value = val;
        end
        % ToggleShadeROI
        function Shade = ToggleShadeROI(IMAGEANLZ)
%             if IMAGEANLZ.GETROIS == 1 && val == 1
%                 IMAGEANLZ.CURRENTROI.CreateBaseROIMask;           % should already be created
%             end
            if IMAGEANLZ.shaderoi == 1
                IMAGEANLZ.shaderoi = 0;
            elseif IMAGEANLZ.shaderoi == 0
                IMAGEANLZ.shaderoi = 1;
            end
            IMAGEANLZ.FIGOBJS.ShadeROI.Value = IMAGEANLZ.shaderoi;
            Shade = IMAGEANLZ.shaderoi;
        end    
        % ToggleLinesROI
        function Lines = ToggleLinesROI(IMAGEANLZ)
            if IMAGEANLZ.linesroi == 1
                IMAGEANLZ.linesroi = 0;
            elseif IMAGEANLZ.linesroi == 0
                IMAGEANLZ.linesroi = 1;
            end
            IMAGEANLZ.FIGOBJS.LinesROI.Value = IMAGEANLZ.linesroi;
            Lines = IMAGEANLZ.linesroi;
        end   
        % ToggleROIEvent
        function Event = ToggleROIEvent(IMAGEANLZ)
            if strcmp(IMAGEANLZ.roievent,'Add')
                IMAGEANLZ.roievent = 'Erase';
            else
                IMAGEANLZ.roievent = 'Add';
            end
            Event = IMAGEANLZ.roievent;
        end
        
        
%==================================================================
% Line
%==================================================================
        % NewLineCreateOrtho
        function NewLineCreateOrtho(IMAGEANLZ)
            ImAnlz_NewLineCreateOrtho(IMAGEANLZ);
        end
        % BuildLine
        function OUT = BuildLine(IMAGEANLZ,x,y,event)
            Data.xpt = round(x);
            Data.ypt = round(y);
            Data.zpt = IMAGEANLZ.SLICE;
            pixdim = GetPixelDimensions(IMAGEANLZ);
            Data.xloc = (Data.xpt-0.5)*pixdim(2);
            Data.yloc = (Data.ypt-0.5)*pixdim(1);
            Data.zloc = (Data.zpt-0.5)*pixdim(3);
            OUT = IMAGEANLZ.CURRENTLINE.BuildLine(Data,event);
            IMAGEANLZ.GETLINE = 1;
        end
        % RecordLineInfo
        function RecordLineInfo(IMAGEANLZ,x,y)
            Data.xpt = round(x);
            Data.ypt = round(y);
            Data.zpt = IMAGEANLZ.SLICE;
            pixdim = GetPixelDimensions(IMAGEANLZ);
            Data.xloc = (Data.xpt-0.5)*pixdim(2);
            Data.yloc = (Data.ypt-0.5)*pixdim(1);
            Data.zloc = (Data.zpt-0.5)*pixdim(3);
            IMAGEANLZ.CURRENTLINE.RecordLineInfo(Data);
        end
        % DrawCurrentLine
        function DrawCurrentLine(IMAGEANLZ)
            axhand = IMAGEANLZ.GetAxisHandle;
            clr = 'r';
            IMAGEANLZ.CURRENTLINE.DrawLine(axhand,clr);
        end
        % WriteCurrentLineData
        function WriteCurrentLineData(IMAGEANLZ,CurrentLine)
            set(IMAGEANLZ.FIGOBJS.CURRENTLINE(1),'visible','on','string',num2str(CurrentLine.lengthTot,'%3.3f'),'foregroundcolor','r');
            set(IMAGEANLZ.FIGOBJS.CURRENTLINE(2),'visible','on','string',num2str(CurrentLine.lengthIP,'%3.3f'),'foregroundcolor','r');
            set(IMAGEANLZ.FIGOBJS.CURRENTLINE(3),'visible','on','string',num2str(CurrentLine.anglePol,'%2.5f'),'foregroundcolor','r'); 
            set(IMAGEANLZ.FIGOBJS.CURRENTLINE(4),'visible','on','string',num2str(CurrentLine.angleAzi,'%2.5f'),'foregroundcolor','r'); 
        end
        % CurrentLineDrawError
        function CurrentLineDrawError(IMAGEANLZ) 
            IMAGEANLZ.CURRENTLINE.DrawError;
        end
        % CurrentLineDrawErrorWrite
        function CurrentLineDrawErrorWrite(IMAGEANLZ) 
            set(IMAGEANLZ.FIGOBJS.CURRENTLINE(1),'visible','off');
            set(IMAGEANLZ.FIGOBJS.CURRENTLINE(2),'visible','off');
            set(IMAGEANLZ.FIGOBJS.CURRENTLINE(3),'visible','off');
            set(IMAGEANLZ.FIGOBJS.CURRENTLINE(4),'visible','off');      
        end
        % SaveLine
        function [n,GlobalSavedLinesInd] = SaveLine(IMAGEANLZ)
            for n = 1:3
                if IMAGEANLZ.GlobalSavedLinesInd(n) == 0
                    test = ImageLineClass(IMAGEANLZ);
                    IMAGEANLZ.SAVEDLINES(n) = test;
                    IMAGEANLZ.SAVEDLINES(n).CopyLineInfo(IMAGEANLZ.CURRENTLINE);
                    axhand = IMAGEANLZ.GetAxisHandle;
                    IMAGEANLZ.SAVEDLINES(n).DrawLine(axhand,IMAGEANLZ.LineClrOrder(n));
                    IMAGEANLZ.SavedLinesInd(n) = 1;
                    IMAGEANLZ.GlobalSavedLinesInd(n) = 1;
                    break
                end
            end
            GlobalSavedLinesInd = IMAGEANLZ.GlobalSavedLinesInd;
        end
        % UpdateGlobalSavedLinesInd
        function UpdateGlobalSavedLinesInd(IMAGEANLZ,GlobalSavedLinesInd) 
            IMAGEANLZ.GlobalSavedLinesInd = GlobalSavedLinesInd;
        end
        % WriteSavedLineData
        function WriteSavedLineData(IMAGEANLZ,SAVEDLINES,SavedLine)
            set(IMAGEANLZ.FIGOBJS.SAVEDLINES(SavedLine,1),'visible','on','string',num2str(SAVEDLINES(SavedLine).lengthTot,'%3.3f'),'foregroundcolor',IMAGEANLZ.LineClrOrder(SavedLine));
            set(IMAGEANLZ.FIGOBJS.SAVEDLINES(SavedLine,2),'visible','on','string',num2str(SAVEDLINES(SavedLine).lengthIP,'%3.3f'),'foregroundcolor',IMAGEANLZ.LineClrOrder(SavedLine));
            set(IMAGEANLZ.FIGOBJS.SAVEDLINES(SavedLine,3),'visible','on','string',num2str(SAVEDLINES(SavedLine).anglePol,'%3.3f'),'foregroundcolor',IMAGEANLZ.LineClrOrder(SavedLine));
            set(IMAGEANLZ.FIGOBJS.SAVEDLINES(SavedLine,4),'visible','on','string',num2str(SAVEDLINES(SavedLine).angleAzi,'%2.5f'),'foregroundcolor',IMAGEANLZ.LineClrOrder(SavedLine)); 
            set(IMAGEANLZ.FIGOBJS.DeleteLine(SavedLine),'visible','on'); 
        end
        % ClearCurrentLine
        function ClearCurrentLine(IMAGEANLZ)
            IMAGEANLZ.CURRENTLINE.DeleteGraphicObjects;
            IMAGEANLZ.GETLINE = 0;
        end
        % ClearCurrentLineData
        function ClearCurrentLineData(IMAGEANLZ)
            set(IMAGEANLZ.FIGOBJS.CURRENTLINE(1),'visible','off');
            set(IMAGEANLZ.FIGOBJS.CURRENTLINE(2),'visible','off'); 
            set(IMAGEANLZ.FIGOBJS.CURRENTLINE(3),'visible','off');
            set(IMAGEANLZ.FIGOBJS.CURRENTLINE(4),'visible','off'); 
            IMAGEANLZ.GETLINE = 0;
        end
        % TestSavedLines
        function bool = TestSavedLines(IMAGEANLZ) 
            bool = 0;
            if sum(IMAGEANLZ.SavedLinesInd) > 0
                bool = 1;
            end
        end       
         % DrawSavedLines
        function DrawSavedLines(IMAGEANLZ)
            axhand = IMAGEANLZ.GetAxisHandle;
            for n = 1:3
                if IMAGEANLZ.SavedLinesInd(n) == 1
                    if IMAGEANLZ.SAVEDLINES(n).TestLineInSlice(IMAGEANLZ.SLICE)
                        IMAGEANLZ.SAVEDLINES(n).DrawLine(axhand,IMAGEANLZ.LineClrOrder(n));
                    end
                end
            end
        end
        % DeleteSavedLine
        function [GlobalSavedLinesInd] = DeleteSavedLine(IMAGEANLZ,SavedLine)
            if length(IMAGEANLZ.SAVEDLINES) >= SavedLine
                IMAGEANLZ.SAVEDLINES(SavedLine).DeleteGraphicObjects;
            end 
            IMAGEANLZ.SavedLinesInd(SavedLine) = 0;
            IMAGEANLZ.GlobalSavedLinesInd(SavedLine) = 0;
            GlobalSavedLinesInd = IMAGEANLZ.GlobalSavedLinesInd;
        end    
        % DeleteSavedLineData
        function DeleteSavedLineData(IMAGEANLZ,SavedLine)
            set(IMAGEANLZ.FIGOBJS.SAVEDLINES(SavedLine,1),'visible','off');
            set(IMAGEANLZ.FIGOBJS.SAVEDLINES(SavedLine,2),'visible','off');
            set(IMAGEANLZ.FIGOBJS.SAVEDLINES(SavedLine,3),'visible','off');
            set(IMAGEANLZ.FIGOBJS.SAVEDLINES(SavedLine,4),'visible','off');
            set(IMAGEANLZ.FIGOBJS.DeleteLine(SavedLine),'visible','off'); 
        end  
        % EndLineTool
        function EndLineTool(IMAGEANLZ)
            IMAGEANLZ.LineToolActive = 0;
            IMAGEANLZ.buttonfunction = '';
            IMAGEANLZ.movefunction = '';
            IMAGEANLZ.pointer = 'arrow';
            set(gcf,'pointer',IMAGEANLZ.pointer);
        end
        
%==================================================================
% Drawing
%==================================================================
        % SetMark
        function SetMark(IMAGEANLZ,Mark)
            markfraction = 0.004;
            mx = markfraction*(IMAGEANLZ.SCALE.xmax-IMAGEANLZ.SCALE.xmin);
            my = markfraction*(IMAGEANLZ.SCALE.ymax-IMAGEANLZ.SCALE.ymin);
            mlen = max([mx my]);
            DeleteMark(IMAGEANLZ);
            IMAGEANLZ.mark(1) = line([Mark(1)-mlen Mark(1)+mlen],[Mark(2)-mlen Mark(2)+mlen],'parent',IMAGEANLZ.FIGOBJS.ImAxes,'color','w','PickableParts','none');
            IMAGEANLZ.mark(2) = line([Mark(1)-mlen Mark(1)+mlen],[Mark(2)+mlen Mark(2)-mlen],'parent',IMAGEANLZ.FIGOBJS.ImAxes,'color','w','PickableParts','none');
            drawnow;
        end
        % DeleteMark
        function DeleteMark(IMAGEANLZ)
            if not(isempty(IMAGEANLZ.mark))
                delete(IMAGEANLZ.mark);
            end
        end
        % ShowOrthoLine
        function ShowOrthoLine(IMAGEANLZ,val)
            IMAGEANLZ.showortholine = val;
        end
        % DrawOrthoLine
        function DrawOrthoLine(IMAGEANLZ,InputOrient,InputSlice)
            DeleteOrthoLine(IMAGEANLZ);
            imsize = GetImageSize(IMAGEANLZ);
            for n = 1:length(InputOrient)
                if strcmp(InputOrient{n},'Axial')
                    if strcmp(IMAGEANLZ.ORIENT,'Sagittal')
                        IMAGEANLZ.ortholine(n) = line([0 1000],[imsize(1)-InputSlice(n)+1 imsize(1)-InputSlice(n)+1],'parent',IMAGEANLZ.FIGOBJS.ImAxes,'color','w','PickableParts','visible','ButtonDownFcn',@UpdateOrthoSlices,'Tag',num2str(IMAGEANLZ.axnum));
                    elseif strcmp(IMAGEANLZ.ORIENT,'Coronal')
                        IMAGEANLZ.ortholine(n) = line([0 1000],[imsize(1)-InputSlice(n)+1 imsize(1)-InputSlice(n)+1],'parent',IMAGEANLZ.FIGOBJS.ImAxes,'color','w','PickableParts','visible','ButtonDownFcn',@UpdateOrthoSlices,'Tag',num2str(IMAGEANLZ.axnum));
                    end
                elseif strcmp(InputOrient{n},'Sagittal')
                    if strcmp(IMAGEANLZ.ORIENT,'Axial')
                        IMAGEANLZ.ortholine(n) = line([InputSlice(n) InputSlice(n)],[0 1000],'parent',IMAGEANLZ.FIGOBJS.ImAxes,'color','w','PickableParts','visible','ButtonDownFcn',@UpdateOrthoSlices,'Tag',num2str(IMAGEANLZ.axnum));
                    elseif strcmp(IMAGEANLZ.ORIENT,'Coronal')
                        IMAGEANLZ.ortholine(n) = line([InputSlice(n) InputSlice(n)],[0 1000],'parent',IMAGEANLZ.FIGOBJS.ImAxes,'color','w','PickableParts','visible','ButtonDownFcn',@UpdateOrthoSlices,'Tag',num2str(IMAGEANLZ.axnum));
                    end
                elseif strcmp(InputOrient{n},'Coronal')
                    if strcmp(IMAGEANLZ.ORIENT,'Axial')
                        IMAGEANLZ.ortholine(n) = line([0 1000],[InputSlice(n) InputSlice(n)],'parent',IMAGEANLZ.FIGOBJS.ImAxes,'color','w','PickableParts','visible','ButtonDownFcn',@UpdateOrthoSlices,'Tag',num2str(IMAGEANLZ.axnum));
                    elseif strcmp(IMAGEANLZ.ORIENT,'Sagittal')
                        IMAGEANLZ.ortholine(n) = line([InputSlice(n) InputSlice(n)],[0 1000],'parent',IMAGEANLZ.FIGOBJS.ImAxes,'color','w','PickableParts','visible','ButtonDownFcn',@UpdateOrthoSlices,'Tag',num2str(IMAGEANLZ.axnum));
                    end
                end
                if IMAGEANLZ.GETROIS
                    IMAGEANLZ.ortholine(n).PickableParts = 'none';
                end
            end
        end
        % DeleteOrthoLine
        function DeleteOrthoLine(IMAGEANLZ)
            if not(isempty(IMAGEANLZ.ortholine))
                delete(IMAGEANLZ.ortholine);
            end
        end

%==================================================================
% Current Point Value
%==================================================================        
        % TestTinyMove
        function bool = TestTinyMove(IMAGEANLZ) 
            bool = IMAGEANLZ.tinymove;
        end
        % GetCurrentPointData
        function Data = GetCurrentPointData(IMAGEANLZ,x,y)        
            Data.val = IMAGEANLZ.imslice(round(y),round(x));
            pixdim = GetPixelDimensions(IMAGEANLZ);
            imsize = GetImageSize(IMAGEANLZ);
            if strcmp(IMAGEANLZ.ORIENT,'Axial')
                point = [x,y,IMAGEANLZ.SLICE];
            elseif strcmp(IMAGEANLZ.ORIENT,'Sagittal')
                point = [IMAGEANLZ.SLICE,x,imsize(1)-y+1];
            elseif strcmp(IMAGEANLZ.ORIENT,'Coronal')
                point = [x,IMAGEANLZ.SLICE,imsize(1)-y+1];
            end
            point = round(point);
            IMAGEANLZ.tinymove = 0;
            if point(1) == IMAGEANLZ.curmat(1) && point(2) == IMAGEANLZ.curmat(2) && point(3) == IMAGEANLZ.curmat(3)
                IMAGEANLZ.tinymove = 1;
            end
            IMAGEANLZ.curmat = point;
            Data.point = point;
            if strcmp(IMAGEANLZ.ORIENT,'Axial')
                Data.loc = (point-0.5).*pixdim([2 1 3]);
            elseif strcmp(IMAGEANLZ.ORIENT,'Sagittal')
                Data.loc = (point-0.5).*pixdim([3 2 1]);
            elseif strcmp(IMAGEANLZ.ORIENT,'Coronal')
                Data.loc = (point-0.5).*pixdim([2 3 1]);
            end
            
        end
        % SetCurrentPointInfoOrtho
        function SetCurrentPointInfoOrtho(IMAGEANLZ,Data)
            IMAGEANLZ.FIGOBJS.CURVAL.String = num2str(Data.val);
            IMAGEANLZ.FIGOBJS.X.String = num2str(Data.loc(1),'%3.1f');
            IMAGEANLZ.FIGOBJS.Y.String = num2str(Data.loc(2),'%3.1f');
            IMAGEANLZ.FIGOBJS.Z.String = num2str(Data.loc(3),'%3.1f');
%             IMAGEANLZ.FIGOBJS.XPix.String = num2str(IMAGEANLZ.curmat(1),'%3.0f');
%             IMAGEANLZ.FIGOBJS.YPix.String = num2str(IMAGEANLZ.curmat(2),'%3.0f');
%             IMAGEANLZ.FIGOBJS.ZPix.String = num2str(IMAGEANLZ.curmat(3),'%3.0f');
            IMAGEANLZ.FIGOBJS.XPix.String = num2str(Data.point(1),'%3.0f');
            IMAGEANLZ.FIGOBJS.YPix.String = num2str(Data.point(2),'%3.0f');
            IMAGEANLZ.FIGOBJS.ZPix.String = num2str(Data.point(3),'%3.0f');
        end
        % ClearCurrentPointInfoOrtho
        function ClearCurrentPointInfoOrtho(IMAGEANLZ)  
            IMAGEANLZ.FIGOBJS.CURVAL.String = '';
            IMAGEANLZ.FIGOBJS.X.String = '';
            IMAGEANLZ.FIGOBJS.Y.String = '';
            IMAGEANLZ.FIGOBJS.Z.String = '';
            IMAGEANLZ.FIGOBJS.XPix.String = '';
            IMAGEANLZ.FIGOBJS.YPix.String = '';
            IMAGEANLZ.FIGOBJS.ZPix.String = '';
        end
            
%==================================================================
% Image
%==================================================================
        % SetImage        
        function SetImage(IMAGEANLZ)
            IMAGEANLZ.imvol = GetCurrent3DImage(IMAGEANLZ);
        end
        % SetImageSlice        
        function SetImageSlice(IMAGEANLZ)
            IMAGEANLZ.imslice = IMAGEANLZ.imvol(:,:,IMAGEANLZ.SLICE);
        end
        % GetCurrent3DImageComplex
        function Image = GetCurrent3DImageComplex(IMAGEANLZ)
            global TOTALGBL
            Image = TOTALGBL{2,IMAGEANLZ.totgblnum}.Im;
            Image = ImageOrient(IMAGEANLZ,Image);
            Image = Image(:,:,:,IMAGEANLZ.DIM4,IMAGEANLZ.DIM5,IMAGEANLZ.DIM6);
        end
        % GetCurrent3DImage
        function Image = GetCurrent3DImage(IMAGEANLZ)
            global TOTALGBL
            Image = TOTALGBL{2,IMAGEANLZ.totgblnum}.Im;
            Image = ImageOrient(IMAGEANLZ,Image);
            Image = Image(:,:,:,IMAGEANLZ.DIM4,IMAGEANLZ.DIM5,IMAGEANLZ.DIM6);
            Image = ImageTypeCreate(IMAGEANLZ,Image);  
        end
        % GetOriented3DImage
        function Image = GetOriented3DImage(IMAGEANLZ,orient)
            global TOTALGBL
            Image = TOTALGBL{2,IMAGEANLZ.totgblnum}.Im;
            Image = ImageOrientDefined(IMAGEANLZ,Image,orient);
            Image = Image(:,:,:,IMAGEANLZ.DIM4,IMAGEANLZ.DIM5,IMAGEANLZ.DIM6);
            Image = ImageTypeCreate(IMAGEANLZ,Image);  
        end
        % GetComplexOriented3DImage
        function Image = GetComplexOriented3DImage(IMAGEANLZ,orient)
            global TOTALGBL
            Image = TOTALGBL{2,IMAGEANLZ.totgblnum}.Im;
            Image = ImageOrientDefined(IMAGEANLZ,Image,orient);
            Image = Image(:,:,:,IMAGEANLZ.DIM4,IMAGEANLZ.DIM5,IMAGEANLZ.DIM6);
        end
        
%==================================================================
% Image Process
%==================================================================        
        % ImageTypeCreate
        function Image = ImageTypeCreate(IMAGEANLZ,Image)
            if strcmp(IMAGEANLZ.IMTYPE,'abs')
                Image = abs(Image);
            elseif strcmp(IMAGEANLZ.IMTYPE,'real')
                Image = real(Image);
            elseif strcmp(IMAGEANLZ.IMTYPE,'imag')
                Image = imag(Image);
            elseif strcmp(IMAGEANLZ.IMTYPE,'phase')
                Image = angle(Image);
            elseif strcmp(IMAGEANLZ.IMTYPE,'phase90')
                Image = angle(Image);
                Image = Image-pi;
                Image(Image < -pi) = Image(Image < -pi) + 2*pi;
            end
        end
        % ImageOrient
        function Image = ImageOrient(IMAGEANLZ,Image)
            Image = IMAGEANLZ.ImageOrientDefined(Image,IMAGEANLZ.ORIENT);
        end
        % ImageOrientDefined
        function Image = ImageOrientDefined(IMAGEANLZ,Image,orient)
            if strcmp(orient,'Sagittal')
                Image = permute(Image,[3 1 2 4 5 6]);
                Image = flip(Image,1);
            elseif strcmp(orient,'Coronal')
                Image = permute(Image,[3 2 1 4 5 6]);
                Image = flip(Image,1);
                %Image = flip(Image,3);
            end
        end
        
%==================================================================
% Image Plotting
%==================================================================        
        % PlotImage
        function PlotImage(IMAGEANLZ)
            h = image(IMAGEANLZ.imslice,'Parent',IMAGEANLZ.FIGOBJS.ImAxes);                 % note children deleted as part of call
            h.BusyAction = 'cancel';
            h.Interruptible = 'off';
            h.CDataMapping = 'scaled';
            h.PickableParts = 'none';
            h.HitTest = 'off';
            drawnow;
        end
        % SetDataAspectRatio
        function SetDataAspectRatio(IMAGEANLZ)
            pixdim = IMAGEANLZ.GetPixelDimensions;
            IMAGEANLZ.FIGOBJS.ImAxes.DataAspectRatio = pixdim;
        end 
        % SetContrast
        function SetContrast(IMAGEANLZ)
            clim = IMAGEANLZ.GetContrastLimit;
            IMAGEANLZ.FIGOBJS.ImAxes.CLim = clim;
        end
        % ChangeColour
        function ChangeColour(IMAGEANLZ,colour)
            if strcmp(colour,'on')
                colormap(IMAGEANLZ.FIGOBJS.ImAxes,IMAGEANLZ.FIGOBJS.Options.ColorMap);
            else
                colormap(IMAGEANLZ.FIGOBJS.ImAxes,IMAGEANLZ.FIGOBJS.Options.GrayMap);
            end
        end
        % SetScale
        function SetScale(IMAGEANLZ)
            IMAGEANLZ.FIGOBJS.ImAxes.XLim = [IMAGEANLZ.SCALE.xmin IMAGEANLZ.SCALE.xmax];
            IMAGEANLZ.FIGOBJS.ImAxes.YLim = [IMAGEANLZ.SCALE.ymin IMAGEANLZ.SCALE.ymax];
        end 
        
%==================================================================
% Panel Setup
%==================================================================          
        % MultiDimSetup
        function MultiDimSetup(IMAGEANLZ)
            ImAnlz_MultiDimSetup(IMAGEANLZ);
        end    
        % HoldingTest
        function HoldingTest(IMAGEANLZ,totgblnum)
            ImAnlz_HoldingTest(IMAGEANLZ,totgblnum);
        end
        % RoiSizeTest
        function abort = RoiSizeTest(IMAGEANLZ,totgblnum)
            abort = ImAnlz_RoiSizeTest(IMAGEANLZ,totgblnum);
        end
        % ImageDimsCompare
        function abort = ImageDimsCompare(IMAGEANLZ,totgblnum)
            abort = ImAnlz_ImageDimsCompare(IMAGEANLZ,totgblnum);
        end
        
%==================================================================
% Tieing
%================================================================== 
        % TieTest
        function reset = TieTest(IMAGEANLZ,othersize)
            reset = ImAnlz_TieTest(IMAGEANLZ,othersize);
        end
        % TieSlice
        function TieSlice(IMAGEANLZ,val)
            IMAGEANLZ.SLCTIE = val;
            IMAGEANLZ.FIGOBJS.TieSlice.Value = val;
            IMAGEANLZ.FIGOBJS.TieAll.Value = 0;
        end
        % TieZoom
        function TieZoom(IMAGEANLZ,val)
            IMAGEANLZ.ZOOMTIE = val;
            IMAGEANLZ.FIGOBJS.TieZoom.Value = val;
            IMAGEANLZ.FIGOBJS.TieAll.Value = 0;
        end
        % TieDims
        function TieDims(IMAGEANLZ,val)
            IMAGEANLZ.DIMSTIE = val;
            IMAGEANLZ.FIGOBJS.TieDims.Value = val;
            IMAGEANLZ.FIGOBJS.TieAll.Value = 0;
        end
        % TieDatVals
        function TieDatVals(IMAGEANLZ,val)
            IMAGEANLZ.DATVALTIE = val;
            IMAGEANLZ.FIGOBJS.TieDatVals.Value = val;
            IMAGEANLZ.FIGOBJS.TieAll.Value = 0;
        end
        % TieRois
        function TieRois(IMAGEANLZ,val)
            IMAGEANLZ.ROITIE = val;
            IMAGEANLZ.FIGOBJS.TieROIs.Value = val;
            IMAGEANLZ.FIGOBJS.TieAll.Value = 0;
        end
        % TieCursor
        function TieCursor(IMAGEANLZ,val)
            IMAGEANLZ.CURSORTIE = val;
            IMAGEANLZ.FIGOBJS.TieCursor.Value = val;
            IMAGEANLZ.FIGOBJS.TieAll.Value = 0;
        end
        % TieAll
        function TieAll(IMAGEANLZ,val)
            IMAGEANLZ.TieSlice(val);
            IMAGEANLZ.TieZoom(val);
            IMAGEANLZ.TieDims(val);
            IMAGEANLZ.TieDatVals(val);
            IMAGEANLZ.TieRois(val);
            IMAGEANLZ.TieCursor(val);
            IMAGEANLZ.ALLTIE = val;
            IMAGEANLZ.FIGOBJS.TieAll.Value = val;
        end           
        % UnTieAll
        function UnTieAll(IMAGEANLZ)
            IMAGEANLZ.ALLTIE = 0;
            IMAGEANLZ.FIGOBJS.TieAll.Value = 0;
            IMAGEANLZ.TieSlice(0);
            IMAGEANLZ.TieZoom(0);
            IMAGEANLZ.TieDims(0);
            IMAGEANLZ.TieDatVals(0);
            IMAGEANLZ.TieRois(0);
            IMAGEANLZ.TieCursor(0);
        end   
        % DisableTieing
        function DisableTieing(IMAGEANLZ)
            IMAGEANLZ.FIGOBJS.TieAll.Enable = 'off';
            IMAGEANLZ.FIGOBJS.TieSlice.Enable = 'off';
            IMAGEANLZ.FIGOBJS.TieZoom.Enable = 'off';
            IMAGEANLZ.FIGOBJS.TieDims.Enable = 'off';
            IMAGEANLZ.FIGOBJS.TieDatVals.Enable = 'off';
            IMAGEANLZ.FIGOBJS.TieROIs.Enable = 'off';
            IMAGEANLZ.FIGOBJS.TieCursor.Enable = 'off';
        end
        % EnableTieing
        function EnableTieing(IMAGEANLZ)
            IMAGEANLZ.FIGOBJS.TieAll.Enable = 'on';
            IMAGEANLZ.FIGOBJS.TieSlice.Enable = 'on';
            IMAGEANLZ.FIGOBJS.TieZoom.Enable = 'on';
            IMAGEANLZ.FIGOBJS.TieDims.Enable = 'on';
            IMAGEANLZ.FIGOBJS.TieDatVals.Enable = 'on';
            IMAGEANLZ.FIGOBJS.TieROIs.Enable = 'on';
            IMAGEANLZ.FIGOBJS.TieCursor.Enable = 'on';
        end    
 
%==================================================================
% Holding
%==================================================================         
        % ToggleContrast
        function ToggleContrast(IMAGEANLZ,value) 
            IMAGEANLZ.contrasthold = value;
        end

%==================================================================
% Status
%==================================================================   
        % UpdateStatus
        function UpdateStatus(IMAGEANLZ)
        	IMAGEANLZ.STATUS.UpdateStatus;   
        end 
        % ResetStatus
        function ResetStatus(IMAGEANLZ)
        	IMAGEANLZ.STATUS.ResetStatus;   
        end  
        % SetInfo
        function SetInfo(IMAGEANLZ,String)  
        	Status.string = String;
            Status.state = 'info';
            IMAGEANLZ.STATUS.SetStatusLine(Status,3);  
        end  
    end
end
        
%================================================================
%  
%================================================================

classdef ImageAnlzClass < handle

    properties (SetAccess = public)                                         % for now...
        %-- general
        tab,axnum,axeslen;
        totgblnum,axisactive;
        totgblnumhl;
        overtotgblnum;
        highlight;
        pointer;
        presentation;
        %-- current images
        imvol,imslice;
        overimvol,overimslice;
        overimvolalpha,overimslicealpha;
        loadedoverlay;
        %-- loading
        IMPATH;
        IMFILETYPE;
        ROIPATH;
        %-- mouse functions
        buttonfunction;
        movefunction;
        curmat,tinymove;
        %-- contrast
        ImType;
        RelContrast;
        FullContrast;
        MaxContrastMax;
        MaxContrastCurrent;
        MinContrastMin;
        MinContrastCurrent;
        ContrastSettings;
        ImageObject;
        %-- overlay contrast
        OImType;
        ORelContrast;
        OFullContrast;
        OMaxContrastMax;
        OMaxContrastCurrent;
        OMinContrastMin;
        OMinContrastCurrent;
        OContrastSettings;
        OverlayColour;
        OverlayTransparency;
        OverlayObject;
        %-- orient
        ORIENT;
        %-- navigate
        SLICE,DIM4,DIM5,DIM6;
        OverlayDim4;
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
        shaderoi; shaderoivalue;
        linesroi;
        autoupdateroi;
        drawroionall;
        temproiclr;
        complexaverageroi;
        roievent;
        redrawroi;
        colourimage;
        colouroverlay;
        %-- line
        GETLINE;
        LineToolActive;
        %-- tieing
        AllTie;
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
        REDRAWROI;
        SAVEDROIS;
        ROIFREEHAND;                 
        ROISEED;
        ROISPHERE;        
        ROICIRCLE;    
        ROITUBE;
        ROIRECT;
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
            IMAGEANLZ.ImType = IMAGEANLZ2.ImType;
            %error % finish contrast
            IMAGEANLZ.RelContrast = IMAGEANLZ2.RelContrast;                             
            IMAGEANLZ.MaxContrastMax = IMAGEANLZ2.MaxContrastMax;
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
        % GetFocus
        function CurrentObject = GetFocus(IMAGEANLZ)
            CurrentObject = IMAGEANLZ.FIGOBJS.GetFocus;
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
        % TestForLoadedImage
        function bool = TestForLoadedImage(IMAGEANLZ)
            bool = 1;
            if isempty(IMAGEANLZ.totgblnum)
                bool = 0;
            end
        end
        % AssignOverlay
        function AssignOverlay(IMAGEANLZ,totgblnum,overlaynum)
            IMAGEANLZ.overtotgblnum(overlaynum) = totgblnum;
            IMAGEANLZ.loadedoverlay(overlaynum) = 1;
        end 
        % SetOverlayName
        function SetOverlayName(IMAGEANLZ,overlaynum)
            global TOTALGBL
            ImName = TOTALGBL{1,IMAGEANLZ.overtotgblnum(overlaynum)};
            IMAGEANLZ.FIGOBJS.SetOverlayName(ImName,overlaynum);
        end 
        % SetTotGblNumHighlight
        function SetTotGblNumHighlight(IMAGEANLZ,totgblnumhl)
            IMAGEANLZ.totgblnumhl = totgblnumhl;
        end
        % TestForOverlay
        function bool = TestForOverlay(IMAGEANLZ,overlaynum)
            bool = IMAGEANLZ.loadedoverlay(overlaynum);
        end
        % TestForAnyOverlay
        function bool = TestForAnyOverlay(IMAGEANLZ)
            bool = 0;
            for n = 1:4
                if IMAGEANLZ.loadedoverlay(n) == 1
                    bool = 1;
                    return
                end
            end
        end
        % Highlight
        function Highlight(IMAGEANLZ)
            IMAGEANLZ.highlight = 1;
            IMAGEANLZ.FIGOBJS.ImPan.HighlightColor = 'r';
            if not(isempty(IMAGEANLZ.FIGOBJS.AnlzTab)) && not(isempty(IMAGEANLZ.FIGOBJS.InfoTab))
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
        % GetImagePath
        function ImPath = GetImagePath(IMAGEANLZ)
            global TOTALGBL
            ImPath = TOTALGBL{2,IMAGEANLZ.totgblnum}.path;
        end
        % GetImageInfo
        function ImInfo = GetImageInfo(IMAGEANLZ)
            global TOTALGBL
            ImInfo = TOTALGBL{2,IMAGEANLZ.totgblnum}.IMDISP.ImInfo;
        end
        % GetDefaultContrast
        function DefaultContrast = GetDefaultContrast(IMAGEANLZ)
            global TOTALGBL
            DefaultContrast = TOTALGBL{2,IMAGEANLZ.totgblnum}.IMDISP.DEFDISP;
        end
        % GetDefaultContrastOverlay
        function DefaultContrast = GetDefaultContrastOverlay(IMAGEANLZ,overlaynum)
            global TOTALGBL
            DefaultContrast = TOTALGBL{2,IMAGEANLZ.overtotgblnum(overlaynum)}.IMDISP.DEFDISP;
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
        % GetOverlayImageSize
        function imsize = GetOverlayImageSize(IMAGEANLZ,overtotgblnum,overlaynum)
            global TOTALGBL
            if isempty(overtotgblnum)
                overtotgblnum = IMAGEANLZ.overtotgblnum(overlaynum);
            end
            if isempty(overtotgblnum)
                imsize = [];
                return
            end
            newimsize = size(TOTALGBL{2,overtotgblnum}.Im);
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
        function SetOrient(IMAGEANLZ,orient,val)
            IMAGEANLZ.ORIENT = orient;
            IMAGEANLZ.FIGOBJS.Orientation.Value = val;
        end  
        % GetOrient
        function Orient = GetOrient(IMAGEANLZ)
            Orient = IMAGEANLZ.ORIENT;
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
        % TestColourImage
        function colourimage = TestColourImage(IMAGEANLZ)
            colourimage = 0;
            IMAGEANLZ.colourimage = 0;
            imsize = IMAGEANLZ.GetBaseImageSize([]);
            if imsize(4) > 1
                if imsize(4) == 3
                    %answer = questdlg('Display Image in Colour','Colour Image','Yes','No','Yes');
                    answer = 'Yes';
                    if strcmp(answer,'Yes')
                        IMAGEANLZ.colourimage = 1;
                        colourimage = 1;
                        IMAGEANLZ.FIGOBJS.Dim4.Enable = 'Off';
                    else
                        IMAGEANLZ.FIGOBJS.Dim4.Enable = 'On';
                    end
                else
                    IMAGEANLZ.FIGOBJS.Dim4.Enable = 'On';
                end
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
        % TestColourOverlay
        function [colouroverlay,OverlayDim4] = TestColourOverlay(IMAGEANLZ,overlaynum)
            colouroverlay = 0;
            IMAGEANLZ.colouroverlay(overlaynum) = 0;
            imsize = IMAGEANLZ.GetOverlayImageSize([],overlaynum);
            if imsize(4) > 1
                if imsize(4) == 3
                    %answer = questdlg('Display Image in Colour');
                    answer = 'Yes';
                    if strcmp(answer,'Yes')
                        IMAGEANLZ.colouroverlay(overlaynum) = 1;
                        colouroverlay = 1;
                        IMAGEANLZ.OverlayDim4(overlaynum) = 1;
                    else
                        answer = inputdlg('Dim4 Number','Dim4 Number');
                        IMAGEANLZ.OverlayDim4(overlaynum) = str2double(answer{1});
                    end
                else
                    answer = inputdlg('Dim4 Number','Dim4 Number');
                    if isempty(answer)
                        IMAGEANLZ.OverlayDim4(overlaynum) = 0;
                    else 
                        IMAGEANLZ.OverlayDim4(overlaynum) = str2double(answer{1});
                    end
                end
            else
                IMAGEANLZ.OverlayDim4(overlaynum) = 1;
            end
            OverlayDim4 = IMAGEANLZ.OverlayDim4(overlaynum);
        end 
        % SetColourOverlay
        function SetColourOverlay(IMAGEANLZ,overlaynum)
            IMAGEANLZ.colouroverlay(overlaynum) = 1;
        end
        % SetOverlayDimension
        function SetOverlayDimension(IMAGEANLZ,overlaynum,Dim4)
            IMAGEANLZ.OverlayDim4(overlaynum) = Dim4;
        end
        % TestEnableMultiDim
        function colourimage = TestEnableMultiDim(IMAGEANLZ,colourimage)
            IMAGEANLZ.colourimage = colourimage;
            imsize = IMAGEANLZ.GetBaseImageSize([]);
            if imsize(4) > 1
                if colourimage
                        IMAGEANLZ.FIGOBJS.Dim4.Enable = 'Off';
                else
                    IMAGEANLZ.FIGOBJS.Dim4.Enable = 'On';
                end
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
        %TestMinCMinValUserEditTooBig
        function bool = TestMinCMinValUserEditTooBig(IMAGEANLZ,mincmin)
            bool = 0;
            if mincmin >= IMAGEANLZ.MaxContrastMax
                bool = 1;
            end
        end
        %TestMaxCMaxValUserEditTooSmall
        function bool = TestMaxCMaxValUserEditTooSmall(IMAGEANLZ,maxcmax)
            bool = 0;
            if maxcmax <= IMAGEANLZ.MinContrastMin
                bool = 1;
            end
        end
        %CMaxValUserEdit
        function CMaxValUserEdit(IMAGEANLZ)
            IMAGEANLZ.FIGOBJS.CMaxVal.ForegroundColor = [0.8 0.8 0.8];
            IMAGEANLZ.FIGOBJS.CMaxVal.Enable = 'off';
            IMAGEANLZ.FIGOBJS.CMaxVal.Enable = 'on';
        end
        %OverlayMaxUserEdit
        function OverlayMaxUserEdit(IMAGEANLZ,overlaynum)
            IMAGEANLZ.FIGOBJS.OverlayMax(overlaynum).ForegroundColor = [0.8 0.8 0.8];
            IMAGEANLZ.FIGOBJS.OverlayMax(overlaynum).Enable = 'off';
            IMAGEANLZ.FIGOBJS.OverlayMax(overlaynum).Enable = 'on';
        end
        %CMinValUserEdit
        function CMinValUserEdit(IMAGEANLZ)
            IMAGEANLZ.FIGOBJS.CMinVal.ForegroundColor = [0.8 0.8 0.8];
            IMAGEANLZ.FIGOBJS.CMinVal.Enable = 'off';
            IMAGEANLZ.FIGOBJS.CMinVal.Enable = 'on';
        end
        %OverlayMinUserEdit
        function OverlayMinUserEdit(IMAGEANLZ,overlaynum)
            IMAGEANLZ.FIGOBJS.OverlayMin(overlaynum).ForegroundColor = [0.8 0.8 0.8];
            IMAGEANLZ.FIGOBJS.OverlayMin(overlaynum).Enable = 'off';
            IMAGEANLZ.FIGOBJS.OverlayMin(overlaynum).Enable = 'on';
        end
        %MaxCMaxValUserEdit
        function MaxCMaxValUserEdit(IMAGEANLZ)
            IMAGEANLZ.FIGOBJS.MaxCMaxVal.ForegroundColor = [0.8 0.8 0.8];
            IMAGEANLZ.FIGOBJS.MaxCMaxVal.Enable = 'off';
            IMAGEANLZ.FIGOBJS.MaxCMaxVal.Enable = 'on';
        end
        %MinCMinValUserEdit
        function MinCMinValUserEdit(IMAGEANLZ)
            IMAGEANLZ.FIGOBJS.MinCMinVal.ForegroundColor = [0.8 0.8 0.8];
            IMAGEANLZ.FIGOBJS.MinCMinVal.Enable = 'off';
            IMAGEANLZ.FIGOBJS.MinCMinVal.Enable = 'on';
        end
        %MaxCMaxValTest
        function maxcmax = MaxCMaxValTest(IMAGEANLZ,cmax)
            maxcmax = IMAGEANLZ.MaxContrastMax;
            if str2double(cmax) > maxcmax
                IMAGEANLZ.MaxContrastMax = str2double(cmax);
                IMAGEANLZ.FIGOBJS.MaxCMaxVal.String = cmax;
                maxcmax = IMAGEANLZ.MaxContrastMax;
                if abs(IMAGEANLZ.MaxContrastMax) < abs(IMAGEANLZ.MinContrastMin)
                    IMAGEANLZ.FullContrast = abs(IMAGEANLZ.MinContrastMin);
                else
                    IMAGEANLZ.FullContrast = abs(IMAGEANLZ.MaxContrastMax);
                end
                IMAGEANLZ.FIGOBJS.ContrastMax.Min = IMAGEANLZ.MinContrastMin/IMAGEANLZ.FullContrast;
                IMAGEANLZ.FIGOBJS.ContrastMin.Value = IMAGEANLZ.MinContrastCurrent/IMAGEANLZ.FullContrast;
                IMAGEANLZ.FIGOBJS.ContrastMin.Min = IMAGEANLZ.MinContrastMin/IMAGEANLZ.FullContrast;
                IMAGEANLZ.RelContrast(1) = IMAGEANLZ.MinContrastCurrent/IMAGEANLZ.FullContrast;
                IMAGEANLZ.RelContrast(2) = IMAGEANLZ.MaxContrastCurrent/IMAGEANLZ.FullContrast;
                if(IMAGEANLZ.RelContrast(2) <= IMAGEANLZ.RelContrast(1))
                    IMAGEANLZ.RelContrast(2) = IMAGEANLZ.RelContrast(1)+0.01;
                end
            end
        end
        %MinCMinValTest
        function mincmin = MinCMinValTest(IMAGEANLZ,cmin)
            mincmin = IMAGEANLZ.MinContrastMin;
            if str2double(cmin) < mincmin
                IMAGEANLZ.MinContrastMin = str2double(cmin);
                IMAGEANLZ.FIGOBJS.MinCMinVal.String = cmin;
                mincmin = IMAGEANLZ.MinContrastMin;
                if abs(IMAGEANLZ.MaxContrastMax) < abs(IMAGEANLZ.MinContrastMin)
                    IMAGEANLZ.FullContrast = abs(IMAGEANLZ.MinContrastMin);
                else
                    IMAGEANLZ.FullContrast = abs(IMAGEANLZ.MaxContrastMax);
                end
                IMAGEANLZ.FIGOBJS.ContrastMax.Min = IMAGEANLZ.MinContrastMin/IMAGEANLZ.FullContrast;
                IMAGEANLZ.FIGOBJS.ContrastMin.Min = IMAGEANLZ.MinContrastMin/IMAGEANLZ.FullContrast;
                IMAGEANLZ.RelContrast(1) = IMAGEANLZ.MinContrastCurrent/IMAGEANLZ.FullContrast;
                IMAGEANLZ.RelContrast(2) = IMAGEANLZ.MaxContrastCurrent/IMAGEANLZ.FullContrast;
                if(IMAGEANLZ.RelContrast(2) <= IMAGEANLZ.RelContrast(1))
                    IMAGEANLZ.RelContrast(2) = IMAGEANLZ.RelContrast(1)+0.01;
                end
            end
        end
        %ReduceCMaxValTest
        function cmax = ReduceCMaxValTest(IMAGEANLZ,maxcmax)
            cmax = IMAGEANLZ.MaxContrastCurrent;
            if str2double(maxcmax) < cmax
                IMAGEANLZ.MaxContrastCurrent = str2double(maxcmax);
                IMAGEANLZ.FIGOBJS.CMaxVal.String = maxcmax;
                if abs(IMAGEANLZ.MaxContrastMax) < abs(IMAGEANLZ.MinContrastMin)
                    IMAGEANLZ.FullContrast = abs(IMAGEANLZ.MinContrastMin);
                else
                    IMAGEANLZ.FullContrast = abs(IMAGEANLZ.MaxContrastMax);
                end
                IMAGEANLZ.FIGOBJS.ContrastMax.Min = IMAGEANLZ.MinContrastMin/IMAGEANLZ.FullContrast;
                IMAGEANLZ.FIGOBJS.ContrastMin.Min = IMAGEANLZ.MinContrastMin/IMAGEANLZ.FullContrast;
                IMAGEANLZ.RelContrast(1) = IMAGEANLZ.MinContrastCurrent/IMAGEANLZ.FullContrast;
                IMAGEANLZ.RelContrast(2) = IMAGEANLZ.MaxContrastCurrent/IMAGEANLZ.FullContrast;
                if(IMAGEANLZ.RelContrast(2) <= IMAGEANLZ.RelContrast(1))
                    IMAGEANLZ.RelContrast(1) = IMAGEANLZ.RelContrast(2)-0.01;
                end
                IMAGEANLZ.MinContrastCurrent = IMAGEANLZ.RelContrast(1)*IMAGEANLZ.FullContrast;
                IMAGEANLZ.FIGOBJS.CMinVal.String = IMAGEANLZ.MinContrastCurrent;
                cmax = IMAGEANLZ.MaxContrastCurrent;
            end
        end
        %ReduceCMinValTest
        function cmin = ReduceCMinValTest(IMAGEANLZ,maxcmax)
            cmin = IMAGEANLZ.MinContrastCurrent;
            if str2double(maxcmax) < cmin
                if abs(IMAGEANLZ.MaxContrastMax) < abs(IMAGEANLZ.MinContrastMin)
                    IMAGEANLZ.FullContrast = abs(IMAGEANLZ.MinContrastMin);
                else
                    IMAGEANLZ.FullContrast = abs(IMAGEANLZ.MaxContrastMax);
                end
                IMAGEANLZ.FIGOBJS.ContrastMax.Min = IMAGEANLZ.MinContrastMin/IMAGEANLZ.FullContrast;
                IMAGEANLZ.FIGOBJS.ContrastMin.Min = IMAGEANLZ.MinContrastMin/IMAGEANLZ.FullContrast;
                IMAGEANLZ.RelContrast(1) = IMAGEANLZ.MinContrastCurrent/IMAGEANLZ.FullContrast;
                IMAGEANLZ.RelContrast(2) = IMAGEANLZ.MaxContrastCurrent/IMAGEANLZ.FullContrast;
                if(IMAGEANLZ.RelContrast(2) <= IMAGEANLZ.RelContrast(1))
                    IMAGEANLZ.RelContrast(1) = IMAGEANLZ.RelContrast(2)-0.01;
                end
                IMAGEANLZ.MinContrastCurrent = IMAGEANLZ.RelContrast(1)*IMAGEANLZ.FullContrast;
                IMAGEANLZ.FIGOBJS.CMinVal.String = IMAGEANLZ.MinContrastCurrent;
                cmin = IMAGEANLZ.MinContrastCurrent;
            end
        end
        %IncreaseCMinValTest
        function cmin = IncreaseCMinValTest(IMAGEANLZ,mincmin)
            cmin = IMAGEANLZ.MinContrastCurrent;
            if str2double(mincmin) > cmin
                IMAGEANLZ.MinContrastCurrent = str2double(mincmin);
                IMAGEANLZ.FIGOBJS.CMinVal.String = mincmin;
                if abs(IMAGEANLZ.MaxContrastMax) < abs(IMAGEANLZ.MinContrastMin)
                    IMAGEANLZ.FullContrast = abs(IMAGEANLZ.MinContrastMin);
                else
                    IMAGEANLZ.FullContrast = abs(IMAGEANLZ.MaxContrastMax);
                end
                IMAGEANLZ.FIGOBJS.ContrastMax.Min = IMAGEANLZ.MinContrastMin/IMAGEANLZ.FullContrast;
                IMAGEANLZ.FIGOBJS.ContrastMin.Min = IMAGEANLZ.MinContrastMin/IMAGEANLZ.FullContrast;
                IMAGEANLZ.RelContrast(1) = IMAGEANLZ.MinContrastCurrent/IMAGEANLZ.FullContrast;
                IMAGEANLZ.RelContrast(2) = IMAGEANLZ.MaxContrastCurrent/IMAGEANLZ.FullContrast;
                if(IMAGEANLZ.RelContrast(2) <= IMAGEANLZ.RelContrast(1))
                    IMAGEANLZ.RelContrast(2) = IMAGEANLZ.RelContrast(1)+0.01;
                end
                IMAGEANLZ.MaxContrastCurrent = IMAGEANLZ.RelContrast(2)*IMAGEANLZ.FullContrast;
                IMAGEANLZ.FIGOBJS.CMaxVal.String = IMAGEANLZ.MaxContrastCurrent;
                cmin = IMAGEANLZ.MinContrastCurrent;
            end
        end
        %IncreaseCMaxValTest
        function cmax = IncreaseCMaxValTest(IMAGEANLZ,mincmin)
            cmax = IMAGEANLZ.MaxContrastCurrent;
            if str2double(mincmin) > cmax
                if abs(IMAGEANLZ.MaxContrastMax) < abs(IMAGEANLZ.MinContrastMin)
                    IMAGEANLZ.FullContrast = abs(IMAGEANLZ.MinContrastMin);
                else
                    IMAGEANLZ.FullContrast = abs(IMAGEANLZ.MaxContrastMax);
                end
                IMAGEANLZ.FIGOBJS.ContrastMax.Min = IMAGEANLZ.MinContrastMin/IMAGEANLZ.FullContrast;
                IMAGEANLZ.FIGOBJS.ContrastMin.Min = IMAGEANLZ.MinContrastMin/IMAGEANLZ.FullContrast;
                IMAGEANLZ.RelContrast(1) = IMAGEANLZ.MinContrastCurrent/IMAGEANLZ.FullContrast;
                IMAGEANLZ.RelContrast(2) = IMAGEANLZ.MaxContrastCurrent/IMAGEANLZ.FullContrast;
                if(IMAGEANLZ.RelContrast(2) <= IMAGEANLZ.RelContrast(1))
                    IMAGEANLZ.RelContrast(2) = IMAGEANLZ.RelContrast(1)+0.01;
                end
                IMAGEANLZ.MaxContrastCurrent = IMAGEANLZ.RelContrast(2)*IMAGEANLZ.FullContrast;
                IMAGEANLZ.FIGOBJS.CMaxVal.String = IMAGEANLZ.MaxContrastCurrent;
                cmax = IMAGEANLZ.MaxContrastCurrent;
            end
        end
        %MaxContrastMaxUpdate
        function MaxContrastMaxUpdate(IMAGEANLZ,maxcmax)
            IMAGEANLZ.MaxContrastMax = maxcmax;
            if abs(IMAGEANLZ.MaxContrastMax) < abs(IMAGEANLZ.MinContrastMin)
                IMAGEANLZ.FullContrast = abs(IMAGEANLZ.MinContrastMin);
            else
                IMAGEANLZ.FullContrast = abs(IMAGEANLZ.MaxContrastMax);
            end
            IMAGEANLZ.FIGOBJS.ContrastMax.Min = IMAGEANLZ.MinContrastMin/IMAGEANLZ.FullContrast;
            IMAGEANLZ.FIGOBJS.ContrastMin.Min = IMAGEANLZ.MinContrastMin/IMAGEANLZ.FullContrast;
            if(IMAGEANLZ.RelContrast(2) <= IMAGEANLZ.RelContrast(1))
                IMAGEANLZ.RelContrast(2) = IMAGEANLZ.RelContrast(1)+0.01;
            end
        end
        %MinContrastMinUpdate
        function MinContrastMinUpdate(IMAGEANLZ,mincmin)
            IMAGEANLZ.MinContrastMin = mincmin;
            if abs(IMAGEANLZ.MaxContrastMax) < abs(IMAGEANLZ.MinContrastMin)
                IMAGEANLZ.FullContrast = abs(IMAGEANLZ.MinContrastMin);
            else
                IMAGEANLZ.FullContrast = abs(IMAGEANLZ.MaxContrastMax);
            end
            IMAGEANLZ.FIGOBJS.ContrastMax.Min = IMAGEANLZ.MinContrastMin/IMAGEANLZ.FullContrast;
            IMAGEANLZ.FIGOBJS.ContrastMin.Min = IMAGEANLZ.MinContrastMin/IMAGEANLZ.FullContrast;
            IMAGEANLZ.RelContrast(1) = IMAGEANLZ.MinContrastCurrent/IMAGEANLZ.FullContrast;
            IMAGEANLZ.RelContrast(2) = IMAGEANLZ.MaxContrastCurrent/IMAGEANLZ.FullContrast;
            if(IMAGEANLZ.RelContrast(2) <= IMAGEANLZ.RelContrast(1))
                IMAGEANLZ.RelContrast(2) = IMAGEANLZ.RelContrast(1)+0.01;
            end
        end
        % GetContrastLimit
        function clim = GetContrastLimit(IMAGEANLZ)
            if isempty(IMAGEANLZ.FullContrast)
                clim = IMAGEANLZ.RelContrast;                       % no image loaded
            else
                clim = IMAGEANLZ.RelContrast*IMAGEANLZ.FullContrast;
            end
        end
        % ChangeMaxContrastVal
        function ChangeMaxContrastVal(IMAGEANLZ,cmax)
            IMAGEANLZ.MaxContrastCurrent = cmax;
            IMAGEANLZ.RelContrast(1) = IMAGEANLZ.MinContrastCurrent/IMAGEANLZ.FullContrast;
            IMAGEANLZ.RelContrast(2) = IMAGEANLZ.MaxContrastCurrent/IMAGEANLZ.FullContrast;
            if(IMAGEANLZ.RelContrast(2) <= IMAGEANLZ.RelContrast(1))
                IMAGEANLZ.RelContrast(2) = IMAGEANLZ.RelContrast(1)+0.01;
            end
            IMAGEANLZ.SetContrast;
        end
        % ChangeMaxOverlayVal
        function ChangeMaxOverlayVal(IMAGEANLZ,overlaynum,cmax)
            IMAGEANLZ.OFullContrast(overlaynum) = cmax;
            IMAGEANLZ.OMaxContrastCurrent(overlaynum) = cmax;
            IMAGEANLZ.ORelContrast(1,overlaynum) = IMAGEANLZ.OMinContrastCurrent(overlaynum)/IMAGEANLZ.OFullContrast(overlaynum);
            IMAGEANLZ.ORelContrast(2,overlaynum) = IMAGEANLZ.OMaxContrastCurrent(overlaynum)/IMAGEANLZ.OFullContrast(overlaynum);
            if(IMAGEANLZ.ORelContrast(2,overlaynum) <= IMAGEANLZ.ORelContrast(1,overlaynum))
                IMAGEANLZ.ORelContrast(2,overlaynum) = IMAGEANLZ.ORelContrast(1,overlaynum)+0.01;
            end
            IMAGEANLZ.PlotImage;
        end
        % ChangeMinOverlayVal
        function ChangeMinOverlayVal(IMAGEANLZ,overlaynum,cmin)
            IMAGEANLZ.OMinContrastCurrent(overlaynum) = cmin;
            IMAGEANLZ.ORelContrast(1,overlaynum) = IMAGEANLZ.OMinContrastCurrent(overlaynum)/IMAGEANLZ.OFullContrast(overlaynum);
            IMAGEANLZ.ORelContrast(2,overlaynum) = IMAGEANLZ.OMaxContrastCurrent(overlaynum)/IMAGEANLZ.OFullContrast(overlaynum);
            if(IMAGEANLZ.ORelContrast(2,overlaynum) <= IMAGEANLZ.ORelContrast(1,overlaynum))
                IMAGEANLZ.ORelContrast(2,overlaynum) = IMAGEANLZ.ORelContrast(1,overlaynum)+0.01;
            end
            IMAGEANLZ.PlotImage;
        end
        % ChangeMinContrastVal
        function ChangeMinContrastVal(IMAGEANLZ,cmax)
            IMAGEANLZ.MinContrastCurrent = cmax;
            IMAGEANLZ.RelContrast(1) = IMAGEANLZ.MinContrastCurrent/IMAGEANLZ.FullContrast;
            IMAGEANLZ.RelContrast(2) = IMAGEANLZ.MaxContrastCurrent/IMAGEANLZ.FullContrast;
            if(IMAGEANLZ.RelContrast(2) <= IMAGEANLZ.RelContrast(1))
                IMAGEANLZ.RelContrast(2) = IMAGEANLZ.RelContrast(1)+0.01;
            end
            IMAGEANLZ.SetContrast;
        end
        % ChangeMaxContrastRel
        function ChangeMaxContrastRel(IMAGEANLZ,relcmax)
            IMAGEANLZ.RelContrast(2) = relcmax;
            if(IMAGEANLZ.RelContrast(2) <= IMAGEANLZ.RelContrast(1))
                IMAGEANLZ.RelContrast(2) = IMAGEANLZ.RelContrast(1)+0.01;
            end
            IMAGEANLZ.FIGOBJS.ContrastMax.Value = relcmax;
            IMAGEANLZ.FIGOBJS.CMaxVal.String = num2str(IMAGEANLZ.RelContrast(2)*IMAGEANLZ.FullContrast,6);
            IMAGEANLZ.MaxContrastCurrent = IMAGEANLZ.RelContrast(2)*IMAGEANLZ.FullContrast;
            IMAGEANLZ.SetContrast;
        end
        % ChangeMinContrastRel
        function ChangeMinContrastRel(IMAGEANLZ,relcmin)
            IMAGEANLZ.RelContrast(1) = relcmin;
            if(IMAGEANLZ.RelContrast(1) >= IMAGEANLZ.RelContrast(2))
                IMAGEANLZ.RelContrast(1) = IMAGEANLZ.RelContrast(2)-0.01;
            end
            IMAGEANLZ.FIGOBJS.ContrastMin.Value = relcmin;
            IMAGEANLZ.FIGOBJS.CMinVal.String = num2str(IMAGEANLZ.RelContrast(1)*IMAGEANLZ.FullContrast,6);
            IMAGEANLZ.MinContrastCurrent = IMAGEANLZ.RelContrast(1)*IMAGEANLZ.FullContrast;
            IMAGEANLZ.SetContrast;
        end
        % UpdateMaxContrastSlider
        function UpdateMaxContrastSlider(IMAGEANLZ)
            IMAGEANLZ.FIGOBJS.ContrastMax.Value = IMAGEANLZ.RelContrast(2);
        end  
        % UpdateMinContrastSlider
        function UpdateMinContrastSlider(IMAGEANLZ)
            IMAGEANLZ.FIGOBJS.ContrastMin.Value = IMAGEANLZ.RelContrast(1);
        end 
        % ChangeImType
        function ChangeImType(IMAGEANLZ,imtype)
            IMAGEANLZ.ImType = imtype;
            IMAGEANLZ.LoadContrast;
            IMAGEANLZ.imvol = IMAGEANLZ.GetCurrent3DImage;
        end
        % ResetImType
        function ResetImType(IMAGEANLZ)
            IMAGEANLZ.ImType = IMAGEANLZ.FIGOBJS.ImType.String{IMAGEANLZ.FIGOBJS.ImType.Value};
        end
        % ResetImTypeSpecify
        function ResetImTypeSpecify(IMAGEANLZ,ImTypeIn)
            IMAGEANLZ.ImType = ImTypeIn;
        end
        % GetImType
        function ImTypeOut = GetImType(IMAGEANLZ)
            ImTypeOut = IMAGEANLZ.FIGOBJS.ImType.String{IMAGEANLZ.FIGOBJS.ImType.Value};
        end        
        % InitializeContrast
        function ContrastSettings = InitializeContrast(IMAGEANLZ)
            ImAnlz_InitializeContrast(IMAGEANLZ);
            ContrastSettings = IMAGEANLZ.ContrastSettings;
        end
        % OverlayInitializeContrast
        function ContrastSettings = OverlayInitializeContrast(IMAGEANLZ,overlaynum)
            ImAnlz_OverlayInitializeContrast(IMAGEANLZ,overlaynum);
            ContrastSettings = IMAGEANLZ.OContrastSettings{overlaynum};
        end
        % InitializeContrastSpecify
        function InitializeContrastSpecify(IMAGEANLZ,ContrastSettings)
            if strcmp(ContrastSettings.Colour,'Yes')
                IMAGEANLZ.FIGOBJS.ImColour.Value = 2;
                colormap(IMAGEANLZ.FIGOBJS.ImAxes,IMAGEANLZ.FIGOBJS.Options.ColorMap);
            else
                IMAGEANLZ.FIGOBJS.ImColour.Value = 1;
                colormap(IMAGEANLZ.FIGOBJS.ImAxes,IMAGEANLZ.FIGOBJS.Options.GrayMap);
            end
            IMAGEANLZ.ImType = ContrastSettings.ImType; 
            IMAGEANLZ.ContrastSettings = ContrastSettings;
        end
        % OverlayInitializeContrastSpecify
        function OverlayInitializeContrastSpecify(IMAGEANLZ,OContrastSettings,overlaynum)
            IMAGEANLZ.OverlayColour{overlaynum} = OContrastSettings.Colour;
            IMAGEANLZ.OImType{overlaynum} = OContrastSettings.Type;
            IMAGEANLZ.OContrastSettings{overlaynum} = OContrastSettings;
        end
        % DefaultContrast
        function DefaultContrast(IMAGEANLZ)
            ImAnlz_DefaultContrast(IMAGEANLZ);
        end
        % LoadContrast
        function LoadContrast(IMAGEANLZ)
            IMAGEANLZ.FIGOBJS.MinCMinVal.ForegroundColor = [0.8 0.8 0.8];
            IMAGEANLZ.FIGOBJS.MaxCMaxVal.ForegroundColor = [0.8 0.8 0.8];
            IMAGEANLZ.FIGOBJS.CMinVal.ForegroundColor = [0.8 0.8 0.8];
            IMAGEANLZ.FIGOBJS.CMaxVal.ForegroundColor = [0.8 0.8 0.8];
            ImAnlz_UpdateContrastTypeChange(IMAGEANLZ); 
            if abs(IMAGEANLZ.MaxContrastMax) < abs(IMAGEANLZ.MinContrastMin)
                IMAGEANLZ.FullContrast = abs(IMAGEANLZ.MinContrastMin);
            else
                IMAGEANLZ.FullContrast = abs(IMAGEANLZ.MaxContrastMax);
            end
            IMAGEANLZ.FIGOBJS.ContrastMax.Min = IMAGEANLZ.MinContrastMin/IMAGEANLZ.FullContrast;
            IMAGEANLZ.FIGOBJS.ContrastMin.Min = IMAGEANLZ.MinContrastMin/IMAGEANLZ.FullContrast;
            IMAGEANLZ.RelContrast(1) = IMAGEANLZ.MinContrastCurrent/IMAGEANLZ.FullContrast;
            IMAGEANLZ.RelContrast(2) = IMAGEANLZ.MaxContrastCurrent/IMAGEANLZ.FullContrast;
            IMAGEANLZ.FIGOBJS.ContrastMin.Value = IMAGEANLZ.RelContrast(1);
            IMAGEANLZ.FIGOBJS.ContrastMax.Value = IMAGEANLZ.RelContrast(2);
            IMAGEANLZ.FIGOBJS.CMaxVal.String = num2str(IMAGEANLZ.MaxContrastCurrent,6);
            IMAGEANLZ.FIGOBJS.CMinVal.String = num2str(IMAGEANLZ.MinContrastCurrent,6);
            IMAGEANLZ.FIGOBJS.MaxCMaxVal.String = num2str(IMAGEANLZ.MaxContrastMax,6);
            IMAGEANLZ.FIGOBJS.MinCMinVal.String = num2str(IMAGEANLZ.MinContrastMin,6);
            IMAGEANLZ.FIGOBJS.EnableContrast;
            IMAGEANLZ.SetContrast;
        end
        % OverlayLoadContrast
        function OverlayLoadContrast(IMAGEANLZ,overlaynum)
            ImAnlz_OverlayUpdateContrastTypeChange(IMAGEANLZ,overlaynum);
            n = overlaynum;
            if abs(IMAGEANLZ.OMaxContrastMax(n)) < abs(IMAGEANLZ.OMinContrastMin(n))
                IMAGEANLZ.OFullContrast(n) = abs(IMAGEANLZ.OMinContrastMin(n));
            else
                IMAGEANLZ.OFullContrast(n) = abs(IMAGEANLZ.OMaxContrastMax(n));
            end
            IMAGEANLZ.ORelContrast(1,n) = IMAGEANLZ.OMinContrastCurrent(n)/IMAGEANLZ.OFullContrast(n);
            IMAGEANLZ.ORelContrast(2,n) = IMAGEANLZ.OMaxContrastCurrent(n)/IMAGEANLZ.OFullContrast(n);
            if IMAGEANLZ.colouroverlay(n)
                IMAGEANLZ.FIGOBJS.DisplayOverlayContrast([0,1],n);
            else
                IMAGEANLZ.FIGOBJS.DisplayOverlayContrast(IMAGEANLZ.ORelContrast(:,n)*IMAGEANLZ.OFullContrast(n),n);
            end
        end
        % SaveContrast
        function SaveContrast(IMAGEANLZ)
            ImAnlz_SaveContrast(IMAGEANLZ);
        end
        % OverlaySaveContrast
        function OverlaySaveContrast(IMAGEANLZ,overlaynum)
            ImAnlz_OverlaySaveContrast(IMAGEANLZ,overlaynum);
        end
        % ReturnContrast
        function ContrastSettings = ReturnContrast(IMAGEANLZ)
            ContrastSettings = IMAGEANLZ.ContrastSettings;
        end

%==================================================================
% Overlay
%==================================================================              
        % ToggleOverlayColour
        function ToggleOverlayColour(IMAGEANLZ,overlaynum,usecolour)
            if ~IMAGEANLZ.colouroverlay(overlaynum)
                IMAGEANLZ.OverlayColour{overlaynum} = usecolour;
                if IMAGEANLZ.loadedoverlay(overlaynum)
                    delete(IMAGEANLZ.OverlayObject(overlaynum));
                    if strcmp(IMAGEANLZ.OverlayColour{overlaynum},'Yes')
                        cmap = IMAGEANLZ.FIGOBJS.Options.ColorMap;
                    else
                        cmap = IMAGEANLZ.FIGOBJS.Options.GrayMap; 
                    end
                    L = length(cmap);
                    clim = IMAGEANLZ.ORelContrast(:,overlaynum)*IMAGEANLZ.OFullContrast(overlaynum);
                    tImg = L*(IMAGEANLZ.overimslice{overlaynum}-clim(1))/(clim(2)-clim(1));
                    CImg = zeros([size(IMAGEANLZ.overimslice{overlaynum}) 3]);
                    CImg(:,:,1) = interp1((1:L),cmap(:,1),tImg);
                    CImg(:,:,2) = interp1((1:L),cmap(:,2),tImg);
                    CImg(:,:,3) = interp1((1:L),cmap(:,3),tImg);                              
                    ho = image('CData',CImg,'Parent',IMAGEANLZ.FIGOBJS.ImAxes);
                    ho.BusyAction = 'cancel';
                    ho.Interruptible = 'off';
                    ho.CDataMapping = 'scaled';
                    ho.PickableParts = 'none';
                    ho.HitTest = 'off';
                    ho.AlphaData = IMAGEANLZ.OverlayTransparency(overlaynum)*IMAGEANLZ.overimslicealpha{overlaynum};
                    IMAGEANLZ.OverlayObject(overlaynum) = ho;
                end
            end
        end
        % SetOverlayTransparency
        function SetOverlayTransparency(IMAGEANLZ,overlaynum,transparency)
            IMAGEANLZ.OverlayTransparency(overlaynum) = transparency;
            if IMAGEANLZ.loadedoverlay(overlaynum)
                IMAGEANLZ.OverlayObject(overlaynum).AlphaData = IMAGEANLZ.OverlayTransparency(overlaynum)*IMAGEANLZ.overimslicealpha{overlaynum};
            end
        end 
        % SetOverlaySlider
        function SetOverlaySlider(IMAGEANLZ,overlaynum,transparency)
            IMAGEANLZ.FIGOBJS.SetOverlayTransparency(transparency,overlaynum);
        end  
        % DeleteOverlay
        function DeleteOverlay(IMAGEANLZ,overlaynum)
            if IMAGEANLZ.loadedoverlay(overlaynum)
                delete(IMAGEANLZ.OverlayObject(overlaynum));
                IMAGEANLZ.overtotgblnum(overlaynum) = 0;
                IMAGEANLZ.OverlayObject(overlaynum) = gobjects(1);
                IMAGEANLZ.loadedoverlay(overlaynum) = 0;
                IMAGEANLZ.FIGOBJS.DeleteOverlayName(overlaynum);
                IMAGEANLZ.OverlayTransparency(overlaynum) = 0.5;
                IMAGEANLZ.FIGOBJS.SetOverlayTransparency(0.5,overlaynum);
                IMAGEANLZ.FIGOBJS.SetOverlayMax(1,overlaynum);
                IMAGEANLZ.FIGOBJS.SetOverlayMin(0,overlaynum);
                IMAGEANLZ.OverlayColour{overlaynum} = 'Yes';
                IMAGEANLZ.FIGOBJS.SetOverlayColour(overlaynum);
                IMAGEANLZ.overimvol = cell(1,4);
                IMAGEANLZ.OverlayDim4(overlaynum) = 1;
            end
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
            if IMAGEANLZ.redrawroi == 1
                maskslice = IMAGEANLZ.REDRAWROI.roimask(:,:,IMAGEANLZ.SLICE);
                val = maskslice(round(y),round(x));
                z = IMAGEANLZ.SLICE;
                datapoint = [x,y,z,val];
                OUT = IMAGEANLZ.TEMPROI.BuildROI(datapoint,event,maskslice);
            else
                val = IMAGEANLZ.imslice(round(y),round(x));
                z = IMAGEANLZ.SLICE;
                datapoint = [x,y,z,val];
                OUT = IMAGEANLZ.TEMPROI.BuildROI(datapoint,event,IMAGEANLZ.imslice);
            end
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
        % TestEmptyCurrentROI
        function bool = TestEmptyCurrentROI(IMAGEANLZ)
            bool = 0;
            if isempty(IMAGEANLZ.CURRENTROI)
                bool = 1;
            else
                if isempty(IMAGEANLZ.CURRENTROI.roimask) 
                    bool = 1;
                end
            end
        end
        % TestDeletedCurrentROI
        function bool = TestDeletedCurrentROI(IMAGEANLZ)
            bool = 0;
            if isempty(IMAGEANLZ.CURRENTROI)
                bool = 1;
            end
        end        % DrawTempROI
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
                IMAGEANLZ.TEMPROI.ShadeROI(IMAGEANLZ,axhand,IMAGEANLZ.temproiclr,IMAGEANLZ.shaderoivalue);
            end
        end
        % UpdateTempROI
        function UpdateTempROI(IMAGEANLZ,OUT)
            IMAGEANLZ.TEMPROI.ResetLocArr;
            IMAGEANLZ.TEMPROI.BuildLocArr(OUT.xloc,OUT.yloc,OUT.zloc,IMAGEANLZ.roievent,IMAGEANLZ.ORIENT);
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
            IMAGEANLZ.CURRENTROI.Concatenate(TEMPROI,IMAGEANLZ.roievent,IMAGEANLZ.ORIENT);
            if IMAGEANLZ.shaderoi || IMAGEANLZ.autoupdateroi
                IMAGEANLZ.CURRENTROI.AddROIMask;
            end
        end
        % Add2CurrentROIOrtho
        function Add2CurrentROIOrtho(IMAGEANLZ,TEMPROI,DrawOrient)
            IMAGEANLZ.CURRENTROI.Concatenate(TEMPROI,IMAGEANLZ.roievent,DrawOrient);
%             if IMAGEANLZ.shaderoi || IMAGEANLZ.autoupdateroi      % move below
%                 IMAGEANLZ.CURRENTROI.AddROIMask;
%             end
        end
        % Add2CurrentROIMask
        function Add2CurrentROIMask(IMAGEANLZ)
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
            if IMAGEANLZ.redrawroi
                IMAGEANLZ.REDRAWROI.ShadeROI(IMAGEANLZ,axhand,[0 0.3 0.8],IMAGEANLZ.shaderoivalue);
            end
            if isempty(IMAGEANLZ.CURRENTROI) 
                return
            end
            if isempty(IMAGEANLZ.CURRENTROI.xlocarr) && isempty(IMAGEANLZ.CURRENTROI.roimask)
                return
            end
            if IMAGEANLZ.linesroi
                %if strcmp(IMAGEANLZ.ORIENT,IMAGEANLZ.CURRENTROI.drawroiorient)
                    IMAGEANLZ.CURRENTROI.DrawROI(IMAGEANLZ,axhand,[1 0 0],0);
                %end
            end
            if IMAGEANLZ.shaderoi
                IMAGEANLZ.CURRENTROI.ShadeROI(IMAGEANLZ,axhand,[1 0 0],IMAGEANLZ.shaderoivalue);
            end
        end
        % DrawCurrentROILines
        function DrawCurrentROILines(IMAGEANLZ,axhand)
            if isempty(IMAGEANLZ.CURRENTROI) 
                return
            end
            if isempty(IMAGEANLZ.CURRENTROI.xlocarr) && isempty(IMAGEANLZ.CURRENTROI.roimask)
                return
            end
            if IMAGEANLZ.linesroi
                %if strcmp(IMAGEANLZ.ORIENT,IMAGEANLZ.CURRENTROI.drawroiorient)
                    IMAGEANLZ.CURRENTROI.DrawROI(IMAGEANLZ,axhand,[1 0 0],0);
                %end
            end
        end
        % DrawCurrentROIShade
        function DrawCurrentROIShade(IMAGEANLZ,axhand)
            if isempty(IMAGEANLZ.CURRENTROI) 
                return
            end
            if isempty(IMAGEANLZ.CURRENTROI.xlocarr) && isempty(IMAGEANLZ.CURRENTROI.roimask)
                return
            end
            if IMAGEANLZ.shaderoi
                IMAGEANLZ.CURRENTROI.ShadeROI(IMAGEANLZ,axhand,[1 0 0],IMAGEANLZ.shaderoivalue);
            end
        end
        % CompleteCurrentROI
        function CompleteCurrentROI(IMAGEANLZ,roi,roiname)
            IMAGEANLZ.ActivateROI(roi);
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
                if IMAGEANLZ.ROISOFINTEREST(n)
                    if IMAGEANLZ.linesroi
                        if strcmp(IMAGEANLZ.ORIENT,IMAGEANLZ.SAVEDROIS(n).drawroiorient)
                            IMAGEANLZ.SAVEDROIS(n).DrawROI(IMAGEANLZ,axhand,IMAGEANLZ.COLORORDER{n},1);
                        end
                    end
                    if IMAGEANLZ.shaderoi
                        IMAGEANLZ.SAVEDROIS(n).ShadeROI(IMAGEANLZ,axhand,IMAGEANLZ.COLORORDER{n},IMAGEANLZ.shaderoivalue);
                    end
                end
            end
        end
        % ChangeShadeSavedROIs
        function ChangeShadeSavedROIs(IMAGEANLZ)
            if isempty(IMAGEANLZ.SAVEDROIS)
                return
            end
            for n = 1:length(IMAGEANLZ.SAVEDROIS)
                if IMAGEANLZ.ROISOFINTEREST(n)
                    if IMAGEANLZ.shaderoi
                        IMAGEANLZ.SAVEDROIS(n).ChangeShadeAlpha(IMAGEANLZ.shaderoivalue);
                    end
                end
            end
        end  
        % ChangeShadeCurrentROI
        function ChangeShadeCurrentROI(IMAGEANLZ)
            IMAGEANLZ.CURRENTROI.ChangeShadeAlpha(IMAGEANLZ.shaderoivalue);
        end 
        % DrawSavedROIsNoPick
        function DrawSavedROIsNoPick(IMAGEANLZ,axhand)
            if isempty(IMAGEANLZ.SAVEDROIS)
                return
            end
            for n = 1:length(IMAGEANLZ.SAVEDROIS)
                if IMAGEANLZ.ROISOFINTEREST(n)
                    if IMAGEANLZ.linesroi
                        if strcmp(IMAGEANLZ.ORIENT,IMAGEANLZ.SAVEDROIS(n).drawroiorient)
                            IMAGEANLZ.SAVEDROIS(n).DrawROI(IMAGEANLZ,axhand,IMAGEANLZ.COLORORDER{n},0);
                        end
                    end
                    if IMAGEANLZ.shaderoi
                        IMAGEANLZ.SAVEDROIS(n).ShadeROI(IMAGEANLZ,axhand,IMAGEANLZ.COLORORDER{n},IMAGEANLZ.shaderoivalue);
                    end
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
%             if IMAGEANLZ.autoupdateroi || IMAGEANLZ.shaderoi                      % should be no need to do this (very slow)         
%                 IMAGEANLZ.CURRENTROI.CreateBaseROIMask;
%             end
            if IMAGEANLZ.shaderoi 
                IMAGEANLZ.CURRENTROI.ShadeROI(IMAGEANLZ,[],'r',IMAGEANLZ.shaderoivalue);
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
        % ShadeROIChangeSlider
        function ShadeROIChangeSlider(IMAGEANLZ,val)
            IMAGEANLZ.FIGOBJS.ShadeROIValue.Value = val;
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
        % SetROIEvent
        function SetROIEvent(IMAGEANLZ,Event)
            IMAGEANLZ.roievent = Event;
        end
        % ActivateROI
        function ActivateROI(IMAGEANLZ,roinum)
            IMAGEANLZ.ROISOFINTEREST(roinum) = 1;
            IMAGEANLZ.HighlightROI(roinum);
        end
        % DeactivateROI
        function DeactivateROI(IMAGEANLZ,roinum)
            IMAGEANLZ.ROISOFINTEREST(roinum) = 0;
            IMAGEANLZ.UnHighlightROI(roinum);
        end
        % DeactivateAllROIs
        function DeactivateAllROIs(IMAGEANLZ)
            len = length(IMAGEANLZ.ROISOFINTEREST);
            for n = 1:len
                IMAGEANLZ.ROISOFINTEREST(n) = 0;
                IMAGEANLZ.UnHighlightROI(n);
            end
        end
        % TestActiveROIs
        function roisofinterest = TestActiveROIs(IMAGEANLZ)
            roisofinterest = IMAGEANLZ.ROISOFINTEREST;
        end
        % FindNextAvailableROI
        function roinum = FindNextAvailableROI(IMAGEANLZ)
            roinum = length(IMAGEANLZ.SAVEDROIS)+1;
        end
        % TestMaskOnlyROI
        function bool = TestMaskOnlyCurrentROI(IMAGEANLZ)
            bool = 0;
            if isempty(IMAGEANLZ.CURRENTROI.xlocarr)
                bool = 1;
            end
        end
        % InitiateRedrawROI
        function InitiateRedrawROI(IMAGEANLZ)
            IMAGEANLZ.redrawroi = 1;
            IMAGEANLZ.roievent = 'Add';
            IMAGEANLZ.REDRAWROI = ImageRoiClass(IMAGEANLZ);
            IMAGEANLZ.REDRAWROI.CopyRoiInfo(IMAGEANLZ.CURRENTROI);
            IMAGEANLZ.CURRENTROI = ImageRoiClass(IMAGEANLZ);
            IMAGEANLZ.TEMPROI = ImageRoiClass(IMAGEANLZ);
            IMAGEANLZ.TEMPROI.AddNewRegion(IMAGEANLZ.ROISEED);
            IMAGEANLZ.TEMPROI.CREATEMETHOD{1}.RedrawSetup;
            IMAGEANLZ.buttonfunction = 'CreateROI';
            IMAGEANLZ.movefunction = '';
            IMAGEANLZ.pointer = IMAGEANLZ.TEMPROI.GetPointer;
            IMAGEANLZ.FIGOBJS.MakeCurrentVisible;
            Status(1).state = 'busy';
            Status(1).string = 'Redraw ROI';       
            Status(2).state = 'busy';  
            Status(2).string = IMAGEANLZ.TEMPROI.GetStatus;   
            Status(3).state = 'info';  
            Status(3).string = IMAGEANLZ.TEMPROI.GetInfo;        
            IMAGEANLZ.STATUS.SetStatus(Status)                    
        end
        
%==================================================================
% Line
%==================================================================
        % NewLineCreateOrtho
        function NewLineCreateOrtho(IMAGEANLZ)
            ImAnlz_NewLineCreateOrtho(IMAGEANLZ);
        end
        % NewLineCreateOrthoRoi
        function NewLineCreateOrthoRoi(IMAGEANLZ,datapoint)
            IMAGEANLZ.CURRENTLINE = ImageLineClass(IMAGEANLZ);
            IMAGEANLZ.CURRENTLINE.AssignDataPoint(datapoint);
            IMAGEANLZ.SetMoveFunction('DrawLine'); 
        end
        % BuildLine
        function OUT = BuildLine(IMAGEANLZ,x,y,event)
%             Data.xpt = round(x);
%             Data.ypt = round(y);
            Data.xpt = x;
            Data.ypt = y;
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
%             Data.xpt = round(x);
%             Data.ypt = round(y);
            Data.xpt = x;
            Data.ypt = y;
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
            IMAGEANLZ.GETLINE = 0;
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
            if IMAGEANLZ.colourimage
                Data.val = squeeze(IMAGEANLZ.imslice(round(y),round(x),:));
            else
                Data.val = IMAGEANLZ.imslice(round(y),round(x));
            end
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
        % GetCurrentPointDataOverlay
        function Data = GetCurrentPointDataOverlay(IMAGEANLZ,overlaynum,x,y)        
            if IMAGEANLZ.colouroverlay(overlaynum)
                Data.val = squeeze(IMAGEANLZ.overimslice{overlaynum}(round(y),round(x),:));
            else
                Data.val = IMAGEANLZ.overimslice{overlaynum}(round(y),round(x));
            end
        end
        % SetCurrentPointInfoOrtho
        function SetCurrentPointInfoOrtho(IMAGEANLZ,Data)
            if length(Data.val) > 1
                IMAGEANLZ.FIGOBJS.CURVAL.String = [num2str(Data.val(1),'%3.2f'),',',num2str(Data.val(2),'%3.2f'),',',num2str(Data.val(3),'%3.2f')];
            else
                switch IMAGEANLZ.ImType
                    case 'abs'
                        if abs(Data.val) < 0.01
                            num = num2str(Data.val,3);
                        else
                            num = num2str(Data.val,4);
                        end
                    case 'real'
                        if abs(real(Data.val)) < 0.01
                            num = num2str(Data.val,3);
                        else
                            num = num2str(Data.val,4);
                        end
                    case 'imag'
                        if abs(imag(Data.val)) < 0.01
                            num = num2str(Data.val,3);
                        else
                            num = num2str(Data.val,4);
                        end
                    case 'phase'
                        num = num2str(Data.val,4);
                    case 'map'
                        if abs(Data.val) < 0.01
                            num = num2str(Data.val,3);
                        else
                            num = num2str(Data.val,4);
                        end
                end
                IMAGEANLZ.FIGOBJS.CURVAL.String = num;
            end
            IMAGEANLZ.FIGOBJS.X.String = num2str(Data.loc(1),'%3.1f');
            IMAGEANLZ.FIGOBJS.Y.String = num2str(Data.loc(2),'%3.1f');
            IMAGEANLZ.FIGOBJS.Z.String = num2str(Data.loc(3),'%3.1f');
            IMAGEANLZ.FIGOBJS.XPix.String = num2str(Data.point(1),'%3.0f');
            IMAGEANLZ.FIGOBJS.YPix.String = num2str(Data.point(2),'%3.0f');
            IMAGEANLZ.FIGOBJS.ZPix.String = num2str(Data.point(3),'%3.0f');
        end
        % SetCurrentPointInfoOrthoOverlay
        function SetCurrentPointInfoOrthoOverlay(IMAGEANLZ,overlaynum,Data)
            if length(Data.val) > 1
                IMAGEANLZ.FIGOBJS.SetOverlayValue(overlaynum,[num2str(Data.val(1),'%3.2f'),',',num2str(Data.val(2),'%3.2f'),',',num2str(Data.val(3),'%3.2f')]);
            else
                switch IMAGEANLZ.OImType{overlaynum}
                    case 'abs'
                        if abs(Data.val) < 0.01
                            num = num2str(Data.val,3);
                        else
                            num = num2str(Data.val,4);
                        end
                    case 'real'
                        if abs(real(Data.val)) < 0.01
                            num = num2str(Data.val,3);
                        else
                            num = num2str(Data.val,4);
                        end
                    case 'imag'
                        if abs(imag(Data.val)) < 0.01
                            num = num2str(Data.val,3);
                        else
                            num = num2str(Data.val,4);
                        end
                    case 'phase'
                        num = num2str(Data.val,4);
                    case 'map'
                        if abs(Data.val) < 0.01
                            num = num2str(Data.val,3);
                        else
                            num = num2str(Data.val,4);
                        end
                end
                IMAGEANLZ.FIGOBJS.SetOverlayValue(overlaynum,num);
            end
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
        % ClearCurrentPointInfoOrthoOverlay
        function ClearCurrentPointInfoOrthoOverlay(IMAGEANLZ,overlaynum)  
            IMAGEANLZ.FIGOBJS.ClearOverlayValue(overlaynum);
        end
        
%==================================================================
% Image
%==================================================================
        % SetImage        
        function SetImage(IMAGEANLZ)
            IMAGEANLZ.imvol = GetCurrent3DImage(IMAGEANLZ);
%             if not(isempty(IMAGEANLZ.overtotgblnum))
%                 IMAGEANLZ.overimvol = GetCurrent3DImageOverlay(IMAGEANLZ);
%                 IMAGEANLZ.overimvolalpha = ones(size(IMAGEANLZ.overimvol));
%                 IMAGEANLZ.overimvolalpha(IMAGEANLZ.overimvol == 0) = 0;
%             end
        end
        % SetOverlay       
        function SetOverlay(IMAGEANLZ,overlaynum)
            IMAGEANLZ.overimvol{overlaynum} = GetCurrent3DImageOverlay(IMAGEANLZ,overlaynum);
            IMAGEANLZ.overimvolalpha{overlaynum} = ones(size(IMAGEANLZ.overimvol{overlaynum}));
            IMAGEANLZ.overimvolalpha{overlaynum}(IMAGEANLZ.overimvol{overlaynum} == 0) = 0;
        end
        % SetActiveOverlays       
        function SetActiveOverlays(IMAGEANLZ)
            for n = 1:4
                if IMAGEANLZ.TestForOverlay(n)
                    IMAGEANLZ.SetOverlay(n);
                end
            end
        end        
        % SetImageSlice        
        function SetImageSlice(IMAGEANLZ)
            if IMAGEANLZ.colourimage
                IMAGEANLZ.imslice = squeeze(IMAGEANLZ.imvol(:,:,IMAGEANLZ.SLICE,:));                
            else
                IMAGEANLZ.imslice = IMAGEANLZ.imvol(:,:,IMAGEANLZ.SLICE);
            end
            for n = 1:4
                if not(isempty(IMAGEANLZ.overimvol{n}))
                    if IMAGEANLZ.colouroverlay(n)
                        IMAGEANLZ.overimslice{n} = squeeze(IMAGEANLZ.overimvol{n}(:,:,IMAGEANLZ.SLICE,:));
                    else
                        IMAGEANLZ.overimslice{n} = IMAGEANLZ.overimvol{n}(:,:,IMAGEANLZ.SLICE);
                    end
                    IMAGEANLZ.overimslicealpha{n} = IMAGEANLZ.overimvolalpha{n}(:,:,IMAGEANLZ.SLICE);
                end
            end
        end
        % SetOverlaySlice        
        function SetOverlaySlice(IMAGEANLZ,overlaynum)
            if IMAGEANLZ.colouroverlay(overlaynum)
                IMAGEANLZ.overimslice{overlaynum} = squeeze(IMAGEANLZ.overimvol{overlaynum}(:,:,IMAGEANLZ.SLICE,:));
            else
                IMAGEANLZ.overimslice{overlaynum} = IMAGEANLZ.overimvol{overlaynum}(:,:,IMAGEANLZ.SLICE);
            end
            IMAGEANLZ.overimslicealpha{overlaynum} = IMAGEANLZ.overimvolalpha{overlaynum}(:,:,IMAGEANLZ.SLICE);
        end
        % GetCurrent3DImageComplex
        function Image = GetCurrent3DImageComplex(IMAGEANLZ)
            global TOTALGBL
            Image = TOTALGBL{2,IMAGEANLZ.totgblnum}.Im;
            Image = ImageOrient(IMAGEANLZ,Image);
            Image = Image(:,:,:,IMAGEANLZ.DIM4,IMAGEANLZ.DIM5,IMAGEANLZ.DIM6);
        end
        % GetCurrent3DImageComplexOverlay
        function Image = GetCurrent3DImageComplexOverlay(IMAGEANLZ,overlaynum)
            global TOTALGBL
            Image = TOTALGBL{2,IMAGEANLZ.overtotgblnum(overlaynum)}.Im;
            Image = ImageOrient(IMAGEANLZ,Image);
            Image = Image(:,:,:,1,1,1);                     % for now
        end
        % GetCurrent3DImage
        function Image = GetCurrent3DImage(IMAGEANLZ)
            global TOTALGBL
            Image = TOTALGBL{2,IMAGEANLZ.totgblnum}.Im;
            Image = ImageOrient(IMAGEANLZ,Image);
            if IMAGEANLZ.colourimage
                Image = Image(:,:,:,:,IMAGEANLZ.DIM5,IMAGEANLZ.DIM6);
                IMAGEANLZ.ImType = 'colour';
            else
                Image = Image(:,:,:,IMAGEANLZ.DIM4,IMAGEANLZ.DIM5,IMAGEANLZ.DIM6);
            end
            Image = ImageTypeCreate(IMAGEANLZ,Image);  
        end
        % GetCurrent3DImageOverlay
        function Image = GetCurrent3DImageOverlay(IMAGEANLZ,overlaynum)
            global TOTALGBL
            Image = TOTALGBL{2,IMAGEANLZ.overtotgblnum(overlaynum)}.Im;
            Image = ImageOrient(IMAGEANLZ,Image);
            if IMAGEANLZ.colouroverlay(overlaynum)
                %Image = Image;
            else 
                Image = Image(:,:,:,IMAGEANLZ.OverlayDim4(overlaynum));
            end
            if not(isreal(Image))
                Image = abs(Image);
            end
            Image(isnan(Image)) = 0;
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
            if strcmp(IMAGEANLZ.ImType,'abs')
                Image = abs(Image);
            elseif strcmp(IMAGEANLZ.ImType,'real')
                Image = real(Image);
            elseif strcmp(IMAGEANLZ.ImType,'imag')
                Image = imag(Image);
            elseif strcmp(IMAGEANLZ.ImType,'phase')
                Image = angle(Image);
            elseif strcmp(IMAGEANLZ.ImType,'phase90')
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
            IMAGEANLZ.ImageObject = h;                                      % just in case need it
            for n = 1:4
                if IMAGEANLZ.loadedoverlay(n)
                    if IMAGEANLZ.colouroverlay(n)
                        ho = image('CData',IMAGEANLZ.overimslice{n},'Parent',IMAGEANLZ.FIGOBJS.ImAxes);
                    else
                        if strcmp(IMAGEANLZ.OverlayColour{n},'Yes')
                            cmap = IMAGEANLZ.FIGOBJS.Options.ColorMap;
                        else
                            cmap = IMAGEANLZ.FIGOBJS.Options.GrayMap;
                        end
                        L = length(cmap);
                        clim = IMAGEANLZ.ORelContrast(:,n)*IMAGEANLZ.OFullContrast(n);
                        tImg = L*(IMAGEANLZ.overimslice{n}-clim(1))/(clim(2)-clim(1));
                        CImg = zeros([size(IMAGEANLZ.overimslice{n}) 3]);
                        CImg(:,:,1) = interp1((1:L),cmap(:,1),tImg);
                        CImg(:,:,2) = interp1((1:L),cmap(:,2),tImg);
                        CImg(:,:,3) = interp1((1:L),cmap(:,3),tImg);                   
                        ho = image('CData',CImg,'Parent',IMAGEANLZ.FIGOBJS.ImAxes);
                    end
                    ho.BusyAction = 'cancel';
                    ho.Interruptible = 'off';
                    ho.CDataMapping = 'scaled';
                    ho.PickableParts = 'none';
                    ho.HitTest = 'off';
                    ho.AlphaData = IMAGEANLZ.OverlayTransparency(n)*IMAGEANLZ.overimslicealpha{n};
                    IMAGEANLZ.OverlayObject(n) = ho;
                end
            end
            %drawnow;       % this makes 4th dimesion scrolling slow - not sure why here
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
        % UnTieDims
        function UnTieDims(IMAGEANLZ)
            IMAGEANLZ.DIMSTIE = 0;
            IMAGEANLZ.FIGOBJS.TieDims.Value = 0;
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
            %IMAGEANLZ.TieCursor(val);
            IMAGEANLZ.AllTie = val;
            IMAGEANLZ.FIGOBJS.TieAll.Value = val;
        end           
        % UnTieAll
        function UnTieAll(IMAGEANLZ)
            IMAGEANLZ.AllTie = 0;
            IMAGEANLZ.FIGOBJS.TieAll.Value = 0;
            IMAGEANLZ.TieSlice(0);
            IMAGEANLZ.TieZoom(0);
            IMAGEANLZ.TieDims(0);
            IMAGEANLZ.TieDatVals(0);
            IMAGEANLZ.TieRois(0);
            IMAGEANLZ.TieCursor(0);
        end 
        % TestAllTied
        function bool = TestAllTied(IMAGEANLZ)
            bool = IMAGEANLZ.AllTie;
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
        
%================================================================
%  
%================================================================

classdef ImageRoiClass < handle

    properties (SetAccess = private)                                                                             
        locnum;
        lastlocnumadded;
        xloc0arr;                      
        yloc0arr;                      
        zloc0arr;
        roiname;
        roimean;
        roisdv;
        roivol;
        roiimsize;
        baseroiorient;
        drawroiorient;
        drawroiorientarray;
        xlocarr;                      
        ylocarr;                      
        zlocarr;
        linehandles;
        contextmenu;
        shadehandle;
        roimask;
        eventarr;
        roimasksarr2d;
        info;
        alphadata;
        pixdim;
        savepath;
        CREATEMETHOD;
    end
    
%==================================================================
% Init
%==================================================================       
    methods
        % ImageRoiClass
        function IMAGEROI = ImageRoiClass(IMAGEANLZ)
            if exist('IMAGEANLZ','var')
                IMAGEROI = ImRoi_Initialize(IMAGEROI,IMAGEANLZ);
            end
        end
        % AddNewRegion
        function AddNewRegion(IMAGEROI,ACTIVEROI)
            IMAGEROI.locnum = IMAGEROI.locnum+1;
            IMAGEROI.CREATEMETHOD{IMAGEROI.locnum} = ACTIVEROI;
        end
        % InitializeRegion
        function InitializeRegion(IMAGEROI)
            IMAGEROI.CREATEMETHOD{IMAGEROI.locnum}.Initialize;
        end

%==================================================================
% External Define
%==================================================================           
        % ExternalDefineRoiMask
        function IMAGEROI = ExternalDefineRoiMask(IMAGEROI,orient,roiimsize,roimask)
            IMAGEROI.baseroiorient = orient;
            IMAGEROI.drawroiorient = orient;
            IMAGEROI.roiimsize = roiimsize;
            IMAGEROI.roimask = roimask;
        end

%==================================================================
% Creation Info
%==================================================================          
        % GetPointer
        function pointer = GetPointer(IMAGEROI)
            pointer = IMAGEROI.CREATEMETHOD{IMAGEROI.locnum}.pointer;
        end
        % GetStatus
        function status = GetStatus(IMAGEROI)
            status = IMAGEROI.CREATEMETHOD{IMAGEROI.locnum}.status;
        end
        % GetInfo
        function info = GetInfo(IMAGEROI)
            info = IMAGEROI.CREATEMETHOD{IMAGEROI.locnum}.info;
        end

%==================================================================
% Update
%==================================================================          
        % SetDrawOrientation
        function SetDrawOrientation(IMAGEROI,drawroiorient)
            IMAGEROI.drawroiorient = drawroiorient;
        end
        % SetInfo
        function SetInfo(IMAGEROI,info)
            IMAGEROI.info = info;
        end
        
%==================================================================
% Build ROIs
%==================================================================          
        % BuildROI
        function OUT = BuildROI(IMAGEROI,datapoint,event,ImageSlice)
            OUT = IMAGEROI.CREATEMETHOD{IMAGEROI.locnum}.BuildROI(datapoint,event,ImageSlice);
        end
        % ResetLocArr
        function ResetLocArr(IMAGEROI)
            IMAGEROI.roimean = [];
            IMAGEROI.roisdv = [];
            IMAGEROI.roivol = [];
            IMAGEROI.roiname = '';
            IMAGEROI.locnum = 1;
            IMAGEROI.xlocarr = [];                      
            IMAGEROI.ylocarr = [];                         
            IMAGEROI.zlocarr = [];    
            IMAGEROI.xloc0arr = [];                      
            IMAGEROI.yloc0arr = [];                         
            IMAGEROI.zloc0arr = [];  
            IMAGEROI.roimask = [];  
        end
        % BuildLocArr
        function BuildLocArr(IMAGEROI,xloc,yloc,zloc,event,orient)
            for n = 1:length(zloc)
                IMAGEROI.xloc0arr{IMAGEROI.locnum} = xloc{n};  
                IMAGEROI.yloc0arr{IMAGEROI.locnum} = yloc{n}; 
                IMAGEROI.zloc0arr{IMAGEROI.locnum} = zloc{n};
                IMAGEROI.xlocarr{IMAGEROI.locnum} = xloc{n};                % cannot change orientation during roi drawing
                IMAGEROI.ylocarr{IMAGEROI.locnum} = yloc{n}; 
                IMAGEROI.zlocarr{IMAGEROI.locnum} = zloc{n};
                IMAGEROI.eventarr{IMAGEROI.locnum} = event;
                IMAGEROI.drawroiorientarray{IMAGEROI.locnum} = orient;
                if n < length(zloc)
                    IMAGEROI.locnum = IMAGEROI.locnum+1;
                    IMAGEROI.CREATEMETHOD{IMAGEROI.locnum} = IMAGEROI.CREATEMETHOD{IMAGEROI.locnum-1};
                end
            end    
        end
        % DeleteLastRegion
        function DeleteLastRegion(IMAGEROI)
            if IMAGEROI.locnum > 0
                IMAGEROI.RemoveRegion(IMAGEROI.locnum);
                IMAGEROI.xloc0arr = IMAGEROI.xloc0arr(1:IMAGEROI.locnum-1);  
                IMAGEROI.yloc0arr = IMAGEROI.yloc0arr(1:IMAGEROI.locnum-1); 
                IMAGEROI.zloc0arr = IMAGEROI.zloc0arr(1:IMAGEROI.locnum-1); 
                IMAGEROI.xlocarr = IMAGEROI.xlocarr(1:IMAGEROI.locnum-1); 
                IMAGEROI.ylocarr = IMAGEROI.ylocarr(1:IMAGEROI.locnum-1);  
                IMAGEROI.zlocarr = IMAGEROI.zlocarr(1:IMAGEROI.locnum-1);
                IMAGEROI.eventarr = IMAGEROI.eventarr(1:IMAGEROI.locnum-1);
                IMAGEROI.drawroiorientarray = IMAGEROI.drawroiorientarray(1:IMAGEROI.locnum-1);
                IMAGEROI.roimasksarr2d = IMAGEROI.roimasksarr2d(1:IMAGEROI.locnum-1);
                IMAGEROI.CREATEMETHOD = IMAGEROI.CREATEMETHOD(1:IMAGEROI.locnum-1);
                delete(IMAGEROI.contextmenu);
                delete(IMAGEROI.linehandles);
                delete(IMAGEROI.shadehandle);
                if IMAGEROI.lastlocnumadded == IMAGEROI.locnum
                    IMAGEROI.lastlocnumadded = IMAGEROI.lastlocnumadded-1;
                end
                IMAGEROI.locnum = IMAGEROI.locnum-1;
            end
        end
        % Concatenate
        function Concatenate(IMAGEROI,IMAGEROI2,event,orient)
            for n = 1:IMAGEROI2.locnum
                IMAGEROI.xloc0arr{IMAGEROI.locnum+n} = IMAGEROI2.xloc0arr{n};    
                IMAGEROI.yloc0arr{IMAGEROI.locnum+n} = IMAGEROI2.yloc0arr{n};  
                IMAGEROI.zloc0arr{IMAGEROI.locnum+n} = IMAGEROI2.zloc0arr{n};  
                IMAGEROI.xlocarr{IMAGEROI.locnum+n} = IMAGEROI2.xlocarr{n};    
                IMAGEROI.ylocarr{IMAGEROI.locnum+n} = IMAGEROI2.ylocarr{n};  
                IMAGEROI.zlocarr{IMAGEROI.locnum+n} = IMAGEROI2.zlocarr{n};
                IMAGEROI.eventarr{IMAGEROI.locnum+n} = event;
                IMAGEROI.drawroiorientarray{IMAGEROI.locnum+n} = orient;
                switch IMAGEROI2.CREATEMETHOD{n}.roicreatesel
                case 1
                    IMAGEROI.CREATEMETHOD{IMAGEROI.locnum+n} = RoiFreeHandClass;
                case 2
                    IMAGEROI.CREATEMETHOD{IMAGEROI.locnum+n} = RoiSeedClass;
                case 3
                    IMAGEROI.CREATEMETHOD{IMAGEROI.locnum+n} = RoiSphereClass;
                case 4
                    IMAGEROI.CREATEMETHOD{IMAGEROI.locnum+n} = RoiCircleClass;
                case 5
                    IMAGEROI.CREATEMETHOD{IMAGEROI.locnum+n} = RoiTubeClass;
                end
                IMAGEROI.CREATEMETHOD{IMAGEROI.locnum+n}.Copy(IMAGEROI2.CREATEMETHOD{n});
            end
            IMAGEROI.locnum = IMAGEROI.locnum+IMAGEROI2.locnum;
        end
                
%==================================================================
% Draw ROI
%==================================================================          
        % DrawROI
        function DrawROI(IMAGEROI,IMAGEANLZ,axhand,clr,pickable) 
            ImRoi_DrawROI(IMAGEROI,IMAGEANLZ,axhand,clr,pickable);
        end
        % DrawROIwOffset
        function DrawROIwOffset(IMAGEROI,IMAGEANLZ,axhand,clr,xoff,yoff)
            ImRoi_DrawROIwOffset(IMAGEROI,IMAGEANLZ,axhand,clr,xoff,yoff);
        end
        % ShadeROI
        function ShadeROI(IMAGEROI,IMAGEANLZ,axhand,clr,intensity) 
            ImRoi_ShadeROI(IMAGEROI,IMAGEANLZ,axhand,clr,intensity);
        end
        % ShadeROIwOffset
        function ShadeROIwOffset(IMAGEROI,IMAGEANLZ,axhand,clr,xoff,yoff)
            ImRoi_ShadeROIwOffset(IMAGEROI,IMAGEANLZ,axhand,clr,xoff,yoff);
        end        
        % DrawLine
        function DrawLine(IMAGEROI,datapoint,axhand,clr)
            IMAGEROI.CREATEMETHOD{IMAGEROI.locnum}.DrawLine(datapoint,axhand,clr);
        end
        % DrawError
        function DrawError(IMAGEROI)
            IMAGEROI.CREATEMETHOD{IMAGEROI.locnum}.DrawError;
        end
        % DeleteGraphicObjects
        function DeleteGraphicObjects(IMAGEROI)
            delete(IMAGEROI.linehandles);
            delete(IMAGEROI.contextmenu);
            delete(IMAGEROI.shadehandle);
        end
 
%==================================================================
% Draw ROI (Outside Compass)
%================================================================== 
        % OutsideDrawROI
        function OutsideDrawROI(IMAGEROI,slice,axhand,clr) 
            ImRoi_OutsideDrawROI(IMAGEROI,slice,axhand,clr);
        end        
        % OutsideOffsetsDrawROI
        function OutsideOffsetsDrawROI(IMAGEROI,voff,hoff,slice,axhand,clr) 
            ImRoi_OutsideOffsetsDrawROI(IMAGEROI,voff,hoff,slice,axhand,clr);
        end  
        % ChangeShadeAlpha
        function ChangeShadeAlpha(IMAGEROI,alpha)  
            IMAGEROI.shadehandle.AlphaData = alpha*IMAGEROI.alphadata;
        end 
        
%==================================================================
% Nudge
%==================================================================          
        % NudgeUp
        function NudgeUp(IMAGEROI) 
            for n = 1:IMAGEROI.locnum
                IMAGEROI.yloc0arr{n} = IMAGEROI.yloc0arr{n}-0.5;
                IMAGEROI.ylocarr{n} = IMAGEROI.ylocarr{n}-0.5;
            end  
        end
        % NudgeDown
        function NudgeDown(IMAGEROI) 
            for n = 1:IMAGEROI.locnum
                IMAGEROI.yloc0arr{n} = IMAGEROI.yloc0arr{n}+0.5;
                IMAGEROI.ylocarr{n} = IMAGEROI.ylocarr{n}+0.5;
            end  
        end
        % NudgeLeft
        function NudgeLeft(IMAGEROI) 
            for n = 1:IMAGEROI.locnum
                IMAGEROI.xloc0arr{n} = IMAGEROI.xloc0arr{n}-0.5;
                IMAGEROI.xlocarr{n} = IMAGEROI.xlocarr{n}-0.5;
            end  
        end
        % NudgeRight
        function NudgeRight(IMAGEROI) 
            for n = 1:IMAGEROI.locnum
                IMAGEROI.xloc0arr{n} = IMAGEROI.xloc0arr{n}+0.5;
                IMAGEROI.xlocarr{n} = IMAGEROI.xlocarr{n}+0.5;
            end  
        end
        % NudgeIn
        function NudgeIn(IMAGEROI) 
            for n = 1:IMAGEROI.locnum
                IMAGEROI.zloc0arr{n} = IMAGEROI.zloc0arr{n}-1;
                IMAGEROI.zlocarr{n} = IMAGEROI.zlocarr{n}-1;
            end  
        end
        % NudgeOut
        function NudgeOut(IMAGEROI) 
            for n = 1:IMAGEROI.locnum
                IMAGEROI.zloc0arr{n} = IMAGEROI.zloc0arr{n}+1;
                IMAGEROI.zlocarr{n} = IMAGEROI.zlocarr{n}+1;
            end  
        end
        
%==================================================================
% Compute ROI
%==================================================================           
        % AddROIMask
        function AddROIMask(IMAGEROI) 
            if not(strcmp(IMAGEROI.baseroiorient,'Axial'))
                error;
            end
            for m = IMAGEROI.lastlocnumadded+1:IMAGEROI.locnum                                
                if isempty(IMAGEROI.drawroiorientarray{m})
                    tempdrawroiorientarray = IMAGEROI.drawroiorient;
                else
                    tempdrawroiorientarray = IMAGEROI.drawroiorientarray{m};
                end
                if strcmp(tempdrawroiorientarray,'Axial')
                    drawroiimsize = IMAGEROI.roiimsize;
                    temproimask = IMAGEROI.roimask;
                elseif strcmp(tempdrawroiorientarray,'Sagittal')
                    drawroiimsize = IMAGEROI.roiimsize([3 1 2]);
                    temproimask = permute(IMAGEROI.roimask,[3 1 2]);
                    temproimask = flip(temproimask,1);
                elseif strcmp(tempdrawroiorientarray,'Coronal')
                    drawroiimsize = IMAGEROI.roiimsize([3 2 1]);
                    temproimask = permute(IMAGEROI.roimask,[3 2 1]);
                    temproimask = flip(temproimask,1);
                end
                if isempty(IMAGEROI.zloc0arr(m))
                    continue
                end
                roimask2d = roipoly(ones(drawroiimsize(1),drawroiimsize(2)),IMAGEROI.xloc0arr{m},IMAGEROI.yloc0arr{m});
                if strcmp(IMAGEROI.eventarr(m),'Add') 
                    newtemproimask2d = or(temproimask(:,:,IMAGEROI.zloc0arr{m}),roimask2d);
                    IMAGEROI.roimasksarr2d{m} = newtemproimask2d - temproimask(:,:,IMAGEROI.zloc0arr{m}); 
                    temproimask(:,:,IMAGEROI.zloc0arr{m}) = newtemproimask2d;
                elseif strcmp(IMAGEROI.eventarr(m),'Erase')
                    IMAGEROI.roimasksarr2d{m} = and(temproimask(:,:,IMAGEROI.zloc0arr{m}),roimask2d);
                    temproimask(:,:,IMAGEROI.zloc0arr{m}) = temproimask(:,:,IMAGEROI.zloc0arr{m}) - IMAGEROI.roimasksarr2d{m};
                end
                if strcmp(IMAGEROI.drawroiorientarray{m},'Axial')
                    IMAGEROI.roimask = temproimask;
                elseif strcmp(IMAGEROI.drawroiorientarray{m},'Sagittal')
                    temproimask = flip(temproimask,1);
                    IMAGEROI.roimask = permute(temproimask,[2 3 1]);
                elseif strcmp(IMAGEROI.drawroiorientarray{m},'Coronal')
                    temproimask = flip(temproimask,1);
                    IMAGEROI.roimask = permute(temproimask,[3 2 1]);
                end
            end
            IMAGEROI.lastlocnumadded = IMAGEROI.locnum; 
        end
        % CreateBaseROIMask
        function CreateBaseROIMask(IMAGEROI) 
            if not(strcmp(IMAGEROI.baseroiorient,'Axial'))
                error;
            end
            IMAGEROI.roimask = zeros(IMAGEROI.roiimsize);                % to ensure start from scratch
            for m = 1:IMAGEROI.locnum                               
                if isempty(IMAGEROI.drawroiorientarray)
                	IMAGEROI.drawroiorientarray{m} = 'Axial';
                end
                if length(IMAGEROI.drawroiorientarray) < m
                    IMAGEROI.drawroiorientarray{m} = 'Axial';
                end
                if strcmp(IMAGEROI.drawroiorientarray{m},'Axial')
                    drawroiimsize = IMAGEROI.roiimsize;
                    temproimask = IMAGEROI.roimask;
                elseif strcmp(IMAGEROI.drawroiorientarray{m},'Sagittal')
                    drawroiimsize = IMAGEROI.roiimsize([3 1 2]);
                    temproimask = permute(IMAGEROI.roimask,[3 1 2]);
                    temproimask = flip(temproimask,1);
                elseif strcmp(IMAGEROI.drawroiorientarray{m},'Coronal')
                    drawroiimsize = IMAGEROI.roiimsize([3 2 1]);
                    temproimask = permute(IMAGEROI.roimask,[3 2 1]);
                    temproimask = flip(temproimask,1);
                end
                if isempty(IMAGEROI.zloc0arr(m))
                    continue
                end
                roimask2d = roipoly(ones(drawroiimsize(1),drawroiimsize(2)),IMAGEROI.xloc0arr{m},IMAGEROI.yloc0arr{m});
                if isempty(IMAGEROI.eventarr)
                    IMAGEROI.eventarr{m} = 'Add';
                end
                if length(IMAGEROI.eventarr) < m
                    IMAGEROI.eventarr{m} = 'Add';
                end
                if strcmp(IMAGEROI.eventarr(m),'Add') 
                    newtemproimask2d = or(temproimask(:,:,IMAGEROI.zloc0arr{m}),roimask2d);
                    IMAGEROI.roimasksarr2d{m} = newtemproimask2d - temproimask(:,:,IMAGEROI.zloc0arr{m}); 
                    temproimask(:,:,IMAGEROI.zloc0arr{m}) = newtemproimask2d;
                elseif strcmp(IMAGEROI.eventarr(m),'Erase')
                    IMAGEROI.roimasksarr2d{m} = and(temproimask(:,:,IMAGEROI.zloc0arr{m}),roimask2d);
                    temproimask(:,:,IMAGEROI.zloc0arr{m}) = temproimask(:,:,IMAGEROI.zloc0arr{m}) - IMAGEROI.roimasksarr2d{m};
                end
                if strcmp(IMAGEROI.drawroiorientarray{m},'Axial')
                    IMAGEROI.roimask = temproimask;
                elseif strcmp(IMAGEROI.drawroiorientarray{m},'Sagittal')
                    temproimask = flip(temproimask,1);
                    IMAGEROI.roimask = permute(temproimask,[2 3 1]);
                elseif strcmp(IMAGEROI.drawroiorientarray{m},'Coronal')
                    temproimask = flip(temproimask,1);
                    IMAGEROI.roimask = permute(temproimask,[3 2 1]);
                end
            end
        end      
        % ComputeROI
        function ComputeROI(IMAGEROI,IMAGEANLZ)
            ImRoi_ComputeROI(IMAGEROI,IMAGEANLZ);
        end
        % GetROIDataArray
        function vals = GetROIDataArray(IMAGEROI,IMAGEANLZ)
            Image = IMAGEANLZ.GetOriented3DImage(IMAGEROI.drawroiorient);
            vals = Image(logical(IMAGEROI.roimask));
        end
        % GetComplexROIDataArray
        function vals = GetComplexROIDataArray(IMAGEROI,IMAGEANLZ)
            Image = IMAGEANLZ.GetComplexOriented3DImage(IMAGEROI.drawroiorient);
            vals = Image(logical(IMAGEROI.roimask));
        end
        % RemoveRegion
        function RemoveRegion(IMAGEROI,m) 
            if not(strcmp(IMAGEROI.baseroiorient,'Axial'))
                error;
            end                         
            if isempty(IMAGEROI.drawroiorientarray{m})
                tempdrawroiorientarray = IMAGEROI.drawroiorient;
            else
                tempdrawroiorientarray = IMAGEROI.drawroiorientarray{m};
            end
            if strcmp(tempdrawroiorientarray,'Axial')
                drawroiimsize = IMAGEROI.roiimsize;
                temproimask = IMAGEROI.roimask;
            elseif strcmp(tempdrawroiorientarray,'Sagittal')
                drawroiimsize = IMAGEROI.roiimsize([3 1 2]);
                temproimask = permute(IMAGEROI.roimask,[3 1 2]);
                temproimask = flip(temproimask,1);
            elseif strcmp(tempdrawroiorientarray,'Coronal')
                drawroiimsize = IMAGEROI.roiimsize([3 2 1]);
                temproimask = permute(IMAGEROI.roimask,[3 2 1]);
                temproimask = flip(temproimask,1);
            end
            if isempty(IMAGEROI.zloc0arr(m))
                error;
            end
            if strcmp(IMAGEROI.eventarr(m),'Erase') 
                temproimask(:,:,IMAGEROI.zloc0arr{m}) = temproimask(:,:,IMAGEROI.zloc0arr{m}) + IMAGEROI.roimasksarr2d{m};
            elseif strcmp(IMAGEROI.eventarr(m),'Add')
                temproimask(:,:,IMAGEROI.zloc0arr{m}) = temproimask(:,:,IMAGEROI.zloc0arr{m}) - IMAGEROI.roimasksarr2d{m};
            end
            if strcmp(IMAGEROI.drawroiorientarray{m},'Axial')
                IMAGEROI.roimask = temproimask;
            elseif strcmp(IMAGEROI.drawroiorientarray{m},'Sagittal')
                temproimask = flip(temproimask,1);
                IMAGEROI.roimask = permute(temproimask,[2 3 1]);
            elseif strcmp(IMAGEROI.drawroiorientarray{m},'Coronal')
                temproimask = flip(temproimask,1);
                IMAGEROI.roimask = permute(temproimask,[3 2 1]);
            end
        end
        
%==================================================================
% Load/Delete ROIs
%==================================================================        
        % LoadOldROIs
        function LoadOldROIs(IMAGEROI,xloc,yloc,zloc)
            for n = 1:length(zloc)
                IMAGEROI.xloc0arr{IMAGEROI.locnum} = [xloc{n} xloc{n}(1)];  
                IMAGEROI.yloc0arr{IMAGEROI.locnum} = [yloc{n} yloc{n}(1)]; 
                IMAGEROI.zloc0arr{IMAGEROI.locnum} = zloc{n}; 
                IMAGEROI.xlocarr{IMAGEROI.locnum} = [xloc{n} xloc{n}(1)];                % cannot change orientation during roi drawing
                IMAGEROI.ylocarr{IMAGEROI.locnum} = [yloc{n} yloc{n}(1)];  
                IMAGEROI.zlocarr{IMAGEROI.locnum} = zloc{n}; 
                if n < length(zloc)
                    IMAGEROI.locnum = IMAGEROI.locnum+1;
                    IMAGEROI.CREATEMETHOD{IMAGEROI.locnum} = IMAGEROI.CREATEMETHOD{IMAGEROI.locnum-1};
                end
            end    
        end
        % CopyRoiInfo 
        function CopyRoiInfo(IMAGEROI,ROI)
            ImRoi_CopyRoiInfo(IMAGEROI,ROI);
        end
        % DeleteLocArr
        function DeleteLocArr(IMAGEROI)
            ImRoi_Delete(IMAGEROI);
        end
        % PrepareForSave
        function PrepareForSave(IMAGEROI)
            IMAGEROI.roimean = [];
            IMAGEROI.roisdv = [];
            IMAGEROI.roivol = [];
            IMAGEROI.linehandles = gobjects(0); 
        end
        % SetROIName
        function SetROIName(IMAGEROI,roiname)
            IMAGEROI.roiname = roiname;
        end
        % SetROIPath
        function SetROIPath(IMAGEROI,savepath)
            IMAGEROI.savepath = savepath;
        end
        % TestActive
        function bool = TestActive(IMAGEROI)
            bool = IMAGEROI.CREATEMETHOD{IMAGEROI.locnum}.TestActive;
        end
        % ResetTool
        function ResetTool(IMAGEROI)
            IMAGEROI.CREATEMETHOD{IMAGEROI.locnum}.Reset;
        end
        % TestForSavedROI
        function bool = TestForSavedROI(IMAGEROI)
            bool = 1;
            if IMAGEROI.locnum == 0 && isempty(IMAGEROI.roiname)
                if not(isempty(IMAGEROI.xloc0arr))
                    error;
                end
                bool = 0;    
            end
        end         
    end
end
        
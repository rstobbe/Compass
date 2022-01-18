%============================================
%
%============================================
function LoadROIFolder(tab,axnum,roinum)

global IMAGEANLZ
global SCRPTPATHS

if not(isempty(IMAGEANLZ.(tab)(axnum).movefunction))
    error;          % shouldn't get here
end

roisloc = SCRPTPATHS.(tab)(1).roisloc;
path = uigetdir(roisloc,'Select ROI Folder');
if path == 0
    return;
end
SCRPTPATHS.(tab)(1).roisloc = path;

RoiFiles = ls(path);
sz = size(RoiFiles);
RoiFiles = RoiFiles(3:sz(1),:);

for p = 1:(sz(1)-2) 
    [name,ext] = strtok(RoiFiles(p,:),'.');
    if isempty(strfind(ext,'.mat'))
        continue
    end
    ROI = [];
    load([path,'\',RoiFiles(p,:)]);
    if isempty(ROI)
        Status2('error','File did not contain an ROI',1);
        continue
    end
    
    ROI.SetROIName(name);
    
    if IMAGEANLZ.(tab)(axnum).TestAxisActive
        imsize = IMAGEANLZ.(tab)(axnum).GetBaseImageSize([]);
        for n = 1:3
            if ROI.roiimsize(n) ~= imsize(n);
                Status2('error','ROI and Image Dimensions Incompatible',1);
                continue
            end
        end

        if not(isempty(ROI.baseroiorient))
            if not(strcmp(ROI.baseroiorient,IMAGEANLZ.(tab)(axnum).GetBaseOrient([])))
                Status2('error','ROI and Image Orientations Incompatible',1);
                continue
            end
        end
    end

    switch IMAGEANLZ.(tab)(axnum).presentation
        case 'Standard'
            if IMAGEANLZ.(tab)(axnum).ROITIE == 1
                start = 1;    
                stop = IMAGEANLZ.(tab)(axnum).axeslen;
            else
                start = axnum;
                stop = axnum;
            end
            for r = start:stop
                Status2('busy',['Load ROI: ',num2str(p)],1);
                if IMAGEANLZ.(tab)(r).TestAxisActive
                    IMAGEANLZ.(tab)(r).AddROI2Saved(ROI,roinum);
                    IMAGEANLZ.(tab)(r).ActivateROI(roinum);
                    IMAGEANLZ.(tab)(r).DrawSavedROIs([]);
                    IMAGEANLZ.(tab)(r).ComputeSavedROI(roinum);
                    IMAGEANLZ.(tab)(r).SetSavedROIValues;
                end
            end
        case 'Ortho'
            for r = 1:3
                IMAGEANLZ.(tab)(r).AddROI2Saved(ROI,roinum);
                IMAGEANLZ.(tab)(r).ActivateROI(roinum);
                IMAGEANLZ.(tab)(r).DrawSavedROIs([]);
            end
            IMAGEANLZ.(tab)(1).ComputeSavedROI(roinum);
            IMAGEANLZ.(tab)(1).SetSavedROIValues;   
    end
    roinum = roinum + 1;
end

Status2('done','',1);

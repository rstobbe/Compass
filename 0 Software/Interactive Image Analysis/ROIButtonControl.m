%====================================================
% 
%====================================================
function ROIButtonControl(src,event)

global IMAGEANLZ
global FIGOBJS
global RWSUIGBL

tab = src.Parent.Parent.Parent.Parent.Parent.Tag;
roiarr = src.UserData;
axnum = roiarr(1);
roinum = roiarr(2);
SetFocus(tab,axnum);

for n = 1:IMAGEANLZ.(tab)(1).axeslen
    if not(isempty(IMAGEANLZ.(tab)(n).buttonfunction))
        return
    end
end	

IMAGEANLZ.(tab)(axnum).HighlightROI(roinum);
switch RWSUIGBL.Character
    case 'a'
        if ~IMAGEANLZ.(tab)(axnum).ROISOFINTEREST(roinum)
            ActivateROI(src,tab,axnum,roinum);
        else
            DeactivateROI(src,tab,axnum,roinum);
        end
        return
    case 'A'
        if ~IMAGEANLZ.(tab)(axnum).ROISOFINTEREST(roinum)
            ActivateAllROIs(tab,axnum);
        else
            DeactivateAllROIs(tab,axnum);
        end
        return
end
        
if(IMAGEANLZ.(tab)(axnum).SAVEDROISFLAG == 0)
    [s,v] = listdlg('PromptString','Action:','SelectionMode','single','ListString',{'Load ROI','Load ROI Folder','Load Old ROI','Load Old ROI Folder'});
    if isempty(s)
        FIGOBJS.(tab).ROILAB(axnum,roinum).ForegroundColor = [0.8,0.8,0.8];
        return
    end
    switch s
        case 1
            LoadROI(tab,axnum,roinum);
        case 2
            LoadROIFolder(tab,axnum,roinum);
        case 3
            LoadOldROI(tab,axnum,roinum);
        case 4
            LoadOldROIFolder(tab,axnum,roinum);
    end
else
    if not(IMAGEANLZ.(tab)(axnum).TestForSavedROI(roinum))
        [s,v] = listdlg('PromptString','Action:','SelectionMode','single','ListString',{'Load ROI','Load Old ROI'});
        if isempty(s)
            FIGOBJS.(tab).ROILAB(axnum,roinum).ForegroundColor = [0.8,0.8,0.8];
            return
        end
        switch s
            case 1
                LoadROI(tab,axnum,roinum);
            case 2
                LoadOldROI(tab,axnum,roinum);
        end
    else
        [s,v] = listdlg('PromptString','Action:','SelectionMode','single','ListString',{'Save ROI','Save All ROIs','Delete ROI','Delete All ROIs','Export ROI Table','Rename ROI','Edit ROI','Activate ROI' ,'Activate All ROIs','Deactivate ROI' ,'Dectivate All ROIs'});
        if isempty(s)
            if ~IMAGEANLZ.(tab)(axnum).ROISOFINTEREST(roinum)
                FIGOBJS.(tab).ROILAB(axnum,roinum).ForegroundColor = [0.8,0.8,0.8];
            end
            return
        end
        switch s
            case 7
                EditROI(tab,axnum,roinum);
            case 1
                SaveROI(tab,axnum,roinum);
            case 2
                SaveAllROIs(tab,axnum);
            case 6
                RenameROI(tab,axnum,roinum);
            case 5
                TableAllROIs(tab,axnum);
            case 3
                DeleteROI(tab,axnum,roinum);
            case 4
                DeleteAllROIs(tab,axnum);
            case 8
                ActivateROI([],tab,axnum,roinum);
            case 9
                ActivateAllROIs(tab,axnum);
            case 10
                DeactivateROI([],tab,axnum,roinum);
            case 11
                DeactivateAllROIs(tab,axnum);
        end
    end
end

if ~IMAGEANLZ.(tab)(axnum).ROISOFINTEREST(roinum)
    FIGOBJS.(tab).ROILAB(axnum,roinum).ForegroundColor = [0.8,0.8,0.8];
end


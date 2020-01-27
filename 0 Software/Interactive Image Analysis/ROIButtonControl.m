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


switch RWSUIGBL.Key
    case 'shift'
        for n = 1:IMAGEANLZ.(tab)(1).axeslen
            if not(isempty(IMAGEANLZ.(tab)(n).buttonfunction))
                return
            end
        end	
        IMAGEANLZ.(tab)(axnum).HighlightROI(roinum);
        if(IMAGEANLZ.(tab)(axnum).SAVEDROISFLAG == 0)
            [s,v] = listdlg('PromptString','Action:','SelectionMode','single','ListString',{'Load ROI','Load ROI Folder','Load Old ROI','Load Old ROI Folder'});
            if isempty(s)
                FIGOBJS.(tab).ROILAB(axnum,roinum).ForegroundColor = [0.8,0.8,0.8];
                RWSUIGBL.Key = '';
                RWSUIGBL.Character = '';
                return
            end
            switch s
                case 1
                    SelectLoadROI(tab,axnum,roinum);
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
                    if ~IMAGEANLZ.(tab)(axnum).ROISOFINTEREST(roinum)
                        FIGOBJS.(tab).ROILAB(axnum,roinum).ForegroundColor = [0.8,0.8,0.8];
                    end
                    RWSUIGBL.Key = '';
                    RWSUIGBL.Character = '';
                    return
                end
                switch s
                    case 1
                        SelectLoadROI(tab,axnum,roinum);
                    case 2
                        LoadOldROI(tab,axnum,roinum);
                end
            else
                [s,v] = listdlg('PromptString','Action:','SelectionMode','single','ListString',{'Save ROI','Save Selected ROIs','Save All ROIs','Delete ROI','Delete Selected ROIs','Delete All ROIs','Rename ROI','Edit ROI','Export ROI','Export ROI Table'});
                if isempty(s)
                    if ~IMAGEANLZ.(tab)(axnum).ROISOFINTEREST(roinum)
                        FIGOBJS.(tab).ROILAB(axnum,roinum).ForegroundColor = [0.8,0.8,0.8];
                    end
                    RWSUIGBL.Key = '';
                    RWSUIGBL.Character = '';
                    return
                end
                switch s
                    case 8
                        EditROI(tab,axnum,roinum);
                    case 1
                        SaveROI(tab,axnum,roinum);
                    case 2
                        SaveSelectedROIs(tab,axnum,roinum);
                    case 3
                        SaveAllROIs(tab,axnum);
                    case 7
                        RenameROI(tab,axnum,roinum);
                    case 10
                        TableAllROIs(tab,axnum);
                    case 4
                        DeleteROI(tab,axnum,roinum);
                    case 5
                        DeleteSelectedROIs(tab,axnum);
                    case 6
                        DeleteAllROIs(tab,axnum);
                    case 9
                        ExportROI(tab,axnum,roinum);
                end
            end
        end
        if ~IMAGEANLZ.(tab)(axnum).ROISOFINTEREST(roinum)
            FIGOBJS.(tab).ROILAB(axnum,roinum).ForegroundColor = [0.8,0.8,0.8];
        end
    case ''
%         if(IMAGEANLZ.(tab)(axnum).SAVEDROISFLAG == 0)
%             RWSUIGBL.Key = '';
%             RWSUIGBL.Character = '';
%             return
%         end
        if IMAGEANLZ.(tab)(axnum).TestForSavedROI(roinum)
            if ~IMAGEANLZ.(tab)(axnum).ROISOFINTEREST(roinum)
                ActivateROI(src,tab,axnum,roinum);
            else
                DeactivateROI(src,tab,axnum,roinum);
            end
        else
            SelectLoadROI(tab,axnum,roinum);
        end
    case 'a'
        if(IMAGEANLZ.(tab)(axnum).SAVEDROISFLAG == 0)
            RWSUIGBL.Key = '';
            RWSUIGBL.Character = '';
            return
        end
        if ~IMAGEANLZ.(tab)(axnum).ROISOFINTEREST(roinum)
            ActivateAllROIs(tab,axnum);
        else
            DeactivateAllROIs(tab,axnum);
        end
end

RWSUIGBL.Key = '';
RWSUIGBL.Character = '';


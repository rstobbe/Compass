function [] = onDrop(fig,listener,evtArg) 

global IMAGEANLZ

LoadImage = 0;
LoadRoi = 0;

data = evtArg.GetTransferableData();
if (data.IsTransferableAsFileList)       
    files = data.TransferAsFileList;        
    for n = 1:length(files)
        if strcmp(files{n}(end-3),'.')
            ind = strfind(files{n},'\');
            path = files{n}(1:ind(end));
            file = files{n}(ind(end)+1:end);
            if strcmp(file(1:3),'ROI')
                LoadRoi = 1;
            else
                [IMG,Name,ImType,err] = Import_Image(path,file);
                if err.flag
                    return
                end
                totalgbl{1} = Name{1};
                totalgbl{2} = IMG{1};
                from = 'CompassLoad';
                Load_TOTALGBL(totalgbl,'IM',from);
                LoadImage = 1;
            end
        else
            err.flag = 1;
            err.msg = 'Folder loading not supported yet';
            ErrDisp(err);
        end
    end
    tab = fig.CurrentObject.Tag;
    if ~strcmp(tab(1),'I')
        tab = fig.CurrentObject.Parent.Parent.Tag;
    end
    if strcmp(IMAGEANLZ.(tab)(1).presentation,'Ortho')
        axnum = 1;
    else
        axnum = GetFocus(tab);
    end
    if LoadImage == 1
        if strcmp(IMAGEANLZ.(tab)(1).presentation,'Standard')
            Gbl2Image(tab,axnum,IMAGEANLZ.(tab)(axnum).totgblnumhl);
        elseif strcmp(IMAGEANLZ.(tab)(1).presentation,'Ortho')
            Gbl2ImageOrtho(tab,IMAGEANLZ.(tab)(1).totgblnumhl);
        end
    end
    if LoadRoi == 1
        roinum = IMAGEANLZ.(tab)(1).FindNextAvailableROI;
        LoadROI(tab,axnum,roinum,path,file);
    end

    evtArg.DropComplete(true);
elseif (data.IsTransferableAsString)  
    evtArg.DropComplete(false);
else        
    evtArg.DropComplete(false);
end

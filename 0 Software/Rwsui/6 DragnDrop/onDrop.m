function [] = onDrop(fig,listener,evtArg) 

global IMAGEANLZ

data = evtArg.GetTransferableData();
if (data.IsTransferableAsFileList)       
    files = data.TransferAsFileList;        
    for n = 1:length(files)
        if strcmp(files{n}(end-3),'.')
            ind = strfind(files{n},'\');
            impath = files{n}(1:ind(end));
            imfile = files{n}(ind(end)+1:end);
            [IMG,Name,ImType,err] = Import_Image(impath,imfile);
            if err.flag
                return
            end
            totalgbl{1} = Name{1};
            totalgbl{2} = IMG{1};
            from = 'CompassLoad';
            Load_TOTALGBL(totalgbl,'IM',from);
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
    if strcmp(IMAGEANLZ.(tab)(1).presentation,'Standard')
        axnum = GetFocus(tab);
        Gbl2Image(tab,axnum,IMAGEANLZ.(tab)(axnum).totgblnumhl);
    elseif strcmp(IMAGEANLZ.(tab)(1).presentation,'Ortho')
        Gbl2ImageOrtho(tab,IMAGEANLZ.(tab)(1).totgblnumhl);
    end        

    evtArg.DropComplete(true);
elseif (data.IsTransferableAsString)  
    evtArg.DropComplete(false);
else        
    evtArg.DropComplete(false);
end

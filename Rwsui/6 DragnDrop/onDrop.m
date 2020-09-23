function [] = onDrop(fig,listener,evtArg) 

global IMAGEANLZ
global FIGOBJS

LoadImage = 0;
LoadRoi = 0;
Status2('busy','Load File',1);

tab = FIGOBJS.TABGP.SelectedTab.Tag;
if strcmp(tab(1),'I')
    if strcmp(IMAGEANLZ.(tab)(1).presentation,'Ortho')
        axnum = 1;
    else
        axnum = GetFocus(tab);
    end
end

data = evtArg.GetTransferableData();
if (data.IsTransferableAsFileList)       
    files = data.TransferAsFileList;        
    for n = 1:length(files)
        if strcmp(files{n}(end-3),'.')
            ind = strfind(files{n},'\');
            path = files{n}(1:ind(end));
            file = files{n}(ind(end)+1:end);
            % - Imaging Panels
            if strcmp(tab(1),'I')            
                if strcmp(file(1:3),'ROI')
                    roinum = IMAGEANLZ.(tab)(1).FindNextAvailableROI;
                    LoadROI(tab,axnum,roinum,path,file);
                    panelnum = str2double(FIGOBJS.(tab).ScriptTabGroup.SelectedTab.Title(7));
                    scrptnum = 1;
                    [saveData,saveSCRPTcellarray,saveGlobalNames,err] = LoadSelectedFile_B9(panelnum,tab,scrptnum,path,file);
                    if err.flag == 1
                        err.flag = 0;
                        ErrDisp(err); 
                    end
                else
                    [IMG,Name,ImType,err] = Import_Image(path,file);
                    if err.flag
                        panelnum = str2double(FIGOBJS.(tab).ScriptTabGroup.SelectedTab.Title(7));
                        scrptnum = 1;
                        [saveData,saveSCRPTcellarray,saveGlobalNames,err] = LoadSelectedFile_B9(panelnum,tab,scrptnum,path,file);
                        if err.flag == 1
                            ErrDisp(err); 
                            return 
                        end
                        names = fieldnames(saveData);
                        totalgbl{1} = file;
                        totalgbl{2} = saveData.(names{1});
                        from = 'CompassLoad';
                        Load_TOTALGBL(totalgbl,tab,from);
                        err.flag = 0;
                        ErrDisp(err); 
                    else
                        totalgbl{1} = Name{1};
                        totalgbl{2} = IMG{1};
                        from = 'CompassLoad';
                        Load_TOTALGBL(totalgbl,'IM',from);
%                         if strcmp(IMAGEANLZ.(tab)(1).presentation,'Standard')
%                             Gbl2Image(tab,axnum,IMAGEANLZ.(tab)(axnum).totgblnumhl);
%                         elseif strcmp(IMAGEANLZ.(tab)(1).presentation,'Ortho')
%                             Gbl2ImageOrtho(tab,IMAGEANLZ.(tab)(1).totgblnumhl);
%                         end
                    end
                end
            elseif strcmp(tab(1),'A')
                if not(strcmp(file(end-3:end),'.mat'))
                    err.flag = 1;
                    err.msg = 'Not a Saved Script File';
                    ErrDisp(err);
                    return
                end
                load([path,file]);
                if not(exist('saveData','var')) || not(exist('saveSCRPTcellarray','var')) || not(exist('saveGlobalNames','var'))
                    err.flag = 1;
                    err.msg = 'Not a Saved Script File';
                    ErrDisp(err);
                    return
                end
                names = fieldnames(saveData);
                if length(names) > 1 
                    error;      % no longer supported
                end
                fields{1} = saveData.(names{1});
                fields{1}.path = path;
                fields{1}.name = file;
                if exist('saveGlobalNames','var')
                    totalgbl = [saveGlobalNames;fields];
                else
                    totalgbl = [names;fields];
                end
                totalgbl{2,1}.saveSCRPTcellarray = saveSCRPTcellarray;
                from = 'Script';
                Load_TOTALGBL(totalgbl,tab,from);
                err.flag = 0;
                ErrDisp(err); 
            end
        else
            if strcmp(files{n}(end-2),'.')
                err.flag = 1;
                err.msg = 'File type not supported';
                ErrDisp(err);                
            else
                err.flag = 1;
                err.msg = 'Folder loading not supported yet';
                ErrDisp(err);
            end
        end
    end
    evtArg.DropComplete(true);
elseif (data.IsTransferableAsString)  
    evtArg.DropComplete(false);
else        
    evtArg.DropComplete(false);
end

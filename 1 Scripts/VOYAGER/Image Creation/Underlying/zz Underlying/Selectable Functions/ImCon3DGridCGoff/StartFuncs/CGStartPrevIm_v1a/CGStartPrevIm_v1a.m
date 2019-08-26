%=========================================================
% (v1a) 
%  
%=========================================================

function [SCRPTipt,SCRPTGBL,STRT,err] = CGStartPrevIm_v1a(SCRPTipt,SCRPTGBL,STRTipt)

Status2('busy','Load Starting Image',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';
global TOTALGBL

%---------------------------------------------
% Get Input
%---------------------------------------------
STRT.method = STRTipt.Func;
STRT.useprev = STRTipt.('UsePrev');
PanelLabel = 'PrevIm_File';
CallingLabel = STRTipt.Struct.labelstr;

%---------------------------------------------
% Tests
%---------------------------------------------
auto = 0;
val = get(findobj('tag','totalgbl'),'value');
if not(isempty(val)) && val(1) ~= 0
    Gbl = TOTALGBL{2,val};
    if isfield(Gbl,'AutoRecon')
        auto = 1;
    end
end

%---------------------------------------------
% Get Image
%---------------------------------------------
if auto == 1
    Path = Gbl.Path1;
    File = Gbl.SaveName1;
    LoadType = 'Image';
    [SCRPTipt,SCRPTGBL,err] = File2Panel(SCRPTipt,SCRPTGBL,CallingLabel,PanelLabel,LoadType,Path,File);
    Data = SCRPTGBL.([CallingLabel,'_Data']).([PanelLabel,'_Data']);
else 
    LoadAll = 0;
    if not(isfield(STRTipt,[CallingLabel,'_Data']))
        LoadAll = 1;
    end
    if LoadAll == 1 || not(isfield(STRTipt.([CallingLabel,'_Data']),[PanelLabel,'_Data']))
        if isfield(STRTipt.(PanelLabel).Struct,'selectedfile')
            file = STRTipt.(PanelLabel).Struct.selectedfile;
            if not(exist(file,'file'))
                err.flag = 1;
                err.msg = ['(Re) Load ',PanelLabel];
                ErrDisp(err);
                return
            else
                Status2('busy','Load Image1 Data',2);
                load(file);
                saveData.path = file;
                STRTipt.([CallingLabel,'_Data']).([PanelLabel,'_Data']) = saveData;
            end
        else
            err.flag = 1;
            err.msg = ['(Re) Load ',PanelLabel];
            ErrDisp(err);
            return
        end
    end
    Gbl = STRTipt.([CallingLabel,'_Data']).([PanelLabel,'_Data']);   
    fields = fieldnames(Gbl);
    foundimage = 0;
    for n = 1:length(fields)
        if isfield(Gbl.(fields{n}),'Im')
            Data = Gbl.(fields{n});
            foundimage = 1;
            break
        end
    end
    if foundimage == 0;
        err.flag = 1;
        err.msg = 'Image_File1 Selection Does Not Contain An Image';
        return
    end    
end

%--------------------------------------------
% Return
%--------------------------------------------
STRT.IMG = Data;

Status2('done','',2);
Status2('done','',3);
%=========================================================
% (v1a) 
%      
%=========================================================

function [SCRPTipt,SCRPTGBL,SDCLD,err] = MultiSDCLoad_v1a(SCRPTipt,SCRPTGBL,SDCLDipt)

Status2('busy','Load Multiple SDC Files',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';
global TOTALGBL
global MULTIFILELOAD

%---------------------------------------------
% Get Input
%---------------------------------------------
SDCLD.method = SDCLDipt.Func;
for n = 1:MULTIFILELOAD.numfiles
    PanelLabel{n} = ['SDC',num2str(n)];
end
CallingLabel = SDCLDipt.Struct.labelstr;

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
    for n = 1:MULTIFILELOAD.numfiles
        Path = Gbl.(['Path',num2str(n)]);
        File = Gbl.(['SaveName',num2str(n)]);
        LoadType = 'SDC';
        [SCRPTipt,SCRPTGBL,err] = File2Panel(SCRPTipt,SCRPTGBL,CallingLabel,PanelLabel{n},LoadType,Path,File);
        Data{1} = SCRPTGBL.([CallingLabel,'_Data']).([PanelLabel{n},'_Data']);
        error();    %fix
    end
else 
    LoadAll = 0;
    if not(isfield(SDCLDipt,[CallingLabel,'_Data']))
        LoadAll = 1;
    end
    for n = 1:MULTIFILELOAD.numfiles    
        if LoadAll == 1 || not(isfield(SDCLDipt.([CallingLabel,'_Data']),[PanelLabel{n},'_Data']))
            if isfield(SDCLDipt.(PanelLabel{n}).Struct,'selectedfile')
                file = SDCLDipt.(PanelLabel{n}).Struct.selectedfile;
                if not(exist(file,'file'))
                    err.flag = 1;
                    err.msg = ['(Re) Load ',PanelLabel{n}];
                    ErrDisp(err);
                    return
                else
                    Status2('busy',['(Re) Load ',PanelLabel{n}],2);
                    load(file);
                    saveData.path = file;
                    SDCLDipt.([CallingLabel,'_Data']).([PanelLabel{n},'_Data']) = saveData;
                end
            else
                err.flag = 1;
                err.msg = ['(Re) Load ',PanelLabel{n}];
                ErrDisp(err);
                return
            end
        end
        Gbl = SDCLDipt.([CallingLabel,'_Data']).([PanelLabel{n},'_Data']);   
        if not(isfield(Gbl,'SDCS'))
            err.flag = 1;
            err.msg = [PanelLabel{n},' Does Not Contain A SDC'];
            return
        end
        SDCS(n) = Gbl.SDCS;
    end
end

%--------------------------------------------
% Return
%--------------------------------------------
SDCLD.SDCS = SDCS;

Status2('done','',2);
Status2('done','',3);

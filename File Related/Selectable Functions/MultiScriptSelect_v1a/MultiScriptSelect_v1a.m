%=========================================================
% (v1a) 
%      
%=========================================================

function [SCRPTipt,SCRPTGBL,SLCT,err] = MultiScriptSelect_v1a(SCRPTipt,SCRPTGBL,SLCTipt)

Status2('busy','Get Multiple Files',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
SLCT.method = SLCTipt.Func;
numfiles = str2double(SLCTipt.('NumFiles').EntryStr);
for n = 1:numfiles
    PanelLabel{n} = ['Script',num2str(n)];
end
CallingLabel = SLCTipt.Struct.labelstr;
tab = SCRPTGBL.RWSUI.tab;

%---------------------------------------------
% Get Image
%---------------------------------------------
LoadAll = 0;
if not(isfield(SLCTipt,[CallingLabel,'_Data']))
    LoadAll = 1;
end
for n = 1:numfiles    
    if LoadAll == 1 || not(isfield(SLCTipt.([CallingLabel,'_Data']),[PanelLabel{n},'_Data']))
        if isfield(SLCTipt.(PanelLabel{n}).Struct,'selectedfile')
            file = SLCTipt.(PanelLabel{n}).Struct.selectedfile;
            if not(exist(file,'file'))
                err.flag = 1;
                err.msg = ['(Re) Select ',PanelLabel{n}];
                ErrDisp(err);
                return
            else
                Status2('busy',['(Re) Load ',PanelLabel{n}],2);
                ind = strfind(file,'\');
                saveData.path = file(1:ind(end));
                saveData.file = file(ind(end)+1:end);
                panelnum = n+1;
                scrptnum = 1;
                [runfunc,ScrptCellArray,err] = LoadScrptDefault(panelnum,tab,scrptnum,saveData.file,saveData.path);
                saveData.ScrptCellArray = ScrptCellArray;
                SLCTipt.([CallingLabel,'_Data']).([PanelLabel{n},'_Data']) = saveData;
            end
        else
            err.flag = 1;
            err.msg = ['(Re) Select ',PanelLabel{n}];
            ErrDisp(err);
            return
        end
    end
    Data = SLCTipt.([CallingLabel,'_Data']).([PanelLabel{n},'_Data']);   

    %--------------------------------------------
    % Load Images
    %--------------------------------------------
    SLCT.Scripts{n} = Data;   
end

test = SCRPTipt(6).entrystruct


Status2('done','',2);
Status2('done','',3);

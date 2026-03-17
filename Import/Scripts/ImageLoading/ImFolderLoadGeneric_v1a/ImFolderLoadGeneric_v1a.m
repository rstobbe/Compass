%=========================================================
% (v1a) 
%      
%=========================================================

function [SCRPTipt,SCRPTGBL,IMLD,err] = ImFolderLoadGeneric_v1a(SCRPTipt,SCRPTGBL,IMLDipt)

Status2('busy','Load Image Folder',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
IMLD.method = IMLDipt.Func;
numfiles = IMLDipt.('Folder').Struct.numfiles;
for n = 1:numfiles
    PanelLabel{n} = ['Image',num2str(n)];
end
CallingLabel = IMLDipt.Struct.labelstr;

%---------------------------------------------
% Get Image
%---------------------------------------------
LoadAll = 0;
if not(isfield(IMLDipt,[CallingLabel,'_Data']))
    LoadAll = 1;
end
for n = 1:numfiles    
    if LoadAll == 1 || not(isfield(IMLDipt.([CallingLabel,'_Data']),[PanelLabel{n},'_Data']))
        if isfield(IMLDipt.(PanelLabel{n}).Struct,'selectedfile')
            file = IMLDipt.(PanelLabel{n}).Struct.selectedfile;
            if not(exist(file,'file'))
                err.flag = 1;
                err.msg = ['(Re) Load ',PanelLabel{n}];
                ErrDisp(err);
                return
            else
                Status2('busy',['(Re) Load ',PanelLabel{n}],2);
                [IMG,~,~,err] = Import_Image(file,'');
                saveData.IMG = IMG;
                saveData.path = file;
                IMLDipt.([CallingLabel,'_Data']).([PanelLabel{n},'_Data']) = saveData;
            end
        else
            err.flag = 1;
            err.msg = ['(Re) Load ',PanelLabel{n}];
            ErrDisp(err);
            return
        end
    end
    Data = IMLDipt.([CallingLabel,'_Data']).([PanelLabel{n},'_Data']);   

    %--------------------------------------------
    % Load Images
    %--------------------------------------------
    IMLD.IMG{n} = Data.IMG;   
end

Status2('done','',2);
Status2('done','',3);

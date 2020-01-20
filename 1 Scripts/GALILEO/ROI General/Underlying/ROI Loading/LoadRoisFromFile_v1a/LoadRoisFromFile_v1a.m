%=========================================================
% (v1a) 
%      
%=========================================================

function [SCRPTipt,SCRPTGBL,ROILD,err] = LoadRoisFromFile_v1a(SCRPTipt,SCRPTGBL,ROILDipt)

Status2('busy','Load Multiple Roi Files',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
ROILD.method = ROILDipt.Func;
numfiles = str2double(ROILDipt.('NumFiles').EntryStr);
for n = 1:numfiles
    PanelLabel{n} = ['Roi',num2str(n)];
end
CallingLabel = ROILDipt.Struct.labelstr;

%---------------------------------------------
% Get Roi
%---------------------------------------------
LoadAll = 0;
if not(isfield(ROILDipt,[CallingLabel,'_Data']))
    LoadAll = 1;
end
for n = 1:numfiles    
    if LoadAll == 1 || not(isfield(ROILDipt.([CallingLabel,'_Data']),[PanelLabel{n},'_Data']))
        if isfield(ROILDipt.(PanelLabel{n}).Struct,'selectedfile')
            file = ROILDipt.(PanelLabel{n}).Struct.selectedfile;
            path = ROILDipt.(PanelLabel{n}).Struct.selectedpath;
            if not(exist(file,'file'))
                err.flag = 1;
                err.msg = ['(Re) Load ',PanelLabel{n}];
                ErrDisp(err);
                return
            else
                Status2('busy',['(Re) Load ',PanelLabel{n}],2);
                load(file);
                if exist('saveData')
                    ROILDipt.([CallingLabel,'_Data']).([PanelLabel{n},'_Data']) = saveData;
                else
                    ROILDipt.([CallingLabel,'_Data']).([PanelLabel{n},'_Data']).path = path;
                    ROILDipt.([CallingLabel,'_Data']).([PanelLabel{n},'_Data']).loc = file;
                end
            end
        else
            err.flag = 1;
            err.msg = ['(Re) Load ',PanelLabel{n}];
            ErrDisp(err);
            return
        end
    end
    Data = ROILDipt.([CallingLabel,'_Data']).([PanelLabel{n},'_Data']);   

    %--------------------------------------------
    % Load Rois
    %--------------------------------------------
    ROILD.RoiInfo(n) = Data;   
end

Status2('done','',2);
Status2('done','',3);

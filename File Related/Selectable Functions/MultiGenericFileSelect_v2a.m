%==================================================================
% (V1a)
%      
%==================================================================

classdef MultiGenericFileSelect_v2a < handle

properties (SetAccess = private)                   
    Files
end

methods 
   
%==================================================================
% Constructor
%==================================================================  
function obj = MultiGenericFileSelect_v2a()              
end

%=================================================================
% InitViaCompass
%==================================================================  
function err = InitViaCompass(obj,CompassInput)    

    Status2('busy','Get Multiple Files',2);
    Status2('done','',3);
    
    err.flag = 0;
    err.msg = '';
    
    %---------------------------------------------
    % Get Input
    %---------------------------------------------
    numfiles = str2double(CompassInput.('NumFiles').EntryStr);
    if isnan(numfiles)
        err.flag = 1;
        err.msg = 'NumFiles cannot be empty';
        return
    end
    for n = 1:numfiles
        PanelLabel{n} = ['File',num2str(n)];
    end
    CallingLabel = CompassInput.Struct.labelstr;
    
    %---------------------------------------------
    % Get Image
    %---------------------------------------------
    LoadAll = 0;
    if not(isfield(CompassInput,[CallingLabel,'_Data']))
        LoadAll = 1;
    end
    for n = 1:numfiles    
        if LoadAll == 1 || not(isfield(CompassInput.([CallingLabel,'_Data']),[PanelLabel{n},'_Data']))
            if isfield(CompassInput.(PanelLabel{n}).Struct,'selectedfile')
                file = CompassInput.(PanelLabel{n}).Struct.selectedfile;
                if not(exist(file,'file'))
                    err.flag = 1;
                    err.msg = ['(Re) Select ',PanelLabel{n}];
                    ErrDisp(err);
                    return
                else
                    Status2('busy',['(Re) Select ',PanelLabel{n}],2);
                    ind = strfind(file,'\');
                    saveData.path = file(1:ind(end));
                    saveData.file = file(ind(end)+1:end);
                    CompassInput.([CallingLabel,'_Data']).([PanelLabel{n},'_Data']) = saveData;
                end
            else
                err.flag = 1;
                err.msg = ['(Re) Select ',PanelLabel{n}];
                ErrDisp(err);
                return
            end
        end
        Data = CompassInput.([CallingLabel,'_Data']).([PanelLabel{n},'_Data']);   
    
        %--------------------------------------------
        % Load Images
        %--------------------------------------------
        obj.Files{n} = Data;   
    end
    Status2('done','',2);
    Status2('done','',3);

end

%==================================================================
% CompassInterface
%==================================================================  
function [Interface] = CompassInterface(obj,Paths)    
    global MULTIFILELOAD
    m = 1;
    Interface{m,1}.entrytype = 'RunExtFunc';
    Interface{m,1}.labelstr = 'NumFiles';
    Interface{m,1}.entrystr = '';
    Interface{m,1}.buttonname = 'Select';
    Interface{m,1}.runfunc1 = 'MultiGenericFileSelect_v1a_NumFileSel';
    if isempty(MULTIFILELOAD)
        return
    end 
    for n = 1:MULTIFILELOAD.numfiles
        m = m+1;
        Interface{m,1}.entrytype = 'RunExtFunc';
        Interface{m,1}.labelstr = ['File',num2str(n)];
        Interface{m,1}.entrystr = '';
        Interface{m,1}.buttonname = 'Select';
        Interface{m,1}.runfunc1 = 'SelectGenericFileCur';
        Interface{m,1}.(Interface{m,1}.runfunc1).curloc = Paths.experimentsloc;
        Interface{m,1}.runfunc2 = 'SelectGenericFileDef';
        Interface{m,1}.(Interface{m,1}.runfunc2).defloc = Paths.experimentsloc;
    end
end 

end
end
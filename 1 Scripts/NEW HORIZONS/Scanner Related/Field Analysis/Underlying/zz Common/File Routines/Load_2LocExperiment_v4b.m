%====================================================
% (v4a)
%   - update for SMIS
%====================================================

function [FID1,FID2,Params,ExpDisp,err] = Load_2LocExperiment_v4b(path1,path2,Seq,Sys)

FID1 = [];
FID2 = [];
Params = [];
ExpDisp = [];

%==============================================
% Varian
%==============================================
if strcmp(Sys,'Varian')

    %------------------------------------------
    % Check for paths
    %------------------------------------------
    if not(exist([path1,filesep,'fid'],'file')) || not(exist([path2,filesep,'fid'],'file'))
        err.flag = 1;
        err.msg = [path1,filesep,'fid  - Path Is No Longer Valid'];
        return
    end
    
    %------------------------------------------
    % Load
    %------------------------------------------    
    func = str2func(['LoadVarian_',Seq]);
    [TP1,FID1,ParamsDisp,StudyDisp,err] = func(path1);
    if err.flag == 1
        return
    end
    [TP2,FID2,ParamsDisp,StudyDisp,err] = func(path2);
    if err.flag == 1
        return
    end
    [fs1,fs2,comperr] = comp_struct(TP1,TP2,'TP1','TP2');
    if not(isempty(comperr))
        err.flag = 1;
        err.msg = 'test files do not match';
        return
    else
        Params = TP1;
        ExpDisp.StudyDisp = StudyDisp;
        ExpDisp.ParamsDisp= ParamsDisp;
    end
  
    
%==============================================
% SMIS
%==============================================  
elseif strcmp(Sys,'SMIS')

    %------------------------------------------
    % Check for paths
    %------------------------------------------
    if not(exist(path1,'file')) || not(exist(path2,'file'))
        err.flag = 1;
        err.msg = [path1, '- No Longer Valid'];
        return
    end
    
    %------------------------------------------
    % Load
    %------------------------------------------     
    func = str2func(['LoadSMIS_',Seq]);
    [TP1,FID1,ParamsDisp,StudyDisp,err] = func(path1);
    if err.flag == 1
        return
    end
    [TP2,FID2,ParamsDisp,StudyDisp,err] = func(path2);
    if err.flag == 1
        return
    end
    [fs1,fs2,comperr] = comp_struct(TP1,TP2,'TP1','TP2');
    if not(isempty(comperr))
        err.flag = 1;
        err.msg = 'test files do not match';
        return
    else
        Params = TP1;
        ExpDisp.StudyDisp = StudyDisp;
        ExpDisp.ParamsDisp= ParamsDisp;
    end
end    
    


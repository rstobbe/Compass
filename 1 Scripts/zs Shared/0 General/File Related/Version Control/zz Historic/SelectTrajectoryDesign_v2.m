%=========================================================
% For Use with RWSUI B5+
%=========================================================

function [SCRPTipt,gbldata,err] = SelectTrajectoryDesign_v2(SCRPTipt,gbldata)

global RWSUIGBL

Status('busy','Select Trajectory File');
Status2('done','',2);
Status2('done','',3);

err.flag = 0; 
N = gbldata.RWSUI.N;
dataloc = SCRPTipt(N).runfuncinput{1};

if isfield(gbldata,'DefFileLoc');
    defsearch = SCRPTipt(strcmp('DefSearch',{SCRPTipt.labelstr})).entrystr;
    if iscell(defsearch)
        defsearch = SCRPTipt(strcmp('DefSearch',{SCRPTipt.labelstr})).entrystr{SCRPTipt(strcmp('DefSearch',{SCRPTipt.labelstr})).entryvalue};
    end
    if strcmp(defsearch,'Yes')
        dataloc = gbldata.DefFileLoc;
    end
end

[file,path] = uigetfile('ProjDes.mat','Select Trajectory File',dataloc);
if path == 0
    err.flag = 4;
    err.msg = 'Trajectory File Not Selected';
    return
end
loc = [path,file];
label = loc;
if length(label) > RWSUIGBL.fullwid
    ind = strfind(loc,filesep);
    n = 1;
    while true
        label = ['...',loc(ind(n):length(loc))];
        if length(label) < RWSUIGBL.fullwid
            break
        end
        n = n+1;
    end
end

SCRPTipt(N).entrystr = label;
SCRPTipt(N).runfuncoutput{1} = loc;
SCRPTipt(N).runfuncinput{1} = loc;

load(loc);
%whos
gbldata.(SCRPTipt(N).labelstr).PROJdgn = saveData.PROJdgn;
gbldata.(SCRPTipt(N).labelstr).AIDipt = saveData.AIDipt;
gbldata.(SCRPTipt(N).labelstr).ImpData = saveData.impdata;

suitemem = get(findobj('tag','SuiteMember'),'string');
if strcmp(suitemem,'PIONEER')
    scrptnum = 1;
    scrpt = 'des';
    file = 'ProjDes.mat';
    [Data,err] = ExternalLoad(scrptnum,scrpt,path,file);
    if err.flag ~= 0
        ErrDisp(err);
    end
    DispProjBasic(Data.AIDipt);
    reset = 0;
    DispProjName(Data.PROJdgn,reset);
end
    
Status('done','Trajectory File Selected');



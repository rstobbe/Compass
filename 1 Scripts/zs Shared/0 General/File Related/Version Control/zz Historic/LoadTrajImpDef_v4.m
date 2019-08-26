%=========================================================
% 
%=========================================================

function [SCRPTipt,SCRPTGBL,err] = LoadTrajImpDef_v4(SCRPTipt,SCRPTGBL)

global RWSUIGBL
global SCRPTPATHS

tab = SCRPTGBL.RWSUI.tab;

err.flag = 0;
err.msg = '';

if isempty(RWSUIGBL.Key)
    defaultfunc = 'Load From';
    Func = SCRPTGBL.CurrentScript.Func;
    Struct = SCRPTGBL.CurrentScript.Struct;
    defloc = Struct.(Func).defloc;    
elseif strcmp(RWSUIGBL.Key,'shift')
    defaultfunc = 'Load From';
    defloc = SCRPTPATHS.(tab)(SCRPTGBL.RWSUI.panelnum).outloc;
elseif strcmp(RWSUIGBL.Key,'control')
    defaultfunc = 'Make';
    Func = SCRPTGBL.CurrentScript.Func;
    Struct = SCRPTGBL.CurrentScript.Struct;
    defloc = Struct.(Func).defloc;
else
    defaultfunc = 'Load From';
    Func = SCRPTGBL.CurrentScript.Func;
    Struct = SCRPTGBL.CurrentScript.Struct;
    defloc = Struct.(Func).defloc;
end
RWSUIGBL.Key = '';
Func = SCRPTGBL.CurrentScript.Func;
Struct = SCRPTGBL.CurrentScript.Struct;
loadpanel = Struct.(Func).loadpanel;

switch defaultfunc
    case 'Make'
        Status('busy','Select Folder to Make Default');
        path = uigetdir(defloc,'Select Folder to Make Default');
        if path == 0
            err.flag = 4;
            err.msg = 'Default Folder Not Selected';
            return
        end
        SCRPTipt(SCRPTGBL.RWSUI.curpanipt).entrystruct.(Func).defloc = path;
        SCRPTipt(SCRPTGBL.RWSUI.curpanipt).entrystruct.('LoadTrajImpCur_v4').curloc = path;
        Status('done','Default Directory Selected');
        
    case 'Load From'        
        Status('busy','Select Trajectory Implementation File');
        [file,path] = uigetfile('IMP*.mat','Select Trajectory Implementation File',defloc);
        if path == 0
            err.flag = 4;
            err.msg = 'Trajectory Implementation File Not Selected';
            return
        end
        loc = [path,file];
        addpath(path);
        label = loc;
        if length(label) > RWSUIGBL.fullwid
            ind = strfind(loc,filesep);
            n = 1;
            loc1 = loc(1:length(loc)-4);
            while true
                label = ['...',loc1(ind(n):length(loc1))];
                if length(label) < RWSUIGBL.fullwid
                    break
                end
                n = n+1;
            end
        end
        
        SCRPTipt(SCRPTGBL.RWSUI.curpanipt).entrystr = label;
        SCRPTipt(SCRPTGBL.RWSUI.curpanipt).entrystruct.entrystr = label;
        SCRPTipt(SCRPTGBL.RWSUI.curpanipt).entrystruct.altval = 1;
        SCRPTipt(SCRPTGBL.RWSUI.curpanipt).entrystruct.selectedfile = loc;
        SCRPTipt(SCRPTGBL.RWSUI.curpanipt).entrystruct.('LoadTrajImpCur_v4').curloc = path;
        SCRPTPATHS.(tab)(SCRPTGBL.RWSUI.panelnum).outloc = path;
        
        if strcmp(loadpanel,'Yes')
            panelnum = 2;
            panel = 'imp';
            [ImpData,err] = LoadSelectedFile_B9(panelnum,panel,path,file);
            if err.flag
                ErrDisp(err);
            end
            ind = strfind(path,filesep);
            despath = path(1:ind(length(ind)-1));
            panelnum = 1;
            panel = 'des';
            file = 'ProjDes.mat';
            [DesData,err] = LoadSelectedFile_B9(panelnum,panel,despath,file);
            if err.flag ~= 0
                ErrDisp(err);
            end
            err.flag = 0;
            err.msg = '';
        else
            load(loc);
            %whos
            ImpData = saveData;
        end            
        ImpData.path = path;
        
        %---
        %FIGOBJS.(tab).Info.String = ImpData.IMP.ExpDisp;
        %---
        
        funclabel = SCRPTGBL.RWSUI.funclabel;
        callingfuncs = SCRPTGBL.RWSUI.callingfuncs;
        if isempty(callingfuncs)
            SCRPTGBL.([funclabel,'_Data']) = ImpData;
        elseif length(callingfuncs) == 1
            SCRPTGBL.([callingfuncs{1},'_Data']).([funclabel,'_Data']) = ImpData;
        elseif length(callingfuncs) == 2
            SCRPTGBL.([callingfuncs{1},'_Data']).([callingfuncs{2},'_Data']).([funclabel,'_Data']) = ImpData;
        end
        Status('done','Trajectory Implementation Loaded');
end



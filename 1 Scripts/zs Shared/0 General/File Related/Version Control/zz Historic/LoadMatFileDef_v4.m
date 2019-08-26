%=========================================================
% 
%=========================================================

function [SCRPTipt,SCRPTGBL,err] = LoadMatFileDef_v4(SCRPTipt,SCRPTGBL)

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
        Status('done','Default Directory Selected');

    case 'Load From'        
        [file,path] = uigetfile('*.mat','Select Mat File',defloc);
        if path == 0
            err.flag = 4;
            err.msg = 'Mat File Not Selected';
            return
        end
        loc = [path,file];
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
        SCRPTipt(SCRPTGBL.RWSUI.curpanipt).entrystruct.('LoadMatFileCur_v4').curloc = path;
        SCRPTPATHS.(tab)(SCRPTGBL.RWSUI.panelnum).outloc = path;

        load(loc);
        %whos
        saveData.path = path;

        funclabel = SCRPTGBL.RWSUI.funclabel;
        callingfuncs = SCRPTGBL.RWSUI.callingfuncs;
        if isempty(callingfuncs)
            SCRPTGBL.([funclabel,'_Data']) = saveData;
        elseif length(callingfuncs) == 1
            SCRPTGBL.([callingfuncs{1},'_Data']).([funclabel,'_Data']) = saveData;
        elseif length(callingfuncs) == 2
            SCRPTGBL.([callingfuncs{1},'_Data']).([callingfuncs{2},'_Data']).([funclabel,'_Data']) = saveData;
        end
        Status('done','Mat File Loaded');
end



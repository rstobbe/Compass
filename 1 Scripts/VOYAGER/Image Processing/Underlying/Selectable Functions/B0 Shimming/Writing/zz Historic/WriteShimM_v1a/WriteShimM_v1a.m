%=========================================================
% (v1a)
%   
%=========================================================

function [SCRPTipt,SCRPTGBL,WRTSHIM,err] = WriteShimM_v1a(SCRPTipt,SCRPTGBL,WRTSHIMipt,RWSUI)

global SCRPTPATHS
global RWSUIGBL

Status2('busy','Write Shim File',2);
Status2('done','',2);

err.flag = 0;
err.msg = '';

WRTSHIM = struct();
CallingLabel = WRTSHIMipt.Struct.labelstr;
%---------------------------------------------
% Tests
%---------------------------------------------
global TOTALGBL
val = get(findobj('tag','totalgbl'),'value');
auto = 0;
if not(isempty(val)) && val ~= 0
    Gbl = TOTALGBL{2,val};
    if isfield(Gbl,'AutoRecon')
        WRTSHIM.path = Gbl.SYSpath;
        loc = WRTSHIM.path;
        label = loc;
        if length(label) > RWSUIGBL.fullwid
            ind = strfind(loc,filesep);
            n = 1;
            while true
                label = ['...',loc(ind(n)+1:length(loc))];
                if length(label) <= RWSUIGBL.fullwid
                    break
                end
                n = n+1;
            end
        end
        inds = strcmp('WRTpath',{SCRPTipt.labelstr});
        indnum = find(inds==1);
        if length(indnum) > 1
            indnum = indnum(SCRPTGBL.RWSUI.scrptnum);
        end
        SCRPTipt(indnum).entrystr = label;
        SCRPTipt(indnum).entrystruct.entrystr = label;
        SCRPTipt(indnum).entrystruct.altval = 1;
        SCRPTipt(indnum).entrystruct.selectedfile = loc;
        SCRPTipt(indnum).entrystruct.('SelectDirCur_v4').curloc = loc; 
        SCRPTPATHS(RWSUI.panelnum).outloc = loc;
        setfunc = 1;
        DispScriptParam_B9(SCRPTipt,setfunc,RWSUI.panel);
        auto = 1;
        SCRPTGBL.([CallingLabel,'_Data']).('WRTpath_Data').path = WRTSHIM.path;
    end
end
if auto ~= 1
    if not(isfield(WRTSHIMipt,[CallingLabel,'_Data']))
        if isfield(WRTSHIMipt.('WRTpath').Struct,'selectedfile')
            file = WRTSHIMipt.('WRTpath').Struct.selectedfile;
            if not(exist(file,'file'))
                err.flag = 1;
                err.msg = '(Re) Load WRTpath';
                ErrDisp(err);
                return
            else
                WRTSHIMipt.([CallingLabel,'_Data']).('WRTpath_Data').path = file;
            end
        else
            err.flag = 1;
            err.msg = '(Re) Load WRTpath';
            ErrDisp(err);
            return
        end
    end
    WRTSHIM.path = WRTSHIMipt.([CallingLabel,'_Data']).('WRTpath_Data').path;
end

%---------------------------------------------
% Return Input
%---------------------------------------------
WRTSHIM.method = WRTSHIMipt.Func;

Status2('done','',2);
Status2('done','',3);

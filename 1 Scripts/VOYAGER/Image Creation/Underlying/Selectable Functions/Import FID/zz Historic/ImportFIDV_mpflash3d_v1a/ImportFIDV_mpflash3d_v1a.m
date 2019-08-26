%=========================================================
% (v1a)
%       
%=========================================================

function [SCRPTipt,FID,err] = ImportFIDV_mpflash3d_v1a(SCRPTipt,FIDipt,RWSUI)

global RWSUIGBL

Status2('busy','Load FID',2);
Status2('done','',2);

err.flag = 0;
err.msg = '';

FID = struct();
CallingLabel = FIDipt.Struct.labelstr;
%---------------------------------------------
% Tests
%---------------------------------------------
global TOTALGBL
val = get(findobj('tag','totalgbl'),'value');
auto = 0;
if not(isempty(val)) && val ~= 0
    Gbl = TOTALGBL{2,val};
    if isfield(Gbl,'AutoRecon')
        FID.path = Gbl.FIDpath;
        loc = Gbl.FIDpath;
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
        err = DisplayParamsVarian_v1([loc,filesep,'params']); 
        if err.flag
            return
        end
        inds = strcmp('FIDpath',{SCRPTipt.labelstr});
        indnum = find(inds==1);
        if length(indnum) > 1
            indnum = indnum(SCRPTGBL.RWSUI.scrptnum);
        end
        SCRPTipt(indnum).entrystr = label;
        SCRPTipt(indnum).entrystruct.entrystr = label;
        SCRPTipt(indnum).entrystruct.altval = 1;
        SCRPTipt(indnum).entrystruct.selectedfile = loc;
        SCRPTipt(indnum).entrystruct.(CallingLabel).curloc = loc;  
        setfunc = 1;
        DispScriptParam_B9(SCRPTipt,setfunc,RWSUI.panel);
        auto = 1;
    end
end
if auto ~= 1
    if not(isfield(FIDipt,[CallingLabel,'_Data']))
        if isfield(FIDipt.('FIDpath').Struct,'selectedfile')
            file = FIDipt.('FIDpath').Struct.selectedfile;
            if not(exist(file,'file'))
                err.flag = 1;
                err.msg = '(Re) Load FIDpath';
                ErrDisp(err);
                return
            else
                FIDipt.([CallingLabel,'_Data']).('FIDpath_Data').path = file;
            end
        else
            err.flag = 1;
            err.msg = '(Re) Load FIDpath';
            ErrDisp(err);
            return
        end
    end
    FID.path = FIDipt.([CallingLabel,'_Data']).('FIDpath_Data').path;
end

%---------------------------------------------
% Return Panel Input
%---------------------------------------------
FID.method = FIDipt.Func;

Status2('done','',2);
Status2('done','',3);





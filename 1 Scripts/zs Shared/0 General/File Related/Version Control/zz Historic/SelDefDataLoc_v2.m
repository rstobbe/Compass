%=========================================================
% 
%=========================================================

function [SCRPTipt,gbldata,err] = SelDefDataLoc_v2(SCRPTipt,gbldata)

error;              % old - update call

global RWSUIGBL

Status('busy','Select Default Data File Location');
Status2('done','',2);
Status2('done','',3);

err.flag = 0; 
N = gbldata.RWSUI.N;
dataloc = SCRPTipt(N).runfuncinput{1};

path = uigetdir(dataloc,'Select Default Search Location');
if path == 0
    err.flag = 1;
    err.msg = 'Default Data File Location Not Selected';
    return
end
loc = path;
label = loc;
if length(label) > RWSUIGBL.fullwid
    ind = strfind(loc,filesep);
    n = 1;
    while true
        label = ['...',loc(ind(n)+1:length(loc))];
        if length(label) < RWSUIGBL.fullwid
            break
        end
        n = n+1;
    end
end

SCRPTipt(N).entrystr = label;
SCRPTipt(N).runfuncoutput{1} = loc;
SCRPTipt(N).runfuncinput{1} = loc;
gbldata.DefFileLoc = loc;

Status('done','Default Data File Location Selected');



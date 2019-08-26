%=========================================================
% 
%=========================================================

function [SCRPTipt,runfuncdata,gbldata,err] = SelectFldAnlzData_v2(N,runfuncdata,gbldata,SCRPTipt)

Status('busy','Select Field Analysis File');
Status2('done','',2);
Status2('done','',3);

err.flag = 0; 
dataloc = runfuncdata{N};
if isempty(dataloc)
    dataloc = gbldata.DefFileLoc;
end
Sys = SCRPTipt(strcmp('System',{SCRPTipt.labelstr})).entrystr;
if iscell(Sys)
    Sys = SCRPTipt(strcmp('System',{SCRPTipt.labelstr})).entrystr{SCRPTipt(strcmp('System',{SCRPTipt.labelstr})).entryvalue};
end

if strcmp(Sys,'SMIS');
    [file,path] = uigetfile('*.MRD','Select Data File',dataloc);
    if path == 0
        err.flag = 3;
        err.msg = 'Data File Not Selected';
        return
    end
    loc = [path,file];
    ind = strfind(loc,filesep);
    if length(ind) > 2
        label = ['...',loc(ind(length(ind)-2)+1:length(loc))];
    else
        label = loc;
    end
    DisplayParamsSMIS_v1(loc);
elseif strcmp(Sys,'Varian');
    path = uigetdir(dataloc,'Select Data File');
    if path == 0
        err.flag = 3;
        err.msg = 'Data File Not Selected';
        return
    end
    loc = path;
    label = loc;
    if length(label) > 90
        ind = strfind(loc,filesep);
        n = 1;
        while true
            label = ['...',loc(ind(n)+1:length(loc))];
            if length(label) < 90
                break
            end
            n = n+1;
        end
    end
    DisplayParamsVarian_v1([loc,filesep,'params']);    
else
    err.flag = 1;
    err.msg = 'Select System First';
    return
end
runfuncdata{N} = path;
SCRPTipt(N).entrystr = label;

gbldata.FileLocs.(SCRPTipt(N).labelstr) = loc;

Status('done','Data File Selected');



%==================================================
% (v1c)
%       - update for RWSUI_BA
%==================================================

function [SCRPTipt,WRTPout,err] = WriteParamEccV_v1c(SCRPTipt,WRTP)

Status('busy','Write ECC Paramater File Varian');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

WRTPout = struct();
CallingLabel = WRTP.Struct.labelstr;

%---------------------------------------------
% Tests
%---------------------------------------------
if not(isfield(WRTP,[CallingLabel,'_Data']))
    if isfield(WRTP.('ParamDefLoc').Struct,'selectedfile')
        file = WRTP.('ParamDefLoc').Struct.selectedfile;
        if not(exist(file,'file'))
            err.flag = 1;
            err.msg = '(Re) Load ParamDefLoc';
            ErrDisp(err);
            return
        else
            WRTP.([CallingLabel,'_Data']).('ParamDefLoc_Data').path = file;
        end
    else
        err.flag = 1;
        err.msg = '(Re) Load ParamDefLoc';
        ErrDisp(err);
        return
    end
end

%---------------------------------------------
% Load Panel Input
%---------------------------------------------
WRTPout.ParamDefLoc = WRTP.([CallingLabel,'_Data']).('ParamDefLoc_Data').path;

%---------------------------------------------
% Get Local Variables
%---------------------------------------------
GradLoc = WRTP.GradLoc;

%-------------------------------------------------
% Name Parameter File
%-------------------------------------------------
[file,path] = uiputfile('*','Name Parameter File',WRTPout.ParamDefLoc);
if path == 0
    err.flag = 4;
    err.msg = 'Parameter File Not Written';
    return
end
WRTPout.ParamLoc = [path,file];

%-------------------------------------------------
% Write Label
%-------------------------------------------------
label = WRTPout.ParamLoc;
loc = label;
if length(label) > 62
    ind = strfind(loc,filesep);
    n = 1;
    while true
        label = ['...',loc(ind(n)+1:length(loc))];
        if length(label) < 62
            break
        end
        n = n+1;
    end
end
WRTPout.label = label;

%-------------------------------------------------
% Fix Paths
%-------------------------------------------------
inds = strfind(GradLoc,'\');
GradLoc(inds) = '/';
GradDir = GradLoc(4:length(GradLoc));
k = strfind(GradDir,'shapelib');
GradDir = GradDir(k+9:length(GradDir));

%-------------------------------------------------
% Write Parameter File
%-------------------------------------------------
fid = fopen(WRTPout.ParamLoc,'w+');
fprintf(fid,['GradPath = ''',GradDir,'''\n']);
fprintf(fid,['gontime = ',num2str(WRTP.gontime,'%11.6f'),'\n']);
fprintf(fid,['gval = ',num2str(WRTP.gval,'%11.6f'),'\n']);
fprintf(fid,['gvalinparam = ',num2str(WRTP.gvalinparam,'%11.6f'),'\n']);
fprintf(fid,['slewrate = ',num2str(WRTP.slewrate,'%11.6f'),'\n']);
fprintf(fid,['falltime = ',num2str(WRTP.falltime,'%11.6f'),'\n']);
fprintf(fid,['pnum = ',num2str(WRTP.pnum,'%11.6f'),'\n']);
fclose(fid);




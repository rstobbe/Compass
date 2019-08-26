%==================================================
% 
%==================================================

function [WRTP,err] = WriteParamEccV_v1d_Func(WRTP,INPUT)

Status2('busy','Write ECC Paramater File Varian',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
GradLoc = INPUT.GradLoc;
gontime = INPUT.gontime;
gval = INPUT.gval;
gvalinparam  = INPUT.gvalinparam;
slewrate = INPUT.slewrate;
falltime = INPUT.falltime;
pnum = INPUT.pnum;
clear INPUT

%-------------------------------------------------
% Name Parameter File
%-------------------------------------------------
[file,path] = uiputfile('*','Name Parameter File',WRTP.ParamDefLoc);
if path == 0
    err.flag = 4;
    err.msg = 'Parameter File Not Written';
    return
end
WRTP.ParamLoc = [path,file];

%-------------------------------------------------
% Write Label
%-------------------------------------------------
label = WRTP.ParamLoc;
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
WRTP.label = label;

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
fid = fopen(WRTP.ParamLoc,'w+');
fprintf(fid,['GradPath = ''',GradDir,'''\n']);
fprintf(fid,['gontime = ',num2str(gontime,'%11.6f'),'\n']);
fprintf(fid,['gval = ',num2str(gval,'%11.6f'),'\n']);
fprintf(fid,['gvalinparam = ',num2str(gvalinparam,'%11.6f'),'\n']);
fprintf(fid,['slewrate = ',num2str(slewrate,'%11.6f'),'\n']);
fprintf(fid,['falltime = ',num2str(falltime,'%11.6f'),'\n']);
fprintf(fid,['pnum = ',num2str(pnum,'%11.6f'),'\n']);
fclose(fid);

Status2('done','',2);
Status2('done','',3);



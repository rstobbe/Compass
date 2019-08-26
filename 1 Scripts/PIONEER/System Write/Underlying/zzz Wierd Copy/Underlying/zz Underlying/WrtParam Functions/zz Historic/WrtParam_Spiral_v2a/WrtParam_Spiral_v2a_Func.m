%=========================================================
% 
%=========================================================

function [WRTP,err] = WrtParam_Spiral_v2a_Func(WRTP,INPUT)

Status2('busy','Write Parameter Files',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%-------------------------------------------------
% Get input
%-------------------------------------------------
IMP = INPUT.IMP;
WRT = INPUT.WRT;
clear INPUT

%-------------------------------------------------
% Name Parameter File
%-------------------------------------------------
[file,path] = uiputfile('*','Name Parameter File',WRTP.ParamDefLoc);
if path == 0
    err.flag = 1;
    err.msg = 'Parameter File Not Written';
    return
end
WRTP.ParamLoc = [path,file];
WRTP.ProjSet = file;

%-------------------------------------------------
% Fix Paths
%-------------------------------------------------
GradLoc = WRT.GradLoc;
inds = strfind(GradLoc,'\');
GradLoc(inds) = '/';
GradDir = GradLoc(4:length(GradLoc));
k = strfind(GradDir,'shapelib');
GradDir = GradDir(k+9:length(GradDir));
inds = strfind(GradDir,'/');
GradDir = GradDir(1:inds(length(inds)));

%-------------------------------------------------
% 'gorder' modify for spiral
%-------------------------------------------------
% if strcmp(IMP.GWFM.GCOMP.gorder,'zyx')
%     IMP.GWFM.GCOMP.gorder = 'yx';
%     IMP.GWFM.GCOMP.ygshift = 0;
% elseif strcmp(IMP.GWFM.GCOMP.gorder,'xyz')
%     IMP.GWFM.GCOMP.gorder = 'xy';
%     IMP.GWFM.GCOMP.ygshift = 0;
% end

%-------------------------------------------------
% Write Parameter File
%-------------------------------------------------
fid = fopen([path,file],'w+');
fprintf(fid,['ProjSet = ''',WRTP.ProjSet,'''\n']);
fprintf(fid,['GradPath = ''',GradDir,'''\n']);
fprintf(fid,'\n');
fprintf(fid,['gcoil = ''',IMP.GWFM.GCOMP.gcoil,'''\n']);
fprintf(fid,['graddel = ',num2str(IMP.GWFM.GCOMP.graddel,'%11.6g'),'\n']);
fprintf(fid,['xgshift = ',num2str(IMP.GWFM.GCOMP.xgshift,'%11.6g'),'\n']);
fprintf(fid,['ygshift = ',num2str(IMP.GWFM.GCOMP.ygshift,'%11.6g'),'\n']);
fprintf(fid,['zgshift = ',num2str(IMP.GWFM.GCOMP.zgshift,'%11.6g'),'\n']);
fprintf(fid,['gorder = ''',IMP.GWFM.GCOMP.gorder,'''\n']);
fprintf(fid,'\n');
fprintf(fid,['vox = ',num2str(IMP.impPROJdgn.vox,'%11.6g'),'\n']);
fprintf(fid,['fov = ',num2str(IMP.impPROJdgn.fov,'%11.6g'),'\n']);
fprintf(fid,['elip = ',num2str(IMP.impPROJdgn.elip,'%11.6g'),'\n']);
fprintf(fid,['nproj = ',num2str(IMP.impPROJdgn.nproj,'%11.6g'),'\n']);
fprintf(fid,'\n');
fprintf(fid,['tro = ',num2str(IMP.PROJimp.tro,'%11.6g'),'\n']);
fprintf(fid,['np = ',num2str(IMP.PROJimp.npro*2,'%11.6g'),'\n']);
fprintf(fid,['sampstart = ',num2str(IMP.PROJimp.sampstart*1000,'%11.6g'),'\n']);
fprintf(fid,['dwell = ',num2str(IMP.PROJimp.dwell*1000,'%11.6g'),'\n']);
fprintf(fid,['fb = ',num2str(IMP.TSMP.filtBW,'%11.6g'),'\n']);
fprintf(fid,['tgwfm = ',num2str(IMP.GWFM.tgwfm,'%11.6g'),'\n']);

%-------------------------------------------------
% Write Experiment Arrays
%-------------------------------------------------
fprintf(fid,'\n');
nproj = IMP.impPROJdgn.nproj;
projmult = IMP.SYS.projmult;
split = IMP.SYS.split;
divs = nproj/projmult;
fprintf(fid,['divs = ',num2str(divs),'\n']);
fprintf(fid,['pnum = ',num2str(projmult),'\n']);
fprintf(fid,['split = ',num2str(split),'\n']);

if strcmp(IMP.SYS.sym,'PosNeg');
    for n = 1:split
        strtno = (n-1)*(nproj/2)/split+1;
        stpno = n*(nproj/2)/split;
        fprintf(fid,['pstart',num2str(n),' = ',num2str(strtno)]);
        for i = strtno+projmult:projmult:stpno
            fprintf(fid,',');
            fprintf(fid,num2str(i));
        end
        fprintf(fid,[',',num2str(-strtno)]);    
        for i = strtno+projmult:projmult:stpno
            fprintf(fid,',');
            fprintf(fid,num2str(-i));
        end
        fprintf(fid,'\n');
    end
else
    for n = 1:split
        strtno = (n-1)*(nproj)/split+1;
        stpno = n*(nproj)/split;
        fprintf(fid,['pstart',num2str(n),' = ',num2str(strtno)]);
        for i = strtno+projmult:projmult:stpno
            fprintf(fid,',');
            fprintf(fid,num2str(i));
        end
        fprintf(fid,'\n');
    end
end
fclose(fid);

Status2('done','',2);
Status2('done','',3);

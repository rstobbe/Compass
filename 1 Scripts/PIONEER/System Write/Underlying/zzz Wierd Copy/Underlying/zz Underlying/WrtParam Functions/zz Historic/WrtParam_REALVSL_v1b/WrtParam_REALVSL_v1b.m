%=========================================================
% 
%=========================================================

function [WRT,SCRPTipt,err] = WrtParam_REALVSL_v1b(WRT,SCRPTipt,err)

Status('busy','Write Param Files');

err.flag = 0;
err.msg = '';

ParamDefLoc = WRT.wrtparamfunc.Struct.('ParamDefLoc');

%-------------------------------------------------
% Name Parameter File
%-------------------------------------------------
[file,path] = uiputfile('*','Name Parameter File',ParamDefLoc);
if path == 0
    err.flag = 1;
    err.msg = 'Parameter File Not Written';
    return
end
WRT.ParamLoc = [path,file];

%-------------------------------------------------
% Fix Paths
%-------------------------------------------------
GradLoc = WRT.GradLoc;
inds = strfind(GradLoc,'\');
GradLoc(inds) = '/';
GradDir = GradLoc(4:length(GradLoc));
k = strfind(GradDir,'shapelib');
GradDir = GradDir(k+9:length(GradDir));

RefocusLoc = WRT.RefocusLoc;
inds = strfind(WRT.RefocusLoc,'\');
RefocusLoc(inds) = '/';
RefocusDir = RefocusLoc(4:length(RefocusLoc));
k = strfind(RefocusDir,'tablib');
RefocusDir = RefocusDir(k+7:length(RefocusDir));

%-------------------------------------------------
% Write Parameter File
%-------------------------------------------------
fid = fopen([path,file],'w+');
fprintf(fid,['GradPath = ''',GradDir,'''\n']);
fprintf(fid,['RefocusPath = ''',RefocusDir,'''\n']);
fprintf(fid,'\n');
fprintf(fid,['vox = ',num2str(WRT.vox,'%11.6g'),'\n']);
fprintf(fid,['fov = ',num2str(WRT.fov,'%11.6g'),'\n']);
fprintf(fid,['nproj = ',num2str(WRT.nproj,'%11.6g'),'\n']);
fprintf(fid,'\n');
fprintf(fid,['tro = ',num2str(WRT.tro,'%11.6g'),'\n']);
fprintf(fid,['np = ',num2str(WRT.npro*2,'%11.6g'),'\n']);
fprintf(fid,['sampstart = ',num2str(WRT.sampstart*1000,'%11.6g'),'\n']);
fprintf(fid,['dwell = ',num2str(WRT.dwell*1000,'%11.6g'),'\n']);
fprintf(fid,['fb = ',num2str(WRT.filBW,'%11.6g'),'\n']);
fprintf(fid,['tgwfm = ',num2str(WRT.tgwfm,'%11.6g'),'\n']);

%-------------------------------------------------
% Write Experiment Arrays
%-------------------------------------------------
fprintf(fid,'\n');
divs = WRT.nproj/WRT.projmult;
fprintf(fid,['divs = ',num2str(divs),'\n']);
fprintf(fid,['pnum = ',num2str(WRT.projmult),'\n']);
fprintf(fid,['split = ',num2str(WRT.split),'\n']);

if strcmp(WRT.sym,'PosNeg');
    for n = 1:WRT.split
        strtno = (n-1)*(WRT.nproj/2)/WRT.split+1;
        stpno = n*(WRT.nproj/2)/WRT.split;
        fprintf(fid,['pstart',num2str(n),' = ',num2str(strtno)]);
        for i = strtno+WRT.projmult:WRT.projmult:stpno
            fprintf(fid,',');
            fprintf(fid,num2str(i));
        end
        fprintf(fid,[',',num2str(-strtno)]);    
        for i = strtno+WRT.projmult:WRT.projmult:stpno
            fprintf(fid,',');
            fprintf(fid,num2str(-i));
        end
        fprintf(fid,'\n');
    end
else
    for n = 1:WRT.split
        strtno = (n-1)*(WRT.nproj)/WRT.split+1;
        stpno = n*(WRT.nproj)/WRT.split;
        fprintf(fid,['pstart',num2str(n),' = ',num2str(strtno)]);
        for i = strtno+WRT.projmult:WRT.projmult:stpno
            fprintf(fid,',');
            fprintf(fid,num2str(i));
        end
        fprintf(fid,'\n');
    end
end

fclose(fid);

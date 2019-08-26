%=========================================================
% 
%=========================================================

function [SCRPTipt,SCRPTGBL,err] = WriteParamEccV_v1b(SCRPTipt,SCRPTGBL)

err.flag = 0;

%-------------------------------------------------
% Name Parameter File
%-------------------------------------------------
ParamDefLoc = SCRPTipt(strcmp('ParamDefLoc',{SCRPTipt.labelstr})).runfuncoutput{1};
[file,path] = uiputfile('*','Name Parameter File',ParamDefLoc);
if path == 0
    err.flag = 1;
    err.msg = 'Parameter File Not Written';
    return
end
SCRPTGBL.ParamFile.loc = [path,file];

%-------------------------------------------------
% Fix Paths
%-------------------------------------------------
GradLoc = SCRPTGBL.ParamFile.GradLoc;
inds = strfind(GradLoc,'\');
GradLoc(inds) = '/';
GradDir = GradLoc(4:length(GradLoc));
k = strfind(GradDir,'shapelib');
GradDir = GradDir(k+9:length(GradDir));

%-------------------------------------------------
% Write Parameter File
%-------------------------------------------------
fid = fopen([path,file],'w+');
fprintf(fid,['GradPath = ''',GradDir,'''\n']);
fprintf(fid,['graddur = ',num2str(SCRPTGBL.ParamFile.graddur,'%11.6f'),'\n']);
fprintf(fid,['pnum = ',num2str(SCRPTGBL.ParamFile.pnum,'%11.6f'),'\n']);
fclose(fid);




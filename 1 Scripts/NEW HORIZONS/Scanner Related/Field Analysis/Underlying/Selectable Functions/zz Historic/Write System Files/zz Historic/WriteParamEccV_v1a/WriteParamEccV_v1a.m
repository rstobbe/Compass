%=========================================================
% 
%=========================================================

function [SCRPTipt,Output,err] = WriteParamEccV_v1a(SCRPTipt,SCRPTGBL,Input)

err.flag = 0;
Output = struct();
if isfield(SCRPTGBL,'ParamDefLoc')
    ParamDefLoc = SCRPTGBL.ParamDefLoc.DirLoc;
else
    ParamDefLoc = '';
end

%-------------------------------------------------
% Name Parameter File
%-------------------------------------------------
file = strtok(Input.file);
[file,path] = uiputfile(file,'Name Parameter File',ParamDefLoc);
if path == 0
    err.flag = 1;
    err.msg = 'Parameter File Not Written';
    return
end
Output.ParamLoc = [path,file];

%-------------------------------------------------
% Fix Paths
%-------------------------------------------------
inds = strfind(Input.GradLoc,'\');
Input.GradLoc(inds) = '/';
GradDir = Input.GradLoc(4:length(Input.GradLoc));
k = strfind(GradDir,'shapelib');
GradDir = GradDir(k+9:length(GradDir));

%-------------------------------------------------
% Write Parameter File
%-------------------------------------------------
fid = fopen([path,file],'w+');
fprintf(fid,['GradPath = ''',GradDir,'''\n']);
fprintf(fid,['graddur = ',num2str(Input.graddur,'%11.6f'),'\n']);
fprintf(fid,['pnum = ',num2str(Input.pnum,'%11.6f'),'\n']);
fclose(fid);




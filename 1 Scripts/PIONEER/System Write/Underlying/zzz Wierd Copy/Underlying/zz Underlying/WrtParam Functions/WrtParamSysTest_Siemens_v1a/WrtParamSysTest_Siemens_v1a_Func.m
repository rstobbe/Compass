%=========================================================
%
%=========================================================

function [PRMWRT,err] = WrtParamSysTest_Siemens_v1a_Func(PRMWRT,INPUT)

Status2('busy','Write Parameters for Siemens SysTest Acquisition',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%-------------------------------------------------
% Get input
%-------------------------------------------------
IMP = INPUT.IMP;
G = INPUT.G;
clear INPUT
sz = size(G);

%-------------------------------------------------
% Name Waveform
%-------------------------------------------------
name = ['SysTest_',IMP.GWFM.SuggestedName,'.rws'];
[file,path] = uiputfile('*.rws','Name Acquisition',[IMP.path,name]);
if path == 0
    err.flag = 4;
    err.msg = '';
    return
end

ind1 = strfind(file,IMP.GWFM.Type);
ind2 = strfind(file,'.rws');
if IMP.GWFM.Dir == 1 && not(strcmp(file(ind2-1),'X'))
    error
elseif IMP.GWFM.Dir == 2 && not(strcmp(file(ind2-1),'Y'))
    error
elseif IMP.GWFM.Dir == 3 && not(strcmp(file(ind2-1),'Z'))
    error
end  

PRMWRT.id = file(ind1+2:ind2-2);

fid = fopen([path,file],'w+');
%-------------------------------------------------
% Write Parameter File
%-------------------------------------------------
fprintf(fid,'####################################\n');
fprintf(fid,'# R.W.Stobbe\n');
fprintf(fid,'####################################\n');
fprintf(fid,['type:',num2str(IMP.GWFM.EnumType,'%11.6g'),'\n']);                           % update
fprintf(fid,['id:',num2str(PRMWRT.id,'%11.6g'),'\n']);
fprintf(fid,['nproj:',num2str(IMP.PROJimp.nproj,'%11.6g'),'\n']);
fprintf(fid,['tro:',num2str(IMP.PROJimp.tro*1000,'%11.6g'),'\n']);
fprintf(fid,['np:',num2str(IMP.PROJimp.npro,'%11.6g'),'\n']);
fprintf(fid,['os:',num2str(IMP.PROJimp.os,'%11.6g'),'\n']);
fprintf(fid,['dwell:',num2str(IMP.PROJimp.dwell*1000000,'%11.6g'),'\n']);
fprintf(fid,['tgwfm:',num2str(IMP.GWFM.tgwfm*1000,'%11.6g'),'\n']);
fprintf(fid,['gmax:',num2str(max(abs(G(:))),'%11.6g'),'\n']);
fprintf(fid,['dir:',num2str(IMP.GWFM.Dir,'%11.6g'),'\n']);   
fprintf(fid,['gpts:',num2str(sz(2),'%11.6g'),'\n']);
fprintf(fid,'####################################\n');
fclose(fid);

PRMWRT.path = path;
PRMWRT.file = file;
PRMWRT.name = file(9:end-4);

Status2('done','',2);
Status2('done','',3);

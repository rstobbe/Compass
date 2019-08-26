%=========================================================
%
%=========================================================

function [PRMWRT,err] = WrtParamTPI_Siemens_v1a_Func(PRMWRT,INPUT)

Status2('busy','Write Parameters for Siemens TPI Acquisition',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%-------------------------------------------------
% Get input
%-------------------------------------------------
IMP = INPUT.IMP;
fid = INPUT.fid;
G = INPUT.G;
clear INPUT
sz = size(G);

test = IMP.impPROJdgn

%-------------------------------------------------
% Write Parameter File
%-------------------------------------------------
fprintf(fid,'####################################\n');
fprintf(fid,'# R.W.Stobbe\n');
fprintf(fid,'####################################\n');
fprintf(fid,['type:',num2str(10,'%11.6g'),'\n']);                           % update
fprintf(fid,['fov:',num2str(IMP.impPROJdgn.fov,'%11.6g'),'\n']);
fprintf(fid,['x:',num2str(IMP.impPROJdgn.vox,'%11.6g'),'\n']);
fprintf(fid,['y:',num2str(IMP.impPROJdgn.vox,'%11.6g'),'\n']);
fprintf(fid,['z:',num2str(IMP.impPROJdgn.vox/IMP.impPROJdgn.elip,'%11.6g'),'\n']);
fprintf(fid,['tro:',num2str(IMP.PROJimp.tro*1000,'%11.6g'),'\n']);
fprintf(fid,['nproj:',num2str(IMP.impPROJdgn.nproj,'%11.6g'),'\n']);
fprintf(fid,['rsnr:',num2str(round(IMP.KSMP.rSNR),'%11.6g'),'\n']);
fprintf(fid,['np:',num2str(IMP.PROJimp.npro,'%11.6g'),'\n']);
fprintf(fid,['dwell:',num2str(IMP.PROJimp.dwell*1000000,'%11.6g'),'\n']);
fprintf(fid,['tgwfm:',num2str(IMP.GWFM.tgwfm*1000,'%11.6g'),'\n']);
fprintf(fid,['gmax:',num2str(max(G(:)),'%11.6g'),'\n']);
fprintf(fid,['gpts:',num2str(sz(2),'%11.6g'),'\n']);
fprintf(fid,'####################################\n');

Status2('done','',2);
Status2('done','',3);

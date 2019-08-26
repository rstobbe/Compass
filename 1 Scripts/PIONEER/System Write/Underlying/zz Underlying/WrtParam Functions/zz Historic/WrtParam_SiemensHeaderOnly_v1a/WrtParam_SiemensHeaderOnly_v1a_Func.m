%=========================================================
%
%=========================================================

function [PRMWRT,err] = WrtParam_SiemensHeaderOnly_v1a_Func(PRMWRT,INPUT)

Status2('busy','Write Siemens Header Only',3);

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
% Organize
%-------------------------------------------------
if strcmp(IMP.DES.type,'YB') || strcmp(IMP.DES.type,'LR') || strcmp(IMP.DES.type,'LR1a')
    stype = 'YB';
    ntype = num2str(10,'%2.0f');
end

if strcmp(IMP.DES.SPIN.type,'Uniform')
    sspin = num2str(10,'%2.0f');
elseif strcmp(IMP.DES.SPIN.type,'UnderKaiser')
    sspin = num2str(20,'%2.0f');
elseif strcmp(IMP.DES.SPIN.type,'UnderSamp')
    sspin = num2str(20,'%2.0f');
elseif strcmp(IMP.DES.SPIN.type,'KaiserShaped')
    sspin = num2str(20,'%2.0f');
end

%-------------------------------------------------
% Name Waveform
%-------------------------------------------------
id = inputdlg('Enter ID');
if isempty(id)
    err.flag = 4;
    return
end
id = id{1};
sfov = num2str(IMP.impPROJdgn.fov,'%3.0f');
svox = num2str(10*(IMP.impPROJdgn.vox^3)/IMP.impPROJdgn.elip,'%3.0f');
selip = num2str(100*IMP.impPROJdgn.elip,'%3.0f');
stro = num2str(10*IMP.impPROJdgn.tro,'%3.0f');
snproj = num2str(sz(1),'%4.0f');
sp = num2str(1000*IMP.impPROJdgn.p,'%4.0f');
susamp = num2str(IMP.DES.SPIN.number,'%4.0f');
nusamp = num2str(str2double(IMP.DES.SPIN.number)/100,'%4.2f');

name = [stype,'_F',sfov,'_V',svox,'_E',selip,'_T',stro,'_N',snproj,'_P',sp,'_S',sspin,susamp,'_ID',id];
[file,path] = uiputfile('*.hdr','Name Acquisition',[IMP.path,name,'.hdr']);
if path == 0
    err.flag = 3;
    err.msg = 'User Aborted';
    return
end
fid = fopen([path,file],'w+');

%-------------------------------------------------
% Write Parameter File
%-------------------------------------------------
fprintf(fid,'####################################\n');
fprintf(fid,'# R.W.Stobbe\n');
fprintf(fid,'####################################\n');
fprintf(fid,['type:',ntype,'\n']);                          
fprintf(fid,['fov:',num2str(IMP.impPROJdgn.fov,'%11.6g'),'\n']);
fprintf(fid,['x:',num2str(IMP.GWFM.ORNT.dimx,'%11.6g'),'\n']);
fprintf(fid,['y:',num2str(IMP.GWFM.ORNT.dimy,'%11.6g'),'\n']);
fprintf(fid,['z:',num2str(IMP.GWFM.ORNT.dimz,'%11.6g'),'\n']);
fprintf(fid,['tro:',num2str(IMP.TSMP.tro*1000,'%11.6g'),'\n']);
fprintf(fid,['nproj:',num2str(sz(1),'%11.6g'),'\n']);
fprintf(fid,['rsnr:',num2str(round(IMP.KSMP.rSNR),'%11.6g'),'\n']);
fprintf(fid,['p:',num2str(round(IMP.impPROJdgn.p*1000),'%11.6g'),'\n']);
fprintf(fid,['spin:',sspin,'\n']);
fprintf(fid,['usamp:',nusamp,'\n']);
fprintf(fid,['id:',id,'\n']);
fprintf(fid,['np:',num2str(IMP.TSMP.nproProt,'%11.6g'),'\n']);
fprintf(fid,['os:',num2str(IMP.TSMP.sysoversamp,'%11.6g'),'\n']);
fprintf(fid,['dwell:',num2str(IMP.TSMP.dwellProt*1000000,'%11.6g'),'\n']);
fprintf(fid,['tgwfm:',num2str(IMP.GWFM.tgwfm*1000,'%11.6g'),'\n']);
fprintf(fid,['gmax:',num2str(max(abs(G(:))),'%11.6g'),'\n']);
fprintf(fid,['gpts:',num2str(sz(2),'%11.6g'),'\n']);
fprintf(fid,'####################################\n');
fclose(fid);

PRMWRT.path = path;
PRMWRT.file = file;
PRMWRT.name = name;

Status2('done','',3);
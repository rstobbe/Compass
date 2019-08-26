%=========================================================
%
%=========================================================

function [PRMWRT,err] = WrtParam_SiemensRadial3D_v1a_Func(PRMWRT,INPUT)

Status2('busy','Write Parameters for Siemens Radial3D',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%-------------------------------------------------
% Get input
%-------------------------------------------------
IMP = INPUT.IMP;
G = INPUT.G;
recononly = INPUT.recononly;
clear INPUT
sz = size(G);

%-------------------------------------------------
% Test
%-------------------------------------------------
if not(strcmp(IMP.DES.type,'Rad3D'))
    err.flag = 1;
    err.msg = 'WrtParam function only for Radial3D designs';
    return
end

%-------------------------------------------------
% Orient
%-------------------------------------------------
if isfield(IMP,'ORNT')
    ORNT = IMP.ORNT;
elseif isfield(IMP.GWFM,'ORNT')
    ORNT = IMP.GWFM.ORNT;
end
%----------
dimx = ORNT.dimx;                                           % Radial3D has no elip support
dimy = ORNT.dimy; 
dimz = ORNT.dimz; 
%----------

%-------------------------------------------------
% Organize
%-------------------------------------------------
stype = 'YB';                                               % Because I don't want to code another Siemens case for this
ntype = num2str(10,'%2.0f');
sspin = num2str(10,'%2.0f');                                % No meaning

%-------------------------------------------------
% Name Waveform
%-------------------------------------------------
ind = strfind(IMP.name,'ID');
if isempty(ind)
    id = '';
else
    id = IMP.name(ind+2:end);
end
input{1} = id;
id = inputdlg('Enter ID','ID',1,input);
if isempty(id)
    err.flag = 4;
    return
end
id = id{1};
sfov = num2str(IMP.impPROJdgn.fov,'%3.0f');
svox = num2str(10*(IMP.impPROJdgn.vox^3),'%3.0f');
selip = num2str(100,'%3.0f');                               % No Elip
stro = num2str(10*IMP.impPROJdgn.tro,'%3.0f');
snproj = num2str(sz(1),'%4.0f');
sp = num2str(1000,'%4.0f');                                 % p = 1
susamp = num2str(round(100*IMP.impPROJdgn.projosamp),'%4.0f');
nusamp = num2str(round(100*IMP.impPROJdgn.projosamp)/100,'%4.2f');

name = [stype,'_F',sfov,'_V',svox,'_E',selip,'_T',stro,'_N',snproj,'_P',sp,'_S',sspin,susamp,'_ID',id];

if strcmp(recononly,'Yes')
    PRMWRT.name = name;
    return
end

[file,path] = uiputfile('*.rws','Name Acquisition',[IMP.path,name,'.rws']);
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
%----------
% fprintf(fid,['x:',num2str(ORNT.dimx,'%11.6g'),'\n']);             % hack
% fprintf(fid,['y:',num2str(ORNT.dimy,'%11.6g'),'\n']);
% fprintf(fid,['z:',num2str(ORNT.dimz,'%11.6g'),'\n']);
fprintf(fid,['x:',num2str(dimx,'%11.6g'),'\n']);
fprintf(fid,['y:',num2str(dimy,'%11.6g'),'\n']);
fprintf(fid,['z:',num2str(dimz,'%11.6g'),'\n']);
%----------
fprintf(fid,['tro:',num2str(IMP.TSMP.tro*1000,'%11.6g'),'\n']);
fprintf(fid,['nproj:',num2str(sz(1),'%11.6g'),'\n']);
fprintf(fid,['rsnr:',num2str(round(IMP.KSMP.rSNR),'%11.6g'),'\n']);
fprintf(fid,['p:',num2str(1000,'%11.6g'),'\n']);
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

Status2('done','',2);
Status2('done','',3);

%=========================================================
%
%=========================================================

function [SYSWRT,err] = SysWrt_DummyYarnBall_v1a_Func(SYSWRT,INPUT)

Status2('busy','Dummy Write',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%-------------------------------------------------
% Get input
%-------------------------------------------------
IMP = INPUT.IMP;
G = INPUT.G; 
clear INPUT

%---------------------------------------------
% Add Dummies
%---------------------------------------------
if SYSWRT.dummies > 0
    Gtraj1 = G(1,:,:);
    GDum = repmat(Gtraj1,[SYSWRT.dummies,1,1]);
    G = cat(1,GDum,G);
end
sz = size(G);

%-------------------------------------------------
% Organize
%-------------------------------------------------
if not(strcmp(IMP.DES.type,'YB'))
    err.flag = 1;
    err.msg = 'WrtSysfunc only for ''YB''';
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
SYSWRT.name = ['YB_F',sfov,'_V',svox,'_E',selip,'_T',stro,'_N',snproj,'_P',sp,'_S',sspin,susamp,'_ID',id];

%--------------------------------------------
% Panel
%--------------------------------------------
Panel(1,:) = {'','','Output'};
Panel(2,:) = {'',SYSWRT.method,'Output'};
Panel(3,:) = {'Dummies',SYSWRT.dummies,'Output'};
SYSWRT.PanelOutput = cell2struct(Panel,{'label','value','type'},2);

Status2('done','',2);
Status2('done','',3);


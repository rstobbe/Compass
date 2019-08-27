%=====================================================
% 
%=====================================================

function [FIDR,err] = FidRearrange_UserMash_v1a_Func(FIDR,INPUT)

Status2('busy','Data Organization',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
DATA = INPUT.FID.DATA;
twix = DATA.twix;
clear INPUT

%---------------------------------------------
% Load User Mash File
%---------------------------------------------
UserMash = [];
load(FIDR.UserMashFile.loc);

%---------------------------------------------
% Data Array Setup
%---------------------------------------------
Nproj = DATA.DataInfo.NLin;
Npro = DATA.DataInfo.NCol;
Nexp = 1;                                   % fixup
Nrcvrs = DATA.DataInfo.NCha;
Naverages = DATA.DataInfo.NAve; 

UserMash(1,1) = Nproj;
UserMash(1,2) = Naverages;
UserMash(2,1) = Nproj;
UserMash(2,2) = Naverages;

%---------------------------------------------
% Traj/Ave Use
%---------------------------------------------
FIDmat = zeros([Nproj,Npro,Nexp,Nrcvrs]);
multiusearray = zeros([Nproj,1]);
for n = 1:length(UserMash)
    %tic
    FIDmat0 = twix.image(:,:,UserMash(n,1),:,:,UserMash(n,2));
    %toc
    FIDmat0 = permute(FIDmat0,[3,1,4,2]);
    %toc
    FIDmat(UserMash(n,1),:,:,:) = FIDmat(UserMash(n,1),:,:,:) + FIDmat0;
    multiusearray(UserMash(n,1)) = multiusearray(UserMash(n,1)) + 1;
    %toc
    if rem((length(UserMash)-n+1),100) == 0
        Status2('busy',num2str(length(UserMash)-n+1),3);
    end
    %toc
end
multiusearray(multiusearray == 0) = 1;
for n = 1:Nproj
    FIDmat(n,:,:,:) = FIDmat(n,:,:,:)/multiusearray(n);
    if rem((Nproj-n),100) == 0
        Status2('busy',num2str(Nproj-n),3);
    end
end

%---------------------------------------------
% Return
%---------------------------------------------    
Panel(1,:) = {'','','Output'};
Panel(2,:) = {'',FIDR.method,'Output'};
PanelOutput = cell2struct(Panel,{'label','value','type'},2);
FIDR.PanelOutput = PanelOutput;

FIDR.FIDmat = FIDmat;
clear INPUT;  

Status2('done','',2);
Status2('done','',3);


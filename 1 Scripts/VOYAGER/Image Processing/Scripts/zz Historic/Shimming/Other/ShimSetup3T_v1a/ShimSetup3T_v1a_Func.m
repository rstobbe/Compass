%===========================================
% 
%===========================================

function [IMG,err] = ShimSetup3T_v1a_Func(IMG,INPUT)

Status('busy','Shim Setup 3T');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Test
%---------------------------------------------
IMG1 = INPUT.IMG1;
IMG2 = INPUT.IMG2;
ShimFile = INPUT.ShimFile;
clear INPUT;

%---------------------------------------------
% Load ShimFile
%---------------------------------------------
file = fopen(ShimFile);
if file == -1
    error();
end
A = fread(file);
Text = char(A');
fclose(file);

n = 1;
while true
    ind = strfind(Text,10);
    if isempty(ind)
        break
    end
    Text0 = Text(1:ind(1)-1);
    Text = Text(ind(1)+1:end);
    ind = strfind(Text0,32);
    shimval(n) = str2double(Text0(ind(1)+1:ind(2)-1));
    shimname{n} = Text0(ind(end)+1:end-1);
    Shim.(shimname{n}) = shimval(n);
    n = n+1;
end

%---------------------------------------------
% Return
%---------------------------------------------
IMG = IMG1;

ExpPars = IMG1.ExpPars;
ExpPars.te1 = IMG1.ExpPars.te;
ExpPars.te2 = IMG2.ExpPars.te;
IMG.ExpPars = ExpPars;

ReconPars = IMG1.ReconPars;
ReconPars.te1 = IMG1.ExpPars.te;
ReconPars.te2 = IMG2.ExpPars.te;
IMG.ReconPars = ReconPars;

FID = IMG1.FID;
FID.Shim = Shim;
IMG.FID = FID;

sz = size(IMG1.Im);
Im = cat(length(sz)+1,IMG1.Im,IMG2.Im);
IMG.Im = Im;

%---------------------------------------------
% Panel
%---------------------------------------------
PanelOutput = IMG1.PanelOutput;
Panel = struct2cell(PanelOutput).';
ind = find(strcmp(Panel,'TE (ms)'));
tPanel = Panel(ind+1:end,:);
Panel = Panel(1:ind,:);
Panel(ind,:) = {'TE1 (ms)',ExpPars.te1,'Output'};
Panel(ind+1,:) = {'TE2 (ms)',ExpPars.te2,'Output'};
Panel = cat(1,Panel,tPanel);
n = length(Panel);
Panel(n,:) = {'','','Output'};
n = n+1;
Panel(n,:) = {'tof (Hz)',ExpPars.tof,'Output'};
for m = 1:length(shimval)
    Panel(n+m,:) = {shimname{m},shimval(m),'Output'};
end
n = n+m;
Panel(n,:) = {'','','Output'};

PanelOutput = cell2struct(Panel,{'label','value','type'},2);
IMG.PanelOutput = PanelOutput;

Status2('done','',1);
Status2('done','',2);
Status2('done','',3);


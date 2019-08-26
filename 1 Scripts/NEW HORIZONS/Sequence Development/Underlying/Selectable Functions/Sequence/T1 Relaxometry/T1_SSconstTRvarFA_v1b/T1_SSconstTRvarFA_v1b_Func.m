%=========================================================
% 
%=========================================================

function [DES,err] = T1_SSconstTRvarFA_v1a_Func(DES,INPUT)

Status('busy','T1 Relaxometry Test (Const TR - Variable FA)');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
TR = DES.TR;
T1 = DES.T1;
Flip = DES.FlipArray;
clear INPUT;

%---------------------------------------------
% Get Test Values
%---------------------------------------------
top = (1-exp(-TR/T1));
top = repmat(top,1,length(Flip));
bot = 1 - cos(pi*Flip/180)*exp(-TR/T1);
Mz = top./bot;
Mxy0 = sin(pi*Flip/180).*Mz;
%ernst = 180*acos(exp(-TR/T1))/pi

%---------------------------------------------
% Test
%---------------------------------------------
figure(100);
plot(Flip,Mxy0);

%---------------------------------------------
% Add Noise
%---------------------------------------------
noiseSD = 0.0008;
% noiseSD = 0.0000008;
for n = 1:2000
    Mxy = Mxy0 + noiseSD*randn(size(Mxy0));

    regfunc = str2func('T1_SSconstTRvarFA_v1a_Reg');
    INPUT.TR = TR;
    func = @(P,f)regfunc(P,f,INPUT);
    Est = [0.5,100];
    beta = nlinfit(Flip,Mxy,func,Est);

    T1reg(n) = beta(2);
end

test = std(T1reg)
figure(200);
hist(T1reg);

%---------------------------------------------
% Add to Panel Output
%---------------------------------------------
Panel(1,:) = {'','','Output'};
PanelOutput = cell2struct(Panel,{'label','value','type'},2);

DES.ExpDisp = [PanelStruct2Text(PanelOutput) TST.ExpDisp];

Status2('done','',2);
Status2('done','',3);



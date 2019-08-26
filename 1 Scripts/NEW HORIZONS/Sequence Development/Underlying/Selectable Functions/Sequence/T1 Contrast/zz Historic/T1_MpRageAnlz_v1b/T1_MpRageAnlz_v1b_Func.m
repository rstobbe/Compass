%=========================================================
% 
%=========================================================

function [TST,err] = T1_MpRageAnlz_v1b_Func(TST,INPUT)

Status2('busy','Contrast to Noise Optimization',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
T1 = INPUT.T1;
clear INPUT;

%---------------------
% opt - based on Wang 2014
% TI = 1200;
% TD = 0;
% flip = 14;
% TR = 13;
% Segments = 176;
% TRfull = [];

%---------------------
% Siemens Default (as said by Wang 2014)
% TI = 900;
% flip = 9;
% TR = 7.1;                   
% Segments = 176;
% TRfull = 2300;

%---------------------
% Siemens Default (Prisma)
TI = 900;
flip = 8;
TR = 7.3;                   
Segments = 194;
TRfull = 2200;

%---------------------
% opt - based on Wang 2014  - high res
% TI = 1500;
% TD = 0;
% flip = 15;
% TR = 12;
% Segments = 240;
% TRfull = 3000;
% TRfull = [];

%---------------------
% Kulaga - 2015
% TI = 1500;
% flip = 7;
% TR = 7.1;                   % ?? (try on our scanner)
% Segments = 240;
% TRfull = 3000;

NonSampTime = 3;            % Siemens

TIdel = TI - (Segments/2)*TR;
if TIdel <= 0
    error
end

if isempty(TRfull)
    TRfull = TR*Segments + TIdel + TD;
end
TD = TRfull - TR*Segments - TIdel;
if TD < 0
    error
end
sampdutycyc = ((TR-NonSampTime)*Segments)/TRfull;

%---------------------------------------------
% Arrays
%---------------------------------------------
M0 = [-1 -1];
M = 1-(1-M0).*exp(-[(0:TIdel);(0:TIdel)].'./T1);
time = (0:TIdel);

for m = 1:3

    for n = 0:Segments-1
        M2 = cos(pi*flip/180)*M(end,:);
        M(end+1,:) = 1-(1-M2).*exp(-TR./T1);
        time(end+1) = time(end)+TR;
    end    
 
    AQ0mrk(m) = time(end - Segments); 
    TEmrk(m) = time(end - Segments/2);
    TEseg(m) = length(time) - Segments/2;
    AQ1mrk(m) = time(end); 
    
    M(end+1:end+TD,:) = 1-(1-M(end,:)).*exp(-[(1:TD);(1:TD)].'./T1);
    time = [time time(end)+(1:TD)];

    TRmrk(m) = time(end);
    
    M(end+1:end+TIdel,:) = 1-(1+M(end,:)).*exp(-[(1:TIdel);(1:TIdel)].'./T1);
    time = [time time(end)+(1:TIdel)];

end
% 
% flip2 = 20;
% TR2 = 20;
% flip2 = 17.5;
% TR2 = 15;
flip2 = 15;
TR2 = 13;
% flip2 = 9;
% TR2 = 7.1;
sampdutycyc2 = (TR2 - NonSampTime)/TR2;
for n = 0:500
    M2 = cos(pi*flip2/180)*M(end,:);
    M(end+1,:) = 1-(1-M2).*exp(-TR2./T1);
    time(end+1) = time(end)+TR2;
end

MDif = M(:,1)-M(:,2);

figure(100); hold on;
plot(time,M);
plot(time,-MDif)
plot([AQ0mrk(end) AQ0mrk(end)],[-1 1],'k:');
plot([AQ1mrk(end) AQ1mrk(end)],[-1 1],'k:');
plot([TEmrk(end) TEmrk(end)],[-1 1],'k:');
ylim([-1 1]);
plot([0 time(end)],[0 0],'k:');

%xlim([4400 711800]);

MzDifValTE = MDif(TEseg(end))
SigDifValTE = abs(sin(pi*flip/180)*MzDifValTE)
CNR = SigDifValTE*sqrt(sampdutycyc)

MzDifValTE = MDif(end)
SigDifValTE = abs(sin(pi*flip2/180)*MzDifValTE)
CNR = SigDifValTE*sqrt(sampdutycyc2)


error



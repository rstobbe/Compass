%====================================================
%  
%====================================================

function [CRTE,err] = Create_exSLR_v1a_Func(CRTE,INPUT)

Status2('busy','Create exSLR',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
clear INPUT;

%---------------------------------------------
% Create 'Beta' Polynomial (SLR) - John Pauly 
%---------------------------------------------
if strcmp(CRTE.type,'Ex') || strcmp(CRTE.type,'Ref')
    b = dzls(CRTE.slvpts,CRTE.tbwprod,CRTE.ripin,CRTE.ripout);
elseif strcmp(CRTE.type,'MinPh') || strcmp(CRTE.type,'MinPh')
    b = real(RWS_dzmp(CRTE.slvpts,CRTE.tbwprod,CRTE.ripin,CRTE.ripout));   
    if strcmp(CRTE.type,'MinPh')
        b = flipdim(b,2);
    end
end

%---------------------------------------------
% Scale for Tip Angle
%---------------------------------------------
b = b*sin(pi*(CRTE.flip/2)/180);              % see Pauly - proportional to sin(flip/2)
%figure(100); hold on; plot(b,'r');
%title('a and b polynomials');

%---------------------------------------------
% Observe FT
%---------------------------------------------
%bzf = b;
%bzf(8*length(b)) = 0;
%B = fft(bzf);
%figure(101); hold on; plot(abs(B),'r');
%absA = sqrt(1-B.*conj(B));                  % Pauly (17)
%figure(101); hold on;plot(absA,'g');        % green in plot should be covered by blue of abs(A) below      

%---------------------------------------------
% Compute Minimum Phase 'Alpha' Polynomial - John Pauly
%---------------------------------------------
a = b2a(b);
%test = sum(imag(a));                        % should be real (if b is real I guess)
a = real(a);
%figure(100); hold on; plot(a,'b');
%title('a and b polynomials');

%---------------------------------------------
% Test FT
%---------------------------------------------
%azf = a;
%azf(8*length(a)) = 0;
%A = fft(azf);
%figure(101); hold on; plot(abs(A),'b');

%---------------------------------------------
% Inverse SLR - John Pauly
%---------------------------------------------
wfm = real(ab2rf(a,b));
wfm = wfm/max(wfm);
%figure(102); hold on; plot(wfm,'k');

%---------------------------------------------
% Assign Type
%---------------------------------------------
CRTE.type = 'excitation';
CRTE.modulation = 'amplitude';
CRTE.gradref = 'yes';

%---------------------------------------------
% Return
%---------------------------------------------
CRTE.wfm = wfm;
CRTE.Dflip = CRTE.flip;
CRTE.Dtbwprod = CRTE.tbwprod;

Status2('done','',2);
Status2('done','',3);


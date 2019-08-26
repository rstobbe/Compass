%====================================================
%  
%====================================================

function [WRT,err] = Write_RFwfmV_v1a_Func(WRT,INPUT)

Status2('busy','Write RF Waveform Varian',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
CRTE = INPUT.CRTE;
BLD = INPUT.BLD;
clear INPUT;

%---------------------------------------------
% Interpolate
%---------------------------------------------
wfm = CRTE.wfm;
iN = linspace(1,length(wfm),WRT.wfmpts);
iwfm = interp1(1:length(wfm),wfm,iN);
%figure(5); hold on;
%plot(wfm,'b'); plot(iN,iwfm,'r');
wfm = iwfm;

%---------------------------------------------
% Prepare
%---------------------------------------------
wfm = round(10*1023*wfm/(max(abs(wfm))))/10;
integral = sum(wfm)/1023/(length(wfm));

pwfm = zeros(size(wfm));
pwfm(wfm < 0) = 180;
awfm = abs(wfm);

%-------------------------------------------------
% Name Parameter File
%-------------------------------------------------
[file,path] = uiputfile('*','Name RF Waveform','');
if path == 0
    return
end

%-------------------------------------------------
% Write
%-------------------------------------------------
fid = fopen([path,file],'w');
fprintf(fid,'#-----------------------------------------\n');
fprintf(fid,['# ', file,'\n']);
fprintf(fid,'#-----------------------------------------\n');
if strcmp(BLD.gradref,'yes')
    fprintf(fid,'# TYPE  selective\n');
else
    fprintf(fid,'# TYPE  nonselective\n');
end
fprintf(fid,['# MODULATION  ',BLD.modulate,'\n']);
if strcmp(CRTE.type,'excitation')
    fprintf(fid,'# EXCITEWIDTH  %2.2f\n',BLD.Etbwprod);
elseif strcmp(CRTE.type,'inversion')
    fprintf(fid,'# INVERTWIDTH  %2.2f\n',BLD.Etbwprod);
end
fprintf(fid,'# INTEGRAL  %0.6f\n',integral);
if strcmp(BLD.gradref,'yes')
    fprintf(fid,'# AREF  %0.4f\n',BLD.ARef);
end
fprintf(fid,'#-----------------------------------------\n');
fprintf(fid,'%4.1f\t%4.1f\t%g\n',[pwfm;awfm;ones(size(awfm))]);
fclose(fid);


Status('done','');
Status2('done','',2);
Status2('done','',3);



    


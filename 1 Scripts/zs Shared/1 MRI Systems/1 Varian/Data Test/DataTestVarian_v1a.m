%=========================================================
%
%=========================================================

function [DataInfo,err] = DataTestVarian_v1a(DataInfo,FIDmat)

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Dimensions
%---------------------------------------------
sz = size(FIDmat);
if length(sz) == 4 || length(sz) == 3
    nrcvrs = 1;
else
    nrcvrs = sz(5);
end

%--------------------------------------------
% Max Value Test
%--------------------------------------------
for n = 1:nrcvrs
    k1 = FIDmat(:,:,:,:,n);
    maxvals(n) = max(k1(:));
end
DataInfo.maxchanvals = max(abs([real(maxvals) imag(maxvals)]));
if max(DataInfo.maxchanvals) > 30000
    dbgain = ceil(abs(10*log10(DataInfo.maxchanvals/28000)));
    button = questdlg(['Gain is <',num2str(dbgain),'dB from maximum'],'Gain Error','continue','abort','continue');
    if strcmp(button,'abort')
        err.flag = 1;
        err.msg = 'Gain error';
        return
    end
end

%--------------------------------------------
% Receiver Test
%--------------------------------------------
if DataInfo.maxchanvals < 6500
    dbgain = floor(abs(10*log10(DataInfo.maxchanvals/32768)));
    button = questdlg(['Gain is <',num2str(dbgain),'dB of what it should be'],'Gain Error','continue','abort','continue');
    if strcmp(button,'abort')
        err.flag = 1;
        err.msg = 'Gain error';
        return
    end
end
for n = 1:nrcvrs
    if abs(maxvals(n)) < 0.5*median(abs(maxvals(n)))
        button = questdlg(['Gain on rcvr',num2str(n),' is low'],'Receive Gain Error','continue','abort','continue');
        if strcmp(button,'abort')
            err.flag = 1;
            err.msg = 'Receiver Gain error';
            return
        end
    elseif abs(maxvals(n)) > 2*median(abs(maxvals(n)))
        button = questdlg(['Gain on rcvr',num2str(n),' is high'],'Receive Gain Error','continue','abort','continue');
        if strcmp(button,'abort')
            err.flag = 1;
            err.msg = 'Receiver Gain error';
            return
        end
    end    
end

%--------------------------------------------
% DC test
%--------------------------------------------
DataInfo.reldcvals = round(1000*abs(DataInfo.meandcvals)./abs(maxvals))/1000;
for n = 1:nrcvrs
    if DataInfo.reldcvals(n) > 0.05 && DataInfo.maxchanvals > 6500
        button = questdlg(['DC on rcvr',num2str(n),' is ',num2str(100*DataInfo.reldcvals(n)),'% of the maximum value'],'DC Error','continue','abort','continue');
        if strcmp(button,'abort')
            err.flag = 1;
            err.msg = 'DC error';
            return
        end
    end
end



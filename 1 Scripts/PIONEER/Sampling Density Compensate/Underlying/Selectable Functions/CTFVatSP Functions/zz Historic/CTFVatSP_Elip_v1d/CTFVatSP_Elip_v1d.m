%=========================================================
% (v1d)
%   - change 'find convolution values'
%=========================================================

function [DOV,SDCS,SCRPTipt,err] = CTFVatSP_Elip_v1d(Kmat,PROJdgn,PROJimp,TF,KRNprms,SDCS,SCRPTipt,err)

DOV = [];
CTF.CTFfunc = SCRPTipt(strcmp('CTFfunc',{SCRPTipt.labelstr})).entrystr;

CTFvis = 'Off';
CTFtest = 'Off';
%--------------------------------------
% Test TF Convolution
%--------------------------------------
if strcmp(CTFtest,'On')
    Status2('busy','Test TF Convolution',2);
    Status2('busy','',3);
    func = str2func('TF_Uniform_v1a');
    [TF,SDCS] = func(PROJdgn,SDCS,SCRPTipt);
    CTF.visuals = 'On';
    func = str2func(CTF.CTFfunc);
    [tCTF,~,err] = func(PROJdgn,PROJimp,TF,KRNprms,CTF,SDCS,SCRPTipt,err);
    for n = 1:length(err)
        if err(n).flag == 1
            return
        end
    end
    tSDconv = tCTF.ConvTF/(PROJdgn.projosamp*PROJimp.osamp);
    trconv = tCTF.rconv;
    figure(30); hold on;
    plot(trconv,tSDconv,'b-');
    xlim([0 1.2]); 
    title('Convolved TF Shape');
    ind1 = find(tSDconv == max(tSDconv),1);
    ind2 = find(tSDconv == min(tSDconv),1);    
    tSDconvseg = tSDconv(ind1:ind2);
    trconvseg = trconv(ind1:ind2);
    testConvScalVal = tSDconv(1);
    testConvTFrelwid = interp1(tSDconvseg,trconvseg,tSDconv(1)/2,'cubic');      % closer to 1 as more like circle
end

%--------------------------------------
% Build Convolved TF
%--------------------------------------
Status2('busy','Convolve TF',2);
Status2('busy','',3);
func = str2func(CTF.CTFfunc); 
CTF.visuals = CTFvis;
[CTF,SCRPTipt,err] = func(PROJdgn,PROJimp,TF,KRNprms,CTF,SDCS,SCRPTipt,err);
Status2('done','',2);
for n = 1:length(err)
    if err(n).flag == 1
        return
    end
end

%--------------------------------------
% Find Convolved TF Values at Sampling Point Locations
%--------------------------------------
Status2('busy','Interpolate to Sampling Points',2);
DOV = zeros(PROJdgn.nproj,PROJimp.npro);
rKmag = zeros(PROJdgn.nproj,PROJimp.npro);
for n = 1:PROJdgn.nproj 
    for m = 1:PROJimp.npro
        Kx = ((length(CTF.rconv)-1)/2)*((Kmat(n,m,1)/SDCS.compkmax)/abs(CTF.rconv(1))) + ((length(CTF.rconv)+1)/2);
        Ky = ((length(CTF.rconv)-1)/2)*((Kmat(n,m,2)/SDCS.compkmax)/abs(CTF.rconv(1))) + ((length(CTF.rconv)+1)/2);
        Kz = ((length(CTF.rconv)-1)/2)*((Kmat(n,m,3)/SDCS.compkmax)/abs(CTF.rconv(1))) + ((length(CTF.rconv)+1)/2);
        DOV(n,m) = trilin_interp(CTF.ConvTF,Kx,Ky,Kz);
        rKmag(n,m) = ((Kmat(n,m,1).^2 + Kmat(n,m,2).^2 + Kmat(n,m,3).^2).^(1/2))/SDCS.compkmax;
        if not(rem(n,100));
            Status2('busy',['Projection Number: ',num2str(n)],3);
        end
    end
end
SDCS.actkmax = max(rKmag(:))*SDCS.compkmax;

%--------------------------------------
% Visuals
%--------------------------------------
if strcmp(CTFvis,'On')
    figure(31); hold on;
    plot(rKmag(:),DOV(:),'r*');
    plot(CTF.rconv,squeeze(CTF.ConvTF(((length(CTF.rconv)+1)/2),((length(CTF.rconv)+1)/2),:)),'b-*');
    plot(CTF.rconv,squeeze(CTF.ConvTF(((length(CTF.rconv)+1)/2),:,((length(CTF.rconv)+1)/2))),'g-*');
    plot(CTF.rconv,squeeze(CTF.ConvTF(:,((length(CTF.rconv)+1)/2),((length(CTF.rconv)+1)/2))),'k-*');
    title('Convolved Transfer Function Values at Sampling Points');
end
SDCS.CTF = CTF;


%=========================================================
% (v1b)
%   - calls 'CTF_Sphere_v1b'
%   - MinRadDim selectable
%   - MaxSubSamp selectable
%=========================================================

function [DOV,SDCS,SCRPTipt,err] = CTFVatSP_Sphere_v1b(Kmat,PROJdgn,PROJimp,TF,KRNprms,SDCS,SCRPTipt,err)

DOV = [];
CTF.CTFfunc = SCRPTipt(strcmp('CTFfunc',{SCRPTipt.labelstr})).entrystr;
CTF.MinRadDim = str2double(SCRPTipt(strcmp('MinRadDim',{SCRPTipt.labelstr})).entrystr);
CTF.MaxSubSamp = str2double(SCRPTipt(strcmp('MaxSubSamp',{SCRPTipt.labelstr})).entrystr);

%--------------------------------------
% Test TF Convolution
%--------------------------------------
CTFtest = 'Off';
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
    tSDconv = tCTF.SDconv/(PROJdgn.projosamp*PROJimp.osamp);
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
CTF.visuals = Vis;
[CTF,SCRPTipt,err] = func(PROJdgn,PROJimp,TF,KRNprms,CTF,SDCS,SCRPTipt,err);
for n = 1:length(err)
    if err(n).flag == 1
        return
    end
end

%--------------------------------------
% Find Convolved TF Values at Sampling Point Locations
%--------------------------------------
Status2('busy','Interpolate to Sampling Points',2);
rKmag = ((Kmat(:,:,1).^2 + Kmat(:,:,2).^2 + Kmat(:,:,3).^2).^(1/2))/SDCS.compkmax;
SDCS.actkmax = max(rKmag(:))*SDCS.compkmax;
DOV = zeros(size(rKmag),'single');
for n = 1:PROJdgn.nproj
    DOV(n,:) = interp1(CTF.rconv,CTF.SDconv,rKmag(n,:));
    if not(rem(n,100));
        Status2('busy',['Projection Number: ',num2str(n)],3);
    end
end

%--------------------------------------
% Visuals
%--------------------------------------
CTFvis = 'Off';
if strcmp(CTFvis,'On')
    figure(31); hold on;
    plot(rKmag(:),DOV(:),'r*');
    plot(CTF.rconv,CTF.SDconv,'b-');
    title('Convolved Transfer Function Values at Sampling Points');
end
SDCS.CTF = CTF;

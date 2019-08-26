%===========================================================================================
% ** SDC_v2 **  
%===========================================================================================

function [SCRPTipt,SCRPTGBL,err] = SDC_v2(SCRPTipt,SCRPTGBL)

SCRPTGBL.TextBox = '';
SCRPTGBL.Figs = [];
SCRPTGBL.Data = [];

err.flag = 0;
err.msg = '';

% Test if SDC is appropriate for projection set

PROJdgn = SCRPTGBL.Imp_File.PROJdgn;
PROJimp = SCRPTGBL.Imp_File.PROJimp;
Kmat = SCRPTGBL.Imp_File.Kmat;
KRNprms = SCRPTGBL.KRNprms;
KRNprms.Kern = SCRPTGBL.Kern;

SDCS = struct();
SDCS.method = 'SDC_v2';
SDCS.DefName = SCRPTipt(strcmp('SDC_Name',{SCRPTipt.labelstr})).entrystr;
SDCS.IEFunc = SCRPTipt(strcmp('InitialEst',{SCRPTipt.labelstr})).entrystr;
SDCS.SubSamp = str2double(SCRPTipt(strcmp('SubSamp',{SCRPTipt.labelstr})).entrystr);
SDCS.KernelFunc = SCRPTipt(strcmp('KernelFunc',{SCRPTipt.labelstr})).entrystr;
SDCS.tf = SCRPTipt(strcmp('TFFunc',{SCRPTipt.labelstr})).entrystr;
SDCS.ConvTFFunc = SCRPTipt(strcmp('ConvTFFunc',{SCRPTipt.labelstr})).entrystr;
SDCS.IterateFunc = SCRPTipt(strcmp('IterateFunc',{SCRPTipt.labelstr})).entrystr;

%--------------------------------------
% Tests
%--------------------------------------
if SDCS.SubSamp < 2.5
    err.flag = 1;
    err.msg = 'Picking A Larger ConvTFRad Required';
    return
elseif rem(round(1e9/(KRNprms.res*SDCS.SubSamp))/1e9,1)
    err.flag = 1;
    err.msg = '1/(kernres*subsamp) not an integer';
    return
elseif rem(KRNprms.W/KRNprms.res,1)
    err.flag = 1;
    err.msg = 'W/kernres not an integer';
    return
end

%--------------------------------------
% Define TF Convolution Parameters
%--------------------------------------
CTF.kmax = PROJdgn.kmax;
CTF.MinRadDim = 40;

%--------------------------------------
% Test TF Convolution
%--------------------------------------
TFtest = 0;
if TFtest == 1
    Status('busy','Test TF Convolution');
    Status2('busy','',2);
    Status2('busy','',3);
    func = str2func('Uniform_v1');
    [TF,SDCS] = func(PROJdgn,SDCS,SCRPTipt);
    func = str2func(SDCS.ConvTFFunc);
    CTF.testing = 'Yes';
    [tCTF,~,err] = func(PROJdgn,PROJimp,TF,KRNprms,CTF,SDCS,SCRPTipt,err);
    for n = 1:length(err)
        if err(n).flag == 1
            return
        end
    end
    tSDconv = tCTF.SDconv/(PROJdgn.projosamp*PROJimp.osamp);
    trconv = tCTF.rconv;
    figure(10); hold on;
    plot(trconv,tSDconv,'b-');
    xlim([0 1.2]); 
    title('Convolved TF Shape');
    ind1 = find(tSDconv == max(tSDconv),1);
    ind2 = find(tSDconv == min(tSDconv),1);    
    tSDconvseg = tSDconv(ind1:ind2);
    trconvseg = trconv(ind1:ind2);
    CTF.ConvScalVal = tSDconv(1);
    CTF.ConvTFrelwid = interp1(tSDconvseg,trconvseg,tSDconv(1)/2,'cubic');
end

%--------------------------------------
% Load Desired Output Transfer Function
%--------------------------------------
Status('busy','Select Transfer Function');
Status2('busy','',2);
Status2('busy','',3);
func = str2func(SDCS.tf);
[TF,SDCS] = func(PROJdgn,SDCS,SCRPTipt);

%--------------------------------------
% Build Convolved TF
%--------------------------------------
Status('busy','Build a Convolved Version of the Desired Final Transfer Function For SDC');
Status2('busy','',2);
Status2('busy','',3);
func = str2func(SDCS.ConvTFFunc); 
CTF.testing = 'No';
[CTF,SCRPTipt,err] = func(PROJdgn,PROJimp,TF,KRNprms,CTF,SDCS,SCRPTipt,err);
for n = 1:length(err)
    if err(n).flag == 1
        return
    end
end

%--------------------------------------
% Initial Estimate
%--------------------------------------
Status('busy','Initial Estimate');
Status2('busy','',2);
Status2('busy','',3);
func = str2func(SDCS.IEFunc);
[iSDC,SDCS,SCRPTipt] = func(Kmat,PROJdgn,PROJimp,SDCS,SCRPTipt);

%--------------------------------------
% Sampling Density Compensate
%--------------------------------------
Status('busy','Perform SDC Iterations');
Status2('busy','',2);
Status2('busy','',3);
func = str2func(SDCS.IterateFunc); 
[SDC,SDCS,SCRPTipt,err] = func(Kmat,PROJdgn,PROJimp,iSDC,CTF,KRNprms,SDCS,SCRPTipt,err);
for n = 1:length(err)
    if err(n).flag == 1
        return
    end
end

Status2('done','',1);
Status2('done','',2);
Status2('done','',3);

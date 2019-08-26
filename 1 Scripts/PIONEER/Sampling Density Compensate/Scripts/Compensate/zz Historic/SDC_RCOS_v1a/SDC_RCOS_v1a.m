%===========================================================================================
% SDC_RCOS_v1a 
%
%===========================================================================================

function [SCRPTipt,SCRPTGBLout,err] = SDC_RCOS_v1a(SCRPTipt,SCRPTGBL)

SCRPTGBLout.TextBox = '';
SCRPTGBLout.Figs = [];
SCRPTGBLout.Data = [];

err.flag = 0;
err.msg = '';

SDCS = struct();
SDCS.method = 'SDC_v2b';
SDCS.Name = SCRPTipt(strcmp('SDC_Name',{SCRPTipt.labelstr})).entrystr;
SDCS.ImpFile = SCRPTipt(strcmp('Imp_File',{SCRPTipt.labelstr})).runfuncoutput{1};
SDCS.SubSamp = str2double(SCRPTipt(strcmp('SubSamp',{SCRPTipt.labelstr})).entrystr);
SDCS.KernLoadfunc = SCRPTipt(strcmp('KernLoadfunc',{SCRPTipt.labelstr})).entrystr;
SDCS.TFfunc = SCRPTipt(strcmp('TFfunc',{SCRPTipt.labelstr})).entrystr;
SDCS.CTFVatSPfunc = SCRPTipt(strcmp('CTFVatSPfunc',{SCRPTipt.labelstr})).entrystr;
SDCS.InitialEstfunc = SCRPTipt(strcmp('InitialEstfunc',{SCRPTipt.labelstr})).entrystr;
SDCS.Iteratefunc = SCRPTipt(strcmp('Iteratefunc',{SCRPTipt.labelstr})).entrystr;
SDCS.compkmaxsel = SCRPTipt(strcmp('Comp_kmax',{SCRPTipt.labelstr})).entrystr;
if iscell(SDCS.compkmaxsel)
    SDCS.compkmaxsel = SCRPTipt(strcmp('Comp_kmax',{SCRPTipt.labelstr})).entrystr{SCRPTipt(strcmp('Comp_kmax',{SCRPTipt.labelstr})).entryvalue};
end
SDCS.RCOSprojset = SCRPTipt(strcmp('RCOSprojset',{SCRPTipt.labelstr})).entrystr;
if iscell(SDCS.RCOSprojset)
    SDCS.RCOSprojset = SCRPTipt(strcmp('RCOSprojset',{SCRPTipt.labelstr})).entrystr{SCRPTipt(strcmp('RCOSprojset',{SCRPTipt.labelstr})).entryvalue};
end

if not(isfield(SCRPTGBL,'Imp_File'))
    err.flag = 1;
    err.msg = 'Load / Reload  Imp_File';
    return
end
if not(isfield(SCRPTGBL,'KernLoadfunc'))
    err.flag = 1;
    err.msg = 'Load / Reload  KernFile';
    return
end

PROJdgn = SCRPTGBL.Imp_File.PROJdgn;
PROJimp = SCRPTGBL.Imp_File.PROJimp;
Kmat = SCRPTGBL.Imp_File.Kmat;
KRNprms = SCRPTGBL.KernLoadfunc.KRNprms;
SDCS.KRNprms = KRNprms;
KRNprms.Kern = SCRPTGBL.KernLoadfunc.Kern;

%--------------------------------------
% RCOS accomodation
%--------------------------------------
if strcmp(SDCS.RCOSprojset,'Imp');
    Kmat = Kmat(1:PROJimp.nproj,:,:);
    SDCS.Name = [SDCS.Name,'_Imp'];
elseif strcmp(SDCS.RCOSprojset,'Full');    
    PROJimp.nproj = PROJimp.nproj + PROJimp.nprojrc;
    PROJdgn.nproj = PROJimp.nproj;
    PROJimp.tdp = PROJimp.nproj*PROJimp.npro;
    SDCS.Name = [SDCS.Name,'_Full'];
end
    
%--------------------------------------
% Tests
%--------------------------------------
% Should also test if SDC is appropriate for projection set
if SDCS.SubSamp < 2.5
    err.flag = 1;
    err.msg = 'Picking A Larger ConvTFRad Required';
    return
elseif rem(round(1e9/(KRNprms.res*SDCS.SubSamp))/1e9,1)
    err.flag = 1;
    err.msg = '1/(kernres*subsamp) not an integer';
    return
elseif rem((KRNprms.W/2)/KRNprms.res,1)
    err.flag = 1;
    err.msg = 'W/kernres not an integer';
    return
end

%--------------------------------------
% Select Max Value for SDC
%--------------------------------------
if strcmp(SDCS.compkmaxsel,'Design')
    SDCS.compkmax = PROJdgn.kmax;
elseif strcmp(SDCS.compkmaxsel,'Implementation')
    SDCS.compkmax = PROJimp.meanrelkmax*PROJdgn.kmax;
end
    
%--------------------------------------
% Load Desired Output Transfer Function
%--------------------------------------
Status('busy','Load Desired Output Transfer Function');
Status2('busy','',2);
Status2('busy','',3);
func = str2func(SDCS.TFfunc);
[TF,SDCS] = func(PROJdgn,SDCS,SCRPTipt);

%--------------------------------------
% Determine Convolved Transfer Function Values at Sampling Points
%--------------------------------------
Status('busy','Determine Convolved Transfer Function Values at Sampling Points');
Status2('busy','',2);
Status2('busy','',3);
func = str2func(SDCS.CTFVatSPfunc);
[DOV,SDCS,SCRPTipt,err] = func(Kmat,PROJdgn,PROJimp,TF,KRNprms,SDCS,SCRPTipt,err);
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
func = str2func(SDCS.InitialEstfunc);
[iSDC,SDCS,SCRPTipt] = func(Kmat,PROJdgn,PROJimp,SDCS,SCRPTipt);

%--------------------------------------
% Sampling Density Compensate
%--------------------------------------
Status('busy','Perform SDC Iterations');
Status2('busy','',2);
Status2('busy','',3);
func = str2func(SDCS.Iteratefunc); 
[SDC,SDCS,SCRPTipt,err] = func(Kmat,PROJdgn,PROJimp,iSDC,DOV,KRNprms,SDCS,SCRPTipt,err);
for n = 1:length(err)
    if err(n).flag == 1
        return
    end
end

SCRPTGBLout.SDC = SDC;
SCRPTGBLout.SDCS = SDCS;

Status2('done','',1);
Status2('done','',2);
Status2('done','',3);

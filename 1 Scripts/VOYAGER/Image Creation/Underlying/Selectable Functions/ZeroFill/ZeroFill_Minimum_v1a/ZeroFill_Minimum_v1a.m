%=====================================================
% (v1a)
%=====================================================

function [SCRPTipt,ZFIL,err] = ZeroFill_Minimum_v1a(SCRPTipt,ZFILipt,IMP,GRD)

Status2('busy','Zero Fill',2);
Status2('done','',2);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Return Panel Input
%---------------------------------------------
ZFIL.method = ZFILipt.Func;

%---------------------------------------------
% Find Minimum ZeroFill
%---------------------------------------------
%Type = 'M2M';
%[Ksz0,SubSamp0,~,~,~,~,~,err] = ConvSetupTest_v1b(IMP,GRD.KRNprms,Type);

convchw = ceil(((GRD.KRNprms.W*GRD.KRNprms.DesforSS)-2)/2);
if isfield(IMP.PROJimp,'maxrelkmax')
    kmax = IMP.impPROJdgn.kmax*IMP.PROJimp.maxrelkmax;
else
    kmax = IMP.impPROJdgn.kmax;
end
kstep = IMP.impPROJdgn.kstep;
centre = ceil(GRD.KRNprms.DesforSS*kmax/kstep) + (convchw + 2);   
Ksz = centre*2 - 1;
SubSamp = GRD.KRNprms.DesforSS;

if SubSamp == 1.28
    zfarr = linspace(0,768,13);
elseif SubSamp == 1.25
    zfarr = linspace(0,600,61);    
elseif SubSamp == 1.6
    zfarr = linspace(0,800,51);
elseif SubSamp == 2.5
    zfarr = linspace(0,800,81);
end
ZFIL.zf = num2str(zfarr(find(Ksz < zfarr,1,'first')));
ZFIL.Ksz = Ksz;
ZFIL.subsamp = SubSamp;
ZFIL.centre = centre;
ZFIL.kmax = kmax;
ZFIL.kstep = kstep;

Status2('done','',2);
Status2('done','',3);










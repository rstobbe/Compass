%=====================================================
% (v1a)
%=====================================================

function [SCRPTipt,ZFIL,err] = ZeroFill_Selection_v1a(SCRPTipt,ZFILipt,IMP,GRD)

Status2('busy','Zero Fill',2);
Status2('done','',2);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Return Panel Input
%---------------------------------------------
ZFIL.method = ZFILipt.Func;
ZFIL.zf = ZFILipt.('ZeroFill');

%---------------------------------------------
% Find Minimum ZeroFill
%---------------------------------------------
% convchw = ceil(((GRD.KRNprms.W*GRD.KRNprms.DesforSS)-2)/2);
% kmax = IMP.impPROJdgn.kmax*IMP.PROJimp.maxrelkmax;
% kstep = IMP.impPROJdgn.kstep;
% centre = ceil(GRD.KRNprms.DesforSS*kmax/kstep) + (convchw + 2);   
% Ksz = centre*2 - 1;
% SubSamp = GRD.KRNprms.DesforSS;
% 
% ZFIL.Ksz = Ksz;
% ZFIL.subsamp = SubSamp;
% ZFIL.centre = centre;
% ZFIL.kmax = kmax;
% ZFIL.kstep = kstep;

Status2('done','',2);
Status2('done','',3);










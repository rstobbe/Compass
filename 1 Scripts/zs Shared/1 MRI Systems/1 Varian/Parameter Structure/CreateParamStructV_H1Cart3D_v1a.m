%=====================================================
% (v1a)
%   - 
%=====================================================

function [TrajPars,err] = CreateParamStructV_H1Cart3D_v1a(Text)

err.flag = 0;
err.msg = '';

Study.expdefault = Parse_Params(Text,'Date');
Study.varianfolder = Parse_Params(Text,'Study');
Study.subject = Parse_Params(Text,'Subject');
Study.comments = Parse_Params(Text,'Comments');

Setup.len90 = str2double(Parse_Params(Text,'setup 90 length'));
Setup.pwr90 = str2double(Parse_Params(Text,'setup 90 power'));
Setup.gain = str2double(Parse_Params(Text,'setup gain'));
Setup.linewid = str2double(Parse_Params(Text,'setup line-width'));
Setup.resoffset = str2double(Parse_Params(Text,'resonance Offset'));
Setup.vsparam = str2double(Parse_Params(Text,'vs parameters'));

Sequence.Efa = Parse_Params(Text,'Efa');
Sequence.Epat = Parse_Params(Text,'Epat');
Sequence.Epw = str2double(Parse_Params(Text,'Epw'));
Sequence.Etpwr = str2double(Parse_Params(Text,'Etpwr'));
Sequence.Etpwrf = str2double(Parse_Params(Text,'Etpwrf'));
Sequence.MTfa = Parse_Params(Text,'MTfa');
Sequence.MTpat = Parse_Params(Text,'MTpat');
Sequence.MTpw = str2double(Parse_Params(Text,'MTpw'));
Sequence.MTtpwr = str2double(Parse_Params(Text,'MTtpwr'));
Sequence.MTtpwrf = str2double(Parse_Params(Text,'MTtpwrf'));
Sequence.rfspoil = str2double(Parse_Params(Text,'rfspoil'));
Sequence.dummies = str2double(Parse_Params(Text,'dummies'));

Acq.fovro = Parse_Params(Text,'fovro');
Acq.fovpe1 = Parse_Params(Text,'fovpe1');
Acq.fovpe2 = Parse_Params(Text,'fovpe2');
Acq.nro = str2double(Parse_Params(Text,'nro'));
Acq.nv1 = str2double(Parse_Params(Text,'nv1'));
Acq.nv2 = str2double(Parse_Params(Text,'nv2'));
Acq.osnro = str2double(Parse_Params(Text,'osnro'));

TrajPars.Study = Study;
TrajPars.Setup = Setup;
TrajPars.Sequence = Sequence;
TrajPars.Acq = Acq;

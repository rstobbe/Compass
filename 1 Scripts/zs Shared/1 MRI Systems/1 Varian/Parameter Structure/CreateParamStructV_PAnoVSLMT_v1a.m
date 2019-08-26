%=====================================================
% (v1a)
%   - 
%=====================================================

function [TrajPars,err] = CreateParamStructV_PAnoVSLMT_v1a(Text)

err.flag = 0;
err.msg = '';

Study.date = Parse_ParamsV_v1a(Text,'Date');
Study.varianfolder = Parse_ParamsV_v1a(Text,'Study');
Study.subject = Parse_ParamsV_v1a(Text,'Subject');
Study.comments = Parse_ParamsV_v1a(Text,'Comments');

Sequence.protocol = Parse_ParamsV_v1a(Text,'protocol');
Sequence.sequence = Parse_ParamsV_v1a(Text,'sequence');
Sequence.scanlen = str2double(Parse_ParamsV_v1a(Text,'scan length'));
Sequence.TR = str2double(Parse_ParamsV_v1a(Text,'TR'));
Sequence.TE = str2double(Parse_ParamsV_v1a(Text(100:length(Text)),'TE'));
Sequence.Flip = str2double(Parse_ParamsV_v1a(Text,'Flip'));
Sequence.MT = str2double(Parse_ParamsV_v1a(Text,'MT'));
Sequence.MTfa = str2double(Parse_ParamsV_v1a(Text,'MTfa'));
Sequence.MTpw = str2double(Parse_ParamsV_v1a(Text,'MTpw'));
Sequence.MTpat = Parse_ParamsV_v1a(Text,'MTpat');
Sequence.MToff = str2double(Parse_ParamsV_v1a(Text,'MToff'));

Acq.projset = Parse_ParamsV_v1a(Text,'projection set');
Acq.gradpath = Parse_ParamsV_v1a(Text,'gradient path');
Acq.vox = str2double(Parse_ParamsV_v1a(Text,'vox'));
Acq.fov = str2double(Parse_ParamsV_v1a(Text,'fov'));
Acq.tro = str2double(Parse_ParamsV_v1a(Text,'tro'));
Acq.nproj = str2double(Parse_ParamsV_v1a(Text,'nproj'));

Sequence.pw = str2double(Parse_ParamsV_v1a(Text,'pw'));
Sequence.patex = Parse_ParamsV_v1a(Text,'patex');
Sequence.gspoil = Parse_ParamsV_v1a(Text,'gspoil');
Sequence.gspoildur = str2double(Parse_ParamsV_v1a(Text,'gspoildur'));
Sequence.gspoilmag = str2double(Parse_ParamsV_v1a(Text,'gspoilmag'));
Sequence.rfspoil = Parse_ParamsV_v1a(Text,'rfspoil');
Sequence.rfspoilphase = str2double(Parse_ParamsV_v1a(Text,'rfspoilphase'));
Sequence.nave = str2double(Parse_ParamsV_v1a(Text,'nave'));
Sequence.gain = str2double(Parse_ParamsV_v1a(Text,'gain'));
Sequence.dummys = str2double(Parse_ParamsV_v1a(Text,'dummys'));

Acq.npro = str2double(Parse_ParamsV_v1a(Text,'npro'));
Acq.sampstart = str2double(Parse_ParamsV_v1a(Text,'sampstart'));
Acq.dwell = str2double(Parse_ParamsV_v1a(Text,'dwell'));
Acq.fb = str2double(Parse_ParamsV_v1a(Text,'fb'));

Acq.gcoil = Parse_ParamsV_v1a(Text,'gcoil');
Acq.rof2 = str2double(Parse_ParamsV_v1a(Text,'rof2'));
Acq.rdwn = str2double(Parse_ParamsV_v1a(Text,'rdwn'));
Acq.fildel = str2double(Parse_ParamsV_v1a(Text,'fildel'));
Acq.graddel = str2double(Parse_ParamsV_v1a(Text,'graddel'));
Acq.filtrans = str2double(Parse_ParamsV_v1a(Text,'filtrans'));

Setup.len90 = str2double(Parse_ParamsV_v1a(Text,'setup 90 length'));
Setup.pwr90 = str2double(Parse_ParamsV_v1a(Text,'setup 90 power'));
Setup.gain = str2double(Parse_ParamsV_v1a(Text,'setup gain'));
Setup.linewid = str2double(Parse_ParamsV_v1a(Text,'setup line-width'));
Setup.resoffset = str2double(Parse_ParamsV_v1a(Text,'resonance Offset'));
Setup.vsparam = str2double(Parse_ParamsV_v1a(Text,'vs parameters'));

TrajPars.Study = Study;
TrajPars.Setup = Setup;
TrajPars.Sequence = Sequence;
TrajPars.Acq = Acq;

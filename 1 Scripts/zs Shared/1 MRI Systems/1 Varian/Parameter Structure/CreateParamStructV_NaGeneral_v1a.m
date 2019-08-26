%=====================================================
% (v1a)
%   - no sequence specific stuff...
%   - only that needed by recon (and general)
%=====================================================

function [ExpPars,err] = CreateParamStructV_NaGeneral_v1a(Text)

err.flag = 0;
err.msg = '';

Study.expdefault = Parse_ParamsV_v1a(Text,'Date');
Study.varianfolder = Parse_ParamsV_v1a(Text,'Study');
Study.subject = Parse_ParamsV_v1a(Text,'Subject');
Study.comments = Parse_ParamsV_v1a(Text,'Comments');

Setup.len90 = str2double(Parse_ParamsV_v1a(Text,'setup 90 length'));
Setup.pwr90 = str2double(Parse_ParamsV_v1a(Text,'setup 90 power'));
Setup.gain = str2double(Parse_ParamsV_v1a(Text,'setup gain'));
Setup.linewid = str2double(Parse_ParamsV_v1a(Text,'setup line-width'));
Setup.resoffset = str2double(Parse_ParamsV_v1a(Text,'resonance Offset'));
Setup.vsparam = str2double(Parse_ParamsV_v1a(Text,'vs parameters'));

Sequence.protocol = Parse_ParamsV_v1a(Text,'protocol');
Sequence.sequence = Parse_ParamsV_v1a(Text,'sequence');
Sequence.scanlen = str2double(Parse_ParamsV_v1a(Text,'scan length'));
Sequence.phasecycle = str2double(Parse_ParamsV_v1a(Text,'phasecycle'));
Sequence.dummys = str2double(Parse_ParamsV_v1a(Text,'dummys'));
Sequence.orp = str2double(Parse_ParamsV_v1a(Text,'orp'));

Acq.projset = Parse_ParamsV_v1a(Text,'projection set');
Acq.gradpath = Parse_ParamsV_v1a(Text,'gradient path');
Acq.gcoil = Parse_ParamsV_v1a(Text,'gcoil');
Acq.vox = str2double(Parse_ParamsV_v1a(Text,'vox'));
Acq.fov = str2double(Parse_ParamsV_v1a(Text,'fov'));
Acq.elip = str2double(Parse_ParamsV_v1a(Text,'elip'));
Acq.nproj = str2double(Parse_ParamsV_v1a(Text,'nproj'));
Acq.tro = str2double(Parse_ParamsV_v1a(Text,'tro'));
Acq.npro = str2double(Parse_ParamsV_v1a(Text,'npro'));
Acq.sampstart = str2double(Parse_ParamsV_v1a(Text,'sampstart'));
Acq.dwell = str2double(Parse_ParamsV_v1a(Text,'dwell'));
Acq.fb = str2double(Parse_ParamsV_v1a(Text,'fb'));
Acq.rof2 = str2double(Parse_ParamsV_v1a(Text,'rof2'));
Acq.rdwn = str2double(Parse_ParamsV_v1a(Text,'rdwn'));
Acq.fildel = str2double(Parse_ParamsV_v1a(Text,'fildel'));
Acq.graddel = str2double(Parse_ParamsV_v1a(Text,'graddel'));
Acq.filtrans = str2double(Parse_ParamsV_v1a(Text,'filtrans'));
Acq.refocuspath = Parse_ParamsV_v1a(Text,'refocus path');
Acq.refocusfolder = Parse_ParamsV_v1a(Text,'refocus folder');

ExpPars.Study = Study;
ExpPars.Setup = Setup;
ExpPars.Sequence = Sequence;
ExpPars.Acq = Acq;

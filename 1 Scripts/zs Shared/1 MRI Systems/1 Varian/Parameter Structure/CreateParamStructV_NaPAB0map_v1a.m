%=====================================================
% (v1a)
%   - 
%=====================================================

function [ExpPars,err] = CreateParamStructV_NaPAB0map_v1a(Text)

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
Sequence.trep = str2double(Parse_ParamsV_v1a(Text,'trep'));
Sequence.padel1 = str2double(Parse_ParamsV_v1a(Text,'padel1'));
Sequence.padel2 = str2double(Parse_ParamsV_v1a(Text,'padel2'));
Sequence.te1 = str2double(Parse_ParamsV_v1a(Text,[char(10),'te1']));
Sequence.te2 = str2double(Parse_ParamsV_v1a(Text,[char(10),'te2']));
Sequence.flipangle = str2double(Parse_ParamsV_v1a(Text,'flip angle'));
Sequence.pw = str2double(Parse_ParamsV_v1a(Text,'pw'));
Sequence.phasecycle = str2double(Parse_ParamsV_v1a(Text,'phasecycle'));
Sequence.gspoilmag = str2double(Parse_ParamsV_v1a(Text,'gspoil mag'));
Sequence.gspoildur = str2double(Parse_ParamsV_v1a(Text,'gspoil dur'));
Sequence.orp = str2double(Parse_ParamsV_v1a(Text,'orp'));
Sequence.nave = str2double(Parse_ParamsV_v1a(Text,'nave'));
Sequence.tpwr = str2double(Parse_ParamsV_v1a(Text,'tpwr'));
Sequence.tpwrf = str2double(Parse_ParamsV_v1a(Text,'tpwrf'));
Sequence.atpwrf = str2double(Parse_ParamsV_v1a(Text,'atpwrf'));
Sequence.gain = str2double(Parse_ParamsV_v1a(Text,'gain'));
Sequence.dummys = str2double(Parse_ParamsV_v1a(Text,'dummys'));

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

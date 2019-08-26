%=====================================================
% (v1a)
%   - update to reflect underlying nameing change
%=====================================================

function [Tpars,FID,ParamsDisp,StudyDisp,err] = LoadVarian_RFPreSingleGrad_v1a(path)

FID = [];
ParamsDisp = [];
StudyDisp = [];
err.flag = 0;
err.msg = '';

[fid] = ImportExpArrayFIDmatV_v1a([path,filesep,'fid']);

[Text,err] = Load_ParamsV_v1a([path,filesep,'params']);
if err.flag == 1
    return
end

FID = fid;

ind1 = strfind(Text,'DECC File:');
StudyDisp = Text(1:ind1-1);

Study.expdefault = Parse_ParamsV_v1a(Text,'Date');
Study.varianfolder = Parse_ParamsV_v1a(Text,'Study');
Study.subject = Parse_ParamsV_v1a(Text,'Subject');
Study.comments = Parse_ParamsV_v1a(Text,'Comments');

Tpars.expdefault = Parse_ParamsV_v1a(Text,'expdefault');
Tpars.gcoil = Parse_ParamsV_v1a(Text,'gcoil');
Tpars.deccfile = Parse_ParamsV_v1a(Text,'DECC File');
Tpars.orp = str2double(Parse_ParamsV_v1a(Text,'orp'));
Tpars.position = Parse_ParamsV_v1a(Text,'Position');
Tpars.ParamPath = Parse_ParamsV_v1a(Text,'ParamPath');
Tpars.GradPath = Parse_ParamsV_v1a(Text,'GradPath');
Tpars.gval = str2double(Parse_ParamsV_v1a(Text,'gval'));
Tpars.dwell = str2double(Parse_ParamsV_v1a(Text,'dwell'));
Tpars.np = str2double(Parse_ParamsV_v1a(Text,'npro'));
Tpars.tr = str2double(Parse_ParamsV_v1a(Text,'tr'));
Tpars.pnum = str2double(Parse_ParamsV_v1a(Text,'pnum'));

if strcmp(Tpars.position(1),'L') || strcmp(Tpars.position(1),'R')
    Tpars.position = 'LR';
elseif strcmp(Tpars.position(1),'T') || strcmp(Tpars.position(1),'B')
    Tpars.position = 'TB';    
elseif strcmp(Tpars.position(1),'I') || strcmp(Tpars.position(1),'O')
    Tpars.position = 'IO';    
elseif str2double(Tpars.position) > 1000 && str2double(Tpars.position) < 2000
    Tpars.position = 'IO';  
end

if Tpars.orp == 1
    Tpars.graddir = 'LR';
elseif Tpars.orp == 2
    Tpars.graddir = 'TB';
elseif Tpars.orp == 3
    Tpars.graddir = 'IO';
end

ind1 = strfind(Text,'expdefault:');
ind2 = strfind(Text,'tr:');
ParamsDisp = Text(ind1:ind2-1);
ind1 = strfind(Text,'gcoil:');
ind2 = strfind(Text,'Protocol:');
ParamsDisp = [ParamsDisp Text(ind1:ind2-1)];
ind1 = strfind(Text,'DECC File:');
ind2 = strfind(Text,'expdefault:');
ParamsDisp = [ParamsDisp Text(ind1:ind2-2)];
ind1 = strfind(Text,'tr:');
ind2 = strfind(Text,'pw:');
ParamsDisp = [ParamsDisp Text(ind1:ind2-1)];
ParamsDisp = strrep(ParamsDisp,'orp:  1','Grad Direction: LR');
ParamsDisp = strrep(ParamsDisp,'orp:  2','Grad Direction: TB');
ParamsDisp = strrep(ParamsDisp,'orp:  3','Grad Direction: IO');
ParamsDisp = strrep(ParamsDisp,'Position:','2nd Probe Location:');
ParamsDisp = strrep(ParamsDisp,'Position:','2nd Probe Location:');
ParamsDisp = strrep(ParamsDisp,'Position:','2nd Probe Location:');



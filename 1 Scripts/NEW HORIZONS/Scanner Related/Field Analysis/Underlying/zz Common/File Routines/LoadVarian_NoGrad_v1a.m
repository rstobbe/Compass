%=====================================================
% (v1a)
%   - update to reflect underlying nameing change
%=====================================================

function [Tpars,FID,ParamsDisp,StudyDisp,err] = LoadVarian_NoGrad_v1a(path)

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

Tpars.expdefault = Parse_ParamsV_v1a(Text,'expdefault');
Tpars.gcoil = Parse_ParamsV_v1a(Text,'gcoil');
Tpars.deccfile = Parse_ParamsV_v1a(Text,'DECC File');
Tpars.position = Parse_ParamsV_v1a(Text,'Position');
Tpars.dwell = str2double(Parse_ParamsV_v1a(Text,'dwell'));
Tpars.np = str2double(Parse_ParamsV_v1a(Text,'npro'));
Tpars.t1rectime = str2double(Parse_ParamsV_v1a(Text,'t1rectime'));

if strcmp(Tpars.position(1),'L') || strcmp(Tpars.position(1),'R')
    Tpars.position = 'LR';
elseif strcmp(Tpars.position(1),'T') || strcmp(Tpars.position(1),'B')
    Tpars.position = 'TB';    
elseif strcmp(Tpars.position(1),'I') || strcmp(Tpars.position(1),'O')
    Tpars.position = 'IO';    
elseif str2double(Tpars.position) > 1000 && str2double(Tpars.position) < 2000
    Tpars.position = 'IO';  
end

ind1 = strfind(Text,'expdefault:');
ind2 = strfind(Text,'t1rectime:');
ParamsDisp = Text(ind1:ind2-1);
ind1 = strfind(Text,'gcoil:');
ind2 = strfind(Text,'Protocol:');
ParamsDisp = [ParamsDisp Text(ind1:ind2-1)];
ind1 = strfind(Text,'DECC File:');
ind2 = strfind(Text,'orp:');
ParamsDisp = [ParamsDisp Text(ind1:ind2-1)];
ind1 = strfind(Text,'Position:');
ind2 = strfind(Text,'expdefault:');
ParamsDisp = [ParamsDisp Text(ind1:ind2-2)];
ind1 = strfind(Text,'tr:');
ind2 = strfind(Text,'pw:');
ParamsDisp = [ParamsDisp Text(ind1:ind2-1)];
ParamsDisp = strrep(ParamsDisp,'Position:','2nd Probe Location:');
ParamsDisp = strrep(ParamsDisp,'Position:','2nd Probe Location:');
ParamsDisp = strrep(ParamsDisp,'Position:','2nd Probe Location:');

ind1 = strfind(Text,'Date:');
ind2 = strfind(Text,'Protocol:');
StudyDisp = Text(ind1:ind2-1);
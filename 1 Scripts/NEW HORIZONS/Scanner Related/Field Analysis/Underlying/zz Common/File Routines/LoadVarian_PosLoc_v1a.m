%=====================================================
% (v1a)
%   - update to reflect underlying nameing change
%=====================================================

function [Tpars,FID,ParamsDisp,StudyDisp,err] = LoadVarian_PosLoc_v1a(path)

FID = [];
ParamsDisp = [];
StudyDisp = [];
err.flag = 0;
err.msg = '';

%------------------------------------------
% Load Parameters
%------------------------------------------ 
[Text,err] = Load_ParamsV_v1a([path,filesep,'params']);
if err.flag == 1
    return
end

%------------------------------------------
% Build Structure
%------------------------------------------ 
Tpars.expdefault = Parse_ParamsV_v1a(Text,'expdefault');
Tpars.gcoil = Parse_ParamsV_v1a(Text,'gcoil');
Tpars.deccfile = Parse_ParamsV_v1a(Text,'DECC File');
Tpars.orp = str2double(Parse_ParamsV_v1a(Text,'orp'));
Tpars.position = Parse_ParamsV_v1a(Text,'Position');
Tpars.gval = str2double(Parse_ParamsV_v1a(Text,'gval'));
Tpars.dwell = str2double(Parse_ParamsV_v1a(Text,'dwell'));
Tpars.np = str2double(Parse_ParamsV_v1a(Text,'npro'));
Tpars.t1rectime = str2double(Parse_ParamsV_v1a(Text,'t1rectime'));

if strcmp(Tpars.position(1),'L') || strcmp(Tpars.position(1),'R')
    Tpars.position = 'LR';
elseif strcmp(Tpars.position(1),'T') || strcmp(Tpars.position,'B')
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

%------------------------------------------
% Build Panel Display
%------------------------------------------ 
ind1 = strfind(Text,'expdefault:');
ind2 = strfind(Text,'t1rectime:');
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

ind1 = strfind(Text,'Date:');
ind2 = strfind(Text,'Protocol:');
StudyDisp = Text(ind1:ind2-1);

%------------------------------------------
% Load FID
%------------------------------------------ 
FID = ImportExpArrayFIDmatV_v1a([path,filesep,'fid']); 


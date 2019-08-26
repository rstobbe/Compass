%=====================================================
% (v1a)
%   - 
%=====================================================

function [Tpars,FID,ParamsDisp,StudyDisp,err] = LoadVarian_SingleRFPostGrad_v1a(path)

FID = [];
ParamsDisp = [];
StudyDisp = [];
err.flag = 0;
err.msg = '';

[fid] = ImportExpArrayFIDmatV_v1a([path,filesep,'fid']);

[Text,errorflag,error] = Load_Params([path,filesep,'params']);
if errorflag == 1
    err.flag = 1;
    err.msg = error;
    return
end

Tpars.expdefault = Parse_Params(Text,'expdefault');
Tpars.gcoil = Parse_Params(Text,'gcoil');
Tpars.deccfile = Parse_Params(Text,'DECC File');
Tpars.orp = str2double(Parse_Params(Text,'orp'));
Tpars.position = Parse_Params(Text,'Position');
%Tpars.ParamPath = Parse_Params(Text,'ParamPath');
%Tpars.GradPath = Parse_Params(Text,'GradPath');
%Tpars.gontime = str2double(Parse_Params(Text,'gontime'));
Tpars.gval = str2double(Parse_Params(Text,'gval'));
Tpars.dwell = str2double(Parse_Params(Text,'dwell'));
Tpars.np = str2double(Parse_Params(Text,'npro'));
Tpars.tr = str2double(Parse_Params(Text,'tr'));
Tpars.falltime = str2double(Parse_Params(Text,'falltime'));
Tpars.seqtime = str2double(Parse_Params(Text,'seqtime'));

if isnan(Tpars.seqtime)
    Tpars.seqtime = 2*str2double(Parse_Params(Text,'rof2')) + ...
                      str2double(Parse_Params(Text,'pw')) + ...
                      str2double(Parse_Params(Text,'rdwn')) + ...
                      str2double(Parse_Params(Text,'filtrans'));
end
                  
if strcmp(Tpars.position,'L') || strcmp(Tpars.position,'R')
    Tpars.position = 'LR';
elseif strcmp(Tpars.position,'T') || strcmp(Tpars.position,'B')
    Tpars.position = 'TB';    
elseif strcmp(Tpars.position,'I') || strcmp(Tpars.position,'O')
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

ind = strfind(Text,'initdels:');
Text0 = Text(ind:ind+200);
ind = strfind(Text0,char(10));
Text0 = Text0(1:ind(1));
ind = strfind(Text0,char(32));

for n = 1:length(ind)-1
    initdel(n) = str2double(Text0(ind(n)+1:ind(n+1)-1));
    if initdel(n) == 0
        initdel(n) = 0.0001;
    end
    Tpars.initdels(n) = initdel(n);
    FID(n,:) = fid(n,:);
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

ind1 = strfind(Text,'Date:');
ind2 = strfind(Text,'Protocol:');
StudyDisp = Text(ind1:ind2-1);


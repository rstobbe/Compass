%=====================================================
% (v1a)
%   - update to reflect underlying nameing change
%=====================================================

function [Tpars,FID,ParamsDisp,StudyDisp,errorflag,error] = PreGradEddy_v1a_LoadVarian(path)

[fid] = ImportExpArrayFIDmatV_v1a([path,filesep,'fid']);

[Text,errorflag,error] = Load_Params([path,filesep,'params']);
if errorflag == 1
    Status('error',error);
    return
end

Tpars.dwell = str2double(Parse_Params(Text,'dwell'));
Tpars.np = str2double(Parse_Params(Text,'npro'));
Tpars.tr = str2double(Parse_Params(Text,'tr'));
Tpars.pnum = str2double(Parse_Params(Text,'pnum'));
Tpars.gval = str2double(Parse_Params(Text,'gval'));

%FID(n,:,:) = fid(function of pnum)...
FID = fid;

ind1 = strfind(Text,'gcoil:');
ind2 = strfind(Text,'Protocol:');
ParamsDisp = Text(ind1:ind2-1);
ind1 = strfind(Text,'expdefault:');
ind2 = strfind(Text,'pw:');
ParamsDisp = [ParamsDisp Text(ind1:ind2-1)];

ind1 = strfind(Text,'Date:');
ind2 = strfind(Text,'Protocol:');
StudyDisp = Text(ind1:ind2-1);


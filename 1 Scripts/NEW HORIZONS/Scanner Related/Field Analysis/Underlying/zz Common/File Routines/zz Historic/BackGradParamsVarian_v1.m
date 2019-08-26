%=====================================================
% 
%=====================================================

function [dwell,np,ParamsDisp,StudyDisp,errorflag,error] = BackGradParamsVarian_v1(path)

[Text,errorflag,error] = Load_Params([path,filesep,'params']);
if errorflag == 1
    Status('error',error);
    return
end

dwell = str2double(Parse_Params(Text,'dwell'));
np = str2double(Parse_Params(Text,'npro'));

ind1 = strfind(Text,'expdefault:');
ind2 = strfind(Text,'pw:');
ParamsDisp = Text(ind1:ind2-1);

ind1 = strfind(Text,'Date:');
ind2 = strfind(Text,'gcoil:');
StudyDisp = Text(ind1:ind2-1);
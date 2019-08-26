%=========================================================
% 
%=========================================================

function  [FUNClabs,error,errorflag] = Labels(method,func,N)

error = '';
errorflag = 0;
FUNClabs = '';

%--------------------------------
% Tests
%--------------------------------
validfor = {'mN04a_v1','mN05a_v1'};

good = 0;
for n = 1:length(validfor)
    if (strcmp(method,validfor{n}))
        good = 1;
        break
    end
end
if good == 0
    errorflag = 1;
    error = [func,' Function Not Appropriate for ',method];
    Status('error',error);
    return
end

%--------------------------------
% Defaults
%--------------------------------

%--------------------------------
% Labels
%--------------------------------
FUNClabs = '';

%================================================================
%  
%================================================================

classdef MSStudyClass < handle
    
    properties (SetAccess = private)
        Vidx = 0;
        Volunteer = MSVolunteerClass;
    end
    
    methods    
        %--------------------------------------------        
        % AddVolunteer
        %--------------------------------------------              
        function [DAT,err] = AddVolunteer(DAT,Name)
            err.flag = 0;
            for n = 1:DAT.Vidx
                if strcmp(DAT.Volunteer(n).Name,Name)
                    err.flag = 1;
                    err.msg = ['Attempt to add ',Name,' multiple times'];
                    return                                     
                end
            end
            DAT.Vidx = DAT.Vidx + 1;
            V = MSVolunteerClass;
            V.AddVolunteerName(Name);
            DAT.Volunteer(DAT.Vidx) = V;
        end        

        %--------------------------------------------        
        % FindVolunteer
        %-------------------------------------------- 
        function [Volunteer,err] = FindVolunteer(DAT,Name)
            Volunteer = [];
            err.flag = 0;
            found = 0;
            for n = 1:DAT.Vidx
                if strcmp(DAT.Volunteer(n).Name,Name)
                    if found == 1
                        err.flag = 1;
                        err.msg = [Name,' exists multiple times in database'];
                        return
                    end
                    Volunteer = DAT.Volunteer(n);
                    found = 1;
                end
            end
            if found == 0
                err.flag = 1;
                err.msg = ['''',Name,''' does not exist in database'];
                return
            end
        end    
    end              
end
        
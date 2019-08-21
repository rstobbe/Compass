%================================================================
%  
%================================================================

classdef StatusClass < handle

    properties (SetAccess = private)                                                                             
        tab;
        state;
        string;
        Status;
    end
    
%==================================================================
% Init
%==================================================================       
    methods
        % StatusClass
        function STATUS = StatusClass(IMAGEANLZ)
            global RWSUIGBL            
            global FIGOBJS
            arr = (1:10);
            tab = strcmp(IMAGEANLZ.tab,RWSUIGBL.TabArray);
            STATUS.tab = arr(tab);
            STATUS.state = cell(1,3);
            STATUS.string = cell(1,3);
            STATUS.Status = FIGOBJS.Status;
        end
        
%==================================================================
% Functions
%==================================================================          
        % UpdateStatus
        function UpdateStatus(STATUS)
            Status_Update(STATUS);
        end
        % SetStatus
        function SetStatus(STATUS,Status)
            for n = 1:3
                STATUS.string{n} = Status(n).string;
                STATUS.state{n} = Status(n).state;
            end
        end
        % SetStatusLine
        function SetStatusLine(STATUS,Status,line)
            STATUS.string{line} = Status.string;
            STATUS.state{line} = Status.state;
        end
        % ResetStatus
        function ResetStatus(STATUS)
            for n = 1:3
                STATUS.string{n} = '';
                STATUS.state{n} = 'off';
            end
            Status_Update(STATUS);
        end
        % ShowError
        function ShowError(STATUS,Error)
            STATUS.string{3} = 'error';
            STATUS.state{3} = Error;
            Status_Update(STATUS);
        end
        % ShowWarning
        function ShowWarning(STATUS,Warn)
            STATUS.string{3} = 'warn';
            STATUS.state{3} = Warn;
            Status_Update(STATUS);
        end
    end
end
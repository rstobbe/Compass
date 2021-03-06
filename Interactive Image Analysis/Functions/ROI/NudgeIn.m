%============================================
% 
%============================================
function NudgeIn(tab,axnum)

global IMAGEANLZ

%----------------------------------------
% RoiTie
%----------------------------------------
if IMAGEANLZ.(tab)(axnum).ROITIE == 1
    start = 1;    
    stop = IMAGEANLZ.(tab)(axnum).axeslen;
else
    start = axnum;
    stop = axnum;
end

switch IMAGEANLZ.(tab)(axnum).presentation
    case 'Standard'
        %--
        showcurrentroionall = 1;
        %--
        if showcurrentroionall == 1
            for r = start:stop
                if IMAGEANLZ.(tab)(r).TestAxisActive
                    IMAGEANLZ.(tab)(r).CURRENTROI.NudgeIn;
                    if IMAGEANLZ.(tab)(r).shaderoi
                        IMAGEANLZ.(tab)(r).CURRENTROI.CreateBaseROIMask;
                    end
                    IMAGEANLZ.(tab)(r).DrawCurrentROI([]);
                    IMAGEANLZ.(tab)(r).TestUpdateCurrentROIValue;
                end
            end
        else
            IMAGEANLZ.(tab)(axnum).CURRENTROI.NudgeIn;
            if IMAGEANLZ.(tab)(axnum).shaderoi
                IMAGEANLZ.(tab)(axnum).CURRENTROI.CreateBaseROIMask;
            end
            IMAGEANLZ.(tab)(axnum).DrawCurrentROI([]);
        end
    case 'Ortho'
        for r = 1:3
            IMAGEANLZ.(tab)(r).CURRENTROI.NudgeIn;
            if IMAGEANLZ.(tab)(r).shaderoi
                IMAGEANLZ.(tab)(r).CURRENTROI.CreateBaseROIMask;
            end
            IMAGEANLZ.(tab)(r).DrawCurrentROI([]);
        end
        IMAGEANLZ.(tab)(1).TestUpdateCurrentROIValue;
end







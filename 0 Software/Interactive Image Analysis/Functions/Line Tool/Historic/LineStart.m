%============================================
% Drawn Line Across Image...
%============================================
function LineStart

global BUTTONFUNCTION
global PBUTTONFUNCTION
global POINTER
global PPOINTER
global TOGLINE
global LINEHAND
global LINE
global LINEMARKHAND
global LINEMARKHAND2
global AX1
global AX2
global TOGROICOL
global CURFIG

switch TOGLINE
    case 'off'
        TOGLINE = 'on';
        switch BUTTONFUNCTION
            case 'roicollect'
                TOGROICOL.draw = 'off'; 
            case 'roiseed_p'
                TOGROICOL.seedn = 'off';
            case 'roiseed_n'
                TOGROICOL.seedp = 'off';
        end
        PBUTTONFUNCTION = BUTTONFUNCTION;
        BUTTONFUNCTION = 'linecollect';
        cur = NaN*zeros(16,16);
        cur(8,1:15) = 1;
        cur(1:15,8) = 1;
        set(gcf,'pointer','custom','PointerShapeCData',cur,'PointerShapeHotSpot',[8 8]);
        PPOINTER = POINTER;
        POINTER = 'custom';
        for r = 1:2    
            switch r
                case 1; axes = AX1;
                case 2; axes = AX2;
            end
            LINEHAND(r) = line([0 0],[0 0],'parent',axes,'linewidth',1,'color','r');
            LINEMARKHAND(r,1) = line([0 0],[0 0],'parent',axes,'linewidth',1,'color','r');
            LINEMARKHAND(r,2) = line([0 0],[0 0],'parent',axes,'linewidth',1,'color','r');
            LINEMARKHAND(r,3) = line([0 0],[0 0],'parent',axes,'linewidth',1,'color','r');
            LINEMARKHAND(r,4) = line([0 0],[0 0],'parent',axes,'linewidth',1,'color','r');
            LINEMARKHAND2(r,1) = line([0 0],[0 0],'parent',axes,'linewidth',1,'color','r');
            LINEMARKHAND2(r,2) = line([0 0],[0 0],'parent',axes,'linewidth',1,'color','r');
            LINEMARKHAND2(r,3) = line([0 0],[0 0],'parent',axes,'linewidth',1,'color','r');
            LINEMARKHAND2(r,4) = line([0 0],[0 0],'parent',axes,'linewidth',1,'color','r');
        end
        Info('info','Line Tool Active'); 
        Info2('info','');        
    case 'on'
        TOGLINE = 'off';
        BUTTONFUNCTION = PBUTTONFUNCTION;
        POINTER = PPOINTER;
        set(gcf,'pointer',POINTER);
        LINE(1).x = 0;
        LINE(1).y = 0;
        LINE(2).x = 0;
        LINE(2).y = 0;
        Plot_XY_Slice(CURFIG);
        Draw_All_ROIs;
        Info('info',''); 
        Info2('info','');
        switch BUTTONFUNCTION
            case 'roicollect'
                Info('info','Free-Hand Drawing Tool Active'); 
            case 'roiseed_p'
                Info('info','Greater-than Seeding Tool Active');
            case 'roiseed_n'
                Info('info','Less-than Seeding  Tool Active');
        end
end
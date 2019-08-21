%=========================================================
% 
%=========================================================

function CompassPanel4K(style,ob,str,val,callback1,callback2)

global FIGOBJS
BGcolour = FIGOBJS.Colours.BGcolour;
global RWSUIGBL

%------------------------------
% Label Styles
%------------------------------
if strcmp(style,'0heading')
    error;
elseif strcmp(style,'0labellvl1')
    set(ob,'style','text');        
    set(ob,'fontsize',8);    
    set(ob,'fontweight','normal');
    set(ob,'backgroundcolor',BGcolour);                        
    set(ob,'foregroundcolor',[1,1,0.5]);   
    set(ob,'horizontalalignment','left'); 
    set(ob,'callback','');  
    set(ob,'string',str); 
    set(ob,'visible','on');
    set(ob,'enable','on');
elseif strcmp(style,'0labellvl2')
    set(ob,'style','text');        
    set(ob,'fontsize',8);    
    set(ob,'fontweight','normal');
    set(ob,'backgroundcolor',BGcolour);          
    set(ob,'foregroundcolor',[0.4,0.5,1]);             
    set(ob,'horizontalalignment','left'); 
    set(ob,'callback','');  
    set(ob,'string',str); 
    set(ob,'visible','on');
    set(ob,'enable','on');
elseif strcmp(style,'0labellvl3')
    set(ob,'style','text');        
    set(ob,'fontsize',8);    
    set(ob,'fontweight','normal');
    set(ob,'backgroundcolor',BGcolour);          
    set(ob,'foregroundcolor',[0.32,0.4,0.7]);             
    set(ob,'horizontalalignment','left'); 
    set(ob,'callback','');  
    set(ob,'string',str); 
    set(ob,'visible','on');
    set(ob,'enable','on');
elseif strcmp(style,'0labellvl4')
    set(ob,'style','text');        
    set(ob,'fontsize',8);    
    set(ob,'fontweight','normal');
    set(ob,'backgroundcolor',BGcolour);          
    set(ob,'foregroundcolor',[0.30,0.36,0.50]);             
    set(ob,'horizontalalignment','left'); 
    set(ob,'callback','');  
    set(ob,'string',str); 
    set(ob,'visible','on');
    set(ob,'enable','on');
elseif strcmp(style,'0labellvl5')
    set(ob,'style','text');        
    set(ob,'fontsize',8);    
    set(ob,'fontweight','normal');
    set(ob,'backgroundcolor',BGcolour);          
    set(ob,'foregroundcolor',[0.7,0.8,1]);             
    set(ob,'horizontalalignment','left'); 
    set(ob,'callback','');  
    set(ob,'string',str); 
    set(ob,'visible','on');
    set(ob,'enable','on');
elseif strcmp(style,'0scrptfunclvl1')
    set(ob,'style','text');        
    set(ob,'fontsize',8);    
    set(ob,'fontweight','normal');
    set(ob,'backgroundcolor',BGcolour);          
    set(ob,'foregroundcolor',[1,1,0.5]);                
    set(ob,'horizontalalignment','left'); 
    set(ob,'callback','');  
    set(ob,'string',str); 
    set(ob,'visible','on');
    set(ob,'enable','on');
elseif strcmp(style,'0scrptfunclvl2')
    set(ob,'style','text');        
    set(ob,'fontsize',7);    
    set(ob,'fontweight','normal');
    set(ob,'backgroundcolor',BGcolour);          
    set(ob,'foregroundcolor',[0.4,0.5,1]);           
    set(ob,'horizontalalignment','left'); 
    set(ob,'callback','');  
    set(ob,'string',str); 
    set(ob,'visible','on');
    set(ob,'enable','on');
elseif strcmp(style,'0scrptfunclvl3')
    set(ob,'style','text');        
    set(ob,'fontsize',8);    
    set(ob,'fontweight','normal');
    set(ob,'backgroundcolor',BGcolour);          
    set(ob,'foregroundcolor',[0.7,0.8,1]);           
    set(ob,'horizontalalignment','left'); 
    set(ob,'callback','');  
    set(ob,'string',str); 
    set(ob,'visible','on');
    set(ob,'enable','on');
elseif strcmp(style,'0function')
    set(ob,'style','text');        
    set(ob,'fontsize',8);    
    set(ob,'fontweight','normal');
    set(ob,'backgroundcolor',BGcolour);                        
    set(ob,'foregroundcolor',[0.6,0.9,0.6]);   
    set(ob,'horizontalalignment','left'); 
    set(ob,'callback','');  
    set(ob,'string',str); 
    set(ob,'visible','on');
    set(ob,'enable','on');
elseif strcmp(style,'1function')
    set(ob,'style','text');        
    set(ob,'fontsize',8);    
    set(ob,'fontweight','normal');
    set(ob,'backgroundcolor',BGcolour);                        
    set(ob,'foregroundcolor',[0.55,0.4,0.35]);   
    set(ob,'horizontalalignment','left'); 
    set(ob,'callback','');  
    set(ob,'string',str); 
    set(ob,'visible','on');
    set(ob,'enable','on');
elseif strcmp(style,'0output')
    set(ob,'style','text');        
    set(ob,'fontsize',8);    
    set(ob,'fontweight','normal');
    set(ob,'backgroundcolor',BGcolour);                        
    set(ob,'foregroundcolor',[0.9,0.7,0.7]); 
    set(ob,'horizontalalignment','left'); 
    set(ob,'callback','');  
    set(ob,'string',str); 
    set(ob,'visible','on');
    set(ob,'enable','on');
elseif strcmp(style,'0space')
    set(ob,'style','text');        
    set(ob,'fontsize',8);    
    set(ob,'fontweight','normal');
    set(ob,'backgroundcolor',BGcolour);                        
    set(ob,'foregroundcolor',[0.9,0.7,0.7]); 
    set(ob,'horizontalalignment','left'); 
    set(ob,'callback','');  
    set(ob,'string',str); 
    set(ob,'visible','off');
    set(ob,'enable','on');
    
%------------------------------
% Entry Styles
%------------------------------
elseif strcmp(style,'0edit')
    position = get(ob,'position'); 
    position(3) = RWSUIGBL.editwid;
    set(ob,'position',position); 
    set(ob,'style','edit');        
    set(ob,'fontsize',8);    
    set(ob,'backgroundcolor',BGcolour);          
    set(ob,'foregroundcolor',[0.753,0.753,0.753]);                
    set(ob,'callback','');  
    set(ob,'string',str); 
    set(ob,'visible','on');
    set(ob,'enable','on');
elseif strcmp(style,'2edit')
    position = get(ob,'position'); 
    position(3) = RWSUIGBL.editwid;
    set(ob,'position',position); 
    set(ob,'style','edit');        
    set(ob,'fontsize',8);    
    set(ob,'backgroundcolor',BGcolour);          
    set(ob,'foregroundcolor',[0.55,0.4,0.35]);                
    set(ob,'callback','');  
    set(ob,'string',str); 
    set(ob,'visible','on');
    set(ob,'enable','on');
elseif strcmp(style,'0text')
    position = get(ob,'position'); 
    position(3) = RWSUIGBL.textwid;
    set(ob,'position',position);
    set(ob,'style','text');        
    set(ob,'fontsize',8);    
    set(ob,'backgroundcolor',BGcolour);          
    set(ob,'foregroundcolor',[0.753,0.753,0.753]); 
    set(ob,'horizontalalignment','left'); 
    set(ob,'callback','');  
    set(ob,'string',str); 
    set(ob,'visible','on');
    set(ob,'enable','on');
elseif strcmp(style,'0name1text')
    position = get(ob,'position'); 
    position(3) = RWSUIGBL.textwid;
    set(ob,'position',position);
    set(ob,'style','text');        
    set(ob,'fontsize',7);    
    set(ob,'backgroundcolor',BGcolour);          
    set(ob,'foregroundcolor',[1,1,0.5]); 
    set(ob,'horizontalalignment','left'); 
    set(ob,'callback','');  
    set(ob,'string',str); 
    set(ob,'visible','on');
    set(ob,'enable','on');
elseif strcmp(style,'0name2text')
    position = get(ob,'position'); 
    position(3) = RWSUIGBL.textwid;
    set(ob,'position',position);
    set(ob,'style','text');        
    set(ob,'fontsize',7);    
    set(ob,'backgroundcolor',BGcolour);          
    set(ob,'foregroundcolor',[0.6,0.9,0.6]); 
    set(ob,'horizontalalignment','left'); 
    set(ob,'callback','');  
    set(ob,'string',str); 
    set(ob,'visible','on');
    set(ob,'enable','on');
elseif strcmp(style,'0errortext')
    position = get(ob,'position'); 
    position(3) = RWSUIGBL.textwid;
    set(ob,'position',position);
    set(ob,'style','text');        
    set(ob,'fontsize',8);    
    set(ob,'backgroundcolor',BGcolour);          
    set(ob,'foregroundcolor',[0.8,0.2,0]); 
    set(ob,'horizontalalignment','left'); 
    set(ob,'callback','');  
    set(ob,'string',str); 
    set(ob,'visible','on');
    set(ob,'enable','on');
elseif strcmp(style,'0smalltext')
    position = get(ob,'position'); 
    position(3) = RWSUIGBL.textwid;
    set(ob,'position',position);
    set(ob,'style','text');        
    set(ob,'fontsize',7);    
    set(ob,'backgroundcolor',BGcolour);          
    set(ob,'foregroundcolor',[0.753,0.753,0.753]); 
    set(ob,'horizontalalignment','left'); 
    set(ob,'callback','');  
    set(ob,'string',str); 
    set(ob,'visible','on');
    set(ob,'enable','on');
elseif strcmp(style,'2text')
    position = get(ob,'position'); 
    position(3) = RWSUIGBL.textwid;
    set(ob,'position',position);
    set(ob,'style','text');        
    set(ob,'fontsize',8);    
    set(ob,'backgroundcolor',BGcolour);          
    set(ob,'foregroundcolor',[0.55,0.4,0.35]); 
    set(ob,'horizontalalignment','left'); 
    set(ob,'callback','');  
    set(ob,'string',str); 
    set(ob,'visible','on');
    set(ob,'enable','on');
elseif strcmp(style,'2smalltext')
    position = get(ob,'position'); 
    position(3) = RWSUIGBL.textwid;
    set(ob,'position',position);
    set(ob,'style','text');        
    set(ob,'fontsize',7);    
    set(ob,'backgroundcolor',BGcolour);          
    set(ob,'foregroundcolor',[0.55,0.4,0.35]); 
    set(ob,'horizontalalignment','left'); 
    set(ob,'callback','');  
    set(ob,'string',str); 
    set(ob,'visible','on');
    set(ob,'enable','on');
elseif strcmp(style,'0popupmenu')
    position = get(ob,'position'); 
    position(3) = RWSUIGBL.editwid;
    set(ob,'position',position);
    set(ob,'style','popupmenu');        
    set(ob,'fontsize',9);    
    set(ob,'backgroundcolor',[0,0,0.251]);          
    set(ob,'foregroundcolor',[0.753,0.753,0.753]); 
    set(ob,'callback','');  
    set(ob,'value',val);
    set(ob,'string',str); 
    set(ob,'visible','on');
    set(ob,'enable','on'); 
elseif strcmp(style,'2popupmenu')
    position = get(ob,'position'); 
    position(3) = RWSUIGBL.editwid;
    set(ob,'position',position);
    set(ob,'style','popupmenu');        
    set(ob,'fontsize',7);    
    set(ob,'backgroundcolor',BGcolour);          
    set(ob,'foregroundcolor',[0.55,0.4,0.35]); 
    set(ob,'callback','');  
    set(ob,'value',val);
    set(ob,'string',str); 
    set(ob,'visible','on');
    set(ob,'enable','on'); 
    
%------------------------------
% Select Styles
%------------------------------
elseif strcmp(style,'activated')
    set(ob,'style','pushbutton');        
    set(ob,'fontsize',7);    
    set(ob,'backgroundcolor',[1,1,0.5]);          
    set(ob,'foregroundcolor',[0.8,0.8,0.8]); 
    set(ob,'callback',callback1);
    set(ob,'buttondownfcn',callback2);
    set(ob,'string',str); 
    set(ob,'visible','on');
    set(ob,'enable','on');
elseif strcmp(style,'0pushbutton')
    set(ob,'style','pushbutton');        
    set(ob,'fontsize',7);    
    set(ob,'backgroundcolor',BGcolour);          
    set(ob,'foregroundcolor',[0.8,0.8,0.8]); 
    set(ob,'callback',callback1);
    set(ob,'buttondownfcn',callback2);
    set(ob,'string',str); 
    set(ob,'visible','on');
    set(ob,'enable','on');    
elseif strcmp(style,'0lockpushbutton')
    set(ob,'style','pushbutton');        
    set(ob,'fontsize',7);    
    set(ob,'backgroundcolor',BGcolour);          
    set(ob,'foregroundcolor',[1,1,1]); 
    set(ob,'callback',callback1);
    set(ob,'buttondownfcn',callback2);
    set(ob,'string',str); 
    set(ob,'visible','on');
    set(ob,'enable','off');
elseif strcmp(style,'0off')
    set(ob,'style','text');        
    set(ob,'visible','off');
    set(ob,'enable','off');
    
elseif strcmp(style,'none')
    set(ob,'visible','off');
else
    style
    error;
end

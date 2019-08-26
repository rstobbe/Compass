%==================================
%
%==================================

function dr = Rad2D_Sol(t,r,flag,deradsolfunc) 

dr = 1/(r*deradsolfunc(r));      



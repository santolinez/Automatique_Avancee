function uifun(action)

if nargin < 1
  clc, clear, close all;
  action = 'initialize';
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Create controls
if strcmp(action,'initialize')  
  % dimensions
  hspace = 125;
  vspacefat = 30;
  Lfat = '[x+6 y 48 28]';
  Rfat = '[x+71 y 48 28]';
  vspacethin = 20;
  thin = '[x+6 y 113 18]';
  Lthin = '[x+6 y 63 18]';
  Rthin = '[x+71 y 48 18]';
  
  % main window
  figure('Name','PVTOL','NumberTitle','off','MenuBar','none','Resize','on','Visible','off');
  
  % Start and quit push buttons
  x = 0;
  y = 6;
  pb(1) = uicontrol('Style','push','Position',eval(Lfat),'String','Start','ForegroundColor','w','Callback','uifun(''start'')',...
    'BackGroundColor','b','Tag','pb1');
  pb(2) = uicontrol('Style','push','Position',eval(Rfat),'String','Quit','Callback','uifun(''quit'')',...
    'BackGroundColor','r','Tag','pb2');
  y = y+vspacefat;
  
  % Text and editable text controls for simulation parameters
  y = y+12;
  txt(2) = uicontrol('Style','text','Position',eval(Lthin),'String','Stop time','Tag','t2');
  ed(2) = uicontrol('Style','edit','Position',eval(Rthin),'String','5','Tag','ed2');
  y = y+vspacethin;
  txt(1) = uicontrol('Style','text','Position',eval(Lthin),'String','Start time','Tag','t1');
  ed(1) = uicontrol('Style','edit','Position',eval(Rthin),'String','0','Tag','ed1');
  y = y+vspacethin+12;
  
  % Pop-up menu 2
  pop(1) = uicontrol('Style','popup','Position',eval(thin),'String','Tangent|I/O|Flat',...
    'Callback','uifun(''pop'')','Tag','pop1');
  y = y+2*vspacethin+10;
    
  % Info push button
  pb(3) = uicontrol('Style','push','Position',eval(thin),'String','Info','ForegroundColor','w','Callback','uifun(''info'')',...
    'BackGroundColor','b','Tag','pb3');
  
  % Transfer parameters
  x=x+hspace;
  y=6;
  
  txt(7) = uicontrol('Style','text','Position',eval(Lthin),'String','tf','Tag','t7');
  ed(7) = uicontrol('Style','edit','Position',eval(Rthin),'String','5','Tag','ed7');
  y = y+vspacethin+6;
  
  txt(6) = uicontrol('Style','text','Position',eval(Lthin),'String','zf','Tag','t6');
  ed(6) = uicontrol('Style','edit','Position',eval(Rthin),'String','0','Tag','ed6');
  y = y+vspacethin;
  
  txt(5) = uicontrol('Style','text','Position',eval(Lthin),'String','xf','Tag','t5');
  ed(5) = uicontrol('Style','edit','Position',eval(Rthin),'String','50','Tag','ed5');
  y = y+vspacethin+6;
  
  txt(4) = uicontrol('Style','text','Position',eval(Lthin),'String','zi','Tag','t4');
  ed(4) = uicontrol('Style','edit','Position',eval(Rthin),'String','0','Tag','ed4');
  y = y+vspacethin;
  
  txt(3) = uicontrol('Style','text','Position',eval(Lthin),'String','xi','Tag','t3');
  ed(3) = uicontrol('Style','edit','Position',eval(Rthin),'String','0','Tag','ed3');
  y = y+vspacethin+6;
  
  uicontrol('Style','text','Position',eval(Lthin),'String','Trajectory','BackGroundColor','c');
  y = y+vspacethin+6;
  
  % Feedback parameters
  x=x+hspace;
  y=6;
  
  txt(13) = uicontrol('Style','text','Position',eval(Lthin),'String','zeta20','Tag','t13');
  ed(13) = uicontrol('Style','edit','Position',eval(Rthin),'String','0','Tag','ed13');
  y = y+vspacethin;
  
  txt(12) = uicontrol('Style','text','Position',eval(Lthin),'String','zeta10','Tag','t12');
  ed(12) = uicontrol('Style','edit','Position',eval(Rthin),'String','10','Tag','ed12');
  y = y+vspacethin+30;
  
  txt(11) = uicontrol('Style','text','Position',eval(Lthin),'String','epsilon','Tag','t11');
  ed(11) = uicontrol('Style','edit','Position',eval(Rthin),'String','.1','Tag','ed11');
  y = y+vspacethin;
  
  txt(30) = uicontrol('Style','text','Position',eval(Lthin),'String','lambda','Tag','t30');
  ed(30) = uicontrol('Style','edit','Position',eval(Rthin),'String','20','Tag','ed30');
  y = y+vspacethin;
  
  txt(10) = uicontrol('Style','text','Position',eval(Lthin),'String','b','Tag','t10');
  ed(10) = uicontrol('Style','edit','Position',eval(Rthin),'String','1e4','Tag','ed10');
  y = y+vspacethin;
  
  txt(9) = uicontrol('Style','text','Position',eval(Lthin),'String','a','Tag','t9');
  ed(9) = uicontrol('Style','edit','Position',eval(Rthin),'String','1e4','Tag','ed9');
  y = y+vspacethin;
  
  txt(8) = uicontrol('Style','text','Position',eval(Lthin),'String','g','Tag','t8');
  ed(8) = uicontrol('Style','edit','Position',eval(Rthin),'String','10','Tag','ed8');
  y = y+vspacethin+6;
  
  % Feedback gains
  x=x+hspace;
  y=6;
  
  txt(21) = uicontrol('Style','text','Position',eval(Lthin),'Tag','t21');
  ed(21) = uicontrol('Style','edit','Position',eval(Rthin),'String','10','Tag','ed21');
  y = y+vspacethin;
  
  txt(20) = uicontrol('Style','text','Position',eval(Lthin),'Tag','t20');
  ed(20) = uicontrol('Style','edit','Position',eval(Rthin),'String','-35','Tag','ed20');
  y = y+vspacethin;
  
  txt(19) = uicontrol('Style','text','Position',eval(Lthin),'Tag','t19');
  ed(19) = uicontrol('Style','edit','Position',eval(Rthin),'String','6','Tag','ed19');
  y = y+vspacethin;
  
  txt(18) = uicontrol('Style','text','Position',eval(Lthin),'String','gains2','Tag','t18');
  ed(18) = uicontrol('Style','edit','Position',eval(Rthin),'String','8','Tag','ed18');
  y = y+vspacethin+4;
  
  txt(17) = uicontrol('Style','text','Position',eval(Lthin),'Tag','t17');
  ed(17) = uicontrol('Style','edit','Position',eval(Rthin),'String','10','Tag','ed17');
  y = y+vspacethin;
  
  txt(16) = uicontrol('Style','text','Position',eval(Lthin),'Tag','t16');
  ed(16) = uicontrol('Style','edit','Position',eval(Rthin),'String','-35','Tag','ed16');
  y = y+vspacethin;
  
  txt(15) = uicontrol('Style','text','Position',eval(Lthin),'Tag','t15');
  ed(15) = uicontrol('Style','edit','Position',eval(Rthin),'String','50','Tag','ed15');
  y = y+vspacethin;
  
  txt(14) = uicontrol('Style','text','Position',eval(Lthin),'String','gains1','Tag','t14');
  ed(14) = uicontrol('Style','edit','Position',eval(Rthin),'String','24','Tag','ed14');
  y = y+vspacethin;
  
  % Initial conditions
  x=x+hspace;
  y=6;
  txt(29) = uicontrol('Style','text','Position',eval(Lthin),'String','F20','Tag','t29');
  ed(29) = uicontrol('Style','edit','Position',eval(Rthin),'String','50000','Tag','ed29');
  y = y+vspacethin;
  
  txt(28) = uicontrol('Style','text','Position',eval(Lthin),'String','F10','Tag','t28');
  ed(28) = uicontrol('Style','edit','Position',eval(Rthin),'String','50000','Tag','ed28');
  y = y+vspacethin+4;
  
  txt(27) = uicontrol('Style','text','Position',eval(Lthin),'String','thetadot_0','Tag','t27');
  ed(27) = uicontrol('Style','edit','Position',eval(Rthin),'String','0','Tag','ed27');
  y = y+vspacethin;
  
  txt(26) = uicontrol('Style','text','Position',eval(Lthin),'String','theta_0','Tag','t26');
  ed(26) = uicontrol('Style','edit','Position',eval(Rthin),'String','0','Tag','ed26');
  y = y+vspacethin;
  
  txt(25) = uicontrol('Style','text','Position',eval(Lthin),'String','zdot_0','Tag','t25');
  ed(25) = uicontrol('Style','edit','Position',eval(Rthin),'String','0','Tag','ed25');
  y = y+vspacethin;
  
  txt(24) = uicontrol('Style','text','Position',eval(Lthin),'String','z_0','Tag','t24');
  ed(24) = uicontrol('Style','edit','Position',eval(Rthin),'String','0','Tag','ed24');
  y = y+vspacethin;
  
  txt(23) = uicontrol('Style','text','Position',eval(Lthin),'String','xdot_0','Tag','t23');
  ed(23) = uicontrol('Style','edit','Position',eval(Rthin),'String','0','Tag','ed23');
  y = y+vspacethin;
  
  txt(22) = uicontrol('Style','text','Position',eval(Lthin),'String','x_0','Tag','t22');
  ed(22) = uicontrol('Style','edit','Position',eval(Rthin),'String','0','Tag','ed22');
  y = y+vspacethin;

  % Set colors and resize window
  set(txt,'BackGroundColor','c')
  set(ed,'BackGroundColor','w')
  set(pop,'BackGroundColor','w')
  uifun('pop')
  set(gcf,'Color','c','Visible','on');
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % Pop-up menus callback
elseif strcmp(action,'pop')
  % Get handles from figure UserData
  pop(1) = findobj(gcf,'Tag','pop1');
  pb(1) = findobj(gcf,'Tag','pb1');
  pb(2) = findobj(gcf,'Tag','pb2');
  pb(3) = findobj(gcf,'Tag','pb3');
  for i = 1:30
    str = ['t',num2str(i)];
    txt(i) = findobj(gcf,'Tag',str);
    str = ['ed',num2str(i)];
    ed(i) = findobj(gcf,'Tag',str);
  end
  
  feed = get(pop(1),'Value');
  if feed==1
    sys = 'tgt';
    range = [3:10,14:19,22:29];
  elseif feed==2
    sys = 'io';
    range = [3:11,14:15,18:19,22:29];
  elseif feed==3
    sys = 'flt';
    range = [3:29];
  end
  set(pop(1),'UserData',sys);
  
  set([txt(3:29),ed(3:29)],'Visible','off')

  set([txt(range),ed(range)],'Visible','on')
  set(gcf,'Position',[0, 400 ,125*5, 8*20+2*6+4]);

  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % Stop push button callback
elseif strcmp(action,'quit')

  close all
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % Info push button callback
elseif strcmp(action,'info')
  clc
  disp('Projet Automatique avancée MT5 2025-2026')
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % Start push button callback
elseif strcmp(action,'start')
  % Get handles from figure UserData
  pop(1)=findobj(gcf,'Tag','pop1');
  pb(1)=findobj(gcf,'Tag','pb1');
  pb(2)=findobj(gcf,'Tag','pb2');
  pb(3)=findobj(gcf,'Tag','pb3');
  for i=1:30
    txt(i)=findobj(gcf,'Tag',['t',num2str(i)]);
    ed(i)=findobj(gcf,'Tag',['ed',num2str(i)]);
  end
  
  flag = 1;
  ednum = zeros(1,30);
  % Check numerical editable texts
  for i=1:30
    num = str2num(get(ed(i),'String'));
    set(ed(i),'BackGroundColor','w','ForeGroundColor','k');
    if (num==[])
      if strcmp(get(ed(i),'Visible'),'on')
        set(ed(i),'String','','BackGroundColor','k','ForeGroundColor','w');
        disp('Not a number')
        flag = 0;
        break
      end
    else
      ednum(i) = num;
    end
  end

  
  if flag
    start = ednum(1);
    stop = ednum(2);
    trajData = ednum(3:7); % trajData=[xi,zi,xf,zf,tf]

    param = [ednum(8:11) ednum(30)];
    gains = [ednum(14:17);ednum(18:21)];
    state0 = ednum(22:29);    
    
    % Launch simulation
    sys= get(pop(1),'UserData');
    if strcmp(sys,'flt')
       state0 = [state0  ednum(12:13)];  % états du contrôleur ajoutés à ceux du VTOL
    end
    state0 = state0';
    [tt,state,xz_ref,u_actu] = sim_matl(start,stop,state0,trajData,param,gains,sys);
    pause(1)
    uisave({'tt','state','xz_ref','u_actu','param','gains','sys'},'simu');
  end
end
end


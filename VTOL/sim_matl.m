function [tt,state,xz_ref,u_actu] = sim_matl(start,stop,state0,trajData,param,gains,sys)
global  param_ trajData_ gains_
trajData_ = trajData;
param_= param;
gains_ = gains;

clc
% Integration
disp('Integrating with ode45...')
[tt,state] = ode45(['matl',sys],[start,stop],state0);

% Recompute xz_ref and u_actu
disp('Recomputing xz_ref and u_actu...')
recomp1 = zeros(2,length(tt));
recomp2 = zeros(2,length(tt));
for i=1:length(tt)
  t = tt(i);
  jet = traj(t,trajData);
  nowstate = state(i,:);
  u = feval(['control',sys],t,nowstate,jet);
  recomp1(:,i) = u(1:2);
  recomp2(:,i) = jet([1,6]);
end
xz_ref = recomp2(1:2,:)';
u_actu = recomp1(1:2,:)';
anim(tt,state,xz_ref,u_actu)
affichage(tt,state,xz_ref,u_actu)
end
%---------------------------------------------------------------
%% anim
function anim(tt,state,xz_ref,u_actu)
global param_
param = param_;
% param(1) = g
% param(2) = m/Calpha
% param(3) = J/l/Calpha
% param(4) = epsilon = Talpha (si a=b)

% Normalize thrusts
m = param(2)/sqrt(1+param(4)^2);
state(:,7:8) = state(:,7:8)/m;
u_actu = u_actu/m;

% Make smooth data for graphics
data = [state(:,1:8),xz_ref,u_actu];
start = tt(1);
stop = tt(length(tt));
timegrid = start:(stop-start)/200:stop;
data = [timegrid', interp1(tt,data,timegrid)];

% data(:,1) <> time
% data(:,2) <> x
% data(:,3) <> xdot
% data(:,4) <> z
% data(:,5) <> zdot
% data(:,6) <> theta
% data(:,7) <> thetadot
% data(:,8) <> F1/m
% data(:,9) <> F2/m
% data(:,10) <> x_ref
% data(:,11) <> z_ref
% data(:,12) <> u1/m
% data(:,13) <> u2/m

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Animation
figure(2),clf,set(gcf,'NumberTitle','off','Name','Animation')

% Screen size
xmin = min([data(:,2); data(:,10)]) -10;
xmax = max([data(:,2); data(:,10)]) +10;
ymin = min([data(:,4); data(:,11)]) - 10;
ymax = max([data(:,4); data(:,11)]) + 10;

% Define axes
axes('NextPlot','add','Position',[0 0 1 1],'XColor','k','YColor','k',...
  'XLim',[xmin xmax],'YLim',[ymin ymax])
scale = (xmax-xmin)/(ymax-ymin);
% Plot initial and final desired positions
F = param(1)/2;
statei = [data(1,10); 0; data(1,11); 0; 0; 0; F; F];
statef = [data(length(timegrid),10); 0; data(length(timegrid),11); 0; 0; 0; F; F];
plotvtol(statei,param(4),'Line');
plotvtol(statef,param(4),'Line');

% Actual and reference trajectories
line(data(:,2),data(:,4),'Color','g','Linestyle','--');
drawnow

% Movies
state = data(1,2:9);
epsilon = param(4);
slength = 3/4;

% create frame (longitudinal and lateral)
alpha = atan(epsilon);
rot = [cos(state(5)) -scale*sin(state(5)); sin(state(5))/scale cos(state(5))];

% normalized actual thrusts
F1 = state(7);
F2 = state(8);
vtol = slength*rot*[-10, 0, 10, 2/5, 0, -2/5, -10; -2/3+[0, 0,  0, 2, 5, 2, 0]];
rot1 = [cos(alpha) sin(alpha)*scale; -sin(alpha)/scale cos(alpha)];
arrowF1 = rot1*[-1/2, 1/2, 0, -1/2; 0, 0, -F1, 0];
arrowF1(1,:) = arrowF1(1,:) + 6;
arrowF1(2,:) = arrowF1(2,:) -1;
arrowF1 = slength*rot*arrowF1;
if F1 < 0
  ColorF1 = 'y';
else
  ColorF1 = 'r';
end

rot2 = [cos(alpha) -sin(alpha)*scale; sin(alpha)/scale cos(alpha)];
arrowF2 = rot2*[-1/2, 1/2, 0, -1/2; 0, 0, -F2, 0];
arrowF2(1,:) = arrowF2(1,:) - 6;
arrowF2(2,:) = arrowF2(2,:) -1;
arrowF2 = slength*rot*arrowF2;
if F2<0
  ColorF2 = 'y';
else
  ColorF2 = 'r';
end
h = fill(state(1) + vtol(1,:), state(3) + vtol(2,:),'c',...
  state(1)+arrowF1(1,:), state(3)+arrowF1(2,:),ColorF1,...
  state(1)+arrowF2(1,:), state(3)+arrowF2(2,:),ColorF2);
%
for i = 2:length(timegrid)
  % new
  state = data(i,2:9);
  rot = [cos(state(5)) -scale*sin(state(5)); sin(state(5))/scale cos(state(5))];
  
  % normalized actual thrusts
  F1 = state(7);
  F2 = state(8);
  vtol = slength*rot*[-10, 0, 10, 2/5, 0, -2/5, -10; -2/3+[0, 0,  0, 2, 5, 2, 0]];
  rot1 = [cos(alpha) scale*sin(alpha); -sin(alpha)/scale cos(alpha)];
  arrowF1 = rot1*[-1/2, 1/2, 0, -1/2; 0, 0, -F1, 0];
  arrowF1(1,:) = arrowF1(1,:) + 6;
  arrowF1(2,:) = arrowF1(2,:) -1;
  arrowF1 = slength*rot*arrowF1;
  if F1<0
    ColorF1 = 'y';
  else
    ColorF1 = 'r';
  end
  rot2 = [cos(alpha) -sin(alpha)*scale; sin(alpha)/scale cos(alpha)];
  arrowF2 = rot2*[-1/2, 1/2, 0, -1/2; 0, 0, -F2, 0];
  arrowF2(1,:) = arrowF2(1,:) - 6;
  arrowF2(2,:) = arrowF2(2,:) -1;
  arrowF2 = slength*rot*arrowF2;
  if F2<0
    ColorF2 = 'y';
  else
    ColorF2 = 'r';
  end
  h(1).XData=state(1) + vtol(1,:);
  h(1).YData=state(3) + vtol(2,:);
  h(1).FaceColor='c';
  h(2).XData=state(1)+arrowF1(1,:);
  h(2).YData=state(3)+arrowF1(2,:);
  h(2).FaceColor=ColorF1;
  h(3).XData=state(1)+arrowF2(1,:);
  h(3).YData=state(3)+arrowF2(2,:);
  h(3).FaceColor=ColorF2;
  drawnow
  tinit=clock;
  d=0;
  while d<0.05
    t=clock;
    d=etime(t,tinit);
  end
end
drawnow
end
%---------------------------------------------------------------
%%  function plotvtol
function handle = plotvtol(state,epsilon,Style)
% scaled length
slength = 3/4;

% create frame (longitudinal and lateral)
alpha=atan(epsilon);
rot=[cos(state(5)) -sin(state(5)); sin(state(5)) cos(state(5))];

% normalized actual thrusts
F1= state(7);
F2 = state(8);

vtol = slength*rot*[-10, 0, 10, 2/5, 0, -2/5, -10; -2/3+[0, 0,  0, 2, 5, 2, 0]];
	
rot1 = [cos(alpha) sin(alpha); -sin(alpha) cos(alpha)];
arrowF1 = rot1*[-1/2, 1/2, 0, -1/2; 0, 0, -F1, 0];
arrowF1(1,:) = arrowF1(1,:) + 6;
arrowF1(2,:) = arrowF1(2,:) -1;
arrowF1= slength*rot*arrowF1;
if F1<0
	ColorF1 = 'y';
else
	ColorF1 = 'r';
end

rot2=[cos(alpha) -sin(alpha); sin(alpha) cos(alpha)];
arrowF2 = rot2*[-1/2, 1/2, 0, -1/2; 0, 0, -F2, 0];
arrowF2(1,:) = arrowF2(1,:) - 6;
arrowF2(2,:) = arrowF2(2,:) -1;
arrowF2= slength*rot*arrowF2;
if F2<0
	ColorF2 = 'y';
else
	ColorF2 = 'r';
end

if strcmp(Style,'Line')
	handle= [line(state(1)+vtol(1,:), state(3)+vtol(2,:),'Linestyle','--','Color','c');
		line(state(1)+arrowF1(1,:), state(3)+arrowF1(2,:),'Linestyle','--','Color',ColorF1);
		line(state(1)+arrowF2(1,:), state(3)+arrowF2(2,:),'Linestyle','--','Color',ColorF2) ];
else
	handle = fill( state(1) + vtol(1,:), state(3) + vtol(2,:),'c',...
		state(1)+arrowF1(1,:), state(3)+arrowF1(2,:),ColorF1,...
		state(1)+arrowF2(1,:), state(3)+arrowF2(2,:),ColorF2);
end
end



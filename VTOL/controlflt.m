function output = controlflt(t,state,jet)
% output = controlflt(t,state,jet)
% calcule le vecteur de commande et le champ de vecteur d'état du contrôleur
% pour la commande par platitude
% Entrées :
% t : temps (scalaire)
% state : état combiné du PTVOL et de son contrôleur (vecteur de dim = 10)
% state = [x(t) dx/dt(t) z(t) dz/dt(t) theta(t) d theta/dt(t) F1 F2 ...
%          zeta1 zeta2]
% où zeta1 et zeta2 = états du contrôleur
%
% jet : trajectoire de référence et ses dérivées jusqu'à l'ordre 4
% jet(1) = x_ref,%  jet(2) = dx_ref/dt, ..., jet(5) = d^5x_ref/dt^5
% jet(6) = z_ref, ..., jet(10) = d^5z_ref/dt^5
% Sortie :
% output : vecteur de dimension 4 : [u1;u2;der_z1;der_z2]
% où u1 et u2 sont les commandes 
% et der_z1 et der_z2 sont les dérivées des états du contrôleur dynamique.


global  param_ gains_
g = param_(1);
a = param_(2);
b = param_(3);
epsilon =  param_(4);

gain1 = gains_(1,:);
gain2 = gains_(2,:);

X = state(1:6);
z = state(9:10);

%%%% A modifier %%%%%%%%%%%

x = X(1); dx = X(2);
z_pos = X(3); dz = X(4);
theta = X(5); dtheta = X(6);
zeta1 = z(1);
zeta2 = z(2);

y1 = x - epsilon * sin(theta);
dy1 = dx - epsilon * dtheta * cos(theta);
ddy1 = -zeta1 * sin(theta);
d3y1 = -zeta2 * sin(theta) - zeta1 * dtheta * cos(theta);

y2 = z_pos + epsilon * cos(theta);
dy2 = dz - epsilon * dtheta * sin(theta);
ddy2 = zeta1 * cos(theta) - g;
d3y2 = zeta2 * cos(theta) - zeta1 * dtheta * sin(theta);

y1_ref = jet(1); dy1_ref = jet(2); ddy1_ref = jet(3); d3y1_ref = jet(4); d4y1_ref = jet(5);
y2_ref = jet(6); dy2_ref = jet(7); ddy2_ref = jet(8); d3y2_ref = jet(9); d4y2_ref = jet(10);

w1 = d4y1_ref + gain1(1)*(y1_ref - y1) + gain1(2)*(dy1_ref - dy1) + gain1(3)*(ddy1_ref - ddy1) + gain1(4)*(d3y1_ref - d3y1);
w2 = d4y2_ref + gain2(1)*(y2_ref - y2) + gain2(2)*(dy2_ref - dy2) + gain2(3)*(ddy2_ref - ddy2) + gain2(4)*(d3y2_ref - d3y2);

zeta_safe = zeta1;
if abs(zeta_safe) < 1e-3
    zeta_safe = sign(zeta_safe) * 1e-3 + (zeta_safe == 0) * 1e-3;
end

v_zeta = -w1 * sin(theta) + w2 * cos(theta) + zeta1 * dtheta^2;
v2 = (-w1 * cos(theta) - w2 * sin(theta) - 2 * zeta2 * dtheta) / zeta_safe;

v1 = zeta1 + epsilon * dtheta^2;

v = [v1, v2];
der_z = [zeta2; v_zeta];
%%%%%%%%%%%%%%%%%%%%%%%%%%%
u = [a*v(1)+b*v(2); a*v(1)-b*v(2)]/2;

output = [u;der_z];
end

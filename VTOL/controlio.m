function u = controlio(t,X,jet)
% u = controlio(t,state,jet)
% calcule le vecteur de sortie pour la commande par linéarisation
% entrée-sortie
% entrées :
% t : temps (scalaire)
% state : état  du PTVOL  (vecteur de dim = 8)
% state = [x(t) dx/dt(t) z(t) dz/dt(t) theta(t) d theta/dt(t) F1 F2]
%
% jet : trajectoire de référence et ses dérivées jusqu'à l'ordre 4
% jet(1) = x_ref,%  jet(2) = dx_ref/dt, ..., jet(5) = d^5x_ref/dt^5
% jet(6) = z_ref, ..., jet(10) = d^5z_ref/dt^5
% Sortie :
% u: vecteur de dimension 2 : [u1;u2]
% où u1 et u2 sont les commandes
global  param_ gains_

g = param_(1);
a = param_(2);
b = param_(3);
epsilon =  param_(4);

gain1 = gains_(1,1:2);
gain2 = gains_(2,1:2);
%%% A modifier %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
w1 = 0;
w2 = 0;
v = [0;0];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
u = [a*v(1)+b*v(2); a*v(1)-b*v(2)]/2;
end

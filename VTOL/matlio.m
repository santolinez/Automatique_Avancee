function statedot = matlio(t,state)
% donne le champ de vecteur de l'équation du PVTOL en boucle fermée avec la
% commande par linéarisation entrée-sortie
% state(1) = x
% state(2) = xdot
% state(3) = z
% state(4) = zdot
% state(5) = theta
% state(6) = thetadot
% state(7) = F1
% state(8) = F2

global trajData_ % données de la trajectoire de référence (cf fonction traj)

jet = traj(t,trajData_);
u = controlio(t,state,jet);
statedot = pvtol(t,state,u);

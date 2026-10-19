function affichage(t,state,xz_ref,u_actu)
global param_
param = param_;

% param(1) = g
% param(2) = m/Calpha
% param(3) = J/l/Calpha
% param(4) = epsilon = Talpha (si a=b)
% param(5) = lambda

% Normalize thrusts
mg = param(1)*param(2)/sqrt(1+param(4)^2);
state(:,7:8) = state(:,7:8)/mg;
u_actu = u_actu/mg;


figure(3), clf,set(gcf,'NumberTitle','off','Name','Plots')

subplot(321), plot(t,[state(:,1),xz_ref(:,1)]), grid
ylabel('x et x_{ref}'),xlabel('t'),legend('x','x_{ref}','location','best')

subplot(323), plot(t,[state(:,3),xz_ref(:,2)]), grid
ylabel('z'),xlabel('t'),legend('z','z_{ref}','location','best')

subplot(322), plot(t,state(:,5)), grid
ylabel('theta'),xlabel('t')

subplot(324), plot(xz_ref(:,1),xz_ref(:,2),'b',state(:,1),state(:,3),'r'), grid, %axis('square'), axis('equal')
xlabel('x'), ylabel('z')

subplot(325), plot(t,[state(:,7),u_actu(:,1)]), grid
ylabel('F1n/mg, u1n/mg'),legend('F_1','u_1','location','best')

subplot(326), plot(t,[state(:,8),u_actu(:,2)]), grid
ylabel('F2n/mg, u2n/mg'),legend('F_2','u_2','location','best')
if size(state,2)==10  % cas commande par platitude
  y1_real = state(:,1) - param(4)*sin(state(:,5));
  y2_real = state(:,3) + param(4)*cos(state(:,5));

  figure(4), clf, set(gcf,'NumberTitle','off','Name','Sortie plate vs Centre de masse')
    subplot(211)
    plot(t, state(:,1), 'r', t, y1_real, 'b--'), grid
    xlabel('t (s)'), ylabel('x (m)')
    legend('Centre de masse (x)', 'Sortie plate (y_1)', 'location', 'best')
    title('Évolution de x vs y_1')
    
    subplot(212)
    plot(t, state(:,3), 'r', t, y2_real, 'b--'), grid
    xlabel('t (s)'), ylabel('z (m)')
    legend('Centre de masse (z)', 'Sortie plate (y_2)', 'location', 'best')
    title('Évolution de z vs y_2')
end
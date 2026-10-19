# Projet : Commande d'un Avion à Décollage Vertical (PVTOL)

Ce dépôt contient le développement des différentes lois de commande (linéaire, non-linéaire naïve, et par platitude) appliquées à un avion à décollage et atterrissage verticaux (VTOL) en mode de vol stationnaire (*hovering*).

---

## 1. Modèle Dynamique et Hypothèses

Le véhicule se déplace dans un plan vertical. Le centre de masse est repéré par ses coordonnées $(x, z)$ et son angle d'inclinaison par rapport à l'horizontale est $\theta$.

![Schéma PVTOL](https://via.placeholder.com/600x300.png?text=PVTOL+Diagram) <!-- Remplacer par le chemin relatif de votre image locale si disponible, ex: ./images/pvtol_schema.png -->

### Équations du mouvement

En notant $F_1$ et $F_2$ les poussées des deux réacteurs, le modèle dynamique s'écrit :

$$m\ddot{x} = (F_1 - F_2)\sin\alpha \cos\theta - (F_1 + F_2)\cos\alpha \sin\theta + f_x(\dot{x}, \dot{z}, \theta, \dot{\theta})$$

$$m\ddot{z} = (F_1 - F_2)\sin\alpha \sin\theta + (F_1 + F_2)\cos\alpha \cos\theta - mg + f_z(\dot{x}, \dot{z}, \theta, \dot{\theta})$$

$$J\ddot{\theta} = L(F_1 - F_2)\cos\alpha + f_\theta(\dot{x}, \dot{z}, \theta, \dot{\theta})$$

Où :
- $(F_1 + F_2)$ : Poussée totale des réacteurs.
- $(F_1 - F_2)$ : Différence de poussée créant le moment de rotation.
- $\alpha$ : Inclinaison des réacteurs.
- $mg$ : Poids du véhicule.
- $J$ : Moment d'inertie.
- $f_x, f_z, f_\theta$ : Forces et moments aérodynamiques.

### Hypothèses de simplification

1. **Aérodynamique négligée** en mode *hovering* :
   $$f_x = f_z = f_\theta = 0$$

2. **Dynamique des réacteurs rapide** :
   $$\dot{F}_1 = \lambda(u_1 - F_1), \quad \dot{F}_2 = \lambda(u_2 - F_2)$$
   On considère que $F_1 = u_1$ et $F_2 = u_2$.

3. **Changement de variables de commande** :
   $$\epsilon = \frac{J}{mL}\tan\alpha, \quad a = \frac{m}{\cos\alpha}, \quad b = \frac{J}{L\cos\alpha}$$
   $$v_1 = \frac{F_1 + F_2}{a}, \quad v_2 = \frac{F_1 - F_2}{b}$$

### Modèle Normalisé

$$\ddot{x} = \epsilon v_2 \cos\theta - v_1 \sin\theta$$
$$\ddot{z} = \epsilon v_2 \sin\theta + v_1 \cos\theta - g$$
$$\ddot{\theta} = v_2$$

---

## 2. Commande Linéaire

### Point d'équilibre
Pour un vol stationnaire, la condition d'équilibre $\dot{\xi}_e = f(\xi_e, u_e) = 0$ donne la famille de points d'équilibre :

$$x_e = x_0, \quad z_e = z_0, \quad \theta_e = 0$$
$$\dot{x}_e = \dot{z}_e = \dot{\theta}_e = 0$$
$$v_{1e} = g, \quad v_{2e} = 0$$

### Modèle Tangent Linéarisé
Autour de ce point d'équilibre, en introduisant les variables incrémentales :

$$\delta\ddot{x} = \epsilon \delta v_2 - g \delta\theta \approx -g \delta\theta \quad (\text{car } \epsilon \ll 1)$$
$$\delta\ddot{z} = \delta v_1$$
$$\delta\ddot{\theta} = \delta v_2$$

Le système se découple et permet de déduire la platitude approchée :
$$\delta^{(4)}x = -g \delta v_2$$

### Loi de Commande par Placement de Pôles

$$\delta v_1 = \delta\ddot{z}_{\text{ref}} + k_1 (\delta z_{\text{ref}} - \delta z) + k_2 (\delta\dot{z}_{\text{ref}} - \delta\dot{z})$$

$$\delta v_2 = -\frac{1}{g} \left( \delta x_{\text{ref}}^{(4)} + l_1 (\delta x_{\text{ref}} - \delta x) + l_2 (\delta\dot{x}_{\text{ref}} - \delta\dot{x}) + l_3 (\delta\ddot{x}_{\text{ref}} - \delta\ddot{x}) + l_4 (\delta x_{\text{ref}}^{(3)} - \delta^{(3)}x) \right)$$

Pour un pôle quadruple $p_0$ sur $x$ et un pôle double $p_0$ sur $z$ :

$$k_1 = p_0^2, \quad k_2 = -2p_0$$
$$l_1 = p_0^4, \quad l_2 = -4p_0^3, \quad l_3 = 6p_0^2, \quad l_4 = -4p_0$$

#### Script MATLAB : Calcul des gains
```matlab
clear; clc; close all;

p0 = -4;

% Gains pour z (ordre 2)
k1 = p0^2;
k2 = -2*p0;

% Gains pour x (ordre 4)
l1 = p0^4;
l2 = -4*p0^3;
l3 = 6*p0^2;
l4 = -4*p0;

fprintf('p0 = %d, k1 = %d, k2 = %d, l1 = %d, l2 = %d, l3 = %d, l4 = %d\n', p0, k1, k2, l1, l2, l3, l4);
```

---

## 3. Commande Non-Linéaire Naïve (Linéarisation Entrée-Sortie)

L'objectif est d'imposer $\ddot{x} = w_1$ et $\ddot{z} = w_2$.

### Inversion du système algébrique

$$\begin{bmatrix} w_1 \\ w_2 + g \end{bmatrix} = \begin{bmatrix} -\sin\theta & \epsilon \cos\theta \\ \cos\theta & \epsilon \sin\theta \end{bmatrix} \begin{bmatrix} v_1 \\ v_2 \end{bmatrix}$$

En inversant la matrice :

$$v_1 = (w_2 + g)\cos\theta - w_1 \sin\theta$$
$$v_2 = \frac{1}{\epsilon} (-w_1 \cos\theta + (w_2 + g)\sin\theta)$$

Les commandes auxiliaires sont réglées par retour d'état PD :
$$w_1 = \ddot{x}_{\text{ref}} + k_1(x_{\text{ref}} - x) + k_2(\dot{x}_{\text{ref}} - \dot{x})$$
$$w_2 = \ddot{z}_{\text{ref}} + l_1(z_{\text{ref}} - z) + l_2(\dot{z}_{\text{ref}} - \dot{z})$$

### Étude de la dynamique des zéros (Instabilité)

En imposant $x(t) = z(t) = 0 \Rightarrow w_1 = w_2 = 0$, on obtient la dynamique interne de l'angle $\theta$ :

$$\ddot{\theta} = \frac{g}{\epsilon}\sin\theta$$

Autour de $\theta_e = 0$, la linéarisation donne :
$$\delta\ddot{\theta} - 100 \delta\theta = 0 \implies s^2 - 100 = 0 \implies s_1 = 10, \, s_2 = -10$$

> **Conclusion :** La présence d'une valeur propre positive ($s_1 = 10$) indique que la dynamique zéro est **instable** (système à phase non-minimale). L'angle $\theta$ peut diverger même si $x$ et $z$ suivent leurs références.

---

## 4. Commande Non-Linéaire par Platitude

Pour éviter l'instabilité interne, on choisit une **sortie plate** $(y_1, y_2)$ définie par :

$$y_1 = x - \epsilon \sin\theta$$
$$y_2 = z + \epsilon \cos\theta$$

### Reconstitution des états et commandes

En dérivant deux fois :

$$\ddot{y}_1 = -\zeta \sin\theta$$
$$\ddot{y}_2 = \zeta \cos\theta - g$$

avec $\zeta = v_1 - \epsilon \dot{\theta}^2$.

On en déduit l'expression de l'orientation et des états :

$$\tan\theta = -\frac{\ddot{y}_1}{\ddot{y}_2 + g} \implies \theta = \arctan\left(\frac{-\ddot{y}_1}{\ddot{y}_2 + g}\right)$$
$$x = y_1 + \epsilon \sin\theta$$
$$z = y_2 - \epsilon \cos\theta$$

### Linéarisation Entrée-État par Boucle Dynamique

En dérivant à l'ordre 4 les sorties plates et en posant $\zeta_1 = \zeta$, $\zeta_2 = \dot{\zeta}$, on obtient les commandes réelles :

$$v_1 = \zeta_1 + \epsilon \dot{\theta}^2$$
$$v_2 = \ddot{\theta} = \frac{1}{\zeta_1} (-w_1 \cos\theta - w_2 \sin\theta - 2\zeta_2 \dot{\theta})$$

### Calcul des gains MATLAB pour la commande par platitude

```matlab
clear; clc; close all;

p0 = -3;

% Placement de pôles d'ordre 4
k1 = p0^4;  l1 = k1;
k2 = -4*p0^3; l2 = k2;
k3 = 6*p0^2;  l3 = k3;
k4 = -4*p0;   l4 = k4;

fprintf('p0 = %d, k1=l1=%d, k2=l2=%d, k3=l3=%d, k4=l4=%d\n', p0, k1, k2, k3, k4);
```

---

## 5. Synthèse et Résultats

1. **Génération de Trajectoire (`traj.m`) :**
   Les références doivent être au moins $\mathcal{C}^4$ pour pouvoir fournir les dérivées successives jusqu'à l'ordre 4 ($x_{\text{ref}}^{(4)}, z_{\text{ref}}^{(4)}$) et éviter les à-coups/saturations d'actionneurs.

2. **Comparaison des approches :**
   - **Commande Linéaire :** Valide uniquement au voisinage du point d'équilibre ($\theta \approx 0$).
   - **Commande Naïve :** Génère une instabilité de la dynamique interne ($\theta$ diverge).
   - **Commande par Platitude :** Garantit le découplage parfait et la stabilité globale sans dynamique interne cachée.s
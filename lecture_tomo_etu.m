close all;
clear all;

%% Se placer dans le bon dossier avec le bon nom de fichier

%% User-defined
R = ; % nombre de rotations !!  A COMPLETER (Question 7)!!
delta_angle = ; % pas angulaire choisi !!  A COMPLETER !!

%% remplacement de la virgule en tant que séparateur décimal dans les fichiers de données ASCII par un point pour le format de matlab
for ii=1:R
    filename=['A_scan_',num2str(ii),'.dat'];
    filecomma = comma2point(filename);
end

%% Récupération du vecteur position
T = readtable(filecomma,'HeaderLines',24,'Delimiter','\t');
vecteur_pos = table2array(T(:,1))';
Npos = size(vecteur_pos,2);

%% Récupération des R angles
Matrice_acqui_angle = zeros(R,Npos);

for jj=1:R
    filename=['A_scan_',num2str(jj),'_tmp.txt'];
    T = readtable(filename,'HeaderLines',24,'Delimiter','\t');
    Matrice_acqui_angle(jj,:)=table2array(T(:,2))';
 end

clear filecomma filename ii jj T 
save donnees_entree_tomo

%% Affichage des observables d'entrée !!  A COMPLETER (Question 12)!!


%% Reconstruction tomographique !!  A COMPLETER (Question 13)!!
% obj_rec = iradon( ....

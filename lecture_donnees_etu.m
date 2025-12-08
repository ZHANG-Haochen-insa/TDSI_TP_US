% Programme qui lit les A_scan et les enregistre
%
%   Npos    - [1 x 1] - nombres de A_scan/ translation de l'objet 
%   Nt      - [1 x 1] - nombre d'échantillons temporels pour 1 A_scan
%   vecteur_temps       - [Nt x 1] - vecteur temps en micro seconde
%   pos_amp_extraites   - [Nt x 1] - positions de translation
%   Matrice_acqui_rf    - [N x Nt] - matrice des A_scan
%   Matrice_acqui_env   - [N x Nt] - matrice des enveloppes des A_scan
%   amp_extraites       - [N x 1] - amplitudes calculees par logiciel Gampt 


%%
close all;
clear all;

% Se placer dans le bon dossier avec le bon nom de fichier


% Nombre de Ascan à lire
Npos = ; % !!  A COMPLETER (Question 4) !!

%% Lecture des donnees et fabrication de la matrice A_scan 
% remplacement de la virgule en tant que séparateur décimal dans les
% fichiers de données ASCII par un point pour le format de matlab
for ii=1:Npos%N
    filename=['pos_',num2str(ii),'.dat'];
    filecomma = comma2point(filename);
end

% Récupération du vecteur temps
T = readtable(filecomma,'HeaderLines',24,'Delimiter','\t');
vecteur_temps=table2array(T(:,1))';
Nt = size(vecteur_temps,2);

% Récupération des N Ascan acquis pour un angle
Matrice_acqui_rf=zeros(Npos,Nt);
Matrice_acqui_env=zeros(Npos,Nt);

for jj=1:Npos
    filename=['pos_',num2str(jj),'_tmp.txt'];
    T = readtable(filename,'HeaderLines',24,'Delimiter','\t');
    Matrice_acqui_rf(jj,:)=table2array(T(:,2))';
    Matrice_acqui_env(jj,:)=table2array(T(:,3))';
end
%% Visualisation des A-scan et de leur enveloppe (enveloppe en dB)
% !!  A COMPLETER  (Question 5) !!

%% Calcul des atténuations intervenant en tomographie 
% !!  A COMPLETER (Question 6a)!!

%% Récupération des données amplitudes pour l'angle 0
% Remplacement des virgules
filename_delta = 'A_scan_test.dat';
filecomma_delta = comma2point(filename_delta);

% initialisation
amp_extraites = zeros(Npos,2);

% Lecture des données
T_amp = readtable(filecomma_delta,'HeaderLines',24,'Delimiter','\t');
amp_extraites = table2array(T_amp(:,2));
pos_amp_extraites = table2array(T_amp(:,1));

%% Comparaison avec les delta_amplitudes calculées par Gampt
% !!  A COMPLETER !!

%% 

clear ii jj filecomma filecomma_delta filename filename_delta T T_amp
save matrice_A_scan_test
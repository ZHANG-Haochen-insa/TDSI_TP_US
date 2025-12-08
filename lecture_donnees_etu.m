% 程序功能：读取A扫描数据并保存
%
% 变量说明：
%   Npos                - [1 x 1] - A扫描的数量 / 物体平移的位置数
%   Nt                  - [1 x 1] - 单个A扫描的时间采样点数
%   vecteur_temps       - [Nt x 1] - 时间矢量（单位：微秒）
%   pos_amp_extraites   - [Nt x 1] - 平移位置坐标
%   Matrice_acqui_rf    - [N x Nt] - A扫描射频信号矩阵
%   Matrice_acqui_env   - [N x Nt] - A扫描包络信号矩阵
%   amp_extraites       - [N x 1] - 由Gampt软件计算的幅度值 


%%
% 关闭所有图形窗口
close all;
% 清除所有变量
clear all;

% 需要切换到包含数据文件的正确文件夹


% 要读取的A扫描数量
Npos = 13; % !! 待完成（问题4）!!

%% 读取数据并构建A扫描矩阵
% 将ASCII数据文件中作为小数分隔符的逗号替换为点号
% 这是为了符合MATLAB的数值格式要求
for ii=1:Npos%N
    filename=['pos_',num2str(ii),'.dat'];
    filecomma = comma2point(filename);
end

% R�cup�ration du vecteur temps
T = readtable(filecomma,'HeaderLines',24,'Delimiter','\t');
vecteur_temps=table2array(T(:,1))';
Nt = size(vecteur_temps,2);

% R�cup�ration des N Ascan acquis pour un angle
Matrice_acqui_rf=zeros(Npos,Nt);
Matrice_acqui_env=zeros(Npos,Nt);

% 循环读取所有位置的A扫描数据
for jj=1:Npos
    % 构建临时文件名（已经过comma2point处理）
    filename=['pos_',num2str(jj),'_tmp.txt'];
    % 读取表格数据
    T = readtable(filename,'HeaderLines',24,'Delimiter','\t');
    % 提取第二列（射频信号）并存入矩阵的第jj行
    Matrice_acqui_rf(jj,:)=table2array(T(:,2))';
    % 提取第三列（包络信号）并存入矩阵的第jj行
    Matrice_acqui_env(jj,:)=table2array(T(:,3))';
end
%% 可视化A扫描及其包络（包络以dB为单位显示）
% !! 待完成（问题5）!!

%% 计算层析成像中的衰减
% !! 待完成（问题6a）!!

%% 读取角度0时的幅度数据
% 替换逗号为点号
filename_delta = 'A_scan_test.dat';
filecomma_delta = comma2point(filename_delta);

% initialisation
amp_extraites = zeros(Npos,2);

% Lecture des donn�es
T_amp = readtable(filecomma_delta,'HeaderLines',24,'Delimiter','\t');
amp_extraites = table2array(T_amp(:,2));
pos_amp_extraites = table2array(T_amp(:,1));

%% Comparaison avec les delta_amplitudes calcul�es par Gampt
% !!  A COMPLETER !!

%% 

clear ii jj filecomma filecomma_delta filename filename_delta T T_amp
save matrice_A_scan_test
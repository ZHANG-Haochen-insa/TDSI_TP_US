% 关闭所有图形窗口
close all;
% 清除所有变量
clear all;

%% 需要切换到包含数据文件的正确文件夹

%% 用户定义参数
R = ; % 旋转次数 !! 待完成（问题7）!!
delta_angle = ; % 选择的角度步长 !! 待完成 !!

%% 将ASCII数据文件中作为小数分隔符的逗号替换为点号
%% 这是为了符合MATLAB的数值格式要求
for ii=1:R
    % 构建文件名：A_scan_1.dat, A_scan_2.dat, ...
    filename=['A_scan_',num2str(ii),'.dat'];
    % 调用comma2point函数，将逗号替换为点号
    filecomma = comma2point(filename);
end

%% 读取位置矢量
% 从表格中读取数据，跳过前24行头文件，使用制表符作为分隔符
T = readtable(filecomma,'HeaderLines',24,'Delimiter','\t');
% 提取第一列作为位置矢量并转置
vecteur_pos = table2array(T(:,1))';
% 获取位置点数
Npos = size(vecteur_pos,2);

%% 读取R个角度的数据
% 初始化角度采集矩阵（每行对应一个角度，每列对应一个位置）
Matrice_acqui_angle = zeros(R,Npos);

% 循环读取所有角度的A扫描数据
for jj=1:R
    % 构建临时文件名（已经过comma2point处理）
    filename=['A_scan_',num2str(jj),'_tmp.txt'];
    % 读取表格数据
    T = readtable(filename,'HeaderLines',24,'Delimiter','\t');
    % 提取第二列数据并存入矩阵的第jj行
    Matrice_acqui_angle(jj,:)=table2array(T(:,2))';
 end

% 清除临时变量
clear filecomma filename ii jj T 
% 保存层析成像的输入数据到文件
save donnees_entree_tomo

%% 显示输入的观测数据 !! 待完成（问题12）!!


%% 层析成像重建 !! 待完成（问题13）!!
% obj_rec = iradon( ....

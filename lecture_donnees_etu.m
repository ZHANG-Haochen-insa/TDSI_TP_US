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

% 计算包络的dB值
% 公式: Envelope_dB = 20*log10(Envelope)
% 为避免log(0)，将零值替换为一个很小的值
Matrice_acqui_env_dB = 20*log10(Matrice_acqui_env + eps);

% 显示射频信号矩阵
figure('Name', '问题5: A-scan矩阵可视化', 'Position', [100 100 1200 800]);

% 子图1: 射频信号矩阵
subplot(2,2,1);
imagesc(vecteur_temps, 1:Npos, Matrice_acqui_rf);
colormap(subplot(2,2,1), jet);
colorbar;
xlabel('时间 (\mus)', 'FontSize', 12);
ylabel('平移位置编号', 'FontSize', 12);
title('A-scan矩阵 - 射频信号 (RF)', 'FontSize', 14);
axis tight;

% 子图2: 包络信号矩阵（dB）
subplot(2,2,2);
imagesc(vecteur_temps, 1:Npos, Matrice_acqui_env_dB);
colormap(subplot(2,2,2), hot);
colorbar;
xlabel('时间 (\mus)', 'FontSize', 12);
ylabel('平移位置编号', 'FontSize', 12);
title('A-scan矩阵 - 包络信号 (dB)', 'FontSize', 14);
axis tight;
caxis([max(Matrice_acqui_env_dB(:))-60, max(Matrice_acqui_env_dB(:))]);  % 动态范围60dB

% 子图3: 显示某一位置的RF信号（例如中间位置）
subplot(2,2,3);
pos_exemple = round(Npos/2);  % 选择中间位置
plot(vecteur_temps, Matrice_acqui_rf(pos_exemple,:), 'b-', 'LineWidth', 1.5);
grid on;
xlabel('时间 (\mus)', 'FontSize', 12);
ylabel('幅度 (V)', 'FontSize', 12);
title(['位置 #', num2str(pos_exemple), ' 的射频信号'], 'FontSize', 14);

% 子图4: 显示同一位置的包络（dB）
subplot(2,2,4);
plot(vecteur_temps, Matrice_acqui_env_dB(pos_exemple,:), 'r-', 'LineWidth', 1.5);
grid on;
xlabel('时间 (\mus)', 'FontSize', 12);
ylabel('幅度 (dB)', 'FontSize', 12);
title(['位置 #', num2str(pos_exemple), ' 的包络信号 (dB)'], 'FontSize', 14);

fprintf('\n=== 问题5: A-scan矩阵统计信息 ===\n');
fprintf('A-scan数量 (Npos): %d\n', Npos);
fprintf('时间采样点数 (Nt): %d\n', Nt);
fprintf('时间范围: %.2f - %.2f 微秒\n', min(vecteur_temps), max(vecteur_temps));
fprintf('RF信号幅度范围: [%.4f, %.4f] V\n', min(Matrice_acqui_rf(:)), max(Matrice_acqui_rf(:)));
fprintf('包络信号幅度范围: [%.2f, %.2f] dB\n', min(Matrice_acqui_env_dB(:)), max(Matrice_acqui_env_dB(:)));

%% 计算层析成像中的衰减
% !! 待完成（问题6a）!!

% 理论基础：
% 声波衰减公式: A = A₀ * exp(-∫μ(x,y)dl)
% 取对数: ln(A) = ln(A₀) - ∫μ(x,y)dl
% 因此: ∫μ(x,y)dl = ln(A₀/A) = -ln(A/A₀)
%
% 可观察量 = -ln(A/A₀) 或 ln(A₀/A)
% 用dB表示: -20*log10(A/A₀) = 20*log10(A₀/A)

% 方法1: 从包络中提取最大值作为接收幅度
% 找到每个A-scan中的最大包络值
amp_calculees_envelope = max(Matrice_acqui_env, [], 2);  % 每行的最大值

% 方法2: 从RF信号中提取最大绝对值
amp_calculees_rf = max(abs(Matrice_acqui_rf), [], 2);  % 每行的最大绝对值

% 确定参考幅度A₀（无物体时的幅度或最大接收幅度）
% 这里我们使用所有测量中的最大值作为参考
A0_envelope = max(amp_calculees_envelope);
A0_rf = max(amp_calculees_rf);

% 计算衰减项（自然对数形式）
% attenuation = -ln(A/A₀) = ln(A₀/A)
attenuation_ln = log(A0_envelope ./ amp_calculees_envelope);

% 计算衰减（dB形式）
% attenuation_dB = 20*log10(A₀/A)
attenuation_dB = 20*log10(A0_envelope ./ amp_calculees_envelope);

% 显示结果
fprintf('\n=== 问题6a: 衰减计算 ===\n');
fprintf('参考幅度 A₀ (包络): %.6f V\n', A0_envelope);
fprintf('衰减范围 (自然对数): [%.4f, %.4f]\n', min(attenuation_ln), max(attenuation_ln));
fprintf('衰减范围 (dB): [%.4f, %.4f] dB\n', min(attenuation_dB), max(attenuation_dB));

% 可视化衰减
figure('Name', '问题6a: 衰减计算', 'Position', [150 150 1000 400]);

subplot(1,2,1);
plot(1:Npos, attenuation_ln, 'bo-', 'LineWidth', 1.5, 'MarkerSize', 8);
grid on;
xlabel('平移位置编号', 'FontSize', 12);
ylabel('衰减 (ln单位)', 'FontSize', 12);
title('衰减项: ln(A_0/A)', 'FontSize', 14);

subplot(1,2,2);
plot(1:Npos, attenuation_dB, 'ro-', 'LineWidth', 1.5, 'MarkerSize', 8);
grid on;
xlabel('平移位置编号', 'FontSize', 12);
ylabel('衰减 (dB)', 'FontSize', 12);
title('衰减项: 20*log_{10}(A_0/A)', 'FontSize', 14);

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

%% 比较手动计算的幅度与Gampt软件计算的幅度
% !! 待完成（问题6b）!!

% amp_extraites 是由GS-EchoView/Gampt软件提取的幅度值（dB）
% 我们需要将手动计算的幅度转换为相同的格式进行比较

% 将手动计算的包络幅度转换为dB（相对于参考值）
amp_calculees_dB = 20*log10(amp_calculees_envelope);

fprintf('\n=== 问题6b: 与GS-EchoView对比 ===\n');
fprintf('手动计算幅度范围: [%.2f, %.2f] dB\n', min(amp_calculees_dB), max(amp_calculees_dB));
fprintf('Gampt提取幅度范围: [%.2f, %.2f] dB\n', min(amp_extraites), max(amp_extraites));

% 计算差异
difference = amp_calculees_dB - amp_extraites;
erreur_moyenne = mean(abs(difference));
erreur_std = std(difference);
erreur_max = max(abs(difference));

fprintf('平均绝对误差: %.4f dB\n', erreur_moyenne);
fprintf('误差标准差: %.4f dB\n', erreur_std);
fprintf('最大绝对误差: %.4f dB\n', erreur_max);

% 可视化对比
figure('Name', '问题6b: 幅度对比', 'Position', [200 200 1200 500]);

% 子图1: 幅度对比曲线
subplot(1,3,1);
plot(pos_amp_extraites, amp_extraites, 'b-o', 'LineWidth', 2, 'MarkerSize', 8, 'DisplayName', 'GS-EchoView');
hold on;
plot(pos_amp_extraites, amp_calculees_dB, 'r--s', 'LineWidth', 2, 'MarkerSize', 8, 'DisplayName', '手动计算');
grid on;
xlabel('位置 (mm)', 'FontSize', 12);
ylabel('幅度 (dB)', 'FontSize', 12);
title('幅度对比', 'FontSize', 14);
legend('Location', 'best', 'FontSize', 10);

% 子图2: 散点图对比
subplot(1,3,2);
plot(amp_extraites, amp_calculees_dB, 'ko', 'MarkerSize', 8, 'MarkerFaceColor', 'g');
hold on;
% 绘制理想的y=x线
min_val = min([amp_extraites; amp_calculees_dB]);
max_val = max([amp_extraites; amp_calculees_dB]);
plot([min_val max_val], [min_val max_val], 'r--', 'LineWidth', 2);
grid on;
xlabel('GS-EchoView幅度 (dB)', 'FontSize', 12);
ylabel('手动计算幅度 (dB)', 'FontSize', 12);
title('相关性分析', 'FontSize', 14);
axis equal;
axis([min_val max_val min_val max_val]);

% 计算相关系数
correlation = corrcoef(amp_extraites, amp_calculees_dB);
text(0.05, 0.95, sprintf('相关系数: %.4f', correlation(1,2)), ...
    'Units', 'normalized', 'FontSize', 11, 'BackgroundColor', 'white');

% 子图3: 误差分布
subplot(1,3,3);
bar(1:Npos, difference, 'FaceColor', [0.8 0.3 0.3]);
hold on;
yline(0, 'k--', 'LineWidth', 1.5);
yline(erreur_moyenne, 'b--', 'LineWidth', 1, 'Label', '平均误差');
yline(-erreur_moyenne, 'b--', 'LineWidth', 1);
grid on;
xlabel('位置编号', 'FontSize', 12);
ylabel('误差 (dB)', 'FontSize', 12);
title('幅度误差分布', 'FontSize', 14);

% 分析结果
fprintf('\n分析结论:\n');
if erreur_moyenne < 1.0
    fprintf('  - 手动计算与软件结果非常吻合（误差 < 1 dB）\n');
elseif erreur_moyenne < 3.0
    fprintf('  - 手动计算与软件结果较为一致（误差 < 3 dB）\n');
else
    fprintf('  - 手动计算与软件结果存在较大差异，需要检查计算方法\n');
end

if correlation(1,2) > 0.95
    fprintf('  - 相关性极高（相关系数 > 0.95），提取方法正确\n');
elseif correlation(1,2) > 0.85
    fprintf('  - 相关性良好（相关系数 > 0.85）\n');
else
    fprintf('  - 相关性较低，可能需要调整提取算法\n');
end

%% 

clear ii jj filecomma filecomma_delta filename filename_delta T T_amp
save matrice_A_scan_test
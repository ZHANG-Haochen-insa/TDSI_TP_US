% 关闭所有图形窗口
close all;
% 清除所有变量
clear all;

%% 需要切换到包含数据文件的正确文件夹

%% 用户定义参数
% 问题7: 计算旋转次数
% 已知: 完整旋转 = 360°, 角度步长 = 16.2°
% 计算: R = 360° / 16.2° = 22.22...
% 取整: R = 22 次旋转
R = 22; % 旋转次数 !! 待完成（问题7）!!
delta_angle = 16.2; % 选择的角度步长（度）!! 待完成 !!

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

% 构建角度向量
theta = 0:delta_angle:(R-1)*delta_angle;  % 角度向量（度）

fprintf('\n=== 问题12: 观测数据矩阵信息 ===\n');
fprintf('旋转次数 R: %d\n', R);
fprintf('每个角度的位置数 Npos: %d\n', Npos);
fprintf('角度步长: %.2f 度\n', delta_angle);
fprintf('角度范围: %.2f - %.2f 度\n', min(theta), max(theta));
fprintf('矩阵维度: %d x %d (角度 x 位置)\n', size(Matrice_acqui_angle, 1), size(Matrice_acqui_angle, 2));
fprintf('数据范围: [%.4f, %.4f] dB\n', min(Matrice_acqui_angle(:)), max(Matrice_acqui_angle(:)));

% 显示观测数据矩阵（正弦图 Sinogram）
figure('Name', '问题12: 正弦图（Sinogram）', 'Position', [100 100 1200 800]);

% 子图1: 正弦图 - 彩色显示
subplot(2,2,1);
imagesc(1:Npos, theta, Matrice_acqui_angle);
colormap(gca, hot);
colorbar;
xlabel('平移位置编号', 'FontSize', 12);
ylabel('旋转角度 (度)', 'FontSize', 12);
title('正弦图（Sinogram） - 热图', 'FontSize', 14);
axis tight;

% 子图2: 正弦图 - 灰度显示
subplot(2,2,2);
imagesc(vecteur_pos, theta, Matrice_acqui_angle);
colormap(gca, gray);
colorbar;
xlabel('平移位置 (mm)', 'FontSize', 12);
ylabel('旋转角度 (度)', 'FontSize', 12);
title('正弦图（Sinogram） - 灰度图', 'FontSize', 14);
axis tight;

% 子图3: 特定角度的投影（0度）
subplot(2,2,3);
plot(vecteur_pos, Matrice_acqui_angle(1,:), 'b-', 'LineWidth', 2);
grid on;
xlabel('平移位置 (mm)', 'FontSize', 12);
ylabel('衰减值 (dB)', 'FontSize', 12);
title(['角度 = ', num2str(theta(1)), '° 的投影'], 'FontSize', 14);

% 子图4: 特定位置在不同角度的值
subplot(2,2,4);
pos_center = round(Npos/2);  % 中心位置
plot(theta, Matrice_acqui_angle(:, pos_center), 'r-o', 'LineWidth', 1.5, 'MarkerSize', 6);
grid on;
xlabel('旋转角度 (度)', 'FontSize', 12);
ylabel('衰减值 (dB)', 'FontSize', 12);
title(['位置 #', num2str(pos_center), ' 在不同角度的值'], 'FontSize', 14);

% 3D可视化
figure('Name', '问题12: 正弦图 3D视图', 'Position', [150 150 800 600]);
[X, Y] = meshgrid(vecteur_pos, theta);
surf(X, Y, Matrice_acqui_angle);
shading interp;
colormap(hot);
colorbar;
xlabel('平移位置 (mm)', 'FontSize', 12);
ylabel('旋转角度 (度)', 'FontSize', 12);
zlabel('衰减值 (dB)', 'FontSize', 12);
title('正弦图 - 3D曲面', 'FontSize', 14);
view(45, 30);


%% 层析成像重建 !! 待完成（问题13）!!

fprintf('\n=== 问题13: 断层扫描重建 ===\n');

% 准备数据：iradon需要正弦图和角度向量
% Matrice_acqui_angle: 每行是一个角度的投影
% theta: 角度向量（度）

% 注意：Matrice_acqui_angle中的数据是衰减的dB值
% 对于iradon，我们可以直接使用，或者根据需要进行预处理

% 获取输出图像尺寸（建议使用投影长度）
output_size = Npos;

fprintf('正弦图尺寸: %d 角度 x %d 位置\n', R, Npos);
fprintf('角度范围: %.2f° - %.2f°\n', min(theta), max(theta));
fprintf('输出图像尺寸: %d x %d\n', output_size, output_size);

%% 方法1: 简单反投影（无滤波）
fprintf('\n1. 执行简单反投影（无滤波）...\n');
tic;
obj_rec_none = iradon(Matrice_acqui_angle', theta, 'none', 1, output_size);
time_none = toc;
fprintf('   完成时间: %.3f 秒\n', time_none);

%% 方法2: 滤波反投影 - Shepp-Logan滤波器 + 样条插值
fprintf('2. 执行滤波反投影（Shepp-Logan + 样条插值）...\n');
tic;
obj_rec_shepp_spline = iradon(Matrice_acqui_angle', theta, 'Shepp-Logan', 'spline', output_size);
time_shepp = toc;
fprintf('   完成时间: %.3f 秒\n', time_shepp);

%% 方法3: 滤波反投影 - Shepp-Logan滤波器 + 线性插值
fprintf('3. 执行滤波反投影（Shepp-Logan + 线性插值）...\n');
tic;
obj_rec_shepp_linear = iradon(Matrice_acqui_angle', theta, 'Shepp-Logan', 'linear', output_size);
time_shepp_linear = toc;
fprintf('   完成时间: %.3f 秒\n', time_shepp_linear);

%% 方法4: 其他滤波器测试
fprintf('4. 测试其他滤波器...\n');
obj_rec_ramlak = iradon(Matrice_acqui_angle', theta, 'Ram-Lak', 'spline', output_size);
obj_rec_hamming = iradon(Matrice_acqui_angle', theta, 'Hamming', 'spline', output_size);
obj_rec_cosine = iradon(Matrice_acqui_angle', theta, 'Cosine', 'spline', output_size);
obj_rec_hann = iradon(Matrice_acqui_angle', theta, 'Hann', 'spline', output_size);

%% 可视化所有重建结果
figure('Name', '问题13: 断层扫描重建对比', 'Position', [50 50 1400 900]);

% 无滤波重建
subplot(2,3,1);
imagesc(obj_rec_none);
colormap(gca, hot);
colorbar;
axis equal tight;
title('简单反投影（无滤波）', 'FontSize', 12);
xlabel('X (pixels)', 'FontSize', 10);
ylabel('Y (pixels)', 'FontSize', 10);

% Shepp-Logan + 样条
subplot(2,3,2);
imagesc(obj_rec_shepp_spline);
colormap(gca, hot);
colorbar;
axis equal tight;
title('Shepp-Logan + 样条插值', 'FontSize', 12);
xlabel('X (pixels)', 'FontSize', 10);
ylabel('Y (pixels)', 'FontSize', 10);

% Shepp-Logan + 线性
subplot(2,3,3);
imagesc(obj_rec_shepp_linear);
colormap(gca, hot);
colorbar;
axis equal tight;
title('Shepp-Logan + 线性插值', 'FontSize', 12);
xlabel('X (pixels)', 'FontSize', 10);
ylabel('Y (pixels)', 'FontSize', 10);

% Ram-Lak
subplot(2,3,4);
imagesc(obj_rec_ramlak);
colormap(gca, hot);
colorbar;
axis equal tight;
title('Ram-Lak + 样条插值', 'FontSize', 12);
xlabel('X (pixels)', 'FontSize', 10);
ylabel('Y (pixels)', 'FontSize', 10);

% Hamming
subplot(2,3,5);
imagesc(obj_rec_hamming);
colormap(gca, hot);
colorbar;
axis equal tight;
title('Hamming + 样条插值', 'FontSize', 12);
xlabel('X (pixels)', 'FontSize', 10);
ylabel('Y (pixels)', 'FontSize', 10);

% Hann
subplot(2,3,6);
imagesc(obj_rec_hann);
colormap(gca, hot);
colorbar;
axis equal tight;
title('Hann + 样条插值', 'FontSize', 12);
xlabel('X (pixels)', 'FontSize', 10);
ylabel('Y (pixels)', 'FontSize', 10);

%% 详细对比：无滤波 vs 最佳滤波
figure('Name', '问题13: 无滤波与滤波对比', 'Position', [100 100 1200 500]);

subplot(1,3,1);
imagesc(obj_rec_none);
colormap(gca, hot);
colorbar;
axis equal tight;
title('简单反投影（无滤波）', 'FontSize', 14);
xlabel('X (pixels)');
ylabel('Y (pixels)');

subplot(1,3,2);
imagesc(obj_rec_shepp_spline);
colormap(gca, hot);
colorbar;
axis equal tight;
title('滤波反投影（Shepp-Logan）', 'FontSize', 14);
xlabel('X (pixels)');
ylabel('Y (pixels)');

% 差异图
subplot(1,3,3);
difference_img = obj_rec_shepp_spline - obj_rec_none;
imagesc(difference_img);
colormap(gca, jet);
colorbar;
axis equal tight;
title('差异图（滤波 - 无滤波）', 'FontSize', 14);
xlabel('X (pixels)');
ylabel('Y (pixels)');

%% 剖面对比
figure('Name', '问题13: 中心剖面对比', 'Position', [150 150 1200 400]);

center_line = round(output_size/2);

subplot(1,2,1);
plot(obj_rec_none(center_line,:), 'b-', 'LineWidth', 2, 'DisplayName', '无滤波');
hold on;
plot(obj_rec_shepp_spline(center_line,:), 'r-', 'LineWidth', 2, 'DisplayName', 'Shepp-Logan');
plot(obj_rec_ramlak(center_line,:), 'g--', 'LineWidth', 1.5, 'DisplayName', 'Ram-Lak');
plot(obj_rec_hamming(center_line,:), 'm--', 'LineWidth', 1.5, 'DisplayName', 'Hamming');
grid on;
xlabel('X位置 (pixels)', 'FontSize', 12);
ylabel('衰减值', 'FontSize', 12);
title(['水平剖面 (Y = ', num2str(center_line), ')'], 'FontSize', 14);
legend('Location', 'best');

subplot(1,2,2);
plot(obj_rec_none(:,center_line), 'b-', 'LineWidth', 2, 'DisplayName', '无滤波');
hold on;
plot(obj_rec_shepp_spline(:,center_line), 'r-', 'LineWidth', 2, 'DisplayName', 'Shepp-Logan');
plot(obj_rec_ramlak(:,center_line), 'g--', 'LineWidth', 1.5, 'DisplayName', 'Ram-Lak');
plot(obj_rec_hamming(:,center_line), 'm--', 'LineWidth', 1.5, 'DisplayName', 'Hamming');
grid on;
xlabel('Y位置 (pixels)', 'FontSize', 12);
ylabel('衰减值', 'FontSize', 12);
title(['垂直剖面 (X = ', num2str(center_line), ')'], 'FontSize', 14);
legend('Location', 'best');

%% 定量分析
fprintf('\n=== 重建结果统计信息 ===\n');

fprintf('\n简单反投影（无滤波）:\n');
fprintf('  均值: %.4f\n', mean(obj_rec_none(:)));
fprintf('  标准差: %.4f\n', std(obj_rec_none(:)));
fprintf('  范围: [%.4f, %.4f]\n', min(obj_rec_none(:)), max(obj_rec_none(:)));

fprintf('\nShepp-Logan + 样条:\n');
fprintf('  均值: %.4f\n', mean(obj_rec_shepp_spline(:)));
fprintf('  标准差: %.4f\n', std(obj_rec_shepp_spline(:)));
fprintf('  范围: [%.4f, %.4f]\n', min(obj_rec_shepp_spline(:)), max(obj_rec_shepp_spline(:)));

fprintf('\nRam-Lak + 样条:\n');
fprintf('  均值: %.4f\n', mean(obj_rec_ramlak(:)));
fprintf('  标准差: %.4f\n', std(obj_rec_ramlak(:)));
fprintf('  范围: [%.4f, %.4f]\n', min(obj_rec_ramlak(:)), max(obj_rec_ramlak(:)));

fprintf('\nHamming + 样条:\n');
fprintf('  均值: %.4f\n', mean(obj_rec_hamming(:)));
fprintf('  标准差: %.4f\n', std(obj_rec_hamming(:)));
fprintf('  范围: [%.4f, %.4f]\n', min(obj_rec_hamming(:)), max(obj_rec_hamming(:)));

%% 保存重建结果
fprintf('\n正在保存重建结果...\n');
save('resultats_reconstruction.mat', ...
    'obj_rec_none', 'obj_rec_shepp_spline', 'obj_rec_shepp_linear', ...
    'obj_rec_ramlak', 'obj_rec_hamming', 'obj_rec_cosine', 'obj_rec_hann', ...
    'theta', 'Matrice_acqui_angle', 'output_size');

% 保存最佳重建图像
imwrite(uint8(255*mat2gray(obj_rec_shepp_spline)), 'reconstruction_shepp_logan.png');
imwrite(uint8(255*mat2gray(obj_rec_none)), 'reconstruction_sans_filtrage.png');

fprintf('重建完成！结果已保存。\n');
fprintf('\n与GS-EchoView的结果对比：\n');
fprintf('  - 请将上述重建图像与GS-EchoView软件保存的图像进行视觉对比\n');
fprintf('  - Shepp-Logan滤波器通常提供最佳的边缘保持和噪声抑制\n');
fprintf('  - 由于角度采样数量有限（%d个角度），重建图像可能存在轻微条纹伪影\n', R);
fprintf('  - 增加角度数量（例如到180个）可以显著改善图像质量\n');

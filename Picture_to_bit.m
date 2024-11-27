% 1. 读取图片
img = imread('C:\Users\X2013\Desktop\ADI\R-C.jpg'); % 替换为图片路径
img_gray = rgb2gray(img);       % 转换为灰度图

% 2. 将灰度值转化为一维信号
signal = double(img_gray(:));   % 展平成一维向量，并转换为double类型

% 3. 归一化信号
signal = signal / max(signal);  % 归一化到 [0, 1]

% 4. 将信号调整为模拟信号 (插值平滑处理)
t = linspace(0, 1, length(signal)); % 生成时间序列
fs = 100;                          % 模拟采样率，8 kHz
t_resampled = linspace(0, 1, fs);   % 插值到目标采样率
signal_resampled = interp1(t, signal, t_resampled, 'spline'); % 插值平滑

% 5. 绘制结果
figure;
subplot(2,1,1);
imshow(img_gray);                  % 显示灰度图片
title('灰度图像');
subplot(2,1,2);
plot(t_resampled, signal_resampled);
title('图片生成的模拟信号');
xlabel('时间 (s)');
ylabel('信号幅度');

% 6. 输出信号
disp('模拟信号已生成，保存或用于后续处理');

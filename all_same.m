% 系统参数
fs_pcm = 8e3;              % PCM采样率：8KHz
f_sub = 2e6;               % 副载波频率：2MHz
f_carrier = 10e6;          % 主载波频率：10MHz
f_rf = 1.2e9;              % 射频频率：1.2GHz
f_mod_freq = 100;          % 模拟信号频率：100Hz
alpha = 0.5;               % 调相指数
rolloff = 0.5;             % 滚降因子
distance = 2;              % 测试距离：2米

% 1. 读取图片并转换为灰度图
img = imread('C:\Users\X2013\Desktop\ADI\R-C.jpg'); % 替换为图片路径
img_gray = rgb2gray(img);  % 转换为灰度图

% 2. 将灰度图转换为一维信号
signal = double(img_gray(:));   % 展平成一维向量
signal = signal / max(signal);  % 归一化到 [0, 1]

% 参数设置
A = 87.6; % A-law 编码参数

% 3. PCM 抽样量化编码（A-law）
% 步骤 1：将信号归一化到 [-1, 1]
signal = 2 * signal - 1;  % 原信号范围 [0, 1] -> [-1, 1]

% 步骤 2：根据 A-law 公式进行非线性压缩
compressed_signal = zeros(size(signal)); % 初始化
threshold = 1 / A; % 分段阈值
for i = 1:length(signal)
    if abs(signal(i)) < threshold
        compressed_signal(i) = sign(signal(i)) * (A * abs(signal(i))) / (1 + log(A));
    else
        compressed_signal(i) = sign(signal(i)) * (1 + log(A * abs(signal(i)))) / (1 + log(A));
    end
end

% 步骤 3：将非线性压缩信号映射到 8 位量化的 [0, 255]
quantized_signal = round((compressed_signal + 1) / 2 * 255); % 映射到 [0, 255]
pcm_bits = de2bi(quantized_signal, 8, 'left-msb'); % 转换为二进制 PCM 编码
pcm_bits = pcm_bits(:)'; % 展平为一维比特流

% 4. PCM采样率为8kHz
t_pcm = (0:length(pcm_bits)-1) / fs_pcm; % 时间序列

% 5. 极性转换 (NRZ-L)
nrz_signal = 2 * pcm_bits - 1; % 将二进制信号转换为 NRZ-L 双极性格式

% 6. 上采样
samples_per_bit = 10;          % 每位比特的采样点数
nrz_upsampled = upsample(nrz_signal, samples_per_bit); % 上采样

% 7. BPSK 调制
t = (0:length(nrz_upsampled)-1) / (fs_pcm * samples_per_bit); % 调整时间序列
bpsk_signal = nrz_upsampled .* cos(2 * pi * f_sub * t); % BPSK 调制

% 8. 脉冲成型滤波
h = rcosdesign(rolloff, 4, samples_per_bit, 'sqrt');  % 滚降滤波器
bpsk_shaped = conv(bpsk_signal, h, 'same'); % 卷积进行脉冲成型

% 9. FM 调制
fs_high = fs_pcm * samples_per_bit; % 调整采样率
f_dev = f_carrier * alpha;          % FM 偏移频率，根据调相指数
fm_signal = fmmod(bpsk_shaped, f_carrier, 2*f_carrier, 0.5*f_sub); % FM 调制

% 10. RF 信号生成
t_rf = (0:length(fm_signal)-1) / fs_high; % 时间序列
rf_signal = cos(2 * pi * f_rf * t_rf) .* fm_signal; % 射频信号

% 11. 绘图显示结果
figure;
subplot(5,1,1);
imshow(img_gray);
title('灰度图像');

subplot(5,1,2);
plot(t_pcm(1:200), nrz_signal(1:200)); 
title('PCM 编码后的 NRZ-L 信号');

subplot(5,1,3);
plot(t(1:1000), bpsk_signal(1:1000));
title('BPSK 调制信号');

subplot(5,1,4);
plot(t_rf(1:1000), fm_signal(1:1000));
title('FM 调制信号');

subplot(5,1,5);
plot(t_rf(1:1000), rf_signal(1:1000));
title('RF 信号（1.2GHz 射频载波）');

% 12. 输出信号
disp('射频信号已生成，可保存或传输');



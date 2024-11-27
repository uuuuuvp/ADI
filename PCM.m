% 假设 modulated_signal 是已经生成的模拟信号
% 采样频率和量化参数设置
fs = 8000;              % 采样频率，8 kHz
bits = 8;               % 量化位数 (8位量化)
amplitude = max(abs(modulated_signal)); % 信号幅度范围

% 1. 对模拟信号进行抽样
t = (0:length(modulated_signal)-1) / fs; % 原始时间序列
sampled_signal = modulated_signal(1:fs:length(modulated_signal)); % 抽样点

% 2. 对信号进行均匀量化
quantization_levels = 2^bits;            % 量化级数
quantization_step = 2 * amplitude / quantization_levels; % 量化步长
quantized_signal = round(sampled_signal / quantization_step) * quantization_step;

% 3. 编码为PCM码
encoded_signal = dec2bin((quantized_signal / quantization_step + ...
                          quantization_levels / 2), bits); % 转换为二进制编码

% 4. 绘图展示结果
figure;

% 原始模拟信号
subplot(3,1,1);
plot(t(1:fs), modulated_signal(1:fs)); % 显示 1 秒的模拟信号
title('原始模拟信号');
xlabel('时间 (s)');
ylabel('幅度');

% 抽样信号
subplot(3,1,2);
stem(sampled_signal, 'filled'); % 用stem图展示离散的抽样信号
title('抽样后的离散信号');
xlabel('采样点');
ylabel('幅度');

% 量化信号
subplot(3,1,3);
stem(quantized_signal, 'filled');
title('量化后的信号');
xlabel('采样点');
ylabel('幅度');

% 5. 输出结果
disp('抽样、量化与编码完成！');
disp('量化后的PCM码为：');
disp(encoded_signal); % 显示量化后的PCM编码

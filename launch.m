% 1. 确保与 Pluto SDR 连接
dev = sdrupluto;  % 使用 Pluto SDR 设备连接

% 2. 配置 Pluto SDR 参数
% 设置发送频率 (例如 1.2 GHz 射频频率)
tx_freq = 1.2e9;  % 设置发射频率为 1.2 GHz
rx_freq = 1.2e9;  % 接收频率（如果需要接收）

% 设置采样率为设备支持的合适值 (例如 2 MHz)
fs_pluto = 2e6;  % 设备采样率

% 设置增益和其他参数
gain = 0;         % 增益设置为 0 (根据需要调整)

% 配置 Pluto SDR 参数
dev.CenterFrequency = tx_freq;   % 发射频率
dev.BasebandSampleRate = fs_pluto; % 设置采样率
dev.Gain = gain;                 % 设置增益

% 3. 准备发送信号
% 使用 fm_signal 作为输入信号 (FM 调制信号)
% 由于 Pluto SDR 通常需要复数信号，确保信号格式正确
tx_signal = complex(fm_signal, 0);  % 将信号转化为复数信号，虚部设置为0

% 4. 发送信号
% 向 Pluto SDR 发送信号
transmitRepeat(dev, tx_signal);

% 提示信息
disp('信号正在通过 Pluto SDR 发射...');

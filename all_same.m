% ϵͳ����
fs_pcm = 8e3;              % PCM�����ʣ�8KHz
f_sub = 2e6;               % ���ز�Ƶ�ʣ�2MHz
f_carrier = 10e6;          % ���ز�Ƶ�ʣ�10MHz
f_rf = 1.2e9;              % ��ƵƵ�ʣ�1.2GHz
f_mod_freq = 100;          % ģ���ź�Ƶ�ʣ�100Hz
alpha = 0.5;               % ����ָ��
rolloff = 0.5;             % ��������
distance = 2;              % ���Ծ��룺2��

% 1. ��ȡͼƬ��ת��Ϊ�Ҷ�ͼ
img = imread('C:\Users\X2013\Desktop\ADI\R-C.jpg'); % �滻ΪͼƬ·��
img_gray = rgb2gray(img);  % ת��Ϊ�Ҷ�ͼ

% 2. ���Ҷ�ͼת��Ϊһά�ź�
signal = double(img_gray(:));   % չƽ��һά����
signal = signal / max(signal);  % ��һ���� [0, 1]

% ��������
A = 87.6; % A-law �������

% 3. PCM �����������루A-law��
% ���� 1�����źŹ�һ���� [-1, 1]
signal = 2 * signal - 1;  % ԭ�źŷ�Χ [0, 1] -> [-1, 1]

% ���� 2������ A-law ��ʽ���з�����ѹ��
compressed_signal = zeros(size(signal)); % ��ʼ��
threshold = 1 / A; % �ֶ���ֵ
for i = 1:length(signal)
    if abs(signal(i)) < threshold
        compressed_signal(i) = sign(signal(i)) * (A * abs(signal(i))) / (1 + log(A));
    else
        compressed_signal(i) = sign(signal(i)) * (1 + log(A * abs(signal(i)))) / (1 + log(A));
    end
end

% ���� 3����������ѹ���ź�ӳ�䵽 8 λ������ [0, 255]
quantized_signal = round((compressed_signal + 1) / 2 * 255); % ӳ�䵽 [0, 255]
pcm_bits = de2bi(quantized_signal, 8, 'left-msb'); % ת��Ϊ������ PCM ����
pcm_bits = pcm_bits(:)'; % չƽΪһά������

% 4. PCM������Ϊ8kHz
t_pcm = (0:length(pcm_bits)-1) / fs_pcm; % ʱ������

% 5. ����ת�� (NRZ-L)
nrz_signal = 2 * pcm_bits - 1; % ���������ź�ת��Ϊ NRZ-L ˫���Ը�ʽ

% 6. �ϲ���
samples_per_bit = 10;          % ÿλ���صĲ�������
nrz_upsampled = upsample(nrz_signal, samples_per_bit); % �ϲ���

% 7. BPSK ����
t = (0:length(nrz_upsampled)-1) / (fs_pcm * samples_per_bit); % ����ʱ������
bpsk_signal = nrz_upsampled .* cos(2 * pi * f_sub * t); % BPSK ����

% 8. ��������˲�
h = rcosdesign(rolloff, 4, samples_per_bit, 'sqrt');  % �����˲���
bpsk_shaped = conv(bpsk_signal, h, 'same'); % ��������������

% 9. FM ����
fs_high = fs_pcm * samples_per_bit; % ����������
f_dev = f_carrier * alpha;          % FM ƫ��Ƶ�ʣ����ݵ���ָ��
fm_signal = fmmod(bpsk_shaped, f_carrier, 2*f_carrier, 0.5*f_sub); % FM ����

% 10. RF �ź�����
t_rf = (0:length(fm_signal)-1) / fs_high; % ʱ������
rf_signal = cos(2 * pi * f_rf * t_rf) .* fm_signal; % ��Ƶ�ź�

% 11. ��ͼ��ʾ���
figure;
subplot(5,1,1);
imshow(img_gray);
title('�Ҷ�ͼ��');

subplot(5,1,2);
plot(t_pcm(1:200), nrz_signal(1:200)); 
title('PCM ������ NRZ-L �ź�');

subplot(5,1,3);
plot(t(1:1000), bpsk_signal(1:1000));
title('BPSK �����ź�');

subplot(5,1,4);
plot(t_rf(1:1000), fm_signal(1:1000));
title('FM �����ź�');

subplot(5,1,5);
plot(t_rf(1:1000), rf_signal(1:1000));
title('RF �źţ�1.2GHz ��Ƶ�ز���');

% 12. ����ź�
disp('��Ƶ�ź������ɣ��ɱ������');



% ���� modulated_signal ���Ѿ����ɵ�ģ���ź�
% ����Ƶ�ʺ�������������
fs = 8000;              % ����Ƶ�ʣ�8 kHz
bits = 8;               % ����λ�� (8λ����)
amplitude = max(abs(modulated_signal)); % �źŷ��ȷ�Χ

% 1. ��ģ���źŽ��г���
t = (0:length(modulated_signal)-1) / fs; % ԭʼʱ������
sampled_signal = modulated_signal(1:fs:length(modulated_signal)); % ������

% 2. ���źŽ��о�������
quantization_levels = 2^bits;            % ��������
quantization_step = 2 * amplitude / quantization_levels; % ��������
quantized_signal = round(sampled_signal / quantization_step) * quantization_step;

% 3. ����ΪPCM��
encoded_signal = dec2bin((quantized_signal / quantization_step + ...
                          quantization_levels / 2), bits); % ת��Ϊ�����Ʊ���

% 4. ��ͼչʾ���
figure;

% ԭʼģ���ź�
subplot(3,1,1);
plot(t(1:fs), modulated_signal(1:fs)); % ��ʾ 1 ���ģ���ź�
title('ԭʼģ���ź�');
xlabel('ʱ�� (s)');
ylabel('����');

% �����ź�
subplot(3,1,2);
stem(sampled_signal, 'filled'); % ��stemͼչʾ��ɢ�ĳ����ź�
title('���������ɢ�ź�');
xlabel('������');
ylabel('����');

% �����ź�
subplot(3,1,3);
stem(quantized_signal, 'filled');
title('��������ź�');
xlabel('������');
ylabel('����');

% 5. ������
disp('�����������������ɣ�');
disp('�������PCM��Ϊ��');
disp(encoded_signal); % ��ʾ�������PCM����

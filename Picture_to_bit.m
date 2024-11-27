% 1. ��ȡͼƬ
img = imread('C:\Users\X2013\Desktop\ADI\R-C.jpg'); % �滻ΪͼƬ·��
img_gray = rgb2gray(img);       % ת��Ϊ�Ҷ�ͼ

% 2. ���Ҷ�ֵת��Ϊһά�ź�
signal = double(img_gray(:));   % չƽ��һά��������ת��Ϊdouble����

% 3. ��һ���ź�
signal = signal / max(signal);  % ��һ���� [0, 1]

% 4. ���źŵ���Ϊģ���ź� (��ֵƽ������)
t = linspace(0, 1, length(signal)); % ����ʱ������
fs = 100;                          % ģ������ʣ�8 kHz
t_resampled = linspace(0, 1, fs);   % ��ֵ��Ŀ�������
signal_resampled = interp1(t, signal, t_resampled, 'spline'); % ��ֵƽ��

% 5. ���ƽ��
figure;
subplot(2,1,1);
imshow(img_gray);                  % ��ʾ�Ҷ�ͼƬ
title('�Ҷ�ͼ��');
subplot(2,1,2);
plot(t_resampled, signal_resampled);
title('ͼƬ���ɵ�ģ���ź�');
xlabel('ʱ�� (s)');
ylabel('�źŷ���');

% 6. ����ź�
disp('ģ���ź������ɣ���������ں�������');

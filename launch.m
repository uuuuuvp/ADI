% 1. ȷ���� Pluto SDR ����
dev = sdrupluto;  % ʹ�� Pluto SDR �豸����

% 2. ���� Pluto SDR ����
% ���÷���Ƶ�� (���� 1.2 GHz ��ƵƵ��)
tx_freq = 1.2e9;  % ���÷���Ƶ��Ϊ 1.2 GHz
rx_freq = 1.2e9;  % ����Ƶ�ʣ������Ҫ���գ�

% ���ò�����Ϊ�豸֧�ֵĺ���ֵ (���� 2 MHz)
fs_pluto = 2e6;  % �豸������

% �����������������
gain = 0;         % ��������Ϊ 0 (������Ҫ����)

% ���� Pluto SDR ����
dev.CenterFrequency = tx_freq;   % ����Ƶ��
dev.BasebandSampleRate = fs_pluto; % ���ò�����
dev.Gain = gain;                 % ��������

% 3. ׼�������ź�
% ʹ�� fm_signal ��Ϊ�����ź� (FM �����ź�)
% ���� Pluto SDR ͨ����Ҫ�����źţ�ȷ���źŸ�ʽ��ȷ
tx_signal = complex(fm_signal, 0);  % ���ź�ת��Ϊ�����źţ��鲿����Ϊ0

% 4. �����ź�
% �� Pluto SDR �����ź�
transmitRepeat(dev, tx_signal);

% ��ʾ��Ϣ
disp('�ź�����ͨ�� Pluto SDR ����...');

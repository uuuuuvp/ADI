function [sampleData,a13_moddata] = PCM_13Encode(inputData,Fs,sampleVal)
%Ҫ�������ʴ�Fs����Ϊ8kHz,��Ҫȷ��һ��������������֮�ȣ�P/Q��ʹ�� P/Q ��ԭʼ������֮����ĳ��ָ���ݲ��ڵ���8k��
%Ҫȷ����Щ���ӣ�ʹ��rat�������²�����8000��ԭʼ������Fs֮��
[P,Q]=rat(8000/Fs);
%��ʹ�� rat ��õķ��Ӻͷ�ĸ������Ϊ resample �����룬�����8kHz �����Ĳ��Ρ�
sampleData = resample(inputData,P,Q);
MaxS = max(abs(sampleData));
sampleData = sampleData/MaxS;
disp(sampleData);
[ a13_moddata ] = a_13coding( sampleData );
end

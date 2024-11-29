function [sampleData,a13_moddata] = PCM_13Encode(inputData,Fs,sampleVal)
%要将采样率从Fs更改为8kHz,需要确定一个有理数（整数之比）P/Q，使得 P/Q 与原始采样率之积在某个指定容差内等于8k。
%要确定这些因子，使用rat。输入新采样率8000与原始采样率Fs之比
[P,Q]=rat(8000/Fs);
%将使用 rat 求得的分子和分母因子作为 resample 的输入，输出以8kHz 采样的波形。
sampleData = resample(inputData,P,Q);
MaxS = max(abs(sampleData));
sampleData = sampleData/MaxS;
disp(sampleData);
[ a13_moddata ] = a_13coding( sampleData );
end

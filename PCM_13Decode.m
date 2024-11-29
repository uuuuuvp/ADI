function  [outData] = PCM_13Decode( inputData )
 
n=length(inputData);
outData=zeros(1,n/8);
MM=zeros(1,8);
 
for kk=1:n/8
    MM(1:8)=inputData(1,(kk-1)*8+1:kk*8); % 取得8位PCM码
    
    temp=MM(2)*2^2+MM(3)*2+MM(4)     ; % 将8位PCM码的第2~4位二进制数转化为10进制（三位二进制转十进制）
       %用于判断抽样值在哪个段落内
 
%     段落序号i=1                
    if temp==0
        q=1;    %段内量化间隔
        a=0;    %段落起始电平
    end
%     段落序号i=2   
    if temp==1
        q=1;
        a=16;
    end
%     段落序号i=3    
    if temp==2
        q=2;
        a=32;
    end
%     段落序号i=4    
    if temp==3
        q=4;
        a=64;
    end
%     段落序号i=5    
    if temp==4
        q=8;
        a=128;
    end
%     段落序号i=6    
    if temp==5
        q=16;
        a=256;
    end
%     段落序号i=7    
    if temp==6
        q=32;
        a=512;
    end
%     段落序号i=8    
    if temp==7
        q=64;
        a=1024;
    end
   
   A= MM(5)*2^3+MM(6)*2^2+MM(7)*2+MM(8)  ;% 8位PCM码的第5~8位二进制数转化为10进制
% 用于判断抽样值量化级数
                                     
    R=(a+A*q+q/2)/2048;%取量化间隔中点值进行译码
    if  MM(1)==0  %判断极性
        R=-R;
    end
    outData(1,kk)=R;%译码后数据
end
end

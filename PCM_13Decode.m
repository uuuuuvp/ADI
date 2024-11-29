function  [outData] = PCM_13Decode( inputData )
 
n=length(inputData);
outData=zeros(1,n/8);
MM=zeros(1,8);
 
for kk=1:n/8
    MM(1:8)=inputData(1,(kk-1)*8+1:kk*8); % ȡ��8λPCM��
    
    temp=MM(2)*2^2+MM(3)*2+MM(4)     ; % ��8λPCM��ĵ�2~4λ��������ת��Ϊ10���ƣ���λ������תʮ���ƣ�
       %�����жϳ���ֵ���ĸ�������
 
%     �������i=1                
    if temp==0
        q=1;    %�����������
        a=0;    %������ʼ��ƽ
    end
%     �������i=2   
    if temp==1
        q=1;
        a=16;
    end
%     �������i=3    
    if temp==2
        q=2;
        a=32;
    end
%     �������i=4    
    if temp==3
        q=4;
        a=64;
    end
%     �������i=5    
    if temp==4
        q=8;
        a=128;
    end
%     �������i=6    
    if temp==5
        q=16;
        a=256;
    end
%     �������i=7    
    if temp==6
        q=32;
        a=512;
    end
%     �������i=8    
    if temp==7
        q=64;
        a=1024;
    end
   
   A= MM(5)*2^3+MM(6)*2^2+MM(7)*2+MM(8)  ;% 8λPCM��ĵ�5~8λ��������ת��Ϊ10����
% �����жϳ���ֵ��������
                                     
    R=(a+A*q+q/2)/2048;%ȡ��������е�ֵ��������
    if  MM(1)==0  %�жϼ���
        R=-R;
    end
    outData(1,kk)=R;%���������
end
end

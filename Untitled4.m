Fs = 10000; %采样频率决定了两个正弦波点之间的间隔
N = 4096; %采样点数
N1 = 0 : 1/Fs : N/Fs-1/Fs;
s = sin(1000*2*pi*N1) + sin(3000*2*pi*N1) +sin(4000*2*pi*N1);
fidc = fopen('E:\mem.txt','wt');
for x = 1 : N
   fprintf(fidc,'%x\n',round((s(x)+2.12)*58));
end 
fclose(fidc);  
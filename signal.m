width=16;
y2=round(y.*2^(width-3));%量化Q13
fig=fopen('signal.coe','w');
fprintf(fig,'memory_initialization_radix=10;\n memory_initialization_vector = \n');
for i = 1:N %将数据转换为补码表示
    if y2(i) >= 0
        y2(i) = y2(i);
    else
        y2(i) = 2^width + y2(i);%负整数补码表示（相当于对数据位宽n做2^(n+1)做补）
    end                                 %大于2^15-1=32767的是负数；小于32767的是正数
end
for i=1:N
    if i==N
         fprintf(fig,'%d,',y2(i)); 
    else
         fprintf(fig,'%d,\r\n',y2(i));
    end
end
fclose(fig);

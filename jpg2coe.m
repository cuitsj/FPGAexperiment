%%Jpg图像可使用matlab工具将其转换为coe文件，具体步骤如下：将以下代码保存为M文件，将其与待转换的jpg图像保存在同一目录下；
%%注意：下面红色标记的代码是要转换的jpg文件名和要生成的coe文件名，蓝色标记的是转换的RGB模式，这里是RGB444。可以根据实际情况更改
function img2 = IMG2coe8(imgfile,outfile)

img=imread('elements.jpg');
height=size(img,1);
width=size(img,2);
s=fopen('elements.coe','wb');
fprintf(s,'%s\n',';VGAMemoryMap');
fprintf(s,'%s\n',';.COEfilewithhexcoefficients');
fprintf(s,';Height:%d,Width:%d\n\n',height,width);
fprintf(s,'%s\n','memory_initialization_radix=16;');
fprintf(s,'%s\n','memory_initialization_vector=');

cnt=0;
img2=img;
for r=1:height
    for c=1:width
        cnt=cnt+1;
        R=img(r,c,1);
        G=img(r,c,2);
        B=img(r,c,3);
        Rb=dec2bin(double(R),8);
        Gb=dec2bin(double(G),8);
        Bb=dec2bin(double(B),8);
        
        img2(r,c,1)=bin2dec([Rb(1:4) '00000']);
        img2(r,c,2)=bin2dec([Gb(1:4) '00000']);
        img2(r,c,3)=bin2dec([Bb(1:4) '00000']);
        Outbyte=[Rb(1:4) Gb(1:4) Bb(1:4)];
        
        if(Outbyte(1:4) == '0000')
            fprintf(s,'0%X',bin2dec(Outbyte));
        else
            fprintf(s,'%X',bin2dec(Outbyte));
        end
        if((c==width)&&(r==height))
            fprintf(s,'%c',';');
        else
            if(mod(cnt,32)==0)
                fprintf(s,'%c\n',',');
            else
                fprintf(s,'%c',',');
            end
        end
    end
end

fclose(s);

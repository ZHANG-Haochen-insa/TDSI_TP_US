%*************************************************************************
% 功能说明：此函数将ASCII文件中的逗号替换为点号
% 这是从网络上改编而来的函数
% 
% 输入参数：filepoint [字符串] - 包含逗号的文件名
% 输出参数：filecomma [字符串] - 包含点号的文件名
%
% 作者：N. Ducros 
% 单位：INSA de Lyon/Creatis
% 日期：2013年4月8日
%*************************************************************************

function filecomma = comma2point(filepoint)

% 创建新的临时文件名：将原文件扩展名前加上'_tmp'并改为'.txt'
filecomma = [filepoint(1:end-4),'_tmp','.txt'];
% 复制原文件到新的临时文件
copyfile(filepoint, filecomma);

% 设置缓冲区大小为1024字节
bufsize = 1024;
% 以读写模式打开临时文件
fid = fopen(filecomma,'r+');

% 循环读取文件直到文件末尾
while ~feof(fid)
    % 从文件中读取bufsize个字节，x是读取的数据，c是实际读取的字节数
    [x,c] = fread(fid,[1,bufsize]);
    % 找出所有逗号的位置（ASCII码44）
    idx = (x==',');
    % 如果存在逗号
    if any(idx)
        % 将文件指针向后移动c个字节（回到刚才读取的起始位置）
        fseek(fid,-c,'cof');
        % 将所有逗号替换为点号（ASCII码46）
        x(idx) = '.';
        % 将修改后的数据写回文件
        fwrite(fid,x);
    end
end
% 关闭文件
fclose(fid);
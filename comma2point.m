%*************************************************************************
% This function replaces commas by dots in ascii files. It's been adapted 
% from the web.
% 
% Input : filepoint [string] - filename of file with commas
% Output: filecomma [string] - filename of file with dots
%
% Author: N. Ducros 
% Institution: INSA de Lyon/Creatis
% Date: 08-Apr-2013
%*************************************************************************

function filecomma = comma2point(filepoint)

filecomma = [filepoint(1:end-4),'_tmp','.txt'];
copyfile(filepoint, filecomma);

bufsize = 1024;
fid = fopen(filecomma,'r+');

while ~feof(fid)
    [x,c] = fread(fid,[1,bufsize]);
    idx = (x==',');
    if any(idx)
        fseek(fid,-c,'cof');
        x(idx) = '.';
        fwrite(fid,x);
    end
end
fclose(fid);
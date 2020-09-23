function [time,I]=Acquisition_Image(nomfich,s,i)
%nomfich    : CHemin et nom du fichier à ouvrir
%s          : Les infos contenus dans le fichier .ptw, Ti, fréquence....
%i          : image n° i

fid=fopen(nomfich,'r');
%Récupération de l'image
fseek (fid, s.m_MainHeaderSize+i*s.m_FrameHeaderSize+(i-1)*s.m_FrameSize*2,'bof'); %skip frame header
I=fread(fid, [s.m_cols, s.m_rows],'uint16');I=I';
%récupération du temps
fseek (fid, s.m_MainHeaderSize+(i-1)*(s.m_FrameSize*2+s.m_FrameHeaderSize),'bof');
fseek(fid,80,'cof');
a=fread(fid,4,'char')';
fseek(fid,76,'cof');
b=fread(fid,2,'char')';
t=[a(2) a(1) a(4) a(3) b(1) b(2)];
time=t(1)*3600+t(2)*60+t(3)+t(4)/100+t(5)/1000+t(6)/1000000;

fclose(fid); %close file


end







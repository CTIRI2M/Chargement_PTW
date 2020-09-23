
function [t,T]=Acquisition_Sequence_Complete_ROI(nomfich,s,ROI)
%Nomfich   : CHemin et nom du fichier à ouvrir
%s         : Les infos contenus dans le fichier .ptw, Ti, fréquence....
%ROI       : Structure avec .pl le vecteur ligne et .pc le vecteur colonne des indices des coordonnées 
%Si on ne met pas pl et pc on prendra toute l'image

%Boucle sur le nombre d'images
fid=fopen(nomfich,'r');
%Saut du header principal
fseek (fid, s.m_MainHeaderSize,'bof');
%Barre d'avancement
h = waitbar(0,'Please wait...');
for i=1:s.m_nframes
    %récupération du temps
    fseek(fid,80,'cof');
    a=fread(fid,[1 4],'uint8=>char')';
    fseek(fid,76,'cof');
    b=fread(fid,[1 2],'uint8=>char')';
    t=[a(2) a(1) a(4) a(3) b(1) b(2)];
    t0(i)=t(1)*3600+t(2)*60+t(3)+t(4)/100+t(5)/1000+t(6)/1000000;
    %Récupération des images
    fseek (fid, s.m_MainHeaderSize+i*s.m_FrameHeaderSize+(i-1)*s.m_FrameSize*2,'bof'); %skip frame header
    z=fread(fid, [s.m_cols, s.m_rows],'uint16');z=z';    
    T(:,:,i)=z(ROI.pl,ROI.pc);    
    waitbar(i/s.m_nframes)
end
close(h);
fclose(fid); %close file
t=t0-t0(1);

end







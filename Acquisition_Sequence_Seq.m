
function [t1,T]=Acquisition_Sequence_Complete_Seq(nomfich,s,Seq)
%Nomfich   : CHemin et nom du fichier à ouvrir
%s         : Les infos contenus dans le fichier .ptw, Ti, fréquence....
%Seq       : Structure avec .Ndeb pour le début, .pas pour le pas et .Nfin pour la dernière
%Si on ne met pas pl et pc on prendra toute l'image
Nt=length(Seq.Ndeb:Seq.pas:Seq.Nfin);
[t0,data]=Acquisition_Image(nomfich,s,1);
%Boucle sur le nombre d'images
fid=fopen(nomfich,'r');
%Saut du header principal
fseek (fid, s.m_MainHeaderSize,'bof');
%Barre d'avancement
h = waitbar(0,'Please wait...');
cpt=1;
for i=Seq.Ndeb:Seq.pas:Seq.Nfin
    %Récupération de l'image
    fseek (fid, s.m_MainHeaderSize+i*s.m_FrameHeaderSize+(i-1)*s.m_FrameSize*2,'bof'); %skip frame header
    I=fread(fid, [s.m_cols, s.m_rows],'uint16');I=I';
    T(:,:,cpt)=I;
    %récupération du temps
    fseek (fid, s.m_MainHeaderSize+(i-1)*(s.m_FrameSize*2+s.m_FrameHeaderSize),'bof');
    fseek(fid,80,'cof');
    a=fread(fid,4,'char')';
    fseek(fid,76,'cof');
    b=fread(fid,2,'char')';
    t=[a(2) a(1) a(4) a(3) b(1) b(2)];
    t1(cpt)=t(1)*3600+t(2)*60+t(3)+t(4)/100+t(5)/1000+t(6)/1000000;
    cpt=cpt+1;
    waitbar(cpt/Nt)
end
close(h);
fclose(fid); %close file
t1=t1-t0;

end







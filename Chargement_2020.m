% -------------------------------------------------------------------------
% -------------------------------------------------------------------------
%
%           Programme d'extraction des températures et des temps d'un
%           fichier .PTW
%
% -------------------------------------------------------------------------
%                      C. Pradère le 22 Septembre 2020
%                               version 1.0
% -------------------------------------------------------------------------
% -------------------------------------------------------------------------
%Initialisation
clear all
close all
clc

% -------------------------------------------------------------------------
%                           Chargement des répertoires
% -------------------------------------------------------------------------
%Ouverture de la fenêtre de chargement
[file,workdir]=uigetfile('*.ptw','Sélectionnez le fichier','MultiSelect', 'off');
nomfich=[workdir,file];

% -------------------------------------------------------------------------
%                       Récupération des infos du fichier
% -------------------------------------------------------------------------

[s]=Lecture_Donnees(nomfich);

% -------------------------------------------------------------------------
%                       Chargement image + sélection méthode
% -------------------------------------------------------------------------

%Chargement de la première image
[t0,data]=Acquisition_Image(nomfich,s,1);
%Sélection de la  ROI
figure(1);imagesc(data);
fig=uifigure;
selection = uiconfirm(fig,'Choisir la façon de convertir le fichier','Choix',...
    'Options',{'Totale','Par ROI','Par séquence','Par ROi et séquence'},...
    'DefaultOption',1)
close(fig)
if isequal(selection,'Totale') == 1
    tic;
    [t,T]=Acquisition_Sequence(nomfich,s);
    toc
end
if isequal(selection,'Par ROI') == 1
    % -------------------------------------------------------------------------
    %                       Sélection de la ROI
    % -------------------------------------------------------------------------    
    figure;imagesc(data);title('Choose the Region Of Interest');
    g = imrect(gca);
    position = wait(g);
    close all;
    %Affectation des positions
    position=round(position);%[xmin ymin width height]
    pl=position(2):position(2)+position(4);
    pc=position(1):position(1)+position(3);
    Nl=length(pl);Nc=length(pc);
    ROI.pl=pl;ROI.pc=pc;
    tic;
    [t,T]=Acquisition_Sequence_ROI(nomfich,s,ROI);%
    toc
end
if isequal(selection,'Par séquence') == 1
    prompt = {'Image de début','Pas','Image de fin'};
    dlgtitle = 'Input';
    dims = [1 35];
    definput = {'1','1',num2str(s.m_nframes)};
    answer = inputdlg(prompt,dlgtitle,dims,definput);
    Seq.Ndeb=str2num(cell2mat(answer(1,:)));
    Seq.pas=str2num(cell2mat(answer(2,:)));
    Seq.Nfin=str2num(cell2mat(answer(3,:)));
    tic;
    [t,T]=Acquisition_Sequence_Seq(nomfich,s,Seq);%
    toc
end
if isequal(selection,'Par ROi et séquence')==1
    
    % ---------------------------------------------------------------------
    %                       Sélection de la ROI
    % ---------------------------------------------------------------------   
    figure;imagesc(data);title('Choose the Region Of Interest');
    g = imrect(gca);
    position = wait(g);
    close all;
    %Affectation des positions
    position=round(position);%[xmin ymin width height]
    pl=position(2):position(2)+position(4);
    pc=position(1):position(1)+position(3);
    Nl=length(pl);Nc=length(pc);
    ROI.pl=pl;ROI.pc=pc;
    
    % ---------------------------------------------------------------------
    %                       Sélection de la Séquence
    % ---------------------------------------------------------------------  
 
    prompt = {'Image de début','Pas','Image de fin'};
    dlgtitle = 'Input';
    dims = [1 35];
    definput = {'1','1',num2str(s.m_nframes)};
    answer = inputdlg(prompt,dlgtitle,dims,definput);
    Seq.Ndeb=str2num(cell2mat(answer(1,:)));
    Seq.pas=str2num(cell2mat(answer(2,:)));
    Seq.Nfin=str2num(cell2mat(answer(3,:)));
    
    tic;
    [t,T]=Acquisition_Sequence_Complete(nomfich,s,ROI,Seq);
    toc
end

% close all;for i=1:size(T,3);imagesc(T(:,:,i));title(num2str(i));axis equal;colorbar;drawnow;end
return
% -------------------------------------------------------------------------
%                       Sélection de la Séquence
% -------------------------------------------------------------------------

Seq.Ndeb=1;Seq.pas=10;Seq.Nfin=300;
% -------------------------------------------------------------------------
%                      Chargement
% -------------------------------------------------------------------------

tic;
% [t,T]=Acquisition_Sequence(nomfich,s);
% [t,T]=Acquisition_Sequence_ROI(nomfich,s,ROI);%
% [t,T]=Acquisition_Sequence_Seq(nomfich,s,Seq);
[t,T]=Acquisition_Sequence_Complete(nomfich,s,ROI,Seq);
toc
return











tic;
% nomfich='SIC1.ptw';
nomfich='Montpellier_2.ptw';
% nomfich='resistance_Socool5.ptw';
[s]=Lecture_Donnees(nomfich);

%Boucle sur le nombre d'images
fid=fopen(nomfich,'r');
%Saut du header principal
fseek (fid, s.m_MainHeaderSize,'bof');
for i=1:s.m_nframes
    [time,I]=Acquisition_Image(fid,s,i);
    t0(i)=time;
    T(:,:,i)=I;
end
fclose(fid); %close file
% Ar=reshape(A,s.m_cols,s.m_rows,s.m_nframes);
t=t0-0*t0(1);
toc
tic;
nom0=strrep(nomfich,'.ptw','.mat');
save(nom0,'s','t','T')
toc
return






function [xf,f]=hann(x,overlap)

%Cette fonction fenetre le signal dans la matrice x (chaque 
%colonne en represente un bloc) par la fenetre de hanning. 
%Celle-ci s'applique seulement sur les extremites
%des blocs, de maniere a compenser un overlap de "overlap" echantillons. 

%Fenetre de hanning de taille 2*overlap
h=hanning(2*overlap);

%formation de la fenetre f, de taille egale a celle des blocs de x
s=size(x);
f=ones(s(1),1);
%Flanc montant
f(1:overlap)=h(1:overlap);
%Flanc descendant
f(s(1)-overlap+1:s(1))=h(overlap+1:2*overlap);
%Forme matricielle (pour le produit ci-dessous)
fmat=repmat(f,1,s(2));

%fenetrage
xf=x.*fmat;

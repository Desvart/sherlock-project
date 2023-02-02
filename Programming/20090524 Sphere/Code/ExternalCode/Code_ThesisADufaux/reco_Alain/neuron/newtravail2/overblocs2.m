function [xblocs]=overblocs(x,blocsize,overlap)

%Cette fonction arrange le signal x en une matrice xblocs
%dont chaque colonne represente un bloc de taille blocsize.
%Chaque bloc a un overlap avec l'un de ses voisins de "overlap" 
%echantillons.
%rem: overlap doit etre un nombre entier de fois blocsize.
%valeurs typiques: blocsize=2048, overlap=128

% x est tranforme en un vecteur colonne si necessaire
s=size(x);
if (s(2)~= 1) x=x'; end;

%nombre de blocs total, en tenant compte des overlap
nblocs=floor((length(x)-overlap)/(blocsize-overlap));

%dimensionnement de la matrice xblocs
xblocs=zeros(blocsize,nblocs);

%Remplissage de la matrice xblocs
for (i=1:nblocs) 
   xblocs(:,i)=x(1+(i-1)*(blocsize-overlap):i*blocsize-(i-1)*overlap);
end;


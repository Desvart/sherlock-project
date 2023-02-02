function [filenames]=f(name,indexes);

%Soit un set de fichiers dont le format du nom est le suivant:
%	nameXXX.wav
%name est le corps du nom, toujours identique (n'importe quelle longueur!) 
%XXX est un entier à 3 digits, dont les valeurs sont listées dans
%le vecteur "indexes".
%filenames est une matrice dont chaque ligne représente le nom d'un fichier

name=[name '000.wav'];
l=length(name);
filenames=repmat(name,length(indexes),1);

for i=1:length(indexes),
   index=int2str(indexes(i));
   s=size(index);
   filenames(i,l-4-s(2)+1:l-4)=index;
end;

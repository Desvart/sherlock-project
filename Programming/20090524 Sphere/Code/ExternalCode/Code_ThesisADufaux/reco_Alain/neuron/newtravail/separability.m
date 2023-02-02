function [vsep,dsep] = separability( x, target, NbClasses )
%Perform LDA


%Estimation statistiques classes
[mx,cx]=estimate(x,target);
for i=1:NbClasses,[m{i},c{i}]=class_extract(mx,cx,i);end;

%Sw
temp=zeros(size(x,1));
for i=1:NbClasses,
   temp=temp+c{i};
end;
Sw=temp/NbClasses;

%moyenne totale
mean0=mean(x')';

%Sb
temp=zeros(size(x,1));
for i=1:NbClasses,
   temp=temp+(m{i}-mean0)*(m{i}-mean0)';
end;
Sb=temp/NbClasses;

%J
%J=inv(Sw)*Sb;
%[vsepJ,dsepJ] = eig(J);
[H,A]=eig(Sw);
temp=H*(inv(A))^0.5;
%I=temp'*Sw*temp
temp=temp'*Sb*temp;
[U,Sigma]=eig(temp);
Nabla=H*(inv(A))^0.5*U;
vsep=Nabla;dsep=Sigma;
%vsep=vsepJ;dsep=dsepJ;
du=diag(dsep);
du=abs(du);
[dsep di] = sort(-du);dsep=-dsep;vsep=vsep(:,di);
%dsep=abs(dsep);%pour supprimer des valeurs propres négatives proches de 0
%dsep=dsep+1e-20;%pour supprimer des valeurs propres nulles

%Sbtest=H*A^0.5*U*Sigma*U'*A^0.5*H';
%Swtest=H*A^0.5*U*I*U'*A^0.5*H';




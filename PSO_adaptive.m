function [A]=PSO_adaptive(LL4,m)
pops=20;%nombre de particule dans la population 
maxgen=100;% nombre d'it�ration maximal

n=2; %n est le nombre des variables de la particule ici deulement delta!
bound=zeros(n,2);%initialisation de la matrice des  limites des variables

% *************Limites des varaiables************
bound(1,:)=[2 120];% limite de chaque variable
bound(2,:)=[0 0.5];
%...
%*************************************************

numvar=n; % Nombre de variables (nombre de dimentions de populations)

rng=(bound(:,2)-bound(:,1))';%largeur de la plage de variation des variables
popi=zeros(pops,numvar);       %popi = initialisation de la population
popi(:,1:numvar)=(ones(pops,1)*rng).*(rand(pops,numvar))+...
    (ones(pops,1)*bound(:,1)');%g�n�ration des valeurs al�atoires de la polulation

wmax=0.9;
wmin=0.4;


c1=1.5;
c2=1.5;


for iter=1:maxgen
W(iter)=wmax-((wmax-wmin)/maxgen)*iter;
end
%on peut �liminer cette boucle et on fixe w � la valeur moyenne

%****************************
popa=popi;
vilocity=rand(numvar,pops)';%initialisation de la vitesse � une valeur al�atoire
Z=popi;
Z2=fitness1(LL4,m,popi);
% for j=2:n
%  for i=1:length(vilocity)
%     if vilocity(i,j-1)>vilocity(i,j);
%    a=vilocity(i,j-1);
%     vilocity(i,j)=a;
%     vilocity(i,j-1)=vilocity(i,j);
%     end
%   end
% end
 
% cette boucle n'est pas n�cessaire elle est utulis� pour un cas pr�cis

k=2; % compteur pour la boucle while

fiti=fitness1(LL4,m,popa); %appel � la fonction � minimiser

[gbest index]=min(fiti);% g�n�ration de la "best postion" global et ses coordonn�es 
xbbest=popa(index,:);% les variables correspondants � la "best position"
ff1(1)=(1/gbest)-1;%d�normalisation de la fonction � minimiser

 i=1:pops;
pbest(i)=fiti(i);%g�n�ration de la meilleurs positions de chaque particule de la polpulation
xbest(i,:)=popa(i,:);%g�n�ration des coordonn�es des meilleurs position

% verifier l'interet de la boucle %%%%%%%%%%%%%

%%%%%%adaptation%%%%%%
while k<maxgen+1
    i=1:pops;
    vilocity(i,:)=W(k)*rand(1)*vilocity(i,:) + c1*rand(1)*(xbbest(ones(size(popa,1),1),:)-popa(i,:))+c2*rand(1)*(xbest(i,:)-popa(i,:));
     
    popa(i,:)=popa(i,:)+vilocity(i,:);%
      
    fitp=fitness1(LL4,m,popa);%appel de la fonction � minimiser
for i=1:pops
    if fitp(i)<pbest(i)
        pbest(i)=fitp(i);%mise � jour de la meilleur position de chaque particile
        
        xbest(i,:)=popa(i,:);%mise � jour des coordonn�es des best
       
    end
end
[gbest index]=min(pbest);%mise � jour de best position globale
xbbest=popa(index,:);% ces coordonn�es xbest

cc(k)=gbest;
ff1(k)=(1/cc(k))-1;% d�normalisation de le fonction � minimiser
k=k+1;
Z=[Z,xbest];
Z2=[Z2,fitness1(LL4,m,xbest)];
end

A=xbbest;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%
% figure(1),
% plot(cc,'b'), hold on;
% xlabel('generation');
% ylabel('fitness');
% title('fitness preogress');
% legend('PSO');

end


function [JT]= fitness1(LL4,m,pop)


for i=1:size(pop,1)

    m_det=det_Q( LL4,pop(i,1),pop(i,2) );
    [number,ratio] = biterr(m,m_det);
    JT(i)=0.5-abs(ratio-0.5);
end

%JT
end






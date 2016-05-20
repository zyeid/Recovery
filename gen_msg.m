function [ pos,SH,RF,PL ] = gen_msg( Nr,Np,H )

%Nr: size of reference
%Np: size of payload
%Nt: nbre d'element de l'hote
%select (Np+Nr) bits from a totale of Nt


indexes = randperm(numel(H));
RF(1:Nr/2)=0;
RF(Nr/2+1:Nr)=1;
RF_pos=indexes(1:Nr);
PL=round(rand(1,Np));
PL_pos=indexes(Nr+1:Nr+Np);
pos=indexes(1:Nr+Np);

H_reshaped=reshape(H,[1,numel(H)]);
for i= 1: size(pos,2)
    SH(i)=H_reshaped(pos(i));% selected host
end




end

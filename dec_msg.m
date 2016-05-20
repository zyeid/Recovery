function [ PL_H,RF_H ] = dec_msg( H,pos,Nr,Np )

H_reshaped=reshape(H,[1,numel(H)]);

for i= 1: size(pos,2)
    SH(i)=H_reshaped(pos(i));% selected host
end

RF_H=SH(1:Nr);
PL_H=SH(1+Nr:Np+Nr);
end


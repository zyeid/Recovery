function [ H1 ] = re_msg( H,SH,pos )
%the host matrix (H) , (SH) the watermarked data and the position of each
%element (pos)

H_reshaped=reshape(H,[1,numel(H)]);
for i=1:size(pos,2)
    H_reshaped(pos(i))=SH(i);
end
H1=reshape(H_reshaped,[sqrt(numel(H_reshaped)), sqrt(numel(H_reshaped))]);
end


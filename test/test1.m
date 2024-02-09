
order = 5;
framelen = 7;

[B, G] = SavitzkyGolayFIR(order, framelen);

display(B);
display(G);

s = fliplr(vander(0.5*(1-framelen):0.5*(framelen-1)));
display(s);
S = s(:,framelen:-1:framelen-order);
display(S);

S = s(:,1:order);
display(S);
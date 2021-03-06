function Q = qmul2(A, B)
% multiply two arbitary quaternion u, v
% u = [w x y z]
% v = [a b c d]
% u*v = [wa-xb-yc-zd, wb+xa+yd+zc, wc-xd+ya-zb, wd+xc-yb+za]

%q = [u(1)*v(1)-dot(u(2:4),v(2:4)), u(1)*v(2:4)+v(1)*u(2:4)+cross(u(2:4),v(2:4))];

Q = cat(3, A(:,:,1).*B(:,:,1) - A(:,:,2).*B(:,:,2)- A(:,:,3).*B(:,:,3)- A(:,:,4).*B(:,:,4),...
           cat(3, A(:,:,1).*B(:,:,2),A(:,:,1).*B(:,:,3),A(:,:,1).*B(:,:,4)) + ...
           cat(3, B(:,:,1).*A(:,:,2),B(:,:,1).*A(:,:,3),B(:,:,1).*A(:,:,4)) + ...
           cross(A(:,:,2:4),B(:,:,2:4),3));

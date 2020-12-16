
function poly_interpolation
n = 5;
a = [-2 2];


close all


x = linspace(a(1), a(2), n+1)';
xp = linspace(a(1), a(2), 10*(n+1))';

f = @(x) 4*(x-1).*x.*(x+1).*exp(-x.^2);
% f = @(x) x.^2;
% f = @(x) abs(x);
% f = @(x) sin(40*x);

y1 = monomial(x, f);
% y2 = newton_basis2(x, f)
g = newton_basis1(x, f)

hold on
fplot(f, a)
plot(x, f(x), 'k.', 'MarkerSize', 10)
plot(xp, polyval(y1 ,xp), '--')
% plot(xp, polyval(y2 ,xp), '--')
fplot(g, a, '--')
hold off



end

function [y] = monomial(x, f)
% c_n, c_(n-1), ..., c_0
[m, ~] = size(x);
M = ones(m, 1);
for ii = 1:(m-1)
    M = [M x.^ii];
end
y = M\f(x);
y = flip(y);
end

function [p] = newton_basis1(x, f)
syms z
p = f(x(1));
q = 1;

for j = 2:length(x)
    syms z
    q = q*(z-x(j-1));
    z = x(j);
    c = (f(z) - subs(p))/subs(q);
    p = p + c*q;
end
p = matlabFunction(p);

end

function [y] = newton_basis2(x, f)
[n, ~] = size(x);
m = ones(n, 1);
M = [m];
for j = 1:(n-1)
    m = m.*(x-x(j));
    M = [M m];
end
y = M\f(x);
y = flip(y);


% % sum c_i*q_i
% for j = 1:n
%     m = m.*(x-x(j));
%     M = [M m];
% end

end

% lagrange interpolation

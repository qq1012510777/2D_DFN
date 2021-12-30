% TEST -- line intersection
%
% [E, lambda, gamma, isConvex] = lineIntersection(A,B,C,D)
%
% Given a line segment AB and another line segment CD, compute the point E
% where the lines intersect.
%
% INPUTS:
%   A = [2,n] = [Ax;Ay] = point in 2D space
%   B = [2,n] = [Bx;By] = point in 2D space
%   C = [2,n] = [Cx;Cy] = point in 2D space
%   D = [2,n] = [Dx;Dy] = point in 2D space
%
% OUTPUTS:
%   E = [2, n] = intersection of lines AB and CD
%   lambda = [1,n]
%       E = lambda*A + (1-lambda)*B
%   gamma = [1,n]
%       E = gamma*C + (1-gamma)*D
%   isConvex = is intersection on both lines?
%       isConvex = (0 <= lambda <= 1)  && (0 <= gamma <= 1)
%
% DERIVATION:
%   E1 = lambda*A + (1-lambda)*B
%   E2 = gamma*C + (1-gamma)*D
%   E1 == E2  --> linear system in [lambda; gamma] --> solve 
%
% IMPLEMENTATION:
%   F = B-D;
%   M = [(B-A), (C-D)]
%   Z = M\F;
%   lambda = Z(1);
%   gamma = Z(2);
%


% Construct a random set of lines and points
nRow = 3;
nCol = 4;
n = nRow*nCol;
A = rand(2,n);
B = rand(2,n);
C = rand(2,n);
D = rand(2,n);

% Compute the intersections:
[E, lambda, gamma, isConvex] = lineIntersection(A,B,C,D);

% Plot the solution:
figure(1); clf;
for i=1:nRow
    for j=1:nCol
        idx = nCol*(i-1) + j;
        subplot(nRow,nCol,idx); hold on;
        plot([A(1,idx), B(1,idx)],[A(2,idx), B(2,idx)],'k-','LineWidth',2);
        plot([C(1,idx), D(1,idx)],[C(2,idx), D(2,idx)],'k-','LineWidth',2);
        if isConvex(idx)
            plot(E(1,idx), E(2,idx),'rs','MarkerSize',10,'LineWidth',3);
        else
            plot(E(1,idx), E(2,idx),'go','MarkerSize',10,'LineWidth',3);
        end
        axis equal; axis([0,1,0,1]);
        title(['Test: ' num2str(idx)]);
        xlabel('x')
        ylabel('y')
        
    end
end



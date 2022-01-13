/* sequence comparisons.  How to change one sequence into another.
A=a_1 a_2 ... a_n
B=b_1 b_2 b_3 ... b_m
Change A into B using 3 operations:
    insert, delete, replace: each operation costs 1.
*/

 % c(N,M,C) if C is minimum cost of changing a_1...a_N into b_1...b_M
% :- table c/3.
%

start :- write('Please enter the length of the first string:'),read(X),
         write('Please enter the length of the first string:'), read(Y),
         c(X,Y,C,Edits),write('Minimum edit ditance cost: '), write(C), nl,
         write('Edits done: '),write(Edits).

c(0,0,Res,Edits) :- Res=0,(string(Edits) -> string_concat(Edits, "replace",Edits2),Edits=Edits2;Edits = "Replace").

c(0,M,Res,Edits) :- M > 0, Res=M,Edits=insert.             % must insert M items
c(N,0,N,Edits) :- N > 0,Edits=delete.              % must delete N items
c(N,M,C,Edits) :- N > 0, M > 0,

        N1 is N-1, M1 is M-1,

        c(N1,M,C1,Edits1), C1a is C1+1,       % insert into A
        c(N,M1,C2,Edits2), C2a is C2+1,    % delete from B
        c(N1,M1,C3,Edits3),                 % replace
         % if the variable B is equal to A,it means that they are currenty the same (COPY, no
         % cost) OR it has to be replaced (which has a cost of 1).
                a(N,A), b(M,B), (A==B
                                -> C3a=C3; C3a is C3+1),
                min(C1a,C2a,Cm1,Edits1,Edits2,Editscm1), min(Cm1,C3a,C,Editscm1,Edits3,Edits).       % take best of 3 ways

% if X is less than or equal to Y, then MIN is X. Otherwise, MIN is Y.
min(X,Y,Z,EditsX,EditsY,EditsZ) :- X =< Y -> Z=X,EditsZ=EditsX ; Z=Y,EditsZ=EditsY.

% example data
a(1,b). a(2,a). a(3,d).
b(1,b). b(2,c).
% to find min, c(7,7,Cost),

a(1,b). a(2,a).
b(1,d). b(2,c).
% to find min, c(7,7,Cost),

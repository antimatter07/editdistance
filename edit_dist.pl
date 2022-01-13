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

c(0,0,Res,Edits) :- Res=0, Edits = " ".
% must insert M items
c(0,M,Res,Edits) :- M > 0, Res=M,Edits = " ".
% must delete N items
c(N,0,N,Edits) :- N > 0, Edits = " ".
c(N,M,C,Edits) :- N > 0, M > 0,

        N1 is N-1, M1 is M-1,

        c(N1,M,C1,Edits1), C1a is C1+1, atom_concat(Edits1,"Delete!",Edits10),Edits100=Edits10,      % insert into A
        c(N,M1,C2,Edits2), C2a is C2+1,atom_concat(Edits2,"Insert!",Edits20),Edits200=Edits20,   % delete from B
        c(N1,M1,C3,Edits3),                 % replace
         % if the variable B is equal to A,it means that they are currenty the same (COPY, no
         % cost) OR it has to be replaced (which has a cost of 1).
                a(N,A), b(M,B), (A==B
                                -> C3a=C3, atom_concat(Edits3, "Copy!",Edits30),Edits300=Edits30;
                                   C3a is C3+1, atom_concat(Edits3, "Replace !",Edits30),Edits300=Edits30),
                min(C1a,C2a,Cm1,Edits100,Edits200,Editscm1), min(Cm1,C3a,C,Editscm1,Edits300,Edits).       % take best of 3 ways

% if X is less than or equal to Y, then MIN is X. Otherwise, MIN is Y.
min(X,Y,Z,EditsX,EditsY,EditsZ) :- X =< Y -> Z=X,EditsZ=EditsX ; Z=Y,EditsZ=EditsY.

% example data
a(1,a). a(2,b). a(3,c). a(4,d). a(5,e).

b(1,a). b(2,z).  b(3,c). b(4,e). b(5,e). b(6,d). b(7,a).

% to find min, c(7,7,Cost),

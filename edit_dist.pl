% ********************
% Name: Matthew James D. Villarica
% Language: Prolog
% Paradigm: Logic
% ********************
% Prolog Version: SWI Prolog 8.4.1
% -----------------------------------
% To compute for minimum edit distance, call the 'start' predicate as a
% query and enter required input.
%
% Before calling of start, please make sure you have entered and
% compiled string 1 and string 2 as facts in the knowledge base.
%------------------------------------------------------------------
% SAMPLE:
% To find edit distance of "ab" into "ac", declare these facts and
% compile:
% s1(1,a). s1(2,b).
% s2(1,a). s2(2,c).
% -----------------------------------------------------------------
%
% STRINGS AS FACTS IN KB:

s1(1,a). s1(2,b). s1(3,c).  s1(4,d). s1(5,e). s1(6,f).
s2(1,a). s2(2,z).  s2(3,c). s2(4,e). s2(5,d).

% recursive relation for displaying the words of string 1 and string 2.
displayS1(S1Index) :- s1(S1Index,CharReturned),Next is S1Index-1, displayS1(Next), write(CharReturned).
displayS1(S1Index) :- S1Index==0.

displayS2(S2Index) :- s2(S2Index,CharReturned),Next is S2Index-1, displayS2(Next), write(CharReturned).
displayS2(S2Index) :- S2Index==0.



% call this to compute and display edit distance
start :- write('Before proceeding, please make sure you have entered and compiled string 1 and string 2 properly.'),nl,
         write('Please enter the length of the first string:'),read(X),
         write('Please enter the length of the second string:'), read(Y),
         write('String 1: '),displayS1(X),nl,
         write('String 2: '),displayS2(Y),nl,
         edit_distance(X,Y,Cost,Edits),write('Minimum edit ditance cost: '), write(Cost), nl,
         write('Edits done: '),write(Edits).

% base cases (prevents index of s1 and s2 from going below 1)
edit_distance(0,0,Res,Edits) :- Res=0, Edits = " ".

edit_distance(0,S2Index,Res,Edits) :- S2Index > 0, Res=S2Index,Edits = " ".

edit_distance(S1Index,0,S1Index,Edits) :- S1Index > 0, Edits = " ".

% recursive case
edit_distance(S1Index,S2Index,FinalCost,Edits) :- S1Index > 0, S2Index > 0,

        % decrement index for both strings
        DecS1 is S1Index-1, DecS2 is S2Index-1,

        % simulate deletion of char at index S1Index
        edit_distance(DecS1,S2Index,Res1,Edits1), Cost1 is Res1+1, atom_concat(Edits1,"  Delete:",Edits10) ,
        s1(S1Index ,CharReturned),
        term_to_atom(CharReturned,EditsChar),
        atom_concat(Edits10,EditsChar,Edits101),Edits100=Edits101,

        % simulate inserting of char from index S2Index
        edit_distance(S1Index,DecS2,Res2,Edits2), Cost2 is Res2+1,atom_concat(Edits2,"  Insert:",Edits20),
        s2(S2Index,CharReturned2),
        term_to_atom(CharReturned2,EditsChar2),atom_concat(Edits20,EditsChar2,Edits202),
        Edits200=Edits202,

        % simulate copy and replacing (replace char at index S1Index with char at index S2Index, or copy)
        edit_distance(DecS1,DecS2,Res3,Edits3),
         % if the variable B is equal to A,it means that they are currenty the same (COPY, no
         % cost) OR it has to be replaced (which has s1 cost of 1).
                s1(S1Index,A), s2(S2Index,B), (A==B
                                -> Cost3=Res3,Edits300=Edits3;
                                   Cost3 is Res3+1,
                                   atom_concat(Edits3, "  Replace:",Edits30), s1(S1Index,CharReturned3),
                                   s2(S2Index,CharReturned3V2),
                                   term_to_atom(CharReturned3,EditsChar3),term_to_atom(CharReturned3V2,EditsChar3V2),
                                   atom_concat(Edits30,EditsChar3,InsertWithHere),
                                   atom_concat(InsertWithHere," with ",InsertCharToRepWith),
                                   atom_concat(InsertCharToRepWith,EditsChar3V2,EditsChar303),
                                   Edits300=EditsChar303),

         %get minimum of all 3, take that as the final cost or the next popped iteration of indices
         min(Cost1,Cost2,CostPH,Edits100,Edits200,EditsPH), min(CostPH,Cost3,FinalCost,EditsPH,Edits300,Edits).

% MINIMUM is assigned to Z and EditsZ
% if X is less than or equal to Y, then MIN is X. Otherwise, MIN is Y.
% Appropriate Edits that lead to MIN should be assigned as the MIN edit.
min(X,Y,Z,EditsX,EditsY,EditsZ) :- X =< Y -> Z=X,EditsZ=EditsX ; Z=Y,EditsZ=EditsY.

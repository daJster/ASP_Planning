% Define individuals
infirmier(1..5).
aide_soignant(1..6).


% Generate all possible combinations
3 { selected_infirmier_journee(I) : infirmier(I) } 5.
2 { selected_aide_soignant_journee(A) : aide_soignant(A) } 6.

1 { selected_infirmier_nuit(I) : infirmier(I) } 5.
2 { selected_aide_soignant_nuit(A) : aide_soignant(A) } 6.

% Check for the conditions for journee
:- #count {I : selected_infirmier_journee(I)} != 3, 
    #count {A : selected_aide_soignant_journee(A)} != 2.
:- #count {I : selected_infirmier_journee(I)} != 2, 
    #count {A : selected_aide_soignant_journee(A)} != 4.

% Check for the conditions for nuit
:- not #count {I : selected_infirmier_nuit(I)} >= 1.

% Check for the constraint of not having consecutive day and night shifts
:- selected_infirmier_journee(I1), selected_infirmier_nuit(I2), I1 = I2.
:- selected_aide_soignant_journee(A1), selected_aide_soignant_nuit(A2), A1 = A2.

% Show the selected individuals for nuit
#show selected_infirmier_nuit/1.
#show selected_aide_soignant_nuit/1.

% Show the selected individuals for journee
#show selected_infirmier_journee/1.
#show selected_aide_soignant_journee/1.
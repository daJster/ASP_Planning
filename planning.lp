% Define individuals
#const n_inf=10.
#const n_as=10.
#const n_d=2.
#const shift_hours=12.

infirmier(1..n_inf).
aide_soignant(1..n_as).
day(1..n_d).
week(1..4).

day_week(D, W) :- day(D), week(W), D = 1..n_d, W = (D-1) / 7 + 1. 

% Generate all possible combinations for each day   
2 { selected_infirmier_journee(I, D, W) : infirmier(I) } 3 :- day_week(D, W).
2 { selected_aide_soignant_journee(A, D, W) : aide_soignant(A) } 4 :- day_week(D, W).

1 { selected_infirmier_nuit(I, D, W) : infirmier(I) } 3 :- day_week(D, W).
2 { selected_aide_soignant_nuit(A, D, W) : aide_soignant(A) } 3 :- day_week(D, W).

% Check for the conditions for day shift
:- day_week(D, W), not 2 { selected_infirmier_journee(I, D, W) : infirmier(I) }, 
    not 2 {selected_aide_soignant_journee(A, D, W) : aide_soignant(A) }.

:- day_week(D, W), not 4 { selected_aide_soignant_journee(A, D, W) : aide_soignant(A) }, 
    not 3 { selected_infirmier_journee(I, D, W) : infirmier(I) }.

% Check for the conditions for night shift
:- day_week(D, W), not 1 { selected_infirmier_nuit(I, D, W) : infirmier(I) }, not 3 { selected_aide_soignant_nuit(A, D, W) : aide_soignant(A) }.

% Check for the constraint of not having consecutive day and night shifts
:- selected_infirmier_journee(I1, D, W), selected_infirmier_nuit(I2, D, W), day_week(D, W).
:- selected_aide_soignant_journee(A1, D, W), selected_aide_soignant_nuit(A2, D, W), day_week(D, W).

% Check for the constraint of not working more than 48 hours per week
:- infirmier(I), S1 = #count {D : selected_infirmier_journee(I, D, W)}, S2 = #count {D : selected_infirmier_nuit(I, D, W)}, S1 + S2 > shift_hours, week(W).
:- aide_soignant(A), S1 = #count {D : selected_aide_soignant_journee(A, D, W)}, S2 = #count {D : selected_aide_soignant_nuit(A, D, W)}, S1 + S2 > shift_hours, week(W).

% Display schedule for each day
#show selected_infirmier_journee/3.
#show selected_aide_soignant_journee/3.
#show selected_infirmier_nuit/3.
#show selected_aide_soignant_nuit/3.
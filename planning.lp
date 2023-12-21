% Define individuals
#const n_inf=7.
#const n_as=7.
#const n_d=28.
#const shift_limit=4.

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
:- day_week(D, W), not 2 { selected_infirmier_journee(I, D, W) : infirmier(I) } 2, 
    not 2 {selected_aide_soignant_journee(A, D, W) : aide_soignant(A) } 2.

:- day_week(D, W), not 4 { selected_aide_soignant_journee(A, D, W) : aide_soignant(A) } 4, 
    not 3 { selected_infirmier_journee(I, D, W) : infirmier(I) } 3.


% Check for the conditions for night shift
:- day_week(D, W), not 1 { selected_infirmier_nuit(I, D, W) : infirmier(I) } 3, not 1 { selected_aide_soignant_nuit(A, D, W) : aide_soignant(A) } 2.



% Check for the constraint of not having consecutive day and night shifts
:- selected_infirmier_journee(I, D, W), selected_infirmier_nuit(I, D, W), day_week(D, W).
:- selected_infirmier_nuit(I, D, W), selected_infirmier_journee(I, D+1, W), day_week(D, W).

:- selected_aide_soignant_journee(A, D, W), selected_aide_soignant_nuit(A, D, W), day_week(D, W).
:- selected_aide_soignant_nuit(A, D, W), selected_aide_soignant_journee(A, D+1, W), day_week(D, W).


% Check for the constraint of not working more than 48 hours per week
:- infirmier(I), week(W), S1 = #count {D : selected_infirmier_journee(I, D, W)}, S2 = #count {D : selected_infirmier_nuit(I, D, W)}, S1 + S2 > shift_limit.
:- aide_soignant(A), week(W), S1 = #count {D : selected_aide_soignant_journee(A, D, W)}, S2 = #count {D : selected_aide_soignant_nuit(A, D, W)}, S1 + S2 > shift_limit.

% Rest after 3 day shifts / 2 night shifts
:- selected_aide_soignant_nuit(A, D, W), selected_aide_soignant_nuit(A, D+1, W), selected_aide_soignant_nuit(A, D+2, W), day_week(D, W).
:- selected_aide_soignant_journee(A, D, W), selected_aide_soignant_journee(A, D+1, W), selected_aide_soignant_journee(A, D+2, W), selected_aide_soignant_journee(A, D+3, W), day_week(D, W).

:- selected_infirmier_nuit(A, D, W), selected_infirmier_nuit(A, D+1, W), selected_infirmier_nuit(A, D+2, W), day_week(D, W).
:- selected_infirmier_journee(A, D, W), selected_infirmier_journee(A, D+1, W), selected_infirmier_journee(A, D+2, W), selected_infirmier_journee(A, D+3, W), day_week(D, W).




% Display schedule for each day
#show selected_infirmier_journee/3.
#show selected_aide_soignant_journee/3.
#show selected_infirmier_nuit/3.
#show selected_aide_soignant_nuit/3.
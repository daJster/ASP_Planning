# ASP_Planning: Hospital Schedule

## Solver
The file `planning.lp` contains the variables and constraints for generating the hospital schedule for a month.
`n_d` is the number of days to plan, `n_inf` and `n_as` are the numbers of nurses (_infirmiers_) and nursing assistants (_aide_soignants_) respectively.
The monthly salary is €3500 for nurses and €2500 for nursing assistants.

### Constraints:
1. Generate all possible combinations for each 24 hours.
2. Check conditions for the day shift (2 nurses and 4 nursing assistants OR 3 nurses and 2 nursing assistants).
3. Check conditions for the night shift (3 workers, one of them is a nurse).
4. Avoid consecutive day and night shifts.
5. Limit working hours to not exceed 48 hours per week.
6. Ensure rest after 3 day shifts OR 2 night shifts.

Execute the solver with the following command:
```bash
clingo planning.lp
```


## Execution
For better visualization, the Python script `planning.py` generates a Gantt chart schedule for each worker, displaying day and night shifts for each day of the week.
Run the script with the command:
```bash
python3 planning.py
```

The Gantt chart will be saved as a PNG file.

## Critics
The generated Gantt chart reveals that some workers exceed 4 shifts in a span of 7 days. This issue arises because the span may cross two different weeks, indicating a flaw in the model.
If this constraint is revised, it may require additional workers to satisfy the constraints properly.
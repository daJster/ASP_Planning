import re
import subprocess

def generate_planning(text):
    planning = {}
    lines = text.split(' ')

    for line in lines:
        if line.strip():
            parts = line.split('(')
            worker_type, indices = parts[0].strip(), parts[1].split(')')[0].split(',')
            worker_id, day, week = int(indices[0]), int(indices[1]), int(indices[2])

            if worker_type not in planning:
                planning[worker_type] = {}

            if day not in planning[worker_type]:
                planning[worker_type][day] = {}
                
            if week not in planning[worker_type][day]:
                planning[worker_type][day][week] = []
                
            planning[worker_type][day][week].append(worker_id)
    return planning


def read_file(file_path):
    with open(file_path, 'r') as file:
        text = file.read()
    return text

def run_clingo(lp_file_path, planning_file_path):
    clingo_command = f"clingo {lp_file_path} > {planning_file_path}"
    subprocess.run(clingo_command, shell=True)

def main():
    planning_file_path, lp_file_path = 'planning.txt', 'planning.lp'
    run_clingo(lp_file_path, planning_file_path)

    text = read_file(planning_file_path)
    match = re.search(r"Answer: 1\n(.+?)SATISFIABLE", text, re.DOTALL)
    planning_text = match.group(1).strip()
    planning = generate_planning(planning_text)

    for worker_type, shifts in planning.items():
        print(f"x {worker_type}:")
        for day, workers in shifts.items():
            for week, workers_ in workers.items():
                print(f"x Week {week}, Day {day}: {workers_}")

if __name__ == "__main__":
    main()

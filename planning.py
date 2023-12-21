import re
import subprocess
import matplotlib.pyplot as plt
import seaborn as sns
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

def run_clingo(lp_file_path):
    clingo_command = f"clingo {lp_file_path}"
    try:
        result = subprocess.run(clingo_command, shell=True, check=True, text=True, capture_output=True)
        output = result.stdout
        return output
    except subprocess.CalledProcessError as e:
        print(f"Error running clingo: {e}")
        return None
    
    
def plot_gantt_chart(data):
    worker_names = ["infirmier", "aide_soignant"]
    shift_types = ["journee", "nuit"]
    
    sns.set_style("whitegrid")
    fig, ax = plt.subplots(figsize=(12, 8))
    
    ax.set_yticks(range(1, 2*7 + 1))
    y_tick_labels = []
 
    for i, (worker_type, shifts) in enumerate(data.items()):
        worker_name, worker_shift = "_".join(worker_type.split("_")[1:-1]), worker_type.split("_")[-1]
        for day, workers in shifts.items():
            for week, workers_ in workers.items():
                for worker in workers_:
                    
                    if worker_shift == shift_types[0]:
                        color_cycle_1 = ["#709eaa", "#985091"]
                        selected_color = color_cycle_1[worker_names.index(worker_name)]
                        ax.barh(worker + worker_names.index(worker_name)*7, 0.7, left=day, color=selected_color, edgecolor='black', label=worker_shift)
                    else :  
                        color_cycle_2 = ["#709eee", "#c83591"]
                        selected_color = color_cycle_2[worker_names.index(worker_name)]
                        ax.barh(worker + worker_names.index(worker_name)*7, 0.7, left=day, color=selected_color, edgecolor='black', label=worker_shift)
                        
    
                    tick_worker_name = f"{' '.join(worker_name.split('_'))} {worker}"
                    if tick_worker_name not in y_tick_labels:
                        y_tick_labels.append(tick_worker_name)
                            

    
    ax.set_yticklabels(y_tick_labels)
    ax.set_xlabel('Day')
    ax.set_title('Schedule for hospital workers')
    ax.set_xticks(range(1, len(data['selected_infirmier_journee']) + 1))
    ax.set_xticklabels([f'{i}' for i in range(1, len(data['selected_infirmier_journee']) + 1)])
    # Adding legend with the saved labels
    ax.legend([plt.Rectangle((0, 0), 1, 1, fc=color) for color in ["#709eaa", "#709eee", "#985091", "#c83591"]],
              shift_types + shift_types, title='Shifts', bbox_to_anchor=(1, 1))
    

    plt.savefig("planning_gantt.png")
    plt.close()

    
def main():
    lp_file_path = 'planning.lp'
    output_text = run_clingo(lp_file_path)

    match = re.search(r"Answer: 1\n(.+?)SATISFIABLE", output_text, re.DOTALL)
    planning_text = match.group(1).strip()
    planning = generate_planning(planning_text)
    current_week = None

    for worker_type, shifts in planning.items():
        print(f"x {worker_type}:")
        for day, workers in shifts.items():
            for week, workers_ in workers.items():
                if week != current_week:
                    print(f"x Week {week}:")
                    current_week = week
                print(f"       x Day {day}: {workers_}")


    plot_gantt_chart(planning)
if __name__ == "__main__":
    main()

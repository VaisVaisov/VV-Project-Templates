import tracemalloc
import sys
import os

sys.path.append(os.path.join(os.path.dirname(os.path.abspath(__file__)), "../../python"))
from main import run_main


def profile():
    output_dir = os.path.join(os.path.dirname(os.path.abspath(__file__)), "../../profiles")
    os.makedirs(output_dir, exist_ok=True)

    tracemalloc.start()
    run_main()
    snapshot = tracemalloc.take_snapshot()
    stats = snapshot.statistics("lineno")

    output_file = os.path.join(output_dir, "memory_stats.txt")
    with open(output_file, "w") as f:
        for stat in stats:
            f.write(str(stat) + "\n")

    print("=== Top 10 memory allocations ===")
    for stat in stats[:10]:
        print(stat)
    print(f"\nSaved: {output_file}")


if __name__ == "__main__":
    profile()

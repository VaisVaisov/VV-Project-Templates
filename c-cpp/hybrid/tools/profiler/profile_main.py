import cProfile
import pstats
import sys
import os

sys.path.append(os.path.join(os.path.dirname(os.path.abspath(__file__)), "../../python"))
from main import run_main


def profile():
    output_dir = os.path.join(os.path.dirname(os.path.abspath(__file__)), "../../profiles")
    os.makedirs(output_dir, exist_ok=True)

    profiler = cProfile.Profile()
    profiler.enable()
    run_main()
    profiler.disable()

    stats_file = os.path.join(output_dir, "profile_stats.txt")
    prof_file = os.path.join(output_dir, "profile.prof")

    with open(stats_file, "w") as f:
        ps = pstats.Stats(profiler, stream=f)
        ps.sort_stats("cumulative")
        ps.print_stats()

    profiler.dump_stats(prof_file)
    print(f"Saved: {prof_file} — visualize: snakeviz {prof_file}")


if __name__ == "__main__":
    profile()

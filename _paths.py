import sys
import os
from pathlib import Path
sys.path.insert(0, os.path.dirname(__file__))


PATH_ROOT = Path(__file__).parent
INPUT_PATH = Path(PATH_ROOT/'input/')
OUTPUT_PATH = Path(PATH_ROOT/'output/')

if not OUTPUT_PATH:
    os.mkdir(OUTPUT_PATH)


if __name__ == '__main__':
    print(INPUT_PATH)

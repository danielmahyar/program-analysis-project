import sys
from pathlib import Path

# Also allow the standalone solution tests to run from the repository's venv.
sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "src"))

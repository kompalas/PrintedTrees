# PrintedTrees: Approximate Decision Tree Classifiers for Printed Electronics

**PrintedTrees** is a framework for **hardware-aware optimization of Decision Tree (DT) classifiers** targeting **tiny printed circuits**.  
It uses a **genetic algorithm with NSGA-II** to jointly minimize **comparator count (area)** and maintain classification accuracy.  
The framework integrates the **EGFET PDK** for synthesis and full hardware evaluation of approximate DTs.

---

## 🔧 Key Features

- 🌳 **Approximate Decision Trees**  
  Optimizes DT thresholds for hardware-friendly, low-cost implementations.

- ⚙️ **Multi-Objective Genetic Optimization**  
  Uses NSGA-II to explore accuracy vs. comparator/area trade-offs.

- 🖨️ **Printed Electronics Integration**  
  Leverages EGFET PDK and hardware libraries for realistic evaluation.

- 🛠️ **RTL-Level Hardware Designs**  
  Auto-generates synthesizable Verilog stored in `rtl/` for each optimized tree.

---

## 📦 Technologies Used

- Python 3  
- NSGA-II (evolutionary optimization)  
- EGFET PDK and printed electronics libraries  
- Verilog RTL design and evaluation  
- Virtual environment (`venv`) for reproducible setup  

---

## ⚙️ Installation

Create and activate a Python virtual environment, then install dependencies:

```bash
# Clone the repository
git clone https://github.com/your-username/printedtrees.git
cd printedtrees

# Create and activate virtual environment
python3 -m venv venv
source venv/bin/activate  # For Linux/Mac
# On Windows: venv\Scripts\activate

# Install dependencies
pip install -r requirements.txt
python setup.py install
```

## 🚀 Usage

Run optimization with command-line arguments:
```bash
python main.py -h
```
Optimized RTL implementations are saved in the rtl/ folder for synthesis and evaluation.

## 📚 Citation
If you use this work, please cite:
```bibtex
@inproceedings{balaskas2022approximate,
  title={Approximate decision trees for machine learning classification on tiny printed circuits},
  author={Balaskas, Konstantinos and Zervakis, Georgios and Siozios, Kostas and Tahoori, Mehdi B and Henkel, J{\"o}rg},
  booktitle={2022 23rd International Symposium on Quality Electronic Design (ISQED)},
  pages={1--6},
  year={2022},
  organization={IEEE}
}
```

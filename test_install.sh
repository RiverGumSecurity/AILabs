#!/bin/bash

set -e
cat <<__EOF__

======================================================================
 This shell script uses CONDA to install all required AI development
 packages. You must have already created and activated your
 conda environment using:

	conda create -n ai python=3.10
	conda activate ai

 BEFORE using this script.  Press CTRL-C to cancel to ENTER to continue.

 Author: Joff Thyer and Derek Banks (c) 2024

======================================================================

-< Press ENTER to Continue or CTRL-C to QUIT >-

__EOF__
read
if [[ `uname -r` == *"WSL2"* ]]; then

	echo "[*] ##############################################"
	echo "[*] ## Target System is WSL2: using PIP method. ##"
	echo "[*] ##############################################"

	echo "[+] Installing GCC using apt"
	sudo apt -y install gcc >/dev/null 2>&1

	echo "[+] Installing: cudatoolkit for WSL2"
	conda install -yq cudatoolkit >/dev/null 2>&1

	echo "[+] Installing: jupyter"
	pip install -q jupyter >/dev/null 2>&1

	echo "[+] Installing: pandas, numpy, matplotlib"
	pip install -q pandas numpy matplotlib >/dev/null 2>&1
	echo "[+] Installing: nltk, seaborn, plotly"
	pip install -q nltk seaborn plotly >/dev/null 2>&1
	echo "[+] Installing: scikit-learn"
	pip install -q scikit-learn >/dev/null 2>&1

	echo "[+] Installing: tensorflow[and-cuda] for WSL2"
	pip install -q tensorflow[and-cuda] >/dev/null 2>&1

	echo "[+] Installing: unsloth"
	pip install -q --upgrade unsloth >/dev/null 2>&1
	echo "[+] Upgrading: unsloth"
	pip install --no-warn-conflicts git+https://github.com/huggingface/transformers.git git+https://github.com/huggingface/trl.git >/dev/null 2>&1


else

	echo "[*] #######################################################"
	echo "[*] ## Target System UNIX/MacOS/BSD: using conda method. ##"
	echo "[*] #######################################################"
	echo "[+] Installing: jupyter"
	conda install -yq jupyter >/dev/null 2>&1
	echo "[+] Installing: huggingface_hub, transformers, pytorch"
	conda install -yq huggingface_hub transformers pytorch >/dev/null 2>&1
	echo "[+] Installing: pandas, numpy, matplotlib"
	conda install -yq pandas numpy matplotlib >/dev/null 2>&1
	echo "[+] Installing: nltk, seaborn, plotly"
	conda install -yq nltk seaborn plotly >/dev/null 2>&1
	echo "[+] Installing: scikit-learn"
	conda install -yq scikit-learn >/dev/null 2>&1
	echo "[+] Installing: tensorflow"
	conda install -yq tensorflow >/dev/null 2>&1

fi
echo ""
echo "#############################################"
echo "### Successfully Completed Installations! ###"
echo "#############################################"

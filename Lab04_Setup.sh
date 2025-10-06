if [[ "${BASH_SOURCE[0]}" = "${0}" ]]; then
    echo "You must run this script using 'source ${0}'"
    exit 1
fi
LAB="lab04"
LDIR="./Lab04_Log_Alert_Summarization"
conda deactivate
`conda env list | grep -q $LAB` && (echo "Removing Existing $LAB conda env" && conda env remove -q --yes -n $LAB)
conda create --yes -n $LAB python=3.13
conda activate $LAB
pip install --upgrade poetry
cd $LDIR
poetry install --no-root
git clone https://github.com/RiverGumSecurity/AILabTools
cd AILabTools
echo "########################################################"
echo " $LAB Setup is complete."
echo " More instructions in this directory from here. "
echo "########################################################"

if [[ "${BASH_SOURCE[0]}" = "${0}" ]]; then
    echo "You must run this script using 'source ${0}'"
    exit 1
fi
LAB="lab22"
LDIR="./022_LargeLanguageModels"
conda deactivate
`conda env list | grep -q $LAB` && (echo "Removing Existing $LAB16 conda env" && conda env remove -q --yes -n $LAB)
conda create -n lab22 \
    python=3.11 \
    pytorch-cuda=12.1 \
    pytorch cudatoolkit xformers -c pytorch -c nvidia -c xformers \
    -y
conda activate lab22
pip install unsloth
pip install jupyter
cd $LDIR
echo "########################################################"
echo " $LAB Setup is complete."
echo " Start jupyter-notebook to proceed"
echo "########################################################"

if [[ "${BASH_SOURCE[0]}" = "${0}" ]]; then
    echo "You must run this script using 'source ${0}'"
    exit 1
fi
LAB="lab01"
LDIR="./Lab01_PhishingDetectionModel"
conda deactivate
rm -f $LDIR/poetry.lock
`conda env list | grep -q $LAB` && (echo "Removing Existing $LAB conda env" && conda env remove -q --yes -n $LAB)
conda create --yes -n $LAB python=3.12
conda activate $LAB
pip install --upgrade poetry
cd $LDIR
poetry install --no-root
echo "########################################################"
echo " $LAB Setup is complete."
echo " Start jupyter-notebook to proceed"
echo "########################################################"

FROM jupyter/minimal-notebook:2c80cf3537ca

LABEL maintainer="Emir Turkes eturkes@bu.edu"

# No need for root
USER $NB_USER

# Install Anaconda into a new conda environment
# Remove conda-forge for pure upstream Anaconda
RUN conda config --system --remove channels conda-forge \
    && conda create -yq -n pymice Python=3.5 Anaconda

# Install PyMICE into newly created conda environment
# Conda does not support sh, so use bash
RUN /bin/bash -c "source activate pymice \
    && pip install -q --exists-action w PyMICE \
    && source deactivate"

# Configure notebooks to strip output before saving to improve version control
RUN mkdir /home/$NB_USER/.jupyter
COPY jupyter_notebook_config.py /home/$NB_USER/.jupyter/
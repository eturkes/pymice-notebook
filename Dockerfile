FROM jupyter/minimal-notebook:2c80cf3537ca

LABEL maintainer="Emir Turkes eturkes@bu.edu"

# Run unprivalaged
# Variable, referring to configured user "jovyan", is derived from base image
USER $NB_USER

# Install Anaconda into a new conda environment
# Remove conda-forge for pure upstream Anaconda
RUN conda config --system --remove channels conda-forge \
    && conda create -yq -n PyMICE Python=3.5.4 Anaconda

# Install PyMICE into newly created conda environment
# Conda does not support sh, so use bash
RUN /bin/bash -c "source activate PyMICE \
    && pip install -q --exists-action w PyMICE \
    && source deactivate"

# Configure notebooks to strip output before saving to improve version control
RUN mkdir /home/$NB_USER/.jupyter
COPY jupyter_notebook_config.py /home/$NB_USER/.jupyter/

# Ensure container does not run as root
USER $NB_USER

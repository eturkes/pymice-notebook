#    This file is part of pymice-notebook.
#    Copyright (C) 2018  Emir Turkes
#
#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
#    Emir Turkes can be contacted at eturkes@bu.edu

FROM jupyter/minimal-notebook:177037d09156

LABEL maintainer="Emir Turkes eturkes@bu.edu"

# Run unprivalaged
# Variable, referring to configured user "jovyan", is derived from base image
USER $NB_USER

# Install Anaconda into a new conda environment
# Remove conda-forge for pure upstream Anaconda
RUN conda config --system --remove channels conda-forge \
    && conda create -yq -n PyMICE python=3.6.6 anaconda

# Install PyMICE into newly created conda environment
# Conda does not support sh, so use bash
RUN /bin/bash -c "source activate PyMICE \
    && pip install -q --exists-action w PyMICE \
    && source deactivate"

# Configure notebooks to strip output before saving to improve version control
COPY jupyter_notebook_config.py /home/$NB_USER/.jupyter/

# Ensure container does not run as root
USER $NB_USER

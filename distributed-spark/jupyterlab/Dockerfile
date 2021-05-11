FROM base

EXPOSE 8888

# # -- Layer: Notebooks and data
# ADD workspace/ ${SHARED_WORKSPACE}/

WORKDIR /tmp
# Install Required Python Packages
COPY requirements.txt requirements.txt
RUN apt-get update -y && \
    apt-get install -y python3-pip python3-dev && \
    pip3 install --upgrade pip && \
    pip3 install -r requirements.txt && \
    jupyter lab clean

WORKDIR ${SHARED_WORKSPACE}
CMD jupyter lab --ip=0.0.0.0 --port=8888 --no-browser --allow-root --NotebookApp.token=
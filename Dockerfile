FROM kbase/sdkbase2:python
MAINTAINER KBase Developer
# -----------------------------------------
# In this section, you can install any system dependencies required
# to run your App.  For instance, you could place an apt-get update or
# install line here, a git checkout to download code, or run any other
# installation scripts.

ENV PATH=/miniconda/bin:${PATH}

# Install system dependencies
RUN apt-get update && apt-get install -y automake build-essential bzip2 wget git default-jre unzip

RUN conda install -y conda-build
RUN conda install -y -c conda-forge -c bioconda hdf5 pytables pypandoc biopython networkx numpy pandas scipy \
scikit-learn psutil pyparsing mcl blast prodigal

RUN wget http://github.com/bbuchfink/diamond/releases/download/v0.9.36/diamond-linux64.tar.gz && tar xzf diamond-linux64.tar.gz
RUN chmod +x diamond && cp diamond /usr/local/bin/

RUN pip install jsonrpcbase pandas nose jinja2 setuptools-markdown configparser

RUN git clone https://bitbucket.org/MAVERICLab/vcontact2.git && cd vcontact2 && pip install .

RUN cp /vcontact2/vcontact2/data/ViralRefSeq-* /miniconda/lib/python3.7/site-packages/vcontact2/data/

RUN wget -O /usr/local/bin/cluster_one-1.0.jar http://paccanarolab.org/static_content/clusterone/cluster_one-1.0.jar
RUN chmod +x /usr/local/bin/cluster_one-1.0.jar

# Clean stuff up to reduce disk space
RUN apt-get clean && conda build purge-all

# -----------------------------------------

COPY ./ /kb/module
RUN mkdir -p /kb/module/work
RUN chmod -R a+rw /kb/module

WORKDIR /kb/module

RUN make all

ENTRYPOINT [ "./scripts/entrypoint.sh" ]

CMD [ ]

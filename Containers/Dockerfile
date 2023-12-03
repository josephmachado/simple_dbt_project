FROM python:3.12.0

# Set pythonpath
ENV PYTHONPATH=/opt/sde
ENV WORKDIR=/opt/sde

# install python requirements
COPY requirements.txt requirements.txt
RUN pip install -r requirements.txt

# keep our docker container running
CMD ["tail", "-f", "/dev/null"]
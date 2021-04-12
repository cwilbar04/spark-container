FROM python:3.8-slim-buster
WORKDIR /webapp
ADD requirements.txt requirements.txt
RUN pip3 install -r requirements.txt
COPY . .
ENTRYPOINT [ "python3" ]
CMD [ "app.py" ]
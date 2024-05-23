FROM python:3.9-slim

WORKDIR /app

COPY requirements.txt /app/
RUN pip install --no-cache-dir -r requirements.txt
RUN pip install requests
COPY . /app

RUN apt-get update && apt-get install -y curl unzip wget

COPY download_gdrive.sh /app/download_gdrive.sh
COPY download_google_drive.py /app/download_google_drive.py

RUN chmod +x /app/download_gdrive.sh

RUN mkdir -p GloVe/glove.6b/ models/ pke/

RUN /app/download_gdrive.sh '1sMDg9foTQpLkcajpEshLkYaibbu5jgwN' 'GloVe/glove.6b/glove.6B.100d.txt'
RUN /app/download_gdrive.sh '16m9DtnT68aF-9rsaZeVGj5916U8qHoHw' 'models/epoch=33.ckpt'

RUN ls -lh models/epoch=33.ckpt && head -n 10 models/epoch=33.ckpt

RUN mv PKE/* pke/

EXPOSE 5551

CMD ["python", "app.py"]

# Use an official Python runtime as a parent image
FROM python:3.9-slim

# Set the working directory in the container
WORKDIR /app

# Copy the requirements file into the container at /app
COPY requirements.txt /app/

# Install any needed packages specified in requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# Install additional required packages for downloading files
RUN apt-get update && apt-get install -y wget unzip && apt-get clean

# Create necessary directories
RUN mkdir -p GloVe/glove.6b/ models/ pke/

# Download the large files from Google Drive and place them in the correct directories
RUN wget --no-check-certificate 'https://docs.google.com/uc?export=download&id=1sMDg9foTQpLkcajpEshLkYaibbu5jgwN' -O glove.6B.zip && \
    unzip glove.6B.zip -d GloVe/glove.6b/ && \
    rm glove.6B.zip

RUN wget --no-check-certificate 'https://docs.google.com/uc?export=download&id=16m9DtnT68aF-9rsaZeVGj5916U8qHoHw' -O models.zip && \
    unzip models.zip -d models/ && \
    rm models.zip

# Copy the current directory contents into the container at /app
COPY . /app

# Move the contents of PKE folder to pke folder
RUN cp -r PKE/* pke/ 

# Make port 5551 available to the world outside this container
EXPOSE 5551

# Run app.py when the container launches
CMD ["python", "app.py"]


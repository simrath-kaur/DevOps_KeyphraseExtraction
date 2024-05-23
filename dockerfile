# Use an official Python runtime as a parent image
FROM python:3.9-slim

# Set the working directory in the container
WORKDIR /app

# Copy the requirements file into the container at /app
COPY requirements.txt /app/

# Install any needed packages specified in requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# Install gdown
RUN pip install gdown

# Install additional tools
RUN apt-get update && apt-get install -y unzip

# Copy the current directory contents into the container at /app
COPY . /app

# Create necessary directories
RUN mkdir -p GloVe/glove.6b/ models/ pke/

# Download large files from Google Drive using gdown
# GloVe file
RUN gdown --id 1sMDg9foTQpLkcajpEshLkYaibbu5jgwN -O GloVe/glove.6b/glove.6B.100d.txt

# Model file
RUN gdown --id 16m9DtnT68aF-9rsaZeVGj5916U8qHoHw -O models/epoch=3.ckpt

# Verify the integrity of the downloaded model file
RUN ls -lh models/epoch=3.ckpt && head -n 10 models/epoch=3.ckpt

# Move contents of PKE folder to pke folder
RUN mv PKE/* pke/

# Make port 5551 available to the world outside this container
EXPOSE 5551

# Run app.py when the container launches
CMD ["python", "app.py"]

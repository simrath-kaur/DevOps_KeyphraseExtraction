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

# Copy the manually downloaded files from the Jenkins workspace to the Docker image
COPY GloVe/glove.6b/glove.6B.100d.txt GloVe/glove.6b/glove.6B.100d.txt
COPY models/epoch=3.ckpt models/epoch=3.ckpt

# Copy the current directory contents into the container at /app
COPY . /app

# Move the contents of PKE folder to pke folder
RUN cp -r PKE/* pke/

# Make port 5551 available to the world outside this container
EXPOSE 5551

# Run app.py when the container launches
CMD ["python", "app.py"]

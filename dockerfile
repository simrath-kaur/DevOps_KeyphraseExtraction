FROM python:3.9-slim

# Set the working directory in the container
WORKDIR /app

# Copy the requirements file into the container at /app
COPY requirements.txt /app/

# Install any needed packages specified in requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# Create necessary directories
RUN mkdir -p GloVe/glove.6b/ models/ pke/

# Copy the manually downloaded GloVe file into the container
COPY /home/simrath/KeyphraseExtraction/GloVe/glove.6B/glove.6B.100d.txt GloVe/glove.6b/glove.6B.100d.txt

# Copy the manually downloaded model file into the container
COPY /home/simrath/KeyphraseExtraction/models/epoch=3.ckpt models/epoch=3.ckpt

# Copy the current directory contents into the container at /app
COPY . /app

# Move the contents of PKE folder to pke folder
RUN cp -r PKE/* pke/ 

# Make port 5551 available to the world outside this container
EXPOSE 5551

# Run app.py when the container launches
CMD ["python", "app.py"]

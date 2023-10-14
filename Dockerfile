FROM python:3.9

# Set environment variables
ENV BENTOML_HOME="/bentoml"
ENV BENTOML_SERVER_PORT=3000

# Create a directory for your BentoML service
WORKDIR $BENTOML_HOME

# Copy your BentoML service bundle to the image
COPY . $BENTOML_HOME

# Install BentoML and other required dependencies
RUN pip install bentoml
RUN pip install -r requirements.txt  # Replace with the actual requirements file
 

RUN python download_model.py

CMD ["bentoml", "serve"]
 

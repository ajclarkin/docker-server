# Sample Flask Application

This is the most basic example you could find. There is:
* Dockerfile to build the initial image
* docker-compose to bring the image up and down
* gunicorn.sh which loads the server required rather than using the built-in development server
* app.py which is a test *hello world* app


The main folder contains the config files only. All flask files should go in the flask/ subdirectory.

In this example the site is being served on 8010 and a volume is being mounted to the docker container rather than
copying the source files into the container.

Remember the correct permissions for gunicorn.sh - it needs to be executable.

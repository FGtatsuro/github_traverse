# FYI:
# - https://docs.docker.com/engine/reference/builder/
# - https://docs.docker.com/develop/develop-images/dockerfile_best-practices/
# - https://hub.docker.com/_/python/
# FYI: https://github.com/GoogleCloudPlatform/python-docs-samples/blob/master/container_engine/django_tutorial/Dockerfile
FROM gcr.io/google_appengine/python:latest

# Backward compatibility with deprecate onbuild image.
# FYI: https://github.com/docker-library/python/pull/314/files#diff-7531449f9a1a85f134eba7d960a91c91L1
RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

COPY requirements.txt /usr/src/app/
# NOTE: asia.gcr.io/google_appengine/python:latest includes both python2 and python3.
# To use python3, we must use python3/pip3 instead of python/pip.
RUN pip3 install --no-cache-dir -r requirements.txt -U pip setuptools wheel
COPY . /usr/src/app

ENTRYPOINT ["gunicorn"]
CMD ["--paste", "development.ini", "--bind", "0.0.0.0:6543"]

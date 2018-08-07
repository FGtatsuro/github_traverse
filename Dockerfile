# FYI:
# - https://docs.docker.com/engine/reference/builder/
# - https://docs.docker.com/develop/develop-images/dockerfile_best-practices/
# - https://hub.docker.com/_/python/
FROM python:3.7

# Backward compatibility with deprecate onbuild image.
# FYI: https://github.com/docker-library/python/pull/314/files#diff-7531449f9a1a85f134eba7d960a91c91L1
RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

COPY requirements.txt /usr/src/app/
RUN pip install --no-cache-dir -r requirements.txt
COPY . /usr/src/app

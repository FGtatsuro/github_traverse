from setuptools import setup, find_packages
from pathlib import Path


# FYI: https://packaging.python.org/guides/making-a-pypi-friendly-readme/
with open(Path(__file__).parent.resolve()/'README.md') as f:
    readme = f.read()

# Ref: 
#    https://packaging.python.org/guides/distributing-packages-using-setuptools/
#    https://setuptools.readthedocs.io/en/latest/setuptools.html
# FYI: 
#    https://github.com/pypa/sampleproject/blob/master/setup.py
#    https://github.com/Pylons/pyramid-cookiecutter-starter/blob/latest/%7B%7Bcookiecutter.repo_name%7D%7D/setup.py
setup(
    name='github_traverse',
    version='0.1.0',
    description='A web application to collect issues/PRs from multiple Github repositories on one place.',

    # FYI: https://packaging.python.org/guides/making-a-pypi-friendly-readme/
    long_description=readme,
    long_description_content_type='text/markdown',

    url='https://github.com/FGtatsuro/github_traverse',
    author='FGtatsuro',

    # Ref: https://pypi.org/classifiers
    classifiers=[
        'Programming Language :: Python :: 3 :: Only'
        'License :: OSI Approved :: MIT License',
        'Topic :: Internet :: WWW/HTTP',
        'Topic :: Internet :: WWW/HTTP :: WSGI :: Application',
    ],
    keywords='web pyramid',

    packages=find_packages(),
    include_package_data=True,

    install_requires=[
        'pyramid',
        'gunicorn'
    ],
    python_requires='>=3',
)

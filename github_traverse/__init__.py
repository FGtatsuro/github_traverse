from wsgiref.simple_server import make_server
from pyramid.config import Configurator
from pyramid.response import Response


def hello_world(request):
    return Response('<h1>Hello World!</h1>')


def json(request):
    return Response(json={'key': 'value'})


def main(global_config=None, **settings):
    config = Configurator(settings=settings)

    config.add_route('hello', '/')
    config.add_view(hello_world, route_name='hello')

    config.add_route('json', '/json/')
    config.add_view(json, route_name='json')

    # FYI: https://docs.pylonsproject.org/projects/pyramid/en/latest/narr/urldispatch.html#redirecting-to-slash-appended-routes
    config.add_notfound_view(append_slash=True)
    return config.make_wsgi_app()

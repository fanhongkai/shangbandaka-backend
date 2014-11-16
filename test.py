from bottle import route, run
import web
@route('/')
def index(name='World'):
    session=web.request.environ["myNameisAnlim"]
    return '<b>Hello World{name}!</b>',session

run(host='localhost', port=8080)

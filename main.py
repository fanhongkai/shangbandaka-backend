#-*-coding:utf-8;-*-
#qpy:webapp:上班打卡
#qpy://127.0.0.1:8080/
"""
上班打卡网站
    网站分为几个部分
        1) 产品介绍页面
        2) 后台管理
        3) 与APP的API接口
"""
import os
from bottle import Bottle, ServerAdapter
from bottle import run, debug, route, error, static_file, template,request,response
from json import dumps

root = os.path.dirname(os.path.abspath(__file__))

######### QPYTHON WEB SERVER ###############

class MyWSGIRefServer(ServerAdapter):
    server = None

    def run(self, handler):
        from wsgiref.simple_server import make_server, WSGIRequestHandler
        if self.quiet:
            class QuietHandler(WSGIRequestHandler):
                def log_request(*args, **kw): pass
            self.options['handler_class'] = QuietHandler
        self.server = make_server(self.host, self.port, handler, **self.options)
        self.server.serve_forever()

    def stop(self):
        #sys.stderr.close()
        import threading 
        threading.Thread(target=self.server.shutdown).start() 
        #self.server.shutdown()
        self.server.server_close() #<--- alternative but causes bad fd exception
        print "# qpyhttpd stop"


######### BUILT-IN ROUTERS ###############
@route('/__exit', method=['GET','HEAD'])
def __exit():
    global server
    server.stop()

@route('/__ping')
def __ping():
    return "ok"


@route('/assets/<filepath:path>')
def server_static(filepath):
    return static_file(filepath, root=root+"/assets")


######### WEBAPP ROUTERS ###############
@route('/')
def home():
    """
    开发模式，展示网站部分的3个模块的入口
    """
    return template("""<h1>关于 - {{name}}</h1>
<p>{{name}}是NANNING GDG的River同学牵头的一个小项目，它的目标是让你了解移动APP产品开发的流程。
<br />您当前处于开发模式，本项目的代码位于<a href="https://github.com/NANNING" target="_blank">GITHUB</a>，
欢迎你<a href="mailto:riverfor@gmail.com">给我写信</a>来参与到这个项目。
<br /><span style="color:grey">2014-5-29</span></p>

<ul>
<li><a href="/website/">网站</a></li>
<li><a href="/manager/">管理系统</a></li>
<li><a href="/api/">API说明</a></li></ul>""", name='上班打卡')

######### MAIN WEBAPP ROUTERS ###############
@route('/website/')
def website():
    """
    APP的官方网站，
    /website/ (主页路径)
    /website/changelogs (版本更新信息)
    /website/about (关于)
    /website/vip (VIP版本)
    """
    return "APP官方网站"


@route('/manager/')
def manager():
    """
    APP的后台管理系统
    /manager/ (登陆)
    /manager/report (登录主页)
    /manager/login (提交登录)
    /manager/register/ (注册使用)
    """
    return template(root+"/templates/venderpage/login.tpl",login_status='')

@route('/manager/register/')
def manager_register():
    """
    开通打卡服务
    """
    return template(root+"/templates/venderpage/register.tpl",register_status='')

@route('/manager/report/')
def manager_report():
    """
    查看打卡报表
    """
    return template(root+"/templates/venderpage/report.tpl",op_status='')

@route('/manager/setting/')
def manager_setting():
    """
    查看打卡报表
    """
    return template(root+"/templates/venderpage/setting.tpl",op_status='')



@route('/api/')
def api():
    """
    APP的API接口概述
    """
    return "API"

@route('/api/register')
def api_register():
    """
    APP的注册接口

    所需要的参数
        mobile: 手机号码

    返回
        err : 错误代码
        msg : 提示消息
        token : 认证Token

    1 验证数据
    2 保存数据
    3 生成token
    4 返回

    """
    company_code = request.POST.get('company_code', '').strip()
    department = request.POST.get('department', '').strip()
    name = request.POST.get('name', '').strip()
    number = request.POST.get('number', '').strip()
    phoneid = request.POST.get('phoneid','').strip()

    #debug
    print (company_code,department,name,number,phoneid)
    response.content_type = 'application/json'

    return dumps({"err":"0", "msg":"ok", "token":"XXXX-AAABBB"})

def re_imei():
    return dumps({"errno":"0", "msg":"990000552011100"})
    #return dumps({"errno":"-1", "msg":"couldn't get the imei"})

@route('/api/checkin')
def api_checkin():
    """
    APP的Checkin接口

    所需要的参数
        token: 认证Token

    返回
        err : 错误代码
        msg : 提示消息

    1 验证数据
    2 保存数据
    3 返回提示
    """
    lat = request.POST.get('lat','').strip() #纬度
    lng = request.POST.get('lng','').strip() #经度
    token = request.POST.get('token','').strip()
    phoneid = request.POST.get('phoneid','').strip()
    #debug
    print (lat,lng,token,phoneid)


    response.content_type = 'application/json'
    return dumps({"err":"0", "msg":"ok"})


######### WEBAPP ROUTERS ###############
if __name__ == '__main__':
    app = Bottle()
    app.route('/', method='GET')(home)
    app.route('/__exit', method=['GET','HEAD'])(__exit)
    app.route('/__ping', method=['GET','HEAD'])(__ping)
    app.route('/assets/<filepath:path>', method='GET')(server_static)

    app.route('/website/', method=['GET','HEAD'])(website)
    app.route('/manager/', method=['GET','HEAD'])(manager)
    app.route('/manager/register/', method=['GET','HEAD'])(manager_register)
    app.route('/manager/report/', method=['GET','HEAD'])(manager_report)
    app.route('/manager/setting/', method=['GET','HEAD'])(manager_setting)
    app.route('/api/', method=['GET','HEAD'])(api)
    app.route('/api/register', method=['GET','POST','HEAD'])(api_register)
    app.route('/api/checkin', method=['GET','POST','HEAD'])(api_checkin)

    app.route('/api/re_imei', method=['GET','POST','HEAD'])(re_imei)
    try:
        server = MyWSGIRefServer(host="0.0.0.0", port="8080")
        app.run(server=server,reloader=False)
    except Exception,ex:
        print "Exception: %s" % repr(ex)

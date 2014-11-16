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
import md5
import bottle
from bottle import Bottle, ServerAdapter
from bottle import run, debug, route, error, static_file, template,request,response,redirect
from json import dumps
from models import CompanyInfo,DepartmentInfo,EmployeesInfo,ManagerInfo,SignSetInfo,RegistrationInfo,LeaveInfo,create_tables,init_tables
import time
import sys

from beaker.middleware import SessionMiddleware



root = os.path.dirname(os.path.abspath(__file__))
if sys.platform == 'darwin':
    temp = os.getenv('IOSTMP')
    if temp=='' or temp==None:
        temp = root+'/tmp/'
else:
    temp = root+'/tmp/'

if not os.path.exists(temp): 
    os.makedirs(temp)

session_root = root+"/session/"
if not os.path.exists(session_root):
    os.makedirs(session_root)

session_opts = {
    'session.type': 'file',
    'session.data_dir': session_root,
    'session.cookie_expires':86400,
    'session.auto': True,
}

######### QPYTHON WEB SERVER ###############
#定义token文件
def check_token():
    token_file=temp+'/.token.json'
    if os.path.exists(token_file):
        line=file.read(open(token_file))
        json_line=json.loads(line)
        token=json_line['token']
        if len(line)>0:
            return token
        else:
            return False
    else:
        return False
#将token数据存到文件中
def save_token_file(data):
    f=open(temp+'/.token.json','w')
    f.write(data)
    f.close()

def save_referer_file(referer):
    f=open(temp+'/.referer.txt')
    f.write(referer)
    f.close()
    
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
def __exit():
    global server
    server.stop()

def __ping():
    return "ok"


def server_static(filepath):
    return static_file(filepath, root=root+"/assets")


######### WEBAPP ROUTERS ###############
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
def website():
    """
    APP的官方网站，
    /website/ (主页路径)
    /website/changelogs (版本更新信息)
    /website/about (关于)
    /website/vip (VIP版本)
    """
    return "APP官方网站"


def manager():
    """
    APP的后台管理系统
    /manager/ (登陆)
    /manager/report (登录主页)
    /manager/login (提交登录)
    /manager/register/ (注册使用)
    """
    return template(root+"/templates/venderpage/login.tpl",login_status='')

def manager_login():
    """登录 """
    form=request.forms
    if form.submit:
        if form.username and form.passwd:
            Company = CompanyInfo.getOne(loginName=form.username)#查询（根据用户名查询密码）
            pass_data = Company.loginPwd.decode('string-escape')       
            passwd_md5 = md5.new(form.passwd).hexdigest()#md5加密，32位
            
            if pass_data == passwd_md5.strip():#strip()去除空格
                #登录成功,将用户信息保存到Session 
                app_session = bottle.request.environ.get('beaker.session')
                app_session["company"]=str(Company.c_Id)#保存公司编号
                redirect("/manager/report/")
                
            else:
                return template(root+"/templates/venderpage/login.tpl",login_status = "用户名或密码错误")

        else:
            return template(root+"/templates/venderpage/login.tpl",login_status = '用户名、密码不能为空')
    else:       
       
        return template(root+"/templates/venderpage/login.tpl",login_status='')
        
def manager_register():    
    """
    开通打卡服务(注册)
    """
    form = request.forms
    if form.submit:
        upload = request.files.get('upload')
        #name, ext = os.path.splitext(upload.filename)
        fileExt=upload.filename.split('.')[-1] #获取文件后缀
        fileExt=upload.filename.split('.')[0] #获取文件名
        save_path = temp+"/Upload" #指定路径
        fileType='png,jpg,jpeg'
        if fileExt in fileType:            
            if not os.path.exists(save_path):
                os.makedirs(save_path)
            file_path = "{path}/{file}".format(path=save_path, file=upload.filename)
            with open(file_path,'wb') as open_file:
                open_file.write(upload.file.read()) #保存文件
                #---------实例化数据 -----------
                Company=CompanyInfo()
                company.loginName=form.username
                company.loginPwd=form.passwd
                company.companyName=form.company_name
                company.Number=int(form.company_number)
                company.Legal=form.company_contact
                company.RegistrationNum=str(datatime.datatime.now())+form.company_name
                company.CompanyPhone=form.company_phone
                company.CompanyEmail=form.company_email
                company.StatusId=True
                company.save(force_insert=True) #主键递增

        else:
            return template(root+"/templates/venderpage/register.tpl",register_status='请选择png,jpg,jpeg文件')
    else:   
        return template(root+"/templates/venderpage/register.tpl",register_status='')
def manager_report():
    """
    查看打卡报表
    """
    return template(root+"/templates/venderpage/report.tpl",op_status='')

def manager_setting():
    """
    查看打卡报表
    """
    return template(root+"/templates/venderpage/setting.tpl",op_status='')



def api():
    """
    APP的API接口概述
    """
    return "API"

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

def mlogin():
    response.content_type = 'application/json'
    return dumps({"errno":"0", "msg":"", "ret": {"id":10001, "token":"a234dsaz"}})
    #return dumps({"errno":"1", "msg":"Fail to login, please check your username or password", "ret": {}})

def reimei():
    response.content_type = 'application/json'
    return dumps({"errno":"0", "msg":"99000055201110"})
    #return dumps({"errno":"-1", "msg":"couldn't get the imei"})
def initimei():
    response.content_type='application/json'
    return dumps({"errno":"0","msg":"OK"})
def getuserdata():
    response.content_type='application/json'
    return dumps({"errno":"0","ret":{"Id":100000,"LoginName":"admin","LoginPwd":"123456","CompanyId":1,"Department":1,"Phone":"18076598729"}})

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

    app.route('/manager/login/', method=['GET','POST'])(manager_login)
    app.route('/manager/register/', method=['GET','POST'])(manager_register)
    app.route('/manager/report/', method=['GET','HEAD'])(manager_report)
    app.route('/manager/setting/', method=['GET','HEAD'])(manager_setting)
    app.route('/api/', method=['GET','HEAD'])(api)
    app.route('/api/register', method=['GET','POST','HEAD'])(api_register)
    app.route('/api/checkin', method=['GET','POST','HEAD'])(api_checkin)

    app.route('/api/reimei', method=['GET','POST','HEAD'])(reimei)
    app.route('/api/mlogin', method=['GET','POST','HEAD'])(mlogin)
    app.route('/api/initimei', method=['GET','POST','HEAD'])(initimei)
    app.route('/api/getuserdata', method=['GET','POST','HEAD'])(getuserdata)
    
    app_with_session = SessionMiddleware(app, session_opts)



    try:
        #server = MyWSGIRefServer(host="127.0.0.1", port="18080")
        server=MyWSGIRefServer(host="0.0.0.0",port="18080")
        bottle.run(server=server,reloader=False,app=app_with_session)
    except Exception,ex:
        print "Exception: %s" % repr(ex)

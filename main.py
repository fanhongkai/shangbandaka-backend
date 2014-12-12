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
from models import CompanyInfo,DepartmentInfo,EmployeesInfo,ManagerInfo,SignSetInfo,RegistrationInfo,LeaveInfo,create_tables,init_tables
import time
import sys
import datetime
import json

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

#---------------------------------------------登录-----------------------------------------------

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
            if Company is None:
                return template(root+"/templates/venderpage/login.tpl",login_status = "用户名或密码错误")
            else:
                pass_data = str(Company.loginPwd) 
                passwd_md5 = str(md5.new(form.passwd).hexdigest())#md5加密，32位
               
                if pass_data== passwd_md5.strip():#strip()去除空格
                    #登录成功,将用户信息保存到Session 
                    app_session = bottle.request.environ.get('beaker.session')
                    app_session["company"] = str(Company.Id)#保存公司编号
                    app_session["companyName"] = Company.companyName #公司名称
                    redirect("/manager/report/")
                    
                else:
                    return template(root+"/templates/venderpage/login.tpl",login_status = "用户名或密码错误")

        else:
            return template(root+"/templates/venderpage/login.tpl",login_status = '用户名、密码不能为空')
    else:       
       
        return template(root+"/templates/venderpage/login.tpl",login_status='')

#----------------------------------------------注册----------------------------------------
        
def manager_register():    
    """
    开通打卡服务(注册)
    """
    form = request.forms
    if form.submit:        
        upload = request.files.get('upload')

        #name, ext = os.path.splitext(upload.filename)
        
        if upload is None:
            
            return template(root+"/templates/venderpage/register.tpl",register_status='请选择png,jpg,jpeg文件')

        else:
           
            fileExt=upload.filename.split('.')[-1] #获取文件后缀
            fileName=upload.filename.split('.')[0] #获取文件名
            save_path = root+"/temp/Upload" #指定路径
            fileType='png,jpg,jpeg'

           
            if fileExt in fileType:                      
                if not os.path.exists(save_path):
                    os.makedirs(save_path)
                file_path = "{path}/{file}".format(path = save_path, file = upload.filename)
                with open(file_path,'wb') as open_file:
                    open_file.write(upload.file.read()) #保存文件

                #---------实例化数据 -----------
        
                
                company = CompanyInfo()                
                company.loginName = str(form.username)
                company.loginPwd = md5.new(str(form.passwd)).hexdigest()
                company.companyName = form.company_name
                company.Number = int(form.company_number)
                company.Legal = form.company_contact
                company.RegistrationNum = form.company_name + str(datetime.datetime.now())[:10]
                company.CompanyPhone = form.company_phone
                company.CompanyEmail = form.company_email
                company.StatusId=True
                company.save(force_insert=True)
                redirect("/manager/")                

            else:
                return template(root+"/templates/venderpage/register.tpl",register_status='请选择png,jpg,jpeg文件')
    else:   

        return template(root+"/templates/venderpage/register.tpl",register_status='')



#-----------------------------------------------考勤管理-----------------------------------

def manager_report():
    """
    查看打卡报表
    """
    
    app_session = bottle.request.environ.get('beaker.session')
    companyId = app_session.get('company')
    companyName = app_session.get('companyName') 
    
    #---------获取部门列表-----------
    array_depart = baseClass().getdepart()#调用类

    #------------end-------------
    
    #---------获取签到位置信息-------

    SingInfo = baseClass().getSingInfo()#调用类
    
    #---------end--------------------

    data=[]
    data_employees = EmployeesInfo.filter(EmployeesInfo.Company == companyId)

    for item in data_employees:        
        base = {"Id":item.Id,"Name":item.Name,"Position":item.Position}
        getRegistByEmployeesId = RegistrationInfo.filter(RegistrationInfo.Company == companyId and RegistrationInfo.EmployeesId == item.Id)
        base['WorkStatus'] = '未签到'
        base['SingTime'] = '-'   
        base['location'] = '-'
        if not getRegistByEmployeesId is None:            
            for emp in getRegistByEmployeesId: 
                base['WorkStatus'] = emp.WorkStatus
                base['SingTime'] = emp.SingTime   
                base['location'] = emp.location
        data.append(base)

    return template(root+"/templates/report.tpl",SingInfo = SingInfo,array_depart = array_depart,templatedir=root+'/templates/',data=data,companyName=companyName)

def manager_setting():
    """
    设置
    """
    return template(root+"/templates/venderpage/setting.tpl",op_status='')



def setSing(Id,showDetail):
    """
    签到设置
    """
    app_session = bottle.request.environ.get('beaker.session')
    companyId = app_session.get('company')
    companyName = app_session.get('companyName') 
    
    if showDetail=='true': #编辑

        data_singInfo = SignSetInfo.filter(SignSetInfo.Company == companyId and SignSetInfo.Id == Id)
        
        for item in data_singInfo:
            data = {"Id":item.Id,"StartTime":item.StartTime,"EndTime":item.EndTime,"SignName":item.SignName}
            
        form = request.forms
        if form.submit:
            SignSetInfo.update(StartTime=form.startTime,EndTime=form.endTime,SignName = form.suggestId,location=form.PutText).where(SignSetInfo.Id==int(Id)).execute()
            redirect("/manager/report/")

        return template(root+"/templates/setSing.tpl",showDetail=True,templatedir=root+'/templates/',data=data,companyName=companyName)
    else:       #添加
        form = request.forms
        if form.submit:
           
            
            new_singInfo = SignSetInfo()            
            new_singInfo.Company = companyId
            new_singInfo.StartTime = form.startTime
            new_singInfo.EndTime = form.endTime
            new_singInfo.SignName = form.suggestId
            new_singInfo.location = form.PutText
            new_singInfo.save(force_insert=True)
            redirect("/manager/report/")            

    return template(root+"/templates/setSing.tpl",showDetail=False,templatedir=root+'/templates/',companyName=companyName)

def  deleteSing(Id):
    
    sign = SignSetInfo.get(Id=Id)
    if not sign is None:
        sign.delete_instance()
        return {"State":"success"}



#----------------------------------------------部门信息管理-------------------------------------

def manager_Department():
    """部门列表"""
    data=[]
    app_session = bottle.request.environ.get('beaker.session')
    companyId = app_session.get('company')
    companyName = app_session.get('companyName') 

    get_department = DepartmentInfo.filter(DepartmentInfo.Company==companyId)
    for item in get_department:
        base = {"Id":item.Id,"Name":item.Name,"Phone":item.Phone,"Leader":item.Leader}
        data.append(base)

    return template(root+"/templates/listDepartment.tpl",templatedir=root+'/templates/',data=data,companyName=companyName)


def edi_department(Id,showDetail):
    """
    部门的添加与编辑
    """
    app_session = bottle.request.environ.get('beaker.session')
    companyId = app_session.get('company')
    companyName = app_session.get('companyName') 
    
    if showDetail =='true': #编辑部门信息

        get_data = DepartmentInfo.filter(DepartmentInfo.Company==companyId and DepartmentInfo.Id==Id)
        for d in get_data:
            data = {"Id":d.Id,"Name":d.Name,"Phone":d.Phone,"Leader":d.Leader}
        form = request.forms        
        res_dic =[]
       
        if form.submit:
            DepartmentInfo.update(Name=form.Name,Phone=form.Phone,Leader=form.Leader).where(DepartmentInfo.Id==Id).execute()
            redirect("/manager/listdepartment/")

        return template(root+"/templates/edit_depart.tpl",showDetail=True,data=data,templatedir=root+'/templates/',companyName=companyName)
       
    else:           #添加部门信息
        
        form = request.forms       
        if form.submit:            
            depart = DepartmentInfo()            
            depart.Name = form.Name
            depart.Company = companyId
            depart.Phone = form.Phone
            depart.Leader = form.Leader           
            depart.save(force_insert=True)
            redirect("/manager/listdepartment/") #跳转到部门列表
        
        return template(root+"/templates/edit_depart.tpl",showDetail=False,templatedir=root+'/templates/',companyName=companyName)


#/manager/deldepartment/<Id>/
def del_department(Id):     #删除部门信息

    """删除部门"""
    #返回JSON对象
   
    depart = DepartmentInfo.get(Id = Id)  
    if not depart is None:  
        depart.delete_instance()
        return {"State":"success"}

#---------------------------------------------员工信息管理--------------------------------------
def manager_listEmployeesBydepart(Id):
    """
    根据部门查询
    """
    app_session = bottle.request.environ.get('beaker.session')
    companyId = app_session.get('company')
    companyName = app_session.get('companyName')

    #---------获取部门列表-----------
    
    array_depart = baseClass().getdepart()#调用类
    
    #------------end-------------
    data = []
    data_em = EmployeesInfo.filter(EmployeesInfo.Company == companyId and EmployeesInfo.Department ==Id)
    for item in data_em:
        base = {"Id": item.Id,'Name':item.Name,'Sex':item.Sex,'Phone':item.Phone,'Email':item.Email,'Position':item.Position}
        get_depart = DepartmentInfo.filter(DepartmentInfo.Id == item.Department)
        base['department'] = ''
        for depar in get_depart:
            if not depar.Name == '':
                base['department'] = depar.Name
        data.append(base)
            
    return template(root+"/templates/listEmployess.tpl",array_depart = array_depart,templatedir = root+'/templates/',data=data,companyName=companyName)

def manager_listEmployees(): #员工列表
    """
    员工列表
    """
    app_session = bottle.request.environ.get('beaker.session')
    companyId = app_session.get('company')
    companyName = app_session.get('companyName')
    
    #---------获取部门列表-----------
    
    array_depart = baseClass().getdepart()#调用类
    
    #------------end-------------
    data = []
    get_em = EmployeesInfo.filter(EmployeesInfo.Company == companyId)
    for item in get_em:
        base = {"Id": item.Id,'Name':item.Name,'Sex':item.Sex,'Phone':item.Phone,'Email':item.Email,'Position':item.Position}
        get_depart = DepartmentInfo.filter(DepartmentInfo.Id == item.Department)
        base['department'] = ''
        for depar in get_depart:
            if not depar.Name == '':
                base['department'] = depar.Name
        data.append(base)
            
    return template(root+"/templates/listEmployess.tpl",array_depart = array_depart,templatedir = root+'/templates/',data=data,companyName=companyName)

def edi_employees(Id,showDetail):  #员工信息管理

    """
    员工的添加与编辑
    """
    app_session = bottle.request.environ.get('beaker.session')
    companyId = app_session.get('company')
    companyName = app_session.get('companyName') 

    #---------获取部门列表-----------
    data_depart = DepartmentInfo.filter(DepartmentInfo.Company==companyId)
    array_depart = []
    for depart in data_depart:
        base = {"Id":depart.Id,"Name":depart.Name}     
        array_depart.append(base)      

    #------------end-------------

    if showDetail =='true':
        data_employ = EmployeesInfo.filter(EmployeesInfo.Company==companyId and EmployeesInfo.Id==Id)
        for item in data_employ:
            data = {"Id":item.Id,"Name":item.Name,"Department":item.Department,"Sex":item.Sex,"IdCard":item.IdCard,"Phone":item.Phone,"Email":item.Email,"Position":item.Position}
        
        
        form = request.forms
        res_dic = []
        if form.submit:                        
            EmployeesInfo.update(Name=form.Name,Sex=form.Sex,IdCard=form.IdCard,Phone=form.Phone,Email=form.Email,Position=form.Position).where(EmployeesInfo.Id==int(Id)).execute()
            redirect("/manager/listemployees/")

        return template(root+"/templates/edit_employees.tpl",array_depart = array_depart,showDetail= True,templatedir=root+'/templates/',data=data,companyName=companyName)
    else:
        form = request.forms
        if form.submit:
            #获取员工根据对应的公司Id查找员工总数，新的员工Id：count+1 
            
            
            employe = EmployeesInfo()
            employe.Name = form.Name
            employe.LoginName = form.Phone            
            employe.LoginPwd = md5.new("123456").hexdigest()
            employe.Company = companyId
            employe.Department = form.department   
            print [form.department]     
            employe.Sex = form.Sex           
            employe.IdCard = form.IdCard            
            employe.Phone = form.Phone            
            employe.Email = form.Email
            employe.Position = form.Position
            employe.Imei = "123456xaxahisia"
            employe.save(force_insert = True)#不管主键是否存在的情况加force_insert = True,相当于id自动递增
            redirect("/manager/listemployees/")

        return template(root+"/templates/edit_employees.tpl",array_depart = array_depart,showDetail = False,templatedir = root+'/templates/',companyName = companyName)

def del_employees(Id):  #删除员工信息
    """
    删除员工信息
    """
    employe = EmployeesInfo.get(Id=Id)
    if not employe is None:
        employe.delete_instance()        
        return {"State":"success"}

#----------------------------------------请假管理--------------------------------------------
def manager_leave():
    """ 
    请假列表 
    """
    #---------获取部门列表-----------
    
    array_depart = baseClass().getdepart()#调用类
    
    #------------end-------------
    data = []
    app_session = bottle.request.environ.get('beaker.session')
    companyId = app_session.get('company')
    companyName = app_session.get('companyName')
    get_leave = LeaveInfo.filter(LeaveInfo.Company == companyId)
    for item in get_leave:
        base = {"Id":item.Id,'StartTime':item.StartTime,'Reason':item.Reason,'Agree':item.Agree}
        get_empName = EmployeesInfo.select().where(EmployeesInfo.Id == item.EmployeesId)
        for getEmp_name in get_empName:
            base['Name'] = getEmp_name.Name
            base['Sex'] = getEmp_name.Sex
            base['Phone'] = getEmp_name.Phone
            data.append(base)
    return template(root+"/templates/listleave.tpl",templatedir=root+'/templates/',array_depart=array_depart,data=data,companyName=companyName)

def edi_leave(Id,showDetail):
    """
    请假编辑
    """
    app_session = bottle.request.environ.get('beaker.session')
    companyId = app_session.get('company')
    companyName = app_session.get('companyName')
    
    if showDetail =='true':        
        data_leave = LeaveInfo.filter(LeaveInfo.Company == companyId and LeaveInfo.Id == Id)
        for item in data_leave:
            getEmployeesById = EmployeesInfo.filter(EmployeesInfo.Id == item.EmployeesId)
            for employe in getEmployeesById:
                data = {"Id":item.Id,"StartTime":item.StartTime,"Reason":item.Reason,"Agree":item.Agree,"Name":employe.Name,"Sex":employe.Sex}
         
        form =request.forms        
        if form.submit:
            LeaveInfo.update(Agree = True,reMsg = form.reMsg).where(LeaveInfo.Id==int(Id)).execute()
            redirect("/manager/listleave/")  

    return template(root+"/templates/edit_leave.tpl",showDetail=True,templatedir= root+'/templates/',data=data,companyName=companyName)
   

def del_leave(Id):
    """
    删除请假信息
    """
    leave = LeaveInfo.get(Id=Id)
    if not leave is None:
        leave.delete_instance()
        return {"State":"success"}




#-------------------------------------------------API接口----------------------------------------

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

def mlogin(username,passwd):
    """
    API登录
    """
    user = EmployeesInfo.getOne(loginName = username)
    passwd_md5 = str(md5.new(passwd).hexdigest())#md5加密，32位
    if not user is None:
        if passwd_md5 == user.loginPwd:
            token = passwd + str(datetime.datetime.now())+ "_" + user.Id + "_" + user.Company
            return {"msg":"成功","error":"0","token":token,"Cname":user.companyName}
        else:
            return {"msg":"用户名或密码错误","error":"1"}
    else:
        return {"msg":"不存在%S的账号" % username,"error":"1"}
def api_registration(token,lat,lon):
    """
    签到
    """

    #---------所需数据数据
    # token ------员工编号（Id）+公司编号 ，其中员工编号与公司编号之间用（_）隔开
    # lat --------纬度
    # lon --------经度    

    #-----------------设计思路---------------
    #（1）点到圆心的距离小于半径就说明在圆内，就可以签到    
    #（2）设置半径半径为5米
    #（3）坐标点的距离公式为：√[(x1-x2)²+(y1-y2)²] 转换成编程语言就是 (x1-x2)²+(y1-y2)² 与 r^2的关系
    #（4）查询数据表中是否存在当天的签到记录（不能重复签到）
    #（5）判断是否是在指定地点附近内签到（半径），读取所有的设置签到地点。然后判断。。。。
    #（6）判断时间，如果在指定时间内签到，则表示正常签到。如果超过了指定时间签到表示迟到。
    #-----------------end---------------------

    #-----------------获取传值数据
    #公司编号
    companyId = token.split("_")[0]

    #员工编号
    employe = token.split("_")[1]    
    
    #半径
    r = 5
    #查询数据表，如果已经在当天签到，则不能再签到
    #获取当前时间
    time_now = time.strftime("%Y-%m-%d %H:%M:%S",time.localtime())
    #将当前时间转换成指定格式
    time_now_fomat = time.strptime(time_now,"%Y-%m-%d %H:%M:%S")

    time_24 =str(time.strftime("%Y-%m-%d",time.localtime())) + " " + "24:00:00"
    time_24_format = time.strptime(time_24,"%Y-%m-%d %H:%M:%S")

    get_today = RegistrationInfo.filter(EmployeesId =employe and time.strptime(SingTime,"%Y-%m-%d") > time_now_fomat and time_24_format > time.strptime(SingTime,"%Y-%m-%d"))
    if get_today is None:
        #一、获取设置坐标
        get_setSign = SignSetInfo.filter(Company = companyId)
        distance = 0
        for sign in get_setSign:
            la = sign[location].split(",")[0] 
            ln = sign[location].split(",")[1]
            distance = (lat-la)*(lat-la) + (lon-ln)*(lon-ln)
            if distance < r * r:
                #签到成功
                #判断签到时间是否在设置签到时间内，
                #一。超过了指定时间-------迟到
                #二。在指定时间内--------正常签到
               
                start_time = str(time.strftime("%Y-%m-%d",time.localtime())) + " " + str(sign["StartTime"])
                #将开始签到时间转换成时间格式
                sign_time_conver = time.strptime(start_time,"%Y-%m-%d %H:%M:%S")
                #结束签到时间
                end_time = str(time.strftime("%Y-%m-%d",time.localtime())) + " " + str(sign["EndTime"])

                if time_fomat > sign_time_conver and time_fomat < endTime:                
                    Registration = RegistrationInfo()
                    Registration.Company = companyId
                    Registration.EmployeesId = employe
                    Registration.WorkStatus = "正常签到"
                    Registration.SingTime = time.strftime("%Y-%m-%d %H:%M:%S",time.localtime())
                    Registration.location = sign["SignName"]
                    return {"msg":"签到成功","error":"0"}
                   
                elif time_fomat > endTime:
                    Registration = RegistrationInfo()
                    Registration.Company = companyId
                    Registration.EmployeesId = employe
                    Registration.WorkStatus = "迟到"
                    Registration.SingTime = time.strftime("%Y-%m-%d %H:%M:%S",time.localtime())
                    Registration.location = sign["SignName"]
                    return {"msg":"你已经迟到啦","error":"0"}
                break

            else:
                return {"msg":"请到指定地点签到哦","error":"0"}
    else:
        return {"msg":"你已经签到","error":"0"}

    

def api_leave(token,settime,reason):

    #---------所需数据数据
    # token ------员工编号（Id）+公司编号 ，其中员工编号与公司编号之间用（_）隔开
    # lat --------纬度
    # lon --------经度    
    employe = token.split('_')[0]   #员工编号
    companyId = token.split('_')[1] #公司编号
    

    startTime = settime.split('_')[0]#请假第一天
    periodTime = settime.split('_')[1]#请假第二天    
    endTime = settime.split('_')[2]#请假第三天
          
    leave = LeaveInfo()
    leave.Company = companyId
    leave.EmployeesId = employe
    leave.StartTime =  time.strptime(startTime,"%Y-%m-%d %H:%M:%S")
    leave.PeriodTime = time.strptime(periodTime,"%Y-%m-%d %H:%M:%S")
    leave.EndTime = time.strptime(endTime,"%Y-%m-%d %H:%M:%S")
    leave.Reason = reason
    leave.reMsg = ''
    leave.Agree = False
    leave.save(force_insert = True)
    return {"msg":"请假成功","error":"0"}

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

#------------------------------------------------类------------------------------------

class baseClass:
    def getdepart(self):
        app_session = bottle.request.environ.get('beaker.session')
        companyId = app_session.get('company')
        companyName = app_session.get('companyName') 

        #---------获取部门列表-----------
        data_depart = DepartmentInfo.filter(DepartmentInfo.Company==companyId)
        array_depart = []
        for depart in data_depart:
            base = {"Id":depart.Id,"Name":depart.Name}     
            array_depart.append(base)  
        return array_depart 

    def getSingInfo(self):
        app_session = bottle.request.environ.get('beaker.session')
        companyId = app_session.get('company')
        companyName = app_session.get('companyName') 

        #-----------获取所有签到位置信息----------
        signInfo = SignSetInfo.filter(SignSetInfo.Company==companyId)
        array_SignInfo = []
        for item in signInfo:
            base = {"Id":item.Id,"SignName":item.SignName,"StartTime":item.StartTime,"EndTime":item.EndTime}
            array_SignInfo.append(base)
        return array_SignInfo

######### WEBAPP ROUTERS ###############
if __name__ == '__main__':

    app = Bottle()

    app.route('/', method='GET')(home)
    app.route('/__exit', method=['GET','HEAD'])(__exit)
    app.route('/__ping', method=['GET','HEAD'])(__ping)
    app.route('/assets/<filepath:path>', method='GET')(server_static)

    app.route('/website/', method=['GET','HEAD'])(website)
    app.route('/manager/', method=['GET','HEAD'])(manager)

    app.route('/manager/login/', method=['GET','POST'])(manager_login) #登录
    app.route('/manager/register/', method=['GET','POST'])(manager_register) #注册
    app.route('/manager/report/', method=['GET','HEAD'])(manager_report)    #报表
    app.route('/manager/setting/', method=['GET','HEAD'])(manager_setting)  #设置

    app.route('/manager/listdepartment/', method=['GET','POST'])(manager_Department) #部门管理
    app.route('/manager/edidepartment/<Id>/<showDetail>/',method=['GET','POST'])(edi_department) 
    app.route('/manager/deldepartment/<Id>/',method=['GET','POST'])(del_department)

    app.route('/manager/listemployees/', method=['GET','POST'])(manager_listEmployees)#员工管理
    app.route('/manager/ediemployees/<Id>/<showDetail>/',method=['POST','GET'])(edi_employees)
    app.route('/manager/delemployees/<Id>/',method=['GET','POST'])(del_employees)
    app.route('/manager/listemployees/<Id>/',method = ['GET','POST'])(manager_listEmployeesBydepart)#根据部门查询员工

    app.route('/manager/listleave/',method=['GET','POST'])(manager_leave)#请假管理
    app.route('/manager/edileave/<Id>/<showDetail>/',method=['GET','POST'])(edi_leave)
    app.route('/manager/delleave/<Id>/',method=['GET','POST'])(del_leave)

    app.route('/manager/setSign/<Id>/<showDetail>/',method=['GET','POST'])(setSing)#签到设置
    app.route('/manager/delsign/<Id>/',method=['GET','POST'])(deleteSing)
    
    

    app.route('/api/', method=['GET','HEAD'])(api)
    app.route('/api/register', method=['GET','POST','HEAD'])(api_register)
    app.route('/api/checkin', method=['GET','POST','HEAD'])(api_checkin)



    app.route('/api/reimei', method=['GET','POST','HEAD'])(reimei)
    app.route('/api/mlogin/<username>/<passwd>', method=['GET','POST','HEAD'])(mlogin)
    app.route('/api/registration/<token>/<lat>/<lon>', method = ['GET','POST'])(api_registration)
    app.route('/api/leave/<token>/<settime>/<reason>',method = ['POST'])(api_leave)
    app.route('/api/initimei', method=['GET','POST','HEAD'])(initimei)
    app.route('/api/getuserdata', method=['GET','POST','HEAD'])(getuserdata)
    
    app_with_session = SessionMiddleware(app, session_opts)



    try:
        server = MyWSGIRefServer(host="127.0.0.1", port="18080")
        #server=MyWSGIRefServer(host="0.0.0.0",port="18080")
        bottle.run(server=server,reloader=False,app=app_with_session)
    except Exception,ex:
        print "Exception: %s" % repr(ex)

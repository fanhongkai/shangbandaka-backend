#-*-coding:utf-8;-*-

import os.path
from peewee import *
import peewee
import sys
import datetime,time

root=os.path.dirname(os.path.abspath(__file__))

if sys.platform=='darwin':
    temp=os.getenv('IOSTMP')
    if temp=='' or temp==None:
        temp=rooe+'/temp'
    db_path=temp+"/__daka.db"
elif sys.platform=='win32':
    db_path='__daka.db'
else:
    temp=root+'/temp/'
    db_path=root+"/../__daka.db"
database =peewee.SqliteDatabase(db_path,check_same_thread=False)

def create_tables():
    CompanyInfo.create_table()#公司信息
    DepartmentInfo.create_table()#部门信息
    EmployeesInfo.create_table()#员工信息
    ManagerInfo.create_table()#管理员信息
    SignSetInfo.create_table()#签到设置（签到位置设置）
    RegistrationInfo.create_table()#签到信息
    LeaveInfo.create_table()#请假信息
    return None
#初始化数据
def init_tables():
    CompanyInfo.insert(loginName='admin',loginPwd='e10adc3949ba59abbe56e057f20f883e',companyName='优趣天下',Number=500,Legal='preson',RegistrationNum='xaxacsnih',CompanyPhone='18076598709',CompanyEmail='1425412316@qq.com').execute()
    DepartmentInfo.insert(Name='技术部',Company=1,Phone='18076598709',Leader='王一').execute()
    EmployeesInfo.insert(Id=1,Name='张三',LoginName='zhangsan',LoginPwd='e10adc3949ba59abbe56e057f20f883e',Company=1,Department=1,Sex='男',IdCard='452229199406235119',Phone='18777452591',Email='1425412316@qq.com',Position='员工',Imei='xacdcooccos').execute()
    EmployeesInfo.insert(Id=2,Name='李四',LoginName='lisi',LoginPwd='e10adc3949ba59abbe56e057f20f883e',Company=1,Department=1,Sex='男',IdCard='452229199406235119',Phone='18777452591',Email='1425412316@qq.com',Position='员工',Imei='xacdcooccos').execute()
    ManagerInfo.insert(LoginName='userAdmin',LoginPswd='e10adc3949ba59abbe56e057f20f883e',Name='李四',LastLoginData='2014-11-09 10:00:00').execute()
    SignSetInfo.insert(Company=1,StartTime='8:00',EndTime='9:00',SignName='优趣天下',location='129,126').execute()
    RegistrationInfo.insert(EmployeesId=1,Company=1,WorkStatus='正常上班',location='129,126').execute()
    LeaveInfo.insert(EmployeesId=1,Company=1,StartTime='2014-11-09',PeriodTime='2014-11-10',EndTime='2014-11-11',Reason='请假过双11',ActTime='2014-11-09 10:00:00',reMsg='这样你也请假？',Agree=False).execute()
    
class BaseModel(peewee.Model):
    class Meta:
        database=database
    @classmethod
    def getOne(cls,*query,**kwargs):
        try:
            return cls.get(*query,**kwargs)
        except DoesNotExist:
            return None

class CompanyInfo(BaseModel):#公司信息
        
        Id=peewee.PrimaryKeyField()
        loginName=peewee.CharField(unique=True)
        loginPwd=peewee.CharField(max_length=200)
        companyName=peewee.CharField(max_length=20)
        Number=peewee.IntegerField()
        Legal=peewee.CharField(max_length=10)
        RegistrationNum=peewee.CharField(max_length=50)
        CompanyPhone=peewee.CharField(max_length=20)
        CompanyEmail=peewee.CharField(max_length=30)        
        def __unicode__(self):#当print CompanyInfo类的时候 输出的是下面的数据（用户名和密码）
            return "%s : %s" %(self.loginName,self.loginPwd)
    
class DepartmentInfo(BaseModel):#部门信息
        Id=peewee.PrimaryKeyField()
        Name=peewee.CharField(max_length=10)
        Company=peewee.IntegerField()#--公司id
        Phone =peewee.CharField(max_length=20)
        Leader=peewee.CharField(max_length=10)        
        def __unicode__(self):
            return "%S : %s" %(self.Id,self.Name)  

class EmployeesInfo(BaseModel):#员工信息
        Id=peewee.PrimaryKeyField()
        Name=peewee.CharField(max_length=10)
        LoginName=peewee.CharField(max_length=20)
        LoginPwd=peewee.CharField(max_length=200)
        Company=peewee.IntegerField()#--公司id
        Department=peewee.IntegerField()#--部门Id
        Sex=peewee.CharField(max_length=2)
        IdCard=peewee.CharField(max_length=20)
        Phone=peewee.CharField(max_length=20)
        Email=peewee.CharField(max_length=30)
        Position=peewee.CharField(max_length=10)
        Imei=peewee.CharField(max_length=50)
        
        def __unicode__(self):
            return "%s: %s :%s" %(self.Name,self.LoginName,self.Position)

class ManagerInfo(BaseModel):#管理员
        Id=peewee.PrimaryKeyField()
        LoginName=peewee.CharField(max_length=20)
        LoginPswd=peewee.CharField(max_length=200)
        Name=peewee.CharField(max_length=20)
        LastLoginData=peewee.DateTimeField(default=datetime.datetime.now)
        
        def __unicode__(self):
            return "%s: %s" %(self.LoginName,self.Name)
        
class SignSetInfo(BaseModel):#签到设置
        Id=peewee.PrimaryKeyField()
        Company=peewee.IntegerField()#--公司id
        StartTime=peewee.DateTimeField()
        EndTime=peewee.DateTimeField()
        SignName=peewee.CharField(max_length=50)
        location=peewee.CharField(max_length=50)
        
        def __unicode__(self):
            return "%s: %s" %(self.SignName,self.location)
        
class RegistrationInfo(BaseModel):#签到
        Id=peewee.PrimaryKeyField()
        Company=peewee.IntegerField()#--公司id
        EmployeesId=peewee.IntegerField()#--员工编号        
        WorkStatus=peewee.CharField(max_length=10)
        SingTime=peewee.DateTimeField(default=datetime.datetime.now)
        location=peewee.CharField(max_length=50)
        
        def __unicode__(self):
            return "%s: %s :%s" %(self.Id,self.EmployeesId,self.SingTime)
        class Meta:
            order_by=('SingTime',)
        
class LeaveInfo(BaseModel):#请假
        Id=peewee.PrimaryKeyField()
        Company=peewee.IntegerField()#--公司id
        EmployeesId=peewee.IntegerField()#--员工编号        
        StartTime=peewee.DateTimeField()
        PeriodTime=peewee.DateTimeField()
        EndTime=peewee.DateTimeField()
        Reason=peewee.CharField(max_length=200)
        ActTime=peewee.DateTimeField(default=datetime.datetime.now)        
        reMsg=peewee.CharField(max_length=50)        
        Agree=peewee.BooleanField(default=False)
        
        def __unicode__(self):
            return "%s: %s :%s" %(self.Id,self.EmployeesId,self.Reason)
        class Meta:
            order_by=('-Id',)

if __name__ == '__main__':
        create_tables()
        init_tables()
        

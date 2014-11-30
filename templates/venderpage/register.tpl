<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="description" content="">
    <meta name="author" content="">
    <link rel="shortcut icon" href="/assets/static/favicon.ico">
    <title>上班打卡(管理系统)</title>
    <!-- Bootstrap core CSS -->
    <link href="/assets/bootstrap/css/bootstrap.min.css" rel="stylesheet">
    <!-- Custom styles for this template -->
    <link href="/assets/static/signin.css" rel="stylesheet">
    <link href="/assets/static/milib.css" rel="stylesheet">
    <script src="/assets/static/jquery.min.js"></script>
    <script src="/assets/bootstrap/js/bootstrap.min.js"></script>
  </head>
  <body style='padding-top:60px'>
    <div class="navbar navbar-fixed-top navbar-inverse" role="navigation">
      <div class="container">
        <div class="navbar-header">
          <a class="navbar-brand" style='padding:15px 10px;margin-left:0px' href="javascript:milib.close()"><span class="glyphicon glyphicon-th-large"></span></a>
          <a class="navbar-brand" style='padding:15px 15px 15px 5px;margin-left:0px' href="#">上班打卡</a>
        </div>
      </div><!-- /.container -->
    </div><!-- /.navbar -->

    <div class="container main pt-10">
      <form action="/manager/register/" method="post" Id="_form" class="form-signin" role="form" enctype="multipart/form-data">
        <h3 class='center ml-not'>企业注册</h3>
        <span style='color:grey'>用户名:</span><br />
        <input type="text" name="username" id="username" class="form-control" value="" placeholder="用户名"  autocomplete='off'>        
        <br />
        <span style='color:grey'>密码:</span><br />
        <input type="password" name="passwd" id="passwd" class="form-control" value="" placeholder="密码"  autocomplete='off'>
        <br />
        <span style='color:grey'>公司名称:</span><br />
        <input type="text" name="company_name" id="company_name" class="form-control" value="" placeholder="公司名称"  autocomplete='off'>
        <br />
        <span style='color:grey'>公司营业执照附件:</span><br />
        <input type="file" name="upload" id="company_id" class="form-control" placeholder="营业执照附件"  autocomplete='off'>
        <br />
        <span style='color:grey'>公司人数:</span><br />
        <input type="text" name="company_number" id="company_number" class="form-control" value="" placeholder="公司人数"  autocomplete='off'>
        <br />
        <span style='color:grey'>联系人:</span><br />
        <input type="text" name="company_contact" id="company_contact" class="form-control" value="" placeholder="联系人"  autocomplete='off'>
        <br />
        <span style='color:grey'>联系电话:</span><br />
        <input type="text" name="company_phone" id="company_phone" class="form-control" value="" placeholder="联系电话"  autocomplete='off'>
        <br />
        <span style='color:grey'>联系邮箱:</span><br />
        <input type="text" name="company_email" id="company_email" class="form-control" value="" placeholder="联系邮箱"  autocomplete='off'>
        <br />
        <span><font color='red'>{{register_status}}</font></span>
        <input type="submit" name="submit" class="btn btn-lg btn-primary btn-block" onclick="return check()" id="butSubmit" value="提交申请"/>          
        <br />
        <span style="color:grey"><a href='/manager/'>登录 >></a>  </span>
      </form>
    </div><!--/.container-->
    <div class="modal js-loading-bar"></div> 
  </body>
</html>
<script type="text/javascript"> 
    function check()
    {
        var username = $("#username").val();        
        if(username ==''||username == null){
            alert("请输入登录账号")
            $("#username").focus();
            return false;
        }        
        var passwd = $("#passwd").val();
        if(passwd ==''|| passwd == null){
            alert("请输入登录密码")
            $("#passwd").focus();
            return false;
        }
        var company_name = $("#company_name").val();
        if(company_name ==''||company_name == null){
            alert("公司名称")
            $("#company_name").focus();
            return false;
        }

        var company_number = $("#company_number").val();
        var num=Number(company_number);
        if(company_number ==''||company_number == null || isNaN(num) || num == 0 || num == 1){
            alert("请输入公司在职人数")
            $("#company_number").focus();
            return false;
        }
        var company_contact = $("#company_contact").val();
        if(company_contact ==''|| company_contact ==null){
            alert("请输入联系人姓名")
            $("#company_contact").focus();
            return false;
        }

        var company_phone = $("#company_phone").val();
        var reg_phone = /^(((14[0-9]{1})|(18[0-9]{1})|(13[0-9]{1})|159|153)+\d{8})$/; //手机格式
        if(company_phone ==''|| company_phone == null || !reg_phone.test(company_phone)){
            alert("请输入有效的联系方式")
            $("#").focus();
            return false;
        }
        var  company_email = $("#company_email").val();
        var reg_email = /^\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*$/; //邮箱格式
        if(company_email ==''|| company_email == null || !reg_email.test(company_email)){
            alert("请输入有效的邮箱地址")
            $("#company_email").focus();
            return false;
        }
        
    }
    
</script>

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
    <link href="/assets/static/dashboard.css" rel="stylesheet">

  </head>
  <style type="text/css">
    .navbar-inverse .navbar-nav>.leave>a, .navbar-inverse .navbar-nav>.leave>a:hover, .navbar-inverse .navbar-nav>.leave>a:focus {
       color: #fff;
       background-color: #080808;
    }
  </style>
  <body style='padding-top:60px'>
    % include(templatedir+"Master/_userlayout.tpl") 
    <div class="container-fluid">
      <div class="row">
        <div class="col-sm-3 col-md-2 sidebar">
          <ul class="nav nav-sidebar">
            <li class="active"><a href="#">全部</a></li>
            <li><a href="#">开发</a></li>
            <li><a href="#">市场</a></li>
            <li><a href="#">销售</a></li>
            <li><a href="/manager/listdepartment/">部门</a></li>
            <li><a href="#"><span class="glyphicon glyphicon-plus"></span> 添加部门</a></li>
          </ul>
        </div>
        <div class="col-sm-9 col-sm-offset-3 col-md-10 col-md-offset-2 main">
          <h1 class="page-header">{{companyName}}</h1>
            <div>
              %if showDetail:
                <form action="/manager/edileave/{{data['Id']}}/true/" method="post" role="form">
                <div class="form-item">
                    <label for="name">姓名</label>
                    <div> 
                    <input type="text" value="{{data['Name']}}" name="Name" Id="Name" readonly="readonly" />
                    </div>           
                </div>  
                <br/>
                <div class="form-item">
                    <label for="name">性别</label>
                    <div> 
                    <input type="text" value="{{data['Sex']}}" name="Sex" Id="Sex" readonly="readonly" />
                    </div>           
                </div>
                <br/>
                <div class="form-item">
                    <label for="name">请假时间</label>
                    <div> 
                    <input type="text" value="{{data['StartTime']}}" name="StartTime" Id="StartTime" readonly="readonly" />
                    </div>           
                </div>
                <br />
                <div class="form-item">
                    <label for="name">请假事由</label>
                    <div> 
                    <input type="text" value="{{data['Reason']}}" name="Reason" Id="Reason" readonly="readonly" />
                    </div>           
                </div>
                <hr>
                <br />
                <div class="form-item">
                    <label for="name" style="color:red">如果不批准请假，请选择性填写驳回原因</label>
                    <div> 
                    <textarea rows="5" cols="40" name="reMsg" Id="reMsg"></textarea> 
                    <!-- <input type="text" value="" name="reMsg" Id="reMsg"/> -->
                    </div>           
                </div>

                  <br />
                  <div>
                      <input type="submit" class="btn btn-primary" name="submit" id="but_save"value="批准"/>&nbsp
                      <input type="submit" class="btn btn-primary" name="reject" id="but_reject" onclick="return check()" value="驳回"/>&nbsp

                      <button type="reset" class="btn btn-primary" name="cancel" onclick="javascript:history.back()">取&nbsp 消</button>&nbsp
                  </div>
                  <hr class="half-rule" />
                  <div class='footer'>
                    <p class="muted credit grey center" style='color:grey'>Copyright © <a href='https://github.com/NANNING'>NANNING</a> 2013-2014. All rights reserved.
                        <span class="right"></span>
                    </p>
                  </div>
                </form>
        </div>
      </div>    
    </div>
    <div class="modal js-loading-bar"></div>
    <script src="/assets/static/jquery.min.js"></script>
    <script src="/assets/bootstrap/js/bootstrap.min.js"></script>   
  </body>
</html>
<script type="text/javascript">
    function check(){
        var reMsg = $("#reMsg").val();
        if(reMsg ==''|| reMsg ==null){
            alert("给我个理由o(>﹏<)o")
            $("#reMsg").focus();
            return false;
        }


    }
</script>
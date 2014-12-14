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
    .navbar-inverse .navbar-nav>.company>a, .navbar-inverse .navbar-nav>.company>a:hover, .navbar-inverse .navbar-nav>.company>a:focus {
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
                <form action="/manager/edidepartment/{{data['Id']}}/true/" method="post" role="form">
                <div class="form-item">
                    <label for="name">部门名称</label>
                    <div> 
                    <input type="text" value="{{data['Name']}}" name="Name" Id="d_Name"/>
                    </div>           
                </div>  
                <br/>
                <div class="form-item">
                    <label for="name">部门电话</label>
                    <div> 
                    <input type="text" value="{{data['Phone']}}" name="Phone" Id="Phone"/>
                    </div>           
                </div>
                <br/>
                <div class="form-item">
                    <label for="name">部门经理</label>
                    <div> 
                    <input type="text" value="{{data['Leader']}}" name="Leader" Id="Leader"/>
                    </div>           
                </div>
                <br />
                  <br />
                  <div>
                      <input type="submit" class="btn btn-primary" name="submit" id="but_save" onclick="return check()" value="确认"/>&nbsp
                      <button type="reset" class="btn btn-primary" name="cancel" onclick="javascript:history.back()">取&nbsp 消</button>&nbsp
                  </div>
                  <hr class="half-rule" />
                  <div class='footer'>
                    <p class="muted credit grey center" style='color:grey'>Copyright © <a href='https://github.com/NANNING'>NANNING</a> 2013-2014. All rights reserved.
                        <span class="right"></span>
                    </p>
                  </div>
                </form>
              %else:
                <form action="/manager/edidepartment/0/false/" method="post" role="form">
                  <div class="form-item">
                      <label for="name">部门名称</label>
                      <div> 
                      <input type="text" placeholder="部门名称"  value="" name="Name" Id="d_Name"/>
                      </div>           
                  </div>
                  <br/>
                  <div class="form-item">
                      <label for="name">部门电话</label>
                      <div> 
                      <input type="text" placeholder="部门电话"  name="Phone" Id="Phone"/>
                      </div>           
                  </div> 
                  <br/>
                  <div class="form-item">
                      <label for="name">部门经理</label>
                      <div> 
                      <input type="text" value="" placeholder="部门经理"  name="Leader" Id="Leader"/>
                      </div>           
                  </div> 
                  <br />
                  <br />
                  <div>
                      <input type="submit" class="btn btn-primary" name="submit" id="but_save" onclick="return check()" value="确认"/>&nbsp
                      <button type="reset" class="btn btn-primary" name="cancel" onclick="javascript:history.back()">取&nbsp 消</button>&nbsp
                  </div>
                  <hr class="half-rule" />
                  <div class='footer'>
                    <p class="muted credit grey center" style='color:grey'>Copyright © <a href='https://github.com/NANNING'>NANNING</a> 2013-2014. All rights reserved.
                        <span class="right"></span>
                    </p>
                  </div>
                </form>    
              %end 
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
      
       var name = $("#d_Name").val(); //部门名称
       if (name == '' || name == undefined || name == null) {
            alert("请输入部门名称");
            $("#Name").focus();
            return false;
        }
       var Phone = $("#Phone").val(); //部门电话
       var re_call = /^(([0\+]\d{2,3}-)?(0\d{2,3})-)(\d{7,8})(-(\d{3,}))?$/;
       var reg_phone = /^(((14[0-9]{1})|(18[0-9]{1})|(13[0-9]{1})|159|153)+\d{8})$/; //手机格式
       if (Phone == '' || Phone == undefined || Phone == null || !reg_phone.test(Phone) && !re_call.test(Phone)) {
            alert("请输入部门电话");
            $("#Phone").focus();
            return false;
        }
        var Leader = $("#Leader").val(); //部门经理
       if (Leader == '' || Leader == undefined || Leader == null) {
            alert("请输入部门电话");
            $("#Leader").focus();
            return false;
        }
        return true

    }
</script>

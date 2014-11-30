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
                <form action="/manager/ediemployees/{{data['Id']}}/true/" method="post" role="form">
                <div class="form-item">
                    <label for="name">姓名</label>
                    <div> 
                        <input type="text" value="{{data['Name']}}" name="Name" Id="Name"/>
                    </div>           
                </div>  
                <br/>
                <div class="form-item">
                    <label for="name">性别</label>
                    <div> 
                        <select value="{{data['Sex']}}" name="Sex" Id="Sex" style="width:170px;">
                          <option Value="男">男</option>
                          <option Value="女">女</option>
                        </select>
                    </div>           
                </div>
                <br/>      
                <div class="form-item">
                    <label for="name">部门</label>
                    <div> 
                      <select value="" name="department" Id="department" style="width:170px;">
                          %for depart in array_depart:
                              
                                <option value="{{depart['Id']}}">{{depart['Name']}}</option>
                             
                          %end
                      </select>
                    </div>           
                </div>
                <br/>              

                <div class="form-item">
                    <label for="name">身份证</label>
                    <div> 
                        <input type="text" value="{{data['IdCard']}}" name="IdCard" Id="IdCard"/>
                    </div>           
                </div>
                <br/>
                <div class="form-item">
                    <label for="name">电话</label>
                    <div> 
                        <input type="text" value="{{data['Phone']}}" name="Phone" Id="Phone"/>
                    </div>           
                </div>
                <br/>
                <div class="form-item">
                    <label for="name">Email</label>
                    <div> 
                        <input type="text" value="{{data['Email']}}" name="Email" Id="Email"/>
                    </div>           
                </div>
                <br/>
                <div class="form-item">
                    <label for="name">职务</label>
                    <div> 
                        <input type="text" value="{{data['Position']}}" name="Position" Id="Position"/>
                    </div>           
                </div>
                <br />
                  <br />
                  <div>
                      <input type="submit" class="btn btn-primary" name="submit" id="but_save" onclick="return check()" value="确认"/>&nbsp
                      <button type="reset" class="btn btn-primary" name="cancel" onclick="javascript:history.back()">取消</button>&nbsp
                  </div>
                  <hr class="half-rule" />
                  <div class='footer'>
                    <p class="muted credit grey center" style='color:grey'>Copyright ? <a href='https://github.com/NANNING'>NANNING</a> 2013-2014. All rights reserved.
                        <span class="right"></span>
                    </p>
                  </div>
                </form>
              %else:
                <form action="/manager/ediemployees/0/false/" method="post" role="form">
                <div class="form-item">
                    <label for="name">姓名</label>
                    <div> 
                        <input type="text" value="" placeholder="姓名" name="Name" Id="Name"/>
                    </div>           
                </div>  
                <br/>
                <div class="form-item">
                    <label for="name">性别</label>
                    <div> 
                       <select value="" name="Sex" Id="Sex" style="width:170px;">
                          <option Value="男">男</option>
                          <option Value="女">女</option>

                        </select>
                    </div>           
                </div>
                <br/>
                <div class="form-item">
                    <label for="name">部门</label>
                    <div> 
                      <select value="" name="department" Id="department" style="width:170px;">
                          %for depart in array_depart:                              
                            <option value="{{depart['Id']}}">{{depart['Name']}}</option>                             
                          %end
                      </select>
                    </div>           
                </div>
                <br/>
                <div class="form-item">
                    <label for="name">身份证</label>
                    <div> 
                        <input type="text" value="" placeholder="身份证"  name="IdCard" Id="IdCard"/>
                    </div>           
                </div>
                <br/>
                <div class="form-item">
                    <label for="name">电话</label>
                    <div> 
                        <input type="text" value="" placeholder="电话"  name="Phone" Id="Phone"/>
                    </div>           
                </div>
                <br/>
                <div class="form-item">
                    <label for="name">Email</label>
                    <div> 
                        <input type="text" value="" placeholder="Email"  name="Email" Id="Email"/>
                    </div>           
                </div>
                <br/>
                <div class="form-item">
                    <label for="name">职务</label>
                    <div> 
                        <input type="text" value="" placeholder="职务"  name="Position" Id="Position"/>
                    </div>           
                </div>
                <br />
                  <br />
                  <div>
                      <input type="submit" class="btn btn-primary" name="submit" id="but_save" onclick="return check()" value="确认"/>&nbsp
                      <button type="reset" class="btn btn-primary" name="cancel" onclick="javascript:history.back()">取消</button>&nbsp
                  </div>
                  <hr class="half-rule" />
                  <div class='footer'>
                    <p class="muted credit grey center" style='color:grey'>Copyright ? <a href='https://github.com/NANNING'>NANNING</a> 2013-2014. All rights reserved.
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
    <script src="/assets/static/jquery.form.js"></script>
  </body>
</html>
<script type="text/javascript">
  function check(){
      
      var Name = $("#Name").val();
      if(Name ==''||Name == null){
          alert("请输入姓名")
          $("#Name").focus();
          return false;
      }

      var IdCard  =  $("#IdCard").val();
      var reg = /^[1-9]{1}[0-9]{14}$|^[1-9]{1}[0-9]{16}([0-9]|[xX])$/;
      if(IdCard ==''||IdCard == null || !reg.test(IdCard)){
          alert("请输入有效的身份证号码")
          $("#IdCard").focus();
          return false;
      }
      var Phone  =  $("#Phone").val();
      var reg_phone = /^(((14[0-9]{1})|(18[0-9]{1})|(13[0-9]{1})|159|153)+\d{8})$/; //手机格式
      if(Phone ==''||Phone == null || !reg_phone.test(Phone)){
          alert("请输入有效的联系号码")
          $("#Phone").focus();
          return false;
      }
      var Email  =  $("#Email").val();
      var reg_email = /^\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*$/;
      if(Email ==''|| Email == null ||!reg_email.test(Email)){
          alert("请输入有效的Email地址")
          $("#Email").focus();
          return false;
      }
      var Position  =  $("#Position").val();
      if(Position ==''|| Position == null){
          alert("请输入职务")
          $("#Position").focus();
          return false;
      }

  }



</script>

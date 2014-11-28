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
            <li><a href="/manager/edidepartment/0/false/"><span class="glyphicon glyphicon-plus"></span> 添加部门</a></li>
          </ul>
        </div>
        <div class="col-sm-9 col-sm-offset-3 col-md-10 col-md-offset-2 main">
          <h1 class="page-header">{{companyName}}</h1>
          <div class="table-responsive">
            <table class="table table-striped">
              <thead>
                <tr>
                  <th>名称</th>
                  <th>电话</th>
                  <th>部门经理</th>                 
                  <th>操作</th>             
                </tr>
              </thead>
              <tbody>                
                    %for d in data:
                        <tr>
                          <td>{{ d['Name'] }}</td>                                            
                          <td>{{ d['Phone'] }}</td>
                          <td>{{ d['Leader'] }}</td>
                          <td>
                            <button type="button" class="btn btn-primary" onclick="edi({{d['Id']}},true)">编辑</button>
                            <button type="button" class="btn" onclick="del({{d['Id']}})">删除</button>
                          </td>
                        </tr>
                    %end
              </tbody>
            </table>
          </div>

          <div style='text-align:center;margin:0px auto'>
            <div class="btn-group">
            <button type="button" class="btn btn-default">1</button>
            <button type="button" class="btn btn-default">2</button>
            <button type="button" class="btn btn-default">3</button>
            <button type="button" class="btn btn-default">4</button>
            </div>
          </div>

          <br />
          <br />
          <hr class="half-rule" />
          <div class='footer'>
            <p class="muted credit grey center" style='color:grey'>Copyright © <a href='https://github.com/NANNING'>NANNING</a> 2013-2014. All rights reserved.
                <span class="right"></span>
            </p>
          </div>
        </div>
      </div>
    
    </div>
    <div class="modal js-loading-bar"></div>
    <script src="/assets/static/jquery.min.js"></script>
    <script src="/assets/bootstrap/js/bootstrap.min.js"></script>
  </body>
</html>
<script type="text/javascript">
    function edi(Id,showDetail){
      location.href='/manager/edidepartment/'+Id+'/'+showDetail+'/';
    }
    function del(Id){
        $.getJSON("/manager/deldepartment/"+Id+"/",function(data){
            $.each(data,function(index,value){
               if(value=="success"){
                  alert("删除成功！")
                  location.reload();
               }
               else{
                  alert("删除失败！")
               }

            });

        });
    }
</script>

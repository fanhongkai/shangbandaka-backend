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
            <li class="active"><a href="/manager/listemployees/">全部</a></li>
            %for depart in array_depart:
              <li><a href="/manager/listemployees/{{depart['Id']}}/">{{depart['Name']}}</a></li>
            %end
            <li><a href="/manager/ediemployees/0/false/"><span class="glyphicon glyphicon-plus"></span> 添加员工</a></li>
            <li><hr></li>
            <li><a href="/manager/listdepartment/"><span class="glyphicon glyphicon-th-large"></span>部门管理</a></li>
            <li><a href="/manager/edidepartment/0/false/"><span class="glyphicon glyphicon-plus"></span> 添加部门</a></li>
            
          </ul>

        </div>
        <div class="col-sm-9 col-sm-offset-3 col-md-10 col-md-offset-2 main">
          <h1 class="page-header">{{companyName}}</h1>

          
          <div class="table-responsive">
            <table class="table table-striped" id="example">
              <thead>
                <tr>
                  <th>姓名</th>
                  <th>性别</th>
                  <th>部门</th>
                  <th>职务</th>
                  <th>电话</th>   
                  <th>Email</th>  
                  <th>操作</th>             
                </tr>
              </thead>
              <tbody>                
                    %for d in data:
                        <tr>
                          <td>{{ d['Name'] }}</td>
                          <td>{{ d['Sex'] }}</td>                          
                          <td>{{ d['department']}}</td>                          
                          <td>{{ d['Position'] }}</td>                          
                          <td>{{ d['Phone'] }}</td>
                          <td>{{ d['Email'] }}</td>
                          <td>
                            <button type="button" class="btn btn-primary" onclick="edit({{d['Id']}},true)"><span class="glyphicon glyphicon-pencil"></span>编辑</button>
                            <button type="button" class="btn" onclick="del({{d['Id']}})">
                              <span class="glyphicon glyphicon-remove"></span>删除</button>
                          </td>
                        </tr>
                    %end
              </tbody>
            </table>
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
    <!-- dataTable 插件-->
    <script src="/assets/js/jquery.dataTables.min.js"></script>
    <style type="text/css" title="currentStyle">
        @import "/assets/css/jquery.dataTables.min.css";
    </style>

    <!-- end -->
    <!-- dataTable 插件配置 -->
    <script type="text/javascript">
      $(document).ready(function(){
        $('#example').dataTable(
            {
              "language": {
                      "lengthMenu": "每页显示 _MENU_ 条",
                      "sProcessing": "&lt;img src=’/assets/loading.gif’ /&gt;",
                      "zeroRecords": "没有找到符合条件的数据",
                      "info": "当前第 _PAGE_ 页总共 _PAGES_页",
                      "infoEmpty": "No records available",
                      "infoFiltered": "(filtered from _MAX_ total records)",
                      "sSearch": "查找：",
                      "oPaginate": 
                      {
                        "sFirst": "首页",
                        "sPrevious": "前一页",
                        "sNext": "后一页",
                        "sLast": "尾页"
                      }

                  }
            }

          );

      });
    </script>
   
    <style type="text/css">
        table.dataTable thead th, table.dataTable thead td {
        padding: 10px 18px;
        border-bottom: 1px solid #E8E8E8;
        }
        table.dataTable.no-footer {
          border-bottom: 1px solid #E8E8E8;
        }

    </style>
 <!-- end -->

  </body>
</html>




<script type="text/javascript">
    function edit(Id,showDetail){
      location.href='/manager/ediemployees/'+Id+'/'+showDetail+'/';
    }    
    function del(Id){
        $.getJSON("/manager/delemployees/"+Id+"/",function(data){
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



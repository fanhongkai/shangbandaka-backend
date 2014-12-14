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
    .navbar-inverse .navbar-nav>.regist>a, .navbar-inverse .navbar-nav>.regist>a:hover, .navbar-inverse .navbar-nav>.regist>a:focus {
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
            %for depart in array_depart:
              <li><a href="#">{{depart['Name']}}</a></li>
            %end            
          </ul>

        </div>
        <div class="col-sm-9 col-sm-offset-3 col-md-10 col-md-offset-2 main">
          <h1 class="page-header">{{companyName}}</h1>

          <div class="row placeholders">
            %for item in SingInfo:
                %if item["Id"]==1:                     
                    <div class="col-xs-6 col-sm-3 placeholder">
                        <span class="glyphicon glyphicon-home" style="font-size:36px"></span>
                        <h4>{{item["SignName"]}}</h4>
                        <span class="text-muted">{{item["StartTime"]}}-{{item["EndTime"]}}</span>
                        <br/>
                        <div class="btn-group">
                            <a class="btn btn-primary" href="#"><i class="icon-user icon-white"></i>管理</a>
                            <a class="btn btn-primary dropdown-toggle" data-toggle="dropdown" href="#"><span class="caret"></span></a>
                            <ul class="dropdown-menu">
                              <li><a href="/manager/setSign/{{item["Id"]}}/true/"><i class="icon-pencil"></i> 编辑</a></li>
                              <li><a href="#" onclick="del({{item['Id']}})"><i class="icon-trash"></i> 删除</a></li>
                            </ul>
                        </div>
                      </div>
                   
                %else:
                    
                      <div class="col-xs-6 col-sm-3 placeholder">
                        <span class="glyphicon glyphicon-map-marker" style="font-size:36px"></span>
                        <h4>{{item["SignName"][:8]+'...'}}</h4>
                        <span class="text-muted">{{item["StartTime"]}}-{{item["EndTime"]}}</span>
                        <br/>
                        <div class="btn-group">
                            <a class="btn btn-primary" href="#"><i class="icon-user icon-white"></i>管理</a>
                            <a class="btn btn-primary dropdown-toggle" data-toggle="dropdown" href="#"><span class="caret"></span></a>
                            <ul class="dropdown-menu">
                              <li><a href="/manager/setSign/{{item["Id"]}}/true/"><i class="icon-pencil"></i> 编辑</a></li>
                              <li><a onclick="del({{item['Id']}})"><i class="icon-trash"></i> 删除</a></li>
                            </ul>
                        </div>
                      </div>

                     
                %end
            %end
            <div class="col-xs-6 col-sm-3 placeholder">
              <a href="/manager/setSign/0/false/">
                <span class="glyphicon glyphicon-plus-sign" style="font-size:36px"></span>
                <h4>新增打卡点</h4>
                <span class="text-muted">自定义</span>
              </a>
            </div>
          </div>

          <h2 class="sub-header">
            <label id="text"></label>
            <select style="float:right" onchange="setTime()" Id = "selectTime">              
            </select>
          </h2>
          <div class="table-responsive">
            <table class="table table-striped" id="example">
              <thead>
                <tr>
                  <th>位置</th>
                  <th>姓名</th>
                  <th>职务</th>
                  <th>出勤情况</th>
                  <th>签到时间</th>   
                         
                </tr>
              </thead>
              <tbody>                
                    %for d in data:
                        <tr>
                          
                          <td>{{ d['location']}}</td>
                          <td>{{ d['Name'] }}</td>
                          <td>{{ d['Position']}}</td>                         
                          <td>{{d['WorkStatus']}}</td>
                          <td>{{ d['SingTime']}}</td>
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
    $(function () {
        $("#text").text(showOption(0) + "  打卡情况");

        var option = '<option>' + showOption(0) + '</option>';
        option += '<option>' + showOption(-1) + '</option>';
        option += '<option>' + showOption(-2) + '</option>';
        option += '<option>' + showOption(-3) + '</option>';
        option += '<option>' + showOption(-4) + '</option>';
        option += '<option>' + showOption(-5) + '</option>';
        option += '<option>' + showOption(-6) + '</option>';
        option += '<option>' + showOption(-7) + '</option>';
        $("#selectTime").html(option);

        var datetime = $("#selectTime").val();
       

    });
    function showOption(day) {//获取时间格式2014-11-01
        var dd = new Date();
        dd.setDate(dd.getDate() + day); //获取AddDayCount天后的日期    
        var y = dd.getFullYear();
        // var m = dd.getMonth() + 1; //获取当前月份的日期   
        var m = ((dd.getMonth() + 1) < 10 ? "0" : "") + (dd.getMonth() + 1)
        //var d = dd.getDate();
        var d = (dd.getDate() < 10 ? "0" : "") + dd.getDate()
        var s = y + "-" + m + "-" + d;
        return s

    }
    function del(Id){
      $.getJSON("/manager/delsign/"+Id+"/",function(data){
              $.each(data,function(index,value){
                 if(value=="success"){                   
                    location.reload();
                 }
                 else{
                    alert("删除失败！")
                 }

              });

          });

    }
    function setTime(){
       var datetime = $("#selectTime").val();
        $("#time").val(datetime);
        location.href = '/manager/reportbytime/'+datetime+'/';

    }

</script>
<style type="text/css">
  a:link {
   text-decoration: none;
  }
  a:visited {
   text-decoration: none;
  }
  a:hover {
   text-decoration: none;
  }
  a:active {
   text-decoration: none;
  }
  .btn-primary {
  color: #fff;
  background-color: #878787;
  border-color: #878787;
  }
  .btn-primary:hover, .btn-primary:focus, .btn-primary:active, .btn-primary.active, .open .dropdown-toggle.btn-primary {
color: #fff;
background-color: #878787;
border-color: #878787;
}

</style>
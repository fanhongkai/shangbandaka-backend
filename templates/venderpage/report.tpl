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
  <body style='padding-top:60px'>
    <div class="navbar navbar-fixed-top navbar-inverse" role="navigation">
      <div class="container">
        <div class="navbar-header">
          <a class="navbar-brand" style='padding:15px 10px;margin-left:0px' href="javascript:milib.close()"><!--span class="glyphicon glyphicon-th-large"></span--><img src='/assets/static/img/logo.png' /></a>
          <a class="navbar-brand" style='padding:15px 15px 15px 5px;margin-left:0px;font-size:20px' href="#">上班打卡</a>
        </div>

        <div class="navbar-collapse collapse">
          <ul class="nav navbar-nav navbar-right">
            <li><a href="#">管理</a></li>
            <li><a href="#">设置</a></li>
            <li><a href="#">帮助</a></li>
            <li><a href="#">注销</a></li>
          </ul>
          <form class="navbar-form navbar-right">
            <input type="text" class="form-control" placeholder="员工姓名">
          </form>
        </div>

      </div><!-- /.container -->
    </div><!-- /.navbar -->

    <div class="container-fluid">
      <div class="row">
        <div class="col-sm-3 col-md-2 sidebar">
          <ul class="nav nav-sidebar">
            <li class="active"><a href="#">全部</a></li>
            <li><a href="#">开发</a></li>
            <li><a href="#">市场</a></li>
            <li><a href="#">销售</a></li>
            <li><a href="#">&nbsp;</a></li>
            <li><a href="#">添加部门</a></li>
          </ul>

        </div>
        <div class="col-sm-9 col-sm-offset-3 col-md-10 col-md-offset-2 main">
          <h1 class="page-header">趣味无限有限公司</h1>

          <div class="row placeholders">
            <div class="col-xs-6 col-sm-3 placeholder">
              <span class="glyphicon glyphicon-home" style="font-size:36px"></span>
              <h4>趣味大厦A座</h4>
              <span class="text-muted">9：00 - 20：00</span>
            </div>
            <div class="col-xs-6 col-sm-3 placeholder">
              <span class="glyphicon glyphicon-map-marker" style="font-size:36px"></span>
              <h4>联通驻场</h4>
              <span class="text-muted">9：00 - 20：00</span>
            </div>
            <div class="col-xs-6 col-sm-3 placeholder">
              <span class="glyphicon glyphicon-plus-sign" style="font-size:36px"></span>
              <h4>新增打卡点</h4>
              <span class="text-muted">自定义</span>
            </div>
          </div>

          <h2 class="sub-header">2014-07-07 打卡情况 <select style='float:right'><option>2014/07/07</option><option>2014/07/06</option></select></h2>
          <div class="table-responsive">
            <table class="table table-striped">
              <thead>
                <tr>
                  <th>位置</th>
                  <th>姓名</th>
                  <th>职务</th>
                  <th>时间</th>
                  <th>Email</th>
                </tr>
              </thead>
              <tbody>
                <tr>
                  <td><span class="glyphicon glyphicon-home"></span></td>
                  <td>李援美</td>
                  <td>产品经理</td>
                  <td>9:00</td>
                  <td>yuanmei@quwei.com</td>
                </tr>
                <tr>
                  <td><span class="glyphicon glyphicon-map-marker"></span></td>
                  <td>王康</td>
                  <td>工程师</td>
                  <td>8:59</td>
                  <td>wangkang@quwei.com</td>
                </tr>
                <tr>
                  <td><span class="glyphicon glyphicon-map-marker"></span></td>
                  <td>周洲</td>
                  <td>设计师</td>
                  <td>10:00</td>
                  <td>zhouzhou@quwei.com</td>
                </tr>
                <tr>
                  <td><span style='color:grey'>请假</span></td>
                  <td>李跃</td>
                  <td>工程师</td>
                  <td>10:00</td>
                  <td>liyue@quwei.com</td>
                </tr>

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

        </div>
      </div>
    </div>


    <div class="container main pt-10"></div><!--/.container-->

    <div class="modal js-loading-bar"></div>

    <script src="/assets/static/jquery.min.js"></script>
    <script src="/assets/bootstrap/js/bootstrap.min.js"></script>
  </body>
</html>

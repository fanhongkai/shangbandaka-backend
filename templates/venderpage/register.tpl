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
      <form action="" method="post" class="form-signin" role="form">
        <h3 class='center ml-not'>企业注册</h3>
        <span style='color:grey'>用户名:</span><br />
        <input type="text" name="username" class="form-control" value="" placeholder="用户名"  autocomplete='off'>
        
        <br />
        <span style='color:grey'>密码:</span><br />
        <input type="password" name="passwd" class="form-control" value="" placeholder="密码"  autocomplete='off'>

        <br />

        <span style='color:grey'>公司名称:</span><br />
        <input type="text" name="company_name" class="form-control" value="" placeholder="公司名称"  autocomplete='off'>
        <br />

        <span style='color:grey'>公司营业执照附件:</span><br />
        <input type="file" name="company_id" class="form-control" value="" placeholder="营业执照附件"  autocomplete='off'>
        <br />

        <span style='color:grey'>公司人数:</span><br />
        <input type="text" name="company_number" class="form-control" value="" placeholder="公司人数"  autocomplete='off'>

        <br />
        <span style='color:grey'>联系人:</span><br />
        <input type="text" name="company_contact" class="form-control" value="" placeholder="联系人"  autocomplete='off'>

        <br />
        <span style='color:grey'>联系电话:</span><br />
        <input type="text" name="company_phone" class="form-control" value="" placeholder="联系电话"  autocomplete='off'>

        <br />
        <span style='color:grey'>联系邮箱:</span><br />
        <input type="text" name="company_email" class="form-control" value="" placeholder="联系邮箱"  autocomplete='off'>





        <br />
        <span><font color='red'>{{register_status}}</font></span>
        <button class="btn btn-lg btn-primary btn-block" type="submit" id='vender-login' name="submit" value="submit">提交申请</button>
        <br />
        <span style="color:grey"><a href='/manager/'>登录 >></a>  </span>
      </form>
    </div><!--/.container-->
    <div class="modal js-loading-bar"></div>

    <script src="/assets/static/jquery.min.js"></script>
    <script src="/assets/bootstrap/js/bootstrap.min.js"></script>
  </body>
</html>

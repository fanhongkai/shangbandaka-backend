﻿<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="description" content="">
    <meta name="author" content="">
    <link rel="shortcut icon" href="/assets/static/favicon.ico">
    <title>�ϰ��(����ϵͳ)</title>
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
            <li class="active"><a href="#">ȫ��</a></li>
            <li><a href="#">����</a></li>
            <li><a href="#">�г�</a></li>
            <li><a href="#">����</a></li>
            <li><a href="/manager/listDepartment/">����</a></li>
            <li><a href="#"><span class="glyphicon glyphicon-plus"></span> ��Ӳ���</a></li>
          </ul>

        </div>
        <div class="col-sm-9 col-sm-offset-3 col-md-10 col-md-offset-2 main">
          <h1 class="page-header">{{companyName}}</h1>
            <div>
              %if showDetail:
                <form action="/manager/ediemployees/{{data['Id']}}/true/" method="post" role="form">
                <div class="form-item">
                    <label for="name">����</label>
                    <div> 
                        <input type="text" value="{{data['Name']}}" name="Name" Id="d_Name"/>
                    </div>           
                </div>  
                <br/>
                <div class="form-item">
                    <label for="name">�Ա�</label>
                    <div> 
                        <input type="select" value="{{data['Sex']}}" name="Sex" Id="Sex"/>
                    </div>           
                </div>
                <br/>
                <div class="form-item">
                    <label for="name">���֤��</label>
                    <div> 
                        <input type="text" value="{{data['IdCard']}}" name="IdCard" Id="IdCard"/>
                    </div>           
                </div>
                <br/>
                <div class="form-item">
                    <label for="name">�绰</label>
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
                    <label for="name">ְ��</label>
                    <div> 
                        <input type="text" value="{{data['Position']}}" name="Position" Id="Position"/>
                    </div>           
                </div>
                <br />
                  <br />
                  <div>
                      <input type="submit" class="btn btn-primary" name="submit" id="but_save" onclick="return check()" value="ȷ��"/>&nbsp
                      <button type="reset" class="btn btn-primary" name="cancel" onclick="javascript:history.back()">ȡ&nbsp ��</button>&nbsp
                  </div>
                  <hr class="half-rule" />
                  <div class='footer'>
                    <p class="muted credit grey center" style='color:grey'>Copyright ? <a href='https://github.com/NANNING'>NANNING</a> 2013-2014. All rights reserved.
                        <span class="right"></span>
                    </p>
                  </div>
                </form>
              %else:
                <form action="/manager/ediemployees/{{data['Id']}}/true/" method="post" role="form">
                <div class="form-item">
                    <label for="name">����</label>
                    <div> 
                        <input type="text" value="" name="Name" Id="d_Name"/>
                    </div>           
                </div>  
                <br/>
                <div class="form-item">
                    <label for="name">�Ա�</label>
                    <div> 
                        <input type="select" value="" name="Sex" Id="Sex"/>
                    </div>           
                </div>
                <br/>
                <div class="form-item">
                    <label for="name">���֤��</label>
                    <div> 
                        <input type="text" value="" name="IdCard" Id="IdCard"/>
                    </div>           
                </div>
                <br/>
                <div class="form-item">
                    <label for="name">�绰</label>
                    <div> 
                        <input type="text" value="" name="Phone" Id="Phone"/>
                    </div>           
                </div>
                <br/>
                <div class="form-item">
                    <label for="name">Email</label>
                    <div> 
                        <input type="text" value="" name="Email" Id="Email"/>
                    </div>           
                </div>
                <br/>
                <div class="form-item">
                    <label for="name">ְ��</label>
                    <div> 
                        <input type="text" value="" name="Position" Id="Position"/>
                    </div>           
                </div>
                <br />
                  <br />
                  <div>
                      <input type="submit" class="btn btn-primary" name="submit" id="but_save" onclick="return check()" value="ȷ��"/>&nbsp
                      <button type="reset" class="btn btn-primary" name="cancel" onclick="javascript:history.back()">ȡ&nbsp ��</button>&nbsp
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

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

    <script src="/assets/static/jquery.min.js"></script>
    <script src="/assets/dist/bootstrap-clockpicker.min.js"></script>
    <script src="/assets/dist/jquery-clockpicker.min.js"></script>
    <link href="/assets/dist/bootstrap-clockpicker.min.css" rel="stylesheet">
    <link href="/assets/dist/jquery-clockpicker.min.css" rel="stylesheet">
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

        </div>
        <div class="col-sm-9 col-sm-offset-3 col-md-10 col-md-offset-2 main">
          <h1 class="page-header">{{companyName}}</h1>
          <div class="table-responsive">
            
            <script type="text/javascript" src="http://api.map.baidu.com/api?v=2.0&ak=VdsvShdGqvkx8DozC4FPEifr"></script>
            <div id="l-map">
            </div>
            <style type="text/css">
        body, html{width: 100%;height: 100%;margin:0;font-family:"微软雅黑";font-size:14px;}
        #l-map{height:300px;width:100%;}
        #r-result{width:100%; margin-top: 10px;}
    </style>
    <script type="text/javascript" src="http://api.map.baidu.com/api?v=2.0&ak=VdsvShdGqvkx8DozC4FPEifr"></script>
    
</head>

<body>
    
    <script type="text/javascript">
    // 百度地图API功能
    function G(id) {
        return document.getElementById(id);
    }

    var map = new BMap.Map("l-map");
    map.centerAndZoom("南宁",15);                   // 初始化地图,设置城市和地图级别。

    var ac = new BMap.Autocomplete(    //建立一个自动完成的对象
        {"input" : "suggestId",location : map});

    ac.addEventListener("onhighlight", function(e) {  //鼠标放在下拉列表上的事件

    var str = "";
        var _value = e.fromitem.value;
        var value = "";
        if (e.fromitem.index > -1) {
            value = _value.province +  _value.city +  _value.district +  _value.street +  _value.business;
        }    
        str = "FromItem<br />index = " + e.fromitem.index + "<br />value = " + value;
        
        value = "";
        if (e.toitem.index > -1) {
            _value = e.toitem.value;
            value = _value.province +  _value.city +  _value.district +  _value.street +  _value.business;
        }    
        str += "<br />ToItem<br />index = " + e.toitem.index + "<br />value = " + value;
        G("searchResultPanel").innerHTML = str;
    });

    var myValue;
    ac.addEventListener("onconfirm", function(e) {    //鼠标点击下拉列表后的事件
    var _value = e.item.value;
        myValue = _value.province +  _value.city +  _value.district +  _value.street +  _value.business;
        G("searchResultPanel").innerHTML ="onconfirm<br />index = " + e.item.index + "<br />myValue = " + myValue;
        
        setPlace();
    });

    function setPlace(){
        map.clearOverlays();    //清除地图上所有覆盖物
        function myFun(){
            var pp = local.getResults().getPoi(0).point;    //获取第一个智能搜索的结果
            map.centerAndZoom(pp, 18);
            map.addOverlay(new BMap.Marker(pp));    //添加标注

            $("#PutText").val(pp.lat + "," + pp.lng)//将经度与纬度保存到hidden控件中
        }
        var local = new BMap.LocalSearch(map, { //智能搜索
          onSearchComplete: myFun
        });
        local.search(myValue);
    }
              
</script>

    <form id="_form" method="post" action="/manager/setSign/0/false/">
            <div id="r-result">
                <input type="hidden" id="location" />
                <div class="well">
                    <label>
                        请输入地址:</label>
                    <div class="sub">                         
                        %if showDetail:                          
                                      
                           <div id="r-result">
                            <input type="text" id="_suggestId" name="suggestId" size="50" 
                              value="{{data['SignName']}}"/>
                              
                            </div>
                              
                            <div id="searchResultPanel" style="border:1px solid #C0C0C0;width:150px;height:auto; display:none;"></div>
                        %else:
                        
                            <div id="r-result"><input type="text" id="suggestId" name="suggestId" size="50" value="百度"/></div>
                        <div id="searchResultPanel" style="border:1px solid #C0C0C0;width:150px;height:auto; display:none;"></div>
                        
                        %end
                    </div>
                    <label style="color: Red; font-size: 5px;">
                        *请输入地址，然后选择下拉列表中的地址详情</label>
                </div>
                <div class="well">
                    <div>
                        <div style="width: 200px; float: left">
                            <label>
                                开始签到时间：</label>
                            <div id="datetimepicker3" class="input-append">
                                %if showDetail:
                                
                                    <div class="input-group clockpicker" data-placement="left" data-align="top" data-autoclose="true">
                                    <input type="text" class="form-control" value="{{data['StartTime']}}" name="startTime" id="startTime"/>
                                    <span class="input-group-addon">
                                        <span class="glyphicon glyphicon-time"></span>
                                    </span>
                                    </div>
                                    <script type="text/javascript">
                                        $('.clockpicker').clockpicker();
                                    </script>
                                   
                                
                                %else:
                                 
                                    
                                    <div class="input-group clockpicker" data-placement="left" data-align="top" data-autoclose="true">
                                    <input type="text" class="form-control"value="08:30" name="startTime" id="startTime"/>
                                    <span class="input-group-addon">
                                        <span class="glyphicon glyphicon-time"></span>
                                    </span>
                                    </div>
                                    <script type="text/javascript">
                                        $('.clockpicker').clockpicker();
                                    </script>
                                    
                                
                                %end
                            </div>
                        </div>
                        <div style="width: 200px;">
                            <label>
                                结束签到时间：</label>
                            <div id="datetimepicker1" class="input-append">
                                %if showDetail:
                                
                                    
                                    <div class="input-group clockpicker" data-placement="left" data-align="top" data-autoclose="true">
                                    <input type="text" class="form-control" value="{{data['EndTime']}}" name="endTime" id="endTime"/>
                                    <span class="input-group-addon">
                                        <span class="glyphicon glyphicon-time"></span>
                                    </span>
                                    </div>
                                    <script type="text/javascript">
                                        $('.clockpicker').clockpicker();
                                    </script>
                                %else:
                                
                                    <div class="input-group clockpicker" data-placement="left" data-align="top" data-autoclose="true">
                                    <input type="text" class="form-control" value="09:00" name="endTime" id="endTime"/>
                                    <span class="input-group-addon">
                                        <span class="glyphicon glyphicon-time"></span>
                                    </span>
                                    </div>
                                    <script type="text/javascript">
                                        $('.clockpicker').clockpicker();
                                    </script>
                                    
                                
                                %end
                            </div>
                        </div>
                    </div>
                </div>
                <div class="sub">
                    <input type="hidden" id="PutText" name="PutText" />
                    <!-- <button type="button" id="butSub" class="btn btn-primary">
                        确认</button> -->
                    <input type="submit" value="确认" id="butsub" name="submit" class="btn btn-primary" />
                    &nbsp
                    <button type="button" class="btn btn-primary" onclick="javascript:history.back()">
                        取&nbsp 消</button>&nbsp
                </div>
            </div>
            </form>
</body>
</html>

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


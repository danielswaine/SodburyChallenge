function clk(){var a=new Date,b=a.getHours(),a=a.getMinutes();9>=a&&(a="0"+a);9>=b&&(b="0"+b);document.getElementById("clock").innerHTML=b+":"+a}window.onload=function(){clk();setInterval(clk,200)};

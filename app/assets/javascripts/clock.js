var localOffset = 0;
var zoneOffset = 0;

window.onload = function() {
  synchronise();
  setInterval(synchronise, 300000);
  setInterval(display, 200);
}

function display() {
  var localTime = new Date().getTime();
  var officialTime = new Date(localTime + zoneOffset - localOffset);
  var h = officialTime.getUTCHours();
  var m = officialTime.getUTCMinutes();
  if (h < 10) {
    h = "0" + h;
  }
  if (m < 10) {
    m = "0" + m;
  }
  $(".clock").html(h + ":" + m);
}

function synchronise() {
  $.ajax({
    type: "GET",
    url: "/time"
  }).done( function evaluate(serverTime) {
    zoneOffset =  serverTime.zone
    localOffset = new Date().getTime() - serverTime.unix;
  });
}

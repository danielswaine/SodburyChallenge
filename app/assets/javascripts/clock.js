var localOffset = 0;

window.onload = function() {
  displayTime();
  getOffset();
  setInterval(displayTime, 200);
  setInterval(getOffset, 300000);
}

function displayTime() {
  var localTime = new Date().getTime();
  var officialTime = new Date(localTime - localOffset);
  var h = officialTime.getHours();
  var m = officialTime.getMinutes();
  if (h < 10) {
    h = "0" + h;
  }
  if (m < 10) {
    m = "0" + m;
  }
  $("#clock").html(h + ":" + m);
}

function getOffset() {
  $.ajax({
    type: "GET",
    url: "/time"
  }).done( function calculateOffset(serverTime) {
    localOffset = new Date().getTime() - serverTime;
  });
}

window.addEventListener('DOMContentLoaded', init, false);
function init() {
  var legends = document.getElementsByClassName('legend');
  for (var i = 0, length = legends.length; i < length; i++) {
    legends[i].addEventListener('click', toggle, false);
  }
}
function toggle() {
  target_id = this.id.split('_')[0];
  target = document.getElementById(target_id);
  opacity = target.getAttribute('fill-opacity');
  if (opacity == 0) {
    target.setAttribute('fill-opacity', 0.25);
  } else {
    target.setAttribute('fill-opacity', 0);
  }
}
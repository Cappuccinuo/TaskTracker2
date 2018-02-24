// Brunch automatically concatenates all files in your
// watched paths. Those paths can be configured at
// config.paths.watched in "brunch-config.js".
//
// However, those files will only be executed if
// explicitly imported. The only exception are files
// in vendor, which are never wrapped in imports and
// therefore are always executed.

// Import dependencies
//
// If you no longer want to use a dependency, remember
// to also remove its path from "config.paths.watched".
import "phoenix_html";
import $ from "jquery";

// Import local files
//
// Local files can be imported directly using relative
// paths "./socket" or full ones "web/static/js/socket".

// import socket from "./socket"
function update_buttons() {
  $('.start-end-button').each((_, bb) => {
    let task_id = $(bb).data('task-id');
    let time_id = $(bb).data('time-id');
    if (count % 2 == 0) {
      $(bb).text("Stop");
    }
    else {
      $(bb).text("Start");
    }
  });
}

function stop(task_id, time_id) {
  alert("stop");
}

function start(task_id) {
  x = new Date();
  alert(x);
}

function control_click(ev) {
  let btn = $(ev.target);
  let task_id = btn.data('task-id');
  let time_id = btn.data('time-id');
  if (time_id != "") {
    stop(task_id);
  }
  else {
    start(task_id);
  }
}

function init_control() {
  if (!$('.start-end-button')) {
    return;
  }
  $(".start-end-button").click(control_click);
  //update_buttons();
}

$(init_control);

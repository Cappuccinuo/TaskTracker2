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
    let completed = $(bb).data('completed');
    if (completed == true) {
      $(bb).text("Start");
    }
    else if (time_id != "") {
      $(bb).text("Stop");
    }
    else {
      $(bb).text("Start");
    }
  });
}

function set_button(task_id, time_id, completed) {
  $('.start-end-button').each((_, bb) => {
    if (task_id == $(bb).data('task-id')) {
      $(bb).data('time-id', time_id);
      $(bb).data('completed', completed);
    }
  });
  update_buttons();
}

function stop(task_id, time_id) {
  let text = JSON.stringify({
    time: {
      end_time: new Date(),
      completed: true
    },
  });
  $.ajax(time_path + "/" + time_id, {
    method: "put",
    dataType: "json",
    contentType: "application/json; charset=UTF-8",
    data: text,
    success: (resp) => { set_button(task_id, resp.data.id, true) },
  });
}

function start(task_id) {
  let text = JSON.stringify({
    time: {
      task_id: task_id,
      start_time: new Date(),
      end_time: new Date(0),
      completed: false
    },
  });
  $.ajax(time_path, {
    method: "post",
    dataType: "json",
    contentType: "application/json; charset=UTF-8",
    data: text,
    success: (resp) => { set_button(task_id, resp.data.id, false); },
  });
}

function restart(task_id, time_id) {
  let text = JSON.stringify({
    time: {
      task_id: task_id,
      end_time: new Date(0),
      completed: false
    },
  });
  $.ajax(time_path + "/" + time_id, {
    method: "put",
    dataType: "json",
    contentType: "application/json; charset=UTF-8",
    data: text,
    success: (resp) => { set_button(task_id, resp.data.id, false) },
  });
}

function control_click(ev) {
  let btn = $(ev.target);
  let task_id = btn.data('task-id');
  let time_id = btn.data('time-id');
  let completed = btn.data('completed');
  if (completed == true) {
    start(task_id);
  }
  else if (time_id != "") {
    stop(task_id, time_id);
  }
  else {
    start(task_id);
  }
}

function control_click_delete(ev) {
  let btn = $(ev.target);
  let time_id = btn.data('time-id');
  $.ajax(time_path + "/" + time_id, {
    method: "delete",
    dataType: "json",
    contentType: "application/json; charset=UTF-8",
    data: "",
    success: () => {alert("delete")}
  });
}

function init_control() {
  if (!$('.start-end-button') || !$('.delete-button')) {
    return;
  }
  $(".start-end-button").click(control_click);
  $(".delete-button").click(control_click_delete);
  update_buttons();
}

$(init_control);

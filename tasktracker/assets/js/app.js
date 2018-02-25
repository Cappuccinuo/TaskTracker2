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

function finish_current_task(task_id, time_id, end_time) {
  let text = JSON.stringify({
    time: {
      task_id: task_id,
      end_time: end_time,
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
  let task_id = btn.data('task-id');
  let time_id = btn.data('time-id');
  $.ajax(time_path + "/" + time_id, {
    method: "delete",
    dataType: "json",
    contentType: "application/json; charset=UTF-8",
    data: "",
    success: () => { set_button(task_id, "", "") }
  });
}

function control_click_submit(ev) {
  let btn = $(ev.target);
  let task_id = btn.data('task-id');
  let time_id = btn.data('time-id');
  let start_time = $('.start-time').val();
  let end_time = $('.end-time').val();
  let completed = btn.data('completed');
  if (!completed && start_time != "") {
    alert("You must finish current task time frame.");
    return;
  }
  if (!completed && start_time == "" && end_time != "") {
    finish_current_task(task_id, time_id, end_time);
  }
  else {
    if (end_time == "") {
      end_time = new Date(0);
    }
    alert(start_time);
    alert(end_time);
    let text = JSON.stringify({
      time: {
        task_id: task_id,
        start_time: start_time,
        end_time: end_time,
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
}

function init_control() {
  if (!$('.start-end-button') && !$('.delete-button') && !$('.submit-button')) {
    return;
  }
  if ($('.start-end-button')) {
    $(".start-end-button").click(control_click);
  }
  if ($('.delete-button')) {
    $(".delete-button").click(control_click_delete);
  }
  if ($('.submit-button')) {
    $(".submit-button").click(control_click_submit);
  }
  update_buttons();
}

$(init_control);

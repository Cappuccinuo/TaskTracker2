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
    success: () => { set_button(task_id, "", true) }
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
  if (start_time == "" && end_time == "") {
    alert("Time cannot be empty")
    return;
  }
  if (end_time == "") {
    alert("End time cannot be empty");
    return;
  }
  if (start_time == "") {
    alert("Start time cannot be empty");
    return;
  }
  if (start_time > end_time) {
    alert("Start time must be earlier than end time");
    return;
  }
  let text = JSON.stringify({
    time: {
      task_id: task_id,
      start_time: start_time,
      end_time: end_time,
      completed: true
    },
  });
  $.ajax(time_path, {
    method: "post",
    dataType: "json",
    contentType: "application/json; charset=UTF-8",
    data: text,
    success: (resp) => { set_button(task_id, resp.data.id, true); },
  });
}

function control_click_edit(ev) {
  let btn = $(ev.target);
  let task_id = btn.data('task-id');
  let time_id = btn.data('time-id');
  let sebtn = $('.start-end-button');
  let current_time = sebtn.data('time-id');
  let current_task = sebtn.data('task-id');
  let current_com = sebtn.data('completed');
  let start_time = $('.start-time').val();
  let end_time = $('.end-time').val();
  let completed = btn.data('completed');
  if (!current_com && current_time != time_id) {
    alert("Please finish the unfinished task first.");
    return;
  }
  if (start_time == "" && end_time == "") {
    alert("Time cannot be empty")
    return;
  }
  if (end_time == "") {
    alert("End time cannot be empty");
    return;
  }
  if (start_time == "") {
    alert("Start time cannot be empty");
    return;
  }
  if (start_time > end_time) {
    alert("Start time must be earlier than end time");
    return;
  }
  let text = JSON.stringify({
    time: {
      task_id: task_id,
      start_time: start_time,
      end_time: end_time,
      completed: true
    },
  });
  $.ajax(time_path + "/" + time_id, {
    method: "put",
    dataType: "json",
    contentType: "application/json; charset=UTF-8",
    data: text,
    success: (resp) => { alert("Edit success.") },
  });
}

function init_control() {
  if (!$('.start-end-button') && !$('.delete-button') && !$('.submit-button') && !$('.edit-button')) {
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
  if ($('.edit-button')) {
    $(".edit-button").click(control_click_edit);
  }
  update_buttons();
}

$(init_control);

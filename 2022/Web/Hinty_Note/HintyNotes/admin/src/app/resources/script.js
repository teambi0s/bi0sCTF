//SETUP DESKTOP
const desktop = {};
//DRAG
desktop.drag = function() {
  $(".drag").draggable({ handle: ".appToolBar" });
};

//WINDOW TOOLBAR
desktop.window = function() {
  $(".close").on("click", function() {
    $(this)
      .closest(".window")
      .fadeOut(200);
  });
  $('.notepadIcon').dblclick(function(){
        $('.window').show().find("textarea").focus();
  })  

  $(".close1").on("click", function() {
    $(this)
      .closest(".window1")
      .fadeOut(200);
  });
  $('.notepadIcon1').dblclick(function(){
        $('.window1').show().find("input").focus();
  })
  $(".close2").on("click", function() {
    $(this)
      .closest(".window2")
      .fadeOut(200);
  });
  $('.notepadIcon2').dblclick(function(){
        $('.window2').show().find("input").focus();
  })
};

//NOTEPAD
desktop.notepad = function() {
  let notepadText = "Type something! Close the window! Double-click the icon! Don't forget to SAVE your work before closing the window!";
  //1.POPULATE TEXTAREA WITH STRING STORED IN NOTEPAD VARIABLE
  $(".notepadTextArea").val(`${notepadText}`);
  //2.PRESS SAVE TO SAVE TEXTAREA TO NOTEPAD VARIABLE (OVERWRITE)
  $(".save").on("click touchstart", function() {
    notepadText = $(".notepadTextArea").val();
  });
  $(".notepadClose").on("click touchstart", function() {
    $(".notepadTextArea").val(`${notepadText}`);
  });
};

//SETUP INIT
desktop.init = function() {
  desktop.drag();
  desktop.window();
  desktop.notepad();
};

//INITIALIZE
$(function() {
  desktop.init();
});
  $(function(){
    //確定未定情報の切り替え
    $('#fix_label').on('click',function(){
      var text = $(this).text();
      if(text == "未定"){
        $(this).text('確定');
      }else{
        $(this).text('未定');
      }
    });
    $('#check_label').on('click',function(){
      var text = $(this).text();
      if(text == "清算済"){
        $(this).text('未清算');
      }else{
        $(this).text('清算済');
      }
    });

    // オートコンプリート
    $( "#place_name" ).autocomplete({
      autoFocus: true,
      source: "/schedules/autocomplete_place_name.json",
      minLength: 0,
    });
    $( "#program" ).autocomplete({
      autoFocus: true,
      source: "/schedules/autocomplete_program",
      minLength: 0,
    });
    $( "#performer" ).autocomplete({
      autoFocus: true,
      source: "/schedules/autocomplete_performer",
      minLength: 0,
    });
    $( "#seat_type" ).autocomplete({
      autoFocus: true,
      source: ["SS","S","A","B"],
      minLength: 0,
    });
    $( "#otherside_name" ).autocomplete({
      autoFocus: true,
      source: "/schedules/autocomplete_otherside_name",
      minLength: 0,
    });
  });
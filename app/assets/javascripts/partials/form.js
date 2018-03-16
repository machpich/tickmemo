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

//文字数カウント
    var countMax = 120;
    $('textarea').bind('keydown keyup keypress change',function(){
        var thisValueLength = $(this).val().length;
        var countDown = (countMax)-(thisValueLength);
        $('.count').html(countDown);

        if(countDown < 0){
            $('.count').css({color:'#ff0000',fontWeight:'bold'});
        }
    });
    $(window).load(function(){
        $('.count').html(countMax);
    });

// 立替関係の取引を選んだときだけ立替が表示
    $('#journal_trade_type_id').on('change',function(){
      var selectVal = $("#journal_trade_type_id option:selected").val();
      var othersideVal = $('#otherside_name').val();
      console.log(othersideVal);

      if (othersideVal == ""){
        if (selectVal>=6){
          $('#otherside_field').removeClass('hidden')
        } else {
          $('#otherside_field').addClass('hidden')
        };
      };
    });

//今日の日付を自動でフォームに入力
    $('#journal_trade_date').focus(function(){
    var date = new Date();
        var yyyy = date.getFullYear();
        var mm = ("0"+(date.getMonth()+1)).slice(-2);
        var dd = ("0"+date.getDate()).slice(-2);
      $(this).val(yyyy+'-'+mm+'-'+dd);
    });

// memo表示の切り替え
    $('#memo_btn').on('click',function(){
      $(this).parents().find('.memos').toggleClass('hidden');
    });

// journal#index画面の切り替え
    $('#related_schedule').click(function(){
      $(this).next().toggleClass('hidden');
    });
    $('#total_loan').click(function(){
      $(this).next().toggleClass('hidden');
    });
});
$(document).on("ajax:success",'.add_note',function(data,response,event){
	console.log(response);
	if(response.status == "success"){
		$("#notes_list").append(
			"<div align='left' class='panel panel-info'>"+
			   " <div class='panel-heading'>"+  
                   "By:   "+response.by+ "</div>"+
			"<div class='panel-body'>"+
                   response.description + "</br>"+   
                   "</div> </div><br>"
                   );
	$(".add_note_btn").show();
	if($(".note_form").length !=0)
		$(".note_form").hide();
	}
	else{
		alert("Note can't be blank");
	}	
});

$(document).on("click",".add_note_btn",function(){
	if( $(".add_note_btn").length !=0 )
			$(".add_note_btn").hide();
	$(".note_form").show();
});


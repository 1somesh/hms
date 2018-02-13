jQuery(function() {
  $("a.fancybox").fancybox();
});

	
function get_appointment_slot(data,event){

	year = $("#appointment_date_1i").val();
	month = $("#appointment_date_2i").val();
	day = $("#appointment_date_3i").val();
	date = year+"-"+month+"-"+day;
	$.ajax({
		url: "/appointments/slots",
		type: "post",
		data: {
			date: date,
			doctor_id: $("#appointment_doctor_id").val()

		},
		success: function(response){
				if(response.status=="success"){
						if(response.slots.length!=0){

							$(".slot_item").html(create_list(response));
							$('.slot_item').show();
						}
						else{
							if( $(".slot_item").length !=0 )
								$(".slot_item").hide();
							alert("no slots avilable for today");
						}
				}
				else{
				    if( $(".slot_item").length !=0 )
						$('.slot_item').hide();
						alert("please select a future date");
				}
		},
		error: function(response){
			alert(response);
		}
	}
		)
	;}


$(document).on("click",".add_note_btn",function(){
	if( $(".add_note_btn").length !=0 )
			$(".add_note_btn").hide();
			$(".note_form").show();
});


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
	if( $(".note_form").length !=0 )
		$(".note_form").hide();
	}
	else{
		alert("Note can't be blank");
	}	
})


function create_list(response){
	list = response.slots.map(slot => "<div class=slot_item ><input type=radio value="+slot+":00:00 name=appointment[start_time]> "+ 
								slot+":00 AM"
								+"<br></div>");
	return list;
}

$(document).on('change','.remove_slot_list',function () {
		if( $(".slot_item").length !=0 )

	$('.slot_item').hide();
})

$(document).on('change','#appointment_date_3i',function () {

 get_appointment_slot();

})
$(document).on('change','#appointment_date_2i',function () {
 get_appointment_slot();
	
})
$(document).on('change','#appointment_date_1i',function () {
 get_appointment_slot();

})

$(document).on('change','#user_image',function(){
	$(".profile_image_upload").append("<input type = 'submit' value='Change Picture'>");
})

$(document).on('change',"#user_role",function(){
	if($("#user_role").val()=="doctor"){
		$("#doctor_duration").show();
	}
	else{
		$("#doctor_duration").hide();
	}
})

$(document).ready(function(){
		if($("#user_role").val()=="patient")
		$("#doctor_duration").hide();
})

// $(document).ready(function(){
//     $(".nav-tabs a").click(function(){
//     	alert("hi");
//         $(this).tab('show');
//     });
//     $('.nav-tabs a').on('shown.bs.tab', function(event){
//     	alert("hi");
//         var x = $(event.target).text();         // active tab
//         var y = $(event.relatedTarget).text();  // previous tab
//         $(".act span").text(x);
//         $(".prev span").text(y);
//     });
// });

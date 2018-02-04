
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
						}
						else{
							$(".slot_item").remove();
							alert("no slots avilable for today");
						}
				}
				else{
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
			$(".add_note_btn").hide();
			$(".note_form").show();
});


$(document).on("ajax:success",'.add_note',function(data,response,event){
	console.log(response);
	if(response.status == "success"){
		$("#notes_list").append("<div align='left' style='border: solid thin;width: 800px;padding-top: 10px;word-wrap: break-word;;' id='notes_list'>"+
                   response.description + "</br>"+  
                   " <div align='right' style='color: rgb(40,20,0);'>"+  
                   "By:   "+response.by+ 
                   "</div> </div><br>"
                   );
	$(".add_note_btn").show();
	$(".note_form").hide();
	}
	else{
		alert("Note can't be blank");
	}	
})


function create_list(response){
	list = response.slots.map(slot => "<div class=slot_item ><input type=radio value="+slot+":00:00 name=appointment[start_time]>"+ 
								slot+":00 PM"
								+"<br></div>");
	return list;
}
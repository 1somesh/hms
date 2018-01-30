
function get_appointment_slot(data,event){

	year = document.getElementById("appointment_date_1i").value
	month = document.getElementById("appointment_date_2i").value
	day = document.getElementById("appointment_date_3i").value
	date = year+"-"+month+"-"+day


	$.ajax({
		url: "/slots",
		type: "post",
		data: {
			doctor_id: document.getElementById("appointment_doctor_id").value,
			date: date
		},
		success: function(response){
				if(response.status=="success"){
						if(response.slots.length!=0){
							$(".slot_item").remove();
							response.slots.map(item => 
							$(".slot_list").append($("<div class=slot_item ><input type=radio value="+item+":00:00 name=appointment[start_time]>"+ 
								item+":00 PM"
								+"<br></div>")));
						}
						else{
							$(".slot_item").remove();
							alert("no slots avilable for today");
						}
				}
				else{
					alert("please select a future date");
				}
		}}
		)
	;}



$(document).on("ajax:success",'.add_note',function(data,response,event){
	console.log(response);
	if(response.status =="success"){
		$("#notes_list").append(response.description+" <div align='right' ><br>  By:   "+response.by+"</div>");
	}
	else{
		alert("Note can't be blank");
	}	
})


